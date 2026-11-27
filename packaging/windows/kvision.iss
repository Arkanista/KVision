#ifndef MyAppVersion
  #define MyAppVersion "2.8.1"
#endif

#ifndef SourceDir
  #define SourceDir "..\..\pkg"
#endif

[Setup]
AppId={{7B6E8E5A-3A2C-4F1D-9B7A-8C4E2D1F9A01}
AppName=KVision VMS
AppVersion={#MyAppVersion}
AppVerName=KVision VMS {#MyAppVersion}
AppPublisher=Arkanista
AppPublisherURL=https://github.com/Arkanista/KVision
AppSupportURL=https://github.com/Arkanista/KVision/issues
AppUpdatesURL=https://github.com/Arkanista/KVision/releases
DefaultDirName={autopf}\KVision
DefaultGroupName=KVision
AllowNoIcons=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
SetupIconFile=..\..\images\kvision.ico
UninstallDisplayIcon={app}\kvision.exe
UninstallDisplayName=KVision VMS
Compression=lzma2/normal
SolidCompression=yes
WizardStyle=modern
OutputBaseFilename=KVision-windows-x64-setup
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\KVision VMS"; Filename: "{app}\kvision.exe"; WorkingDir: "{app}"
Name: "{group}\{cm:UninstallProgram,KVision VMS}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\KVision VMS"; Filename: "{app}\kvision.exe"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\kvision.exe"; WorkingDir: "{app}"; Description: "{cm:LaunchProgram,KVision VMS}"; Flags: nowait postinstall skipifsilent runasoriginaluser
