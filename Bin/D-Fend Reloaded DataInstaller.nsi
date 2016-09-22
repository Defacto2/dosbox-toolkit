; NSI SCRIPT FOR D-FEND RELOADED DATA PACKAGES
; ============================================================

; This is an include file. Example of a installer script file:
; OutFile "...-Setup.exe"
; !include "D-Fend Reloaded DataInstaller.nsi"
;
;Section "PrgName"
;  SetOutPath "$DataInstDir\Confs"
;  File ".\Confs\Prg.prof"
;  SetOutPath "$DataInstDir\VirtualHD\PrgDir"
;  File /r ".\VirtualHD\PrgDir\*.*"
;SectionEnd

!include "MUI.nsh"
!include WinMessages.nsh

Name "D-Fend Reloaded data package"
BrandingText "D-Fend Reloaded data package"

SetCompressor /solid lzma
RequestExecutionLevel user
XPStyle on
InstallDir "$PROGRAMFILES\D-Fend Reloaded\"
InstallDirRegKey HKLM "Software\D-Fend Reloaded" "ProgramFolder"
!insertmacro MUI_RESERVEFILE_LANGDLL

!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"

!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT "$(LANGNAME_WelcomeText)"
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_FINISHPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_RUN "$INSTDIR\DFend.exe"
!define MUI_FINISHPAGE_RUN_TEXT "$(LANGNAME_RunDFend)"

!define MUI_LANGDLL_REGISTRY_ROOT "HKLM" 
!define MUI_LANGDLL_REGISTRY_KEY "Software\D-Fend Reloaded" 
!define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

!insertmacro MUI_LANGUAGE "Danish"
!insertmacro MUI_LANGUAGE "Dutch"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "Polish"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "TradChinese"

Var DataInstDir

LangString LANGNAME_WelcomeText ${LANG_DANISH} "Denne guide fører dig gennem installationen af.\r\n\r\nLuk D-Fend Reloaded, før du fortsætter.\r\n\r\nKlik Næste for at fortsætte."
LangString LANGNAME_InstallError ${LANG_DANISH} "$INSTDIR\DFend.dat bliv ikke fundet."
LangString LANGNAME_RunDFend ${LANG_DANISH} "Kør D-Fend Reloaded nu"

LangString LANGNAME_WelcomeText ${LANG_DUTCH} "Deze wizard zal je begeleiden bij de installatie.\r\n\r\nGelieve D-Fend Reloaded te sluiten voor verder te gaan.\r\n\r\nKlik op Volgende om verder te gaan."
LangString LANGNAME_InstallError ${LANG_DUTCH} "$INSTDIR\DFend.dat niet gevonden."
LangString LANGNAME_RunDFend ${LANG_DUTCH} "D-Fend Reloaded nu starten"

LangString LANGNAME_WelcomeText ${LANG_ENGLISH} "This wizard will guide you through the installation.\r\n\r\nPlease close D-Fend Reloaded before continuing.\r\n\r\nClick Next to continue."
LangString LANGNAME_InstallError ${LANG_ENGLISH} "$INSTDIR\DFend.dat not found."
LangString LANGNAME_RunDFend ${LANG_ENGLISH} "Run D-Fend Reloaded now"

LangString LANGNAME_WelcomeText ${LANG_FRENCH} "Cet assistant va vous guider durant l'installation.\r\n\r\nVeuillez fermer D-Fend Reloaded avant de continuer.\r\n\r\nCliquez sur Suivant pour continuer."
LangString LANGNAME_InstallError ${LANG_FRENCH} "$INSTDIR\DFend.dat introuvable."
LangString LANGNAME_RunDFend ${LANG_FRENCH} "Lancer D-Fend Reloaded maintenant"

LangString LANGNAME_WelcomeText ${LANG_GERMAN} "Dieser Assistent wird Sie durch die Installation begleiten.\r\n\r\nBitte beenden Sie D-Fend Reloaded, bevor Sie fortfahren.\r\n\r\nKlicken Sie auf Weiter, um fortzufahren."
LangString LANGNAME_InstallError ${LANG_GERMAN} "Die Datei $INSTDIR\DFend.dat existiert nicht."
LangString LANGNAME_RunDFend ${LANG_GERMAN} "D-Fend Reloaded jetzt ausführen"

LangString LANGNAME_WelcomeText ${LANG_ITALIAN} "This wizard will guide you through the installation.\r\n\r\nPlease close D-Fend Reloaded before continuing.\r\n\r\nClick Next to continue."
LangString LANGNAME_InstallError ${LANG_ITALIAN} "$INSTDIR\DFend.dat not found."
LangString LANGNAME_RunDFend ${LANG_ITALIAN} "Run D-Fend Reloaded now"

LangString LANGNAME_WelcomeText ${LANG_POLISH} "Ten kreator poprowadzi cie przez proces instalacji.\r\n\r\nZamknij D-Fend Reloaded zanim kontynuujesz.\r\n\r\nKliknij Dalej, aby kontynuowac."
LangString LANGNAME_InstallError ${LANG_POLISH} "$INSTDIR\DFend.dat nie znaleziony."
LangString LANGNAME_RunDFend ${LANG_POLISH} "Uruchom D-Fend Reloaded"

LangString LANGNAME_WelcomeText ${LANG_RUSSIAN} "Ýòîò ìàñòåð ïîìîæåò âàì âûïîëíèòü óñòàíîâêó.\r\n\r\nÏîæàëóéñòà, çàêðîéòå D-Fend Reloaded ïåðåä òåì, êàê ïðîäîëæèòü.\r\n\r\nÍàæìèòå êíîïêó 'Äàëåå' äëÿ ïðîäîëæåíèÿ."
LangString LANGNAME_InstallError ${LANG_RUSSIAN} "$INSTDIR\DFend.dat íå îáíàðóæåí."
LangString LANGNAME_RunDFend ${LANG_RUSSIAN} "Çàïóñòèòü D-Fend Reloaded"

LangString LANGNAME_WelcomeText ${LANG_SIMPCHINESE} "Õâ¸öÏòµ¼»áÔÚÕû¸ö¹ý³ÌÖÐÒýµ¼Äã°²×°¡£\r\n\r\nÔÚ¼ÌÐøÖ®Ç°Çë¹Ø±Õ D-Fend Reloaded¡£\r\n\r\nµã»÷ÏÂÒ»²½¼ÌÐø¡£"
LangString LANGNAME_InstallError ${LANG_SIMPCHINESE} "ÕÒ²»µ½ $INSTDIR\DFend.dat"
LangString LANGNAME_RunDFend ${LANG_SIMPCHINESE} "ÏÖÔÚ¾ÍÆô¶¯ D-Fend Reloaded"

LangString LANGNAME_WelcomeText ${LANG_SPANISH} "Este asistente le guiará a través del proceso de instalación.\r\n\r\nPor favor, cierre D-Fend Reloaded antes de continuar.\r\n\r\nHaga clic en $\"Siguiente$\" para continuar."
LangString LANGNAME_InstallError ${LANG_SPANISH} "No se ha podido encontrar $INSTDIR\DFend.dat."
LangString LANGNAME_RunDFend ${LANG_SPANISH} "Ejecutar D-Fend Reloaded ahora"

LangString LANGNAME_WelcomeText ${LANG_TRADCHINESE} "ß@‚€¾«ì`•þÔÚÕû‚€ß^³ÌÖÐÒýŒ§Äã°²Ñb¡£\r\n\r\nÔÚÀ^ÀmÖ®Ç°ÕˆêPé] D-Fend Reloaded¡£\r\n\r\nüc“ôÏÂÒ»²½À^Àm¡£"
LangString LANGNAME_InstallError ${LANG_TRADCHINESE} "ÕÒ²»µ½ $INSTDIR\DFend.dat¡£"
LangString LANGNAME_RunDFend ${LANG_TRADCHINESE} "¬FÔÚ¾Í†¢„Ó D-Fend Reloaded"

Function .onInit  
  !define MUI_LANGDLL_ALLLANGUAGES
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd  

Section "-SearchingDFendDataDir"
  SectionIn RO
  
  ; Searching DFend.dat
  IfFileExists "$INSTDIR\DFend.dat" DFendDatExists
  MessageBox MB_OK "$(LANGNAME_InstallError)"
  Abort
  DFendDatExists:
  
  ; Reading DFend.dat
  ClearErrors
  FileOpen $0 "$INSTDIR\DFend.dat" r
  IfErrors ErrorReadingDFendDat
  FileRead $0 $1
  FileClose $0
  ErrorReadingDFendDat:

  ; Interpreting DFend.dat content
  StrCmp $1 "USERDIRMODE" Mode1
  StrCpy $DataInstDir  $INSTDIR  
  Goto ModeFinish
  Mode1:
  StrCpy $DataInstDir "$PROFILE\D-Fend Reloaded"
  ModeFinish:
SectionEnd

!define TO_MS 2000

Section "-CloseDFend"
  SectionIn RO

  Push $0
  FindWindow $0 'TDFendReloadedMainform' ''
  IntCmp $0 0 DoneCloseDFend
  SendMessage $0 ${WM_CLOSE} 0 0 /TIMEOUT=${TO_MS}
  Sleep 2000
  DoneCloseDFend:
  Pop $0
SectionEnd