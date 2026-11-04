//! Draw font specimens over Iced's combo menu, which only accepts one font
//! for the whole list. Keep Iced in charge of layout, scrolling and input.
use iced::advanced::text::{self, Renderer as _};
use iced::advanced::widget::{self, Operation, operation};
use iced::advanced::{Layout, Renderer as _, Shell, overlay, renderer};
use iced::widget::overlay::menu;
use iced::{
    Background, Color, Event, Font, Point, Rectangle, Size, Vector, alignment,
    mouse,
};

use super::{Message, style};
use crate::Theme;
use crate::widget::{Element, Renderer};

const PADDING: f32 = 6.0;

fn palette(theme: &Theme) -> (menu::Style, Color) {
    let mut style = style::menu(theme);
    if let (Background::Color(background), Background::Color(selected)) =
        (style.background, style.selected_background)
    {
        for color in [
            style.text_color,
            style.selected_text_color,
            Color::BLACK,
            Color::WHITE,
        ] {
            if color.relative_contrast(background) >= 4.5
                && color.relative_contrast(selected) >= 4.5
            {
                return (style, color);
            }
        }
        // A theme can put the two fills on opposite sides of mid-gray.
        // Move the highlight away from the text so one label color stays
        // readable on both surfaces.
        let edge = if background.relative_luminance()
            < style.text_color.relative_luminance()
        {
            Color::BLACK
        } else {
            Color::WHITE
        };
        style.selected_background = background.mix(edge, 0.18).into();
    }
    (style, style.text_color)
}

pub(super) fn menu_style(theme: &Theme) -> menu::Style {
    let (mut style, _) = palette(theme);
    style.text_color = Color::TRANSPARENT;
    style.selected_text_color = Color::TRANSPARENT;
    style
}

pub(super) fn overlay<'a, 'b>(
    (): &'b mut (),
    inner: &'b mut Element<'a, Message>,
    tree: &'b mut widget::Tree,
    layout: Layout,
    renderer: &Renderer,
    translation: Vector,
    window: Size,
) -> Vec<overlay::Element<'b, Message, Theme, Renderer>> {
    inner
        .as_widget_mut()
        .overlay(
            tree,
            layout,
            renderer,
            &Rectangle::with_size(window),
            translation,
            window,
        )
        .into_iter()
        .map(|mut menu| {
            let mut visible = VisibleRows::default();
            menu.as_overlay_mut().operate(renderer, &mut visible);
            overlay::Element::new(Box::new(Preview { menu, visible }))
        })
        .collect()
}

struct Preview<'a> {
    menu: overlay::Element<'a, Message, Theme, Renderer>,
    visible: VisibleRows,
}

impl overlay::Overlay<Message, Theme, Renderer> for Preview<'_> {
    fn draw(
        &self,
        renderer: &mut Renderer,
        theme: &Theme,
        defaults: &renderer::Style,
        cursor: mouse::Cursor,
    ) {
        self.menu
            .as_overlay()
            .draw(renderer, theme, defaults, cursor);

        let viewport = self.visible.viewport;
        let translation = self
            .visible
            .translation
            .hint(renderer.hint_factor().unwrap_or(1.0));
        let (_, color) = palette(theme);
        renderer.with_layer(viewport, |renderer| {
            for (bounds, name) in &self.visible.rows {
                let bounds = *bounds - translation;
                if !bounds.intersects(&viewport) {
                    continue;
                }
                renderer.fill_text(
                    text::Text {
                        content: name.clone(),
                        bounds: Size::new(
                            (bounds.width - 2.0 * PADDING).max(0.0),
                            bounds.height,
                        ),
                        size: renderer.text_size(),
                        line_height: renderer.line_height(),
                        font: Font::with_family(name.as_str()),
                        align_x: text::Alignment::Default,
                        align_y: alignment::Vertical::Center,
                        shaping: text::Shaping::Advanced,
                        wrapping: text::Wrapping::None,
                        ellipsis: text::Ellipsis::End,
                        hint_factor: renderer.hint_factor(),
                    },
                    Point::new(bounds.x + PADDING, bounds.center_y()),
                    color,
                    // Let the renderer clip the full row to the menu layer.
                    // Pre-intersecting it skips masking in the software renderer.
                    bounds,
                );
            }
        });
    }

    fn operate(&mut self, renderer: &Renderer, operation: &mut dyn Operation) {
        self.menu.as_overlay_mut().operate(renderer, operation);
    }

    fn update(
        &mut self,
        event: &Event,
        cursor: mouse::Cursor,
        renderer: &Renderer,
        shell: &mut Shell<'_, Message>,
    ) {
        self.menu
            .as_overlay_mut()
            .update(event, cursor, renderer, shell);
        // Iced emits row bounds in content coordinates. Read them again
        // after scrolling, including during animated redraws.
        self.visible.rows.clear();
        self.menu
            .as_overlay_mut()
            .operate(renderer, &mut self.visible);
    }

    fn mouse_interaction(
        &self,
        cursor: mouse::Cursor,
        renderer: &Renderer,
    ) -> mouse::Interaction {
        self.menu.as_overlay().mouse_interaction(cursor, renderer)
    }
}

#[derive(Default)]
struct VisibleRows {
    viewport: Rectangle,
    translation: Vector,
    rows: Vec<(Rectangle, String)>,
}

impl Operation for VisibleRows {
    fn traverse(&mut self, visit: &mut dyn FnMut(&mut dyn Operation)) {
        visit(self);
    }

    fn scrollable(
        &mut self,
        _id: Option<&widget::Id>,
        bounds: Rectangle,
        _content: Size,
        translation: Vector,
        _state: &mut dyn operation::Scrollable,
    ) {
        self.viewport = bounds;
        self.translation = translation;
    }

    fn text(
        &mut self,
        _id: Option<&widget::Id>,
        bounds: Rectangle,
        text: &str,
    ) {
        self.rows.push((bounds, text.to_owned()));
    }
}
