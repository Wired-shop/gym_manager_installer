#define MyAppName "Gym Manager"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Wired-Shop"
#define MyAppURL "https://www.example.com/"
#define MyAppExeName "GymManager-Setup.exe"
#define MyAppAssocName MyAppName + " File"
#define MyAppAssocExt ".myp"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt

[Code]
function IsMariaDBInstalled: Boolean;
begin
  Result := DirExists(ExpandConstant('C:\Program Files\MariaDB 10.4'));
end;

procedure BeforeInstall(); 
var
  ResultCode: Integer;
begin
  ShellExec('', 'cmd.exe', '/c sc stop GymManagerApi', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  ShellExec('', 'cmd.exe', '/c sc delete GymManagerApi', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  
  ShellExec('', 'cmd.exe', '/c sc stop GymManagerAccessControlServer', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  ShellExec('', 'cmd.exe', '/c sc delete GymManagerAccessControlServer', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  
  ShellExec('', 'taskkill.exe', '/f /im main.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;


[Setup]
AppId={{9442FA57-6C12-44ED-9E7F-A4DF823D1180}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableDirPage=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
ChangesAssociations=yes
DisableProgramGroupPage=yes
OutputBaseFilename=mysetup
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
WizardStyle=modern

[Languages]
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Users\Patrick Nicolosi\Desktop\Lavoro\gym_manager_installer\live_monitor\data\*"; DestDir: "{app}\live_monitor\data"; Flags: ignoreversion recursesubdirs createallsubdirs; BeforeInstall: BeforeInstall
Source: "C:\Users\Patrick Nicolosi\Desktop\Lavoro\gym_manager_installer\live_monitor\*"; DestDir: "{app}\live_monitor"; Flags: ignoreversion
Source: "C:\Users\Patrick Nicolosi\Desktop\Lavoro\gym_manager_installer\gym_manager\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Users\Patrick Nicolosi\Desktop\Lavoro\gym_manager_installer\gym_manager\*"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Patrick Nicolosi\Desktop\Lavoro\gym_manager_installer\mariadb.msi"; DestDir: "{app}\mariadb"; Flags: ignoreversion; Check: not IsMariaDBInstalled()
Source: "C:\Users\Patrick Nicolosi\Desktop\Lavoro\gym_manager_installer\nssm\*"; DestDir: "{app}\nssm"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Users\Patrick Nicolosi\Desktop\Lavoro\gym_manager_installer\api.exe"; DestDir: "{app}\api"; Flags: ignoreversion
Source: "C:\Users\Patrick Nicolosi\Desktop\Lavoro\gym_manager_installer\access_control_server.exe"; DestDir: "{app}\access_control_server"; Flags: ignoreversion

[Registry]
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#MyAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppAssocName}"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\Applications\{#MyAppExeName}\SupportedTypes"; ValueType: string; ValueName: ".myp"; ValueData: ""

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\main.exe"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\main.exe"; Tasks: desktopicon

[Run]

; Installa MariaDB solo se non è già installato
Filename: "msiexec.exe"; Parameters: "/i ""{app}\mariadb\mariadb.msi"" /quiet"; Flags: waituntilterminated; Check: not IsMariaDBInstalled()
Filename: "C:\Program Files\MariaDB 10.4\bin\mysqld.exe"; Parameters: "--install"; Flags: runhidden waituntilterminated; Check: not IsMariaDBInstalled()

; Setup e Avvio MariaDB
Filename: "{cmd}"; Parameters: "/c sc start MySQL"; Flags: runhidden waituntilterminated;
Filename: "C:\Program Files\MariaDB 10.4\bin\mysql.exe"; Parameters: "-u root -P 3306 -e ""ALTER USER 'root'@'localhost' IDENTIFIED BY ''; CREATE USER 'gymManagerUser'@'localhost' IDENTIFIED BY 'gymManagerWS'; GRANT ALL PRIVILEGES ON *.* TO 'gymManagerUser'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES; CREATE DATABASE Gym_manager;"""; Flags: waituntilterminated

;Installa i servizi
Filename: "{app}\nssm\win64\nssm.exe"; Parameters: "install GymManagerApi ""{app}\api\api.exe"""; Flags: waituntilterminated;
Filename: "{app}\nssm\win64\nssm.exe"; Parameters: "install GymManagerAccessControlServer ""{app}\access_control_server\access_control_server.exe"""; Flags: waituntilterminated; 
Filename: "{app}\nssm\win64\nssm.exe"; Parameters: "start GymManagerApi"; Flags: waituntilterminated; 
Filename: "{app}\nssm\win64\nssm.exe"; Parameters: "start GymManagerAccessControlServer"; Flags: waituntilterminated; 

[UninstallRun]
;Stoppa ed elimina i servizi
Filename: "{cmd}"; Parameters: "/c sc stop GymManagerApi"; Flags: runhidden waituntilterminated; 
Filename: "{cmd}"; Parameters: "/c sc stop GymManagerAccessControlServer"; Flags: runhidden waituntilterminated; 
Filename: "{cmd}"; Parameters: "/c sc delete GymManagerApi"; Flags: runhidden waituntilterminated; 
Filename: "{cmd}"; Parameters: "/c sc delete GymManagerAccessControlServer"; Flags: runhidden waituntilterminated; 
Filename: "taskkill"; Parameters: "/f /im main.exe"; Flags: runhidden waituntilterminated
