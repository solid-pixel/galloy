#define AppName "Galloy"
#define AppPublisher "Galloy contributors"
#define AppExeName "galloy.exe"
#define AppId "{{795C3E44-2945-4FBA-86C2-914F52EAB153}"
#define AppVersion GetEnv("GALLOY_VERSION")
#define SourceDir GetEnv("GALLOY_SOURCE_DIR")
#define OutputDir GetEnv("GALLOY_OUTPUT_DIR")
#define OutputBaseFilename GetEnv("GALLOY_OUTPUT_BASE_FILENAME")

[Setup]
AppId={#AppId}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL=https://github.com/solid-pixel/galloy
AppSupportURL=https://github.com/solid-pixel/galloy/issues
AppUpdatesURL=https://github.com/solid-pixel/galloy/releases
DefaultDirName={localappdata}\Programs\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
LicenseFile={#SourceDir}\inno\license.rtf
OutputDir={#OutputDir}
OutputBaseFilename={#OutputBaseFilename}
SetupIconFile={#SourceDir}\assets\windows\halloy.ico
UninstallDisplayIcon={app}\{#AppExeName}
VersionInfoVersion={#AppVersion}
VersionInfoCompany={#AppPublisher}
VersionInfoDescription={#AppName} Installer
VersionInfoProductName={#AppName}
VersionInfoProductVersion={#AppVersion}
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
CloseApplications=yes
RestartApplications=no
ChangesAssociations=yes
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#OutputDir}\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"; WorkingDir: "{app}"; AppUserModelID: "io.github.solid_pixel.Galloy"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; WorkingDir: "{app}"; Tasks: desktopicon; AppUserModelID: "io.github.solid_pixel.Galloy"

[Registry]
; Register Galloy as an available handler without replacing shared protocol defaults.
Root: HKCU; Subkey: "Software\Galloy\Capabilities"; ValueType: string; ValueName: "ApplicationDescription"; ValueData: "Galloy - unofficial Halloy fork with graphical settings"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Galloy\Capabilities"; ValueType: string; ValueName: "ApplicationIcon"; ValueData: "{app}\{#AppExeName},0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Galloy\Capabilities"; ValueType: string; ValueName: "ApplicationName"; ValueData: "Galloy"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\RegisteredApplications"; ValueType: string; ValueName: "Galloy"; ValueData: "Software\Galloy\Capabilities"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Galloy\Capabilities\URLAssociations"; ValueType: string; ValueName: "irc"; ValueData: "Galloy.IRC"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.IRC"; ValueType: string; ValueName: ""; ValueData: "Galloy irc URL"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.IRC"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.IRC\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#AppExeName},0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.IRC\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExeName}"" ""%1"""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Galloy\Capabilities\URLAssociations"; ValueType: string; ValueName: "ircs"; ValueData: "Galloy.IRCS"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.IRCS"; ValueType: string; ValueName: ""; ValueData: "Galloy ircs URL"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.IRCS"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.IRCS\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#AppExeName},0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.IRCS\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExeName}"" ""%1"""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Galloy\Capabilities\URLAssociations"; ValueType: string; ValueName: "halloy"; ValueData: "Galloy.HALLOY"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.HALLOY"; ValueType: string; ValueName: ""; ValueData: "Galloy halloy URL"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.HALLOY"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.HALLOY\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#AppExeName},0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Galloy.HALLOY\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#AppExeName}"" ""%1"""; Flags: uninsdeletekey

[Run]
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
