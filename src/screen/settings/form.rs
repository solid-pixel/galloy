//! Shared Settings layout; callers retain field IDs, messages and validation.
use iced::widget::{column, container, row, rule};
use iced::{Alignment, Length};

use super::style;
use crate::widget::{Element, text};

pub(super) fn group_rows<'a, M: 'a>(
    rows: Vec<Element<'a, M>>,
) -> Element<'a, M> {
    let mut content = column![].spacing(0);
    for (index, item) in rows.into_iter().enumerate() {
        if index > 0 {
            content = content.push(
                container(rule::horizontal(1))
                    .padding(iced::padding::horizontal(12)),
            );
        }
        content =
            content.push(container(item).padding([8, 12]).width(Length::Fill));
    }
    container(content)
        .width(Length::Fill)
        .style(style::pane)
        .into()
}

pub(super) fn labelled<'a, M: 'a>(
    label: &'a str,
    control: Element<'a, M>,
    max_width: f32,
) -> Element<'a, M> {
    labelled_layout(label, control, max_width, 160.0, false)
}

pub(super) fn labelled_layout<'a, M: 'a>(
    label: &'a str,
    control: Element<'a, M>,
    max_width: f32,
    label_width: f32,
    stacked: bool,
) -> Element<'a, M> {
    let control = container(control).width(Length::Fill.max(max_width));
    if stacked {
        column![text(label), control]
            .spacing(4)
            .width(Length::Fill)
            .into()
    } else {
        row![text(label).width(label_width), control]
            .spacing(12)
            .align_y(Alignment::Center)
            .width(Length::Fill)
            .into()
    }
}
