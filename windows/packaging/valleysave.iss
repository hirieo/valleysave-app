; Instalador de ValleySave para Windows (Inno Setup 6).
; Compilar: ISCC.exe windows\packaging\valleysave.iss
; Requiere que `flutter build windows --release` ya se haya ejecutado.

#define MyAppName "ValleySave"
#define MyAppVersion "0.2.2"
#define MyAppPublisher "Hirieo"
#define MyAppURL "https://github.com/hirieo/valleysave-app"
#define MyAppExeName "valleysave.exe"
#define ReleaseDir "..\..\build\windows\x64\runner\Release"

[Setup]
; AppId fijo — NUNCA cambiar entre versiones, es lo que permite a Windows
; detectar "ya instalado, esto es una actualización" en vez de duplicar.
AppId={{B7B6B1B4-6C6E-4F2A-9C3D-8E5A7B9F1234}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}/releases
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=..\..\dist
OutputBaseFilename=ValleySave-Setup-v{#MyAppVersion}
SetupIconFile=..\runner\resources\app_icon.ico
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#MyAppExeName}
; Sin certificado de firma de código — Windows SmartScreen avisará de
; "editor desconocido" la primera vez, igual que con el .exe suelto de hoy.

[Languages]
; Los 14 idiomas de la app (lib/l10n/*.arb), cubiertos con los .isl
; oficiales que trae Inno Setup + 3 traducidos por la comunidad del
; propio proyecto (chino simplificado/tradicional, euskera) descargados
; de https://jrsoftware.org/files/istrans/ y guardados en languages/
; (no vienen con la instalación local de Inno Setup, así que no se puede
; usar "compiler:" para esos tres — se referencian por ruta relativa).
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"
Name: "chinesesimplified"; MessagesFile: "languages\ChineseSimplified.isl"
Name: "chinesetraditional"; MessagesFile: "languages\ChineseTraditional.isl"
Name: "basque"; MessagesFile: "languages\Basque.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "korean"; MessagesFile: "compiler:Languages\Korean.isl"
Name: "thai"; MessagesFile: "compiler:Languages\Thai.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#ReleaseDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Redistributable de Visual C++ — necesario porque el build de Flutter para
; Windows no enlaza estático contra el runtime (msvcp140.dll, etc.). Sin
; esto, la app falla al arrancar en una máquina limpia sin Visual Studio.
Source: "vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; Solo instala el redistributable si no está ya presente (evita el paso
; extra en la mayoría de máquinas, que ya lo tienen de otras apps).
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; \
    StatusMsg: "Instalando el runtime de Visual C++ (necesario para ValleySave)..."; \
    Check: VCRedistNeedsInstall
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; \
    Flags: nowait postinstall skipifsilent

[Code]
// Comprueba la clave de registro que instala el runtime de VC++ x64
// (versión 14.x, cubre VS2015-2022 — todas comparten el mismo runtime).
function VCRedistNeedsInstall: Boolean;
var
  Installed: Cardinal;
begin
  Result := True;
  if RegQueryDWordValue(HKLM64, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X64', 'Installed', Installed) then
  begin
    if Installed = 1 then
      Result := False;
  end;
end;
