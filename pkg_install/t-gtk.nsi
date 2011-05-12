;NSIS Modern User Interface
;Welcome/Finish Page Example Script
;Written by Joost Verburg

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
;  !include "MUI.nsh"
  !include "WordFunc.nsh"
;  !insertmacro MUI_DEFAULT MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
;  !insertmacro MUI_DEFAULT MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
;  !define MUI_ICON "t-gtk.ico"

;--------------------------------
;General

  ;Name and file
  ;Name "t-gtk 2.0" 
  ;OutFile "t-gtk_setup.exe"
  !include "install_name.nsh"

  XPStyle on
  SetDateSave on
  SetDatablockOptimize on
  CRCCheck on

  ;Default installation folder
  ;InstallDir "C:\t-gtk_2.0"

  ;Request application privileges for Windows Vista
  RequestExecutionLevel user

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\t-gtk" ""

  SetCompressor /SOLID lzma

  /*
    Valores de directorios fuentes para sustituir (NSIS no acepta variables en el comando File):

    \MINGW              (directorio compilador C)
    \GTK+               (directorio GTK)
    \GEDI               (directorio gedit)
    \harbour-ming       (directorio Harbour)
    \harbour-export     (directorio fuentes de Harbour)
    preinstall          (directorio TGTK)
    \MySQL              (directorio Archivos cliente MySQL)
    \pgSQL            (directorio Archivos cliente PostgreSQL)
    
  */

  Var SRC_MINGWDIR
  Var SRC_GTKDIR
  Var SRC_HBDIR
  Var SRC_HB_SVN_DIR
  Var SRC_MYSQL
  Var SRC_PGSQL
  Var SRC_GEDIT

  Var DEST_HBDir  
  Var DEST_GTKDir
  Var DEST_MINGWDIR
  Var DEST_GEDIT

  Var SOURCE

  Var RULES_GTK_SV
  Var RULES_BONOBO
  Var RULES_GNOMEDB
  Var RULES_CURL
  Var RULES_MYSQL
  Var RULES_PGSQL
  Var RULES_WEBKIT



;--------------------------------
;Funciones
Function .onInit

        StrCpy $1 "May, 2011"

	# the plugins dir is automatically deleted when the installer exits
	InitPluginsDir
	File /oname=$PLUGINSDIR\splash.bmp "gmoork.bmp"
	;File /oname=$PLUGINSDIR\splash.bmp "tests\images\tgtk-logo.bmp"
	#optional
	#File /oname=$PLUGINSDIR\splash.wav "C:\myprog\sound.wav"

        advsplash::show 3500 2000 900 0xFDA1FA $PLUGINSDIR\splash
        Pop $0 

  
        MessageBox MB_YESNO "Este Asistente Instalara $(^NameDA) (Revisión de $1). Continuar?" IDYES NoAbort
           Abort ; Pa fuera!.
        NoAbort:

FunctionEnd

;--------------------------------
;Interface Configuration

  !define MUI_HEADERIMAGE "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
  !define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp" ; optional
;  !define MUI_ABORTWARNING
  ;Definiendo Imagenes de Bienvenida y Finalizacion
  !define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"



;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Show release notes"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION ShowReleaseNotes

Function ShowReleaseNotes
  ${If} ${FileExists} $WINDIR\hh.exe
    StrCpy $0 $WINDIR\hh.exe
    Exec '"$0" mk:@MSITStore:$INSTDIR\NSIS.chm::/SectionF.1.html'
  ${Else}
    SearchPath $0 hh.exe
    ${If} ${FileExists} $0
      Exec '"$0" mk:@MSITStore:$INSTDIR\NSIS.chm::/SectionF.1.html'
    ${Else}
      ExecShell "open" "http://www.t-gtk.org"
    ${EndIf}
  ${EndIf}
FunctionEnd



;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "Spanish"



;--------------------------------
;Installer Sections

SectionGroup /e "T-GTK"

;------------------------------------
Section "t-gtk" SecTgtk
;------------------------------------

  ;Rutas de Directorios para copiar

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...
  File /nonfatal /r /x CVS preinstall\*.*


  ;Store installation folder
  WriteRegStr HKCU "Software\t-gtk" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  

  ;File Source
  !include "parameters.nsh"
;  StrCpy $SRC_MINGWDIR    "\MinGW"
;  StrCpy $SRC_GTKDIR      "\GTK+"
;  StrCpy $SRC_HBDIR       "\hb-mingw"
;  StrCpy $SRC_HB_SVN_DIR  "\hb-mingw-svn"
;  StrCpy $SRC_GEDIT       "\gedit"

  ;File Destination
  StrCpy $DEST_MINGWDIR "$INSTDIR\MinGW"
  StrCpy $DEST_GTKDIR   "$INSTDIR\GTK+"
  StrCpy $DEST_HBDIR    "$INSTDIR\hb-mingw"
  StrCpy $DEST_GEDIT    "$INSTDIR\gedit"

  StrCpy $source "preinstall"



; Generar Seteador de Variables.
;FileOpen $0 $INSTDIR\setenv.bat w
;FileWrite $0 "@echo off $\r$\n"
;FileWrite $0 "SET PKG_CONFIG_PATH=$DEST_GTKDIR\lib\pkg-config$\r$\n"
;FileWrite $0 "SET PATH=%PATH%;$DEST_MINGWDIR\bin;$DEST_MINGWDIR\lib;$DEST_MINGWDIR\include$\r$\n"
;FileWrite $0 "SET PATH=%PATH%;$DEST_GTKDIR\bin;$DEST_GTKDIR\lib;$DEST_GTKDIR\include$\r$\n"
;FileWrite $0 "SET PATH=%PATH%;$DEST_GEDIT\bin$\r$\n"
;FileClose $0


; Generar setenv.mk
FileOpen $0 $INSTDIR\setenv.mk w

FileWrite $0  "$\r$\n"
FileWrite $0  "#---------------------------------------------$\r$\n" 
FileWrite $0  "# System Configure of T-Gtk.$\r$\n" 
FileWrite $0  "# (c)2004-11 gTXBASE Team.$\r$\n" 
FileWrite $0  "#$\r$\n" 
FileWrite $0  "#---------------------------------------------$\r$\n" 
FileWrite $0  "$\r$\n" 
FileWrite $0  "#--------------------$\r$\n" 
FileWrite $0  "# Compilador xBase. Opciones [HARBOUR o XHARBOUR]$\r$\n" 
FileWrite $0  "export XBASE_COMPILER =HARBOUR$\r$\n" 
FileWrite $0  "$\r$\n" 
FileWrite $0  "#--------------------$\r$\n" 
FileWrite $0  "# RUTAS Compilador xBase HARBOUR.$\r$\n" 
FileWrite $0  "export HB_BIN_INSTALL =$DEST_HBDIR\bin$\r$\n"
FileWrite $0  "export HB_INC_INSTALL =$DEST_HBDIR\include$\r$\n"
FileWrite $0  "export HB_LIB_INSTALL =$DEST_HBDIR\lib\win\mingw$\r$\n"
FileWrite $0  "export HB_VERSION =21$\r$\n"
FileWrite $0  "#-------------------- $\r$\n"
FileWrite $0  "# RUTAS Compilador xBase xHARBOUR. $\r$\n"
FileWrite $0  "export XHB_BIN_INSTALL =\xhb_mingw\bin$\r$\n"
FileWrite $0  "export XHB_INC_INSTALL =\xhb_mingw\include$\r$\n"
FileWrite $0  "export XHB_LIB_INSTALL =\xhb_mingw\lib$\r$\n"
FileWrite $0  "$\r$\n"
FileWrite $0  "#-------------------- $\r$\n"
FileWrite $0  "# RUTAS T-GTK. $\r$\n"
FileWrite $0  "export TGTK_DIR =$INSTDIR$\r$\n"
FileWrite $0  "export LIBDIR_TGTK =$INSTDIR\lib$\r$\n"
FileWrite $0  "export INCLUDE_TGTK_PRG =$INSTDIR\include$\r$\n"
FileWrite $0  " $\r$\n"
FileWrite $0  "#-------------------- $\r$\n"
FileWrite $0  "# Componentes Adicionales. $\r$\n"
FileWrite $0  "export GTK_PATH =$DEST_GTKDIR$\r$\n"
FileWrite $0  "export TGTK_BIN =$DEST_MINGWDIR$\r$\n"
FileWrite $0  "export PKG_CONFIG_PATH =$DEST_GTKDIR\lib\pkg-config$\r$\n"
FileWrite $0  " $\r$\n"
FileWrite $0  "# Soporte de Impresion. $\r$\n"
FileWrite $0  "export SUPPORT_PRINT_WIN32 =no$\r$\n"
FileWrite $0  " $\r$\n"

;FileWrite $0  "# Soporte para GTKSourceView. $\r$\n"
;FileWrite $0  "export GTKSOURCEVIEW =no$\r$\n"
;FileWrite $0  " $\r$\n"
;FileWrite $0  "# Soporte para Bonobo. $\r$\n"
;FileWrite $0  "export BONOBO =no$\r$\n"
;FileWrite $0  " $\r$\n"
;FileWrite $0  "# Soporte para gnomeDB y LibGDA. $\r$\n"
;FileWrite $0  "export GNOMEDB =no$\r$\n"
;FileWrite $0  " $\r$\n"
;FileWrite $0  "# Soporte para cURL. $\r$\n"
;FileWrite $0  "export CURL =no$\r$\n"
;FileWrite $0  " $\r$\n"
;FileWrite $0  "# Soporte para SQLite. $\r$\n"
;FileWrite $0  "export SQLITE =no$\r$\n"
;FileWrite $0  " $\r$\n"
;FileWrite $0  "# Soporte para MySQL. $\r$\n"
;FileWrite $0  "export MYSQL =yes$\r$\n"
;FileWrite $0  "export DOLPHIN =yes$\r$\n"
;FileWrite $0  "export MYSQL_VERSION =5.0$\r$\n"
;FileWrite $0  'export MYSQL_PATH ="C:\MySQLClient\include"$\r$\n'
;FileWrite $0  " $\r$\n"
;FileWrite $0  "# Soporte para PostgreSQL. $\r$\n"
;FileWrite $0  "export POSTGRE =yes$\r$\n"
;FileWrite $0  "export POSTGRE_VERSION =9.0$\r$\n"
;FileWrite $0  'export POSTGRE_PATH ="C:\pgsql\include"$\r$\n'
 

StrCpy $RULES_GTK_SV   "#Soporte para GtkSourceView$\r$\n"
StrCpy $RULES_GTK_SV   "$RULES_GTK_SVSOURCEVIEW=no$\r$\n"
StrCpy $RULES_GTK_SV   "$RULES_GTK_SV$\r$\n"

StrCpy $RULES_BONOBO   "#Soporte para Bonobo$\r$\n"
StrCpy $RULES_BONOBO   "$RULES_BONOBOBONOBO=no$\r$\n"
StrCpy $RULES_BONOBO   "$RULES_BONOBO$\r$\n"

StrCpy $RULES_GNOMEDB  "#Alpha. Soporte para GNOMEDB y LIBGDA$\r$\n"
StrCpy $RULES_GNOMEDB  "$RULES_GNOMEDBGNOMEDB=no$\r$\n"
StrCpy $RULES_GNOMEDB  "$RULES_GNOMEDB$\r$\n"

StrCpy $RULES_CURL     "#Soporte para CURL$\r$\n"
StrCpy $RULES_CURL     "$RULES_CURLCURL=no$\r$\n"
StrCpy $RULES_CURL     "$RULES_CURL$\r$\n"

StrCpy $RULES_WEBKIT   "#Soporte para WebKit$\r$\n"
StrCpy $RULES_WEBKIT   "$RULES_WEBKITWEBKIT=no$\r$\n"
StrCpy $RULES_WEBKIT   "$RULES_WEBKIT$\r$\n"

StrCpy $RULES_MYSQL    "#Soporte MySQL$\r$\n"
StrCpy $RULES_MYSQL    "$RULES_MYSQLMYSQL=no$\r$\n"
StrCpy $RULES_MYSQL    "$RULES_MYSQLDOLPHIN=no$\r$\n"
StrCpy $RULES_MYSQL    "$RULES_MYSQLMYSQL_PATH='C:/Archivos de programa/MySQL/MySQL Server 5.0/include'$\r$\n"
StrCpy $RULES_MYSQL    "$RULES_MYSQL$\r$\n"

StrCpy $RULES_PGSQL    "#Soporte PostgreSQL$\r$\n"
StrCpy $RULES_PGSQL    "$RULES_PGSQLPOSTGRE=no$\r$\n"
StrCpy $RULES_PGSQL    "$RULES_PGSQLPOSTGRE_PATH='C:/Archivos de programa/PostgreSQL/9.0/include'$\r$\n"
StrCpy $RULES_PGSQL    "$RULES_PGSQL$\r$\n"



SectionEnd



;------------------------------------
Section "Otros Binarios" SecOther
;------------------------------------
  SetOutPath "$INSTDIR\MinGW\bin"
  File /nonfatal miscelan_bin\wget.exe
  File /nonfatal miscelan_bin\7zip.exe

  SetOutPath "$INSTDIR\pkg_install\miscelan_bin"
  File /nonfatal miscelan_bin\wget.exe
  File /nonfatal miscelan_bin\7zip.exe

SectionEnd



;------------------------------------
Section "Soporte MySQL" SecMySQL
;------------------------------------
StrCpy $RULES_MYSQL   "#Soporte MySQL$\r$\n"
StrCpy $RULES_MYSQL   "$RULES_MYSQLMYSQL=yes$\r$\n"
StrCpy $RULES_MYSQL   "$RULES_MYSQLMYSQL_VERSION=5.0$\r$\n"
StrCpy $RULES_MYSQL   "$RULES_MYSQLDOLPHIN=yes$\r$\n"
StrCpy $RULES_MYSQL   "$RULES_MYSQLMYSQL_PATH='C:/Archivos de programa/MySQL/MySQL Server 5.0/include'$\r$\n"
StrCpy $RULES_MYSQL   "$RULES_MYSQL$\r$\n"

  !include "mysql.nsh"
  ;SetOutPath "$INSTDIR\MySQLClient"
  ;ADD YOUR OWN FILES HERE...
  ;File /nonfatal /r "$SRC_MYSQL\*.*"
  ; DOLPHIN
  !include "dolphin.nsh"

SectionEnd

;------------------------------------
Section "Soporte Postgre" SecPgSQL
;------------------------------------
StrCpy $RULES_PGSQL   "#Soporte PostgreSQL$\r$\n"
StrCpy $RULES_PGSQL   "$RULES_PGSQLPOSTGRE=yes$\r$\n"
StrCpy $RULES_PGSQL   "$RULES_PGSQLPOSTGRE_VERSION=9.0$\r$\n"
StrCpy $RULES_PGSQL   "$RULES_PGSQLPOSTGRE_PATH='C:/Archivos de programa/PostgreSQL/9.0/include'$\r$\n"
StrCpy $RULES_PGSQL   "$RULES_PGSQL$\r$\n"

  !include "pgsql.nsh"
  ;SetOutPath "$INSTDIR\PgSQLClient"
  ;ADD YOUR OWN FILES HERE...
  ;File /nonfatal /r "$SRC_PGSQL\*.*"

SectionEnd


/*
;------------------------------------
Section "Soporte CURL" SecCURL
;------------------------------------
StrCpy $RULES_CURL   "#Soporte para CURL$\r$\n"
StrCpy $RULES_CURL   "${RULES_CURL}CURL=yes$\r$\n"
StrCpy $RULES_CURL   "${RULES_CURL}$\r$\n"

;  SetOutPath "$INSTDIR\cURL"

  ;ADD YOUR OWN FILES HERE...
;  File /nonfatal /r "$SRC_CURL\*.*"

SectionEnd
*/

SectionGroupEnd


!ifdef FULL

  ;------------------------------------
  Section "MinGW" SecMinGW
  ;------------------------------------
    SetOutPath "$INSTDIR\MinGW"

    ;ADD YOUR OWN FILES HERE...
    File /nonfatal /r \$SRC_MINGW\*.*

;    SetOutPath "$INSTDIR\MinGW-Utils"
;    File /nonfatal /r $DRIVE\MinGW-UTILS\*.*

  SectionEnd


  ;------------------------------------
  SectionGroup "Harbour"
  ;------------------------------------
  Section "Harbour (Binarios)" SecHarbour

    SetOutPath "$DEST_HBDIR"

    ;ADD YOUR OWN FILES HERE...
    File /nonfatal /r \$SRC_HBDIR\*.*


    CreateShortCut "$DESKTOP\Harbour Project.lnk" "$DEST_HBDIR" "" "$DEST_HBDIR" 0
    CreateDirectory "$SMPROGRAMS\Harbour Project"
;    CreateShortCut  "$SMPROGRAMS\Harbour Project\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
    CreateShortCut  "$SMPROGRAMS\Harbour Project\Harbour Project (Command line).lnk" "cmd.exe" "/k cd $DEST_HBDIR\bin" "cmd.exe" 0
    CreateShortCut  "$SMPROGRAMS\Harbour Project\Harbour Project.lnk" "$INSTDIR\Harbour-MinGW" "" "$DEST_HBDIR" 0
    CreateShortCut  "$SMPROGRAMS\Harbour Project\hbrun.lnk" "$DEST_HBDIR\bin\hbrun.exe" "-v" "$DEST_HBDIR\bin\hbrun.exe" 0
    CreateDirectory "$SMPROGRAMS\Harbour Project\Links"
    WriteINIStr     "$SMPROGRAMS\Harbour Project\Links\Homepage.url"                   "InternetShortcut" "URL" "http://www.harbour-project.org/"
    WriteINIStr     "$SMPROGRAMS\Harbour Project\Links\User Forums.url"                "InternetShortcut" "URL" "http://sourceforge.net/apps/phpbb/harbour-project/"
    WriteINIStr     "$SMPROGRAMS\Harbour Project\Links\Sourceforge Page.url"           "InternetShortcut" "URL" "http://sourceforge.net/projects/harbour-project/"
    WriteINIStr     "$SMPROGRAMS\Harbour Project\Links\Developers' Mail Archives.url"  "InternetShortcut" "URL" "http://lists.harbour-project.org/pipermail/harbour/"
    WriteINIStr     "$SMPROGRAMS\Harbour Project\Links\Development Timeline.url"       "InternetShortcut" "URL" "http://sourceforge.net/apps/trac/harbour-project/timeline"


  SectionEnd


  Section /o "Fuentes" SecHBSource

    SetOutPath "$DEST_HBDIR"

    ;ADD YOUR OWN FILES HERE...
    File /nonfatal /r /x SVN \harbour-svn\*.*

  SectionEnd


  SectionGroupEnd


  ;------------------------------------
  Section "GTK+" SecGTK+
  ;------------------------------------
    SetOutPath "$INSTDIR\GTK+"

    ;ADD YOUR OWN FILES HERE...
    File /nonfatal /r \GTK+\*.*


    ;SetOverwrite off
    SetOutPath $SYSDIR
;    File /nonfatal /r "\GTK+\bin\*.dll"
;    ---CopyFiles $GTKDIR\bin\*.dll $SYSDIR


  SectionEnd


  ;------------------------------------
  Section "gedit" SecGEDIT
  ;------------------------------------
    SetOutPath "$INSTDIR\gedit"

    ;ADD YOUR OWN FILES HERE...
    File /nonfatal /r \gedit\*.*
  ;  ExecWait '"$INSTDIR\gedit-setup-2.30.1-1.exe"'
  ;  Delete '"$INSTDIR\gedit-setup-2.30.1-1.exe"'

    SetOutPath "$PROFILE\.gconf"
    File /nonfatal /r \gedit\.gconf\*.*

  SectionEnd

!endif



;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecTgtk ${LANG_SPANISH} "t-gtk, Fuentes y Librerias compiladas para MinGW."

  LangString DESC_SecOther ${LANG_SPANISH} "t-gtk, Binarios para Descargar y Descomprimir. (wget y 7zip)"

  LangString DESC_SecMySQL ${LANG_SPANISH} "Habilita Soporte de Cliente MySQL"

  LangString DESC_SecPGSQL ${LANG_SPANISH} "Habilita Soporte de Conexión a PostgreSQL"

;  LangString DESC_SecCURL ${LANG_SPANISH} "Soporte para CURL"

!ifdef FULL
  LangString DESC_SecMinGW ${LANG_SPANISH} "MinGW, Compilador y herramientas de compilación GNU."

  LangString DESC_SecHarbour ${LANG_SPANISH} "Harbour. Compilador xBase version 2.1"

  LangString DESC_SecHBSource ${LANG_SPANISH} "Harbour. Codigo Fuente version 2.1"

  LangString DESC_SecGTK+ ${LANG_SPANISH} "GTK+ 2.24, Componentes para desarrollar con GTK+ y Glade."

  LangString DESC_SecGEDIT ${LANG_SPANISH} "gedit. Editor de texto de gnome."
!endif

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecTgtk} $(DESC_SecTgtk)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecOther} $(DESC_SecOther)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMySQL} $(DESC_SecMySQL)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPgSQL} $(DESC_SecPgSQL)
;    !insertmacro MUI_DESCRIPTION_TEXT ${SecCURL}  $(DESC_SecCURL)

!ifdef FULL
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMinGW} $(DESC_SecMinGW)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecHarbour} $(DESC_SecHarbour)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecGTK+}  $(DESC_SecGTK+)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecGEDIT}  $(DESC_SecGEDIT)
!endif

  !insertmacro MUI_FUNCTION_DESCRIPTION_END




;------------------------------------
Section
;------------------------------------

  ;SetOutPath "$DEST_GTKDIR\lib\pkg-config"
  ;File /nonfatal /r $SOURCE\utils\config_system\tgtk_win.pc
  ;Rename $SOURCE\utils\config_system\tgtk_win.pc $DEST_GTKDIR\lib\pkg-config\tgtk.pc
  ;CopyFiles $SOURCE\utils\config_system\tgtk_win.pc $DEST_GTKDIR\lib\pkg-config\tgtk.pc



FileWrite $0 "$RULES_GTK_SV"
FileWrite $0 "$RULES_BONOBO"
FileWrite $0 "$RULES_GNOMEDB"
FileWrite $0 "$RULES_CURL"
FileWrite $0 "$RULES_WEBKIT"
FileWrite $0 "$RULES_MYSQL"
FileWrite $0 "$RULES_PGSQL"

FileWrite $0  "# eof $\r$\n"


FileClose $0


  CreateShortCut  "$DESKTOP\t-gtk.lnk" "$INSTDIR" "" "$INSTDIR" 0
  CreateDirectory "$SMPROGRAMS\t-gtk"
  CreateShortCut  "$SMPROGRAMS\t-gtk\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut  "$SMPROGRAMS\t-gtk\t-gtk (demo).lnk" "cmd.exe" "/k cd $INSTDIR\tests\gclass\demo" "cmd.exe" 0
  WriteINIStr     "$SMPROGRAMS\t-gtk\Homepage.url"                   "InternetShortcut" "URL" "http://www.t-gtk.org/"
  WriteINIStr     "$SMPROGRAMS\t-gtk\Foro.url"                   "InternetShortcut" "URL" "http://www.gtxbase.org/forums"
  WriteINIStr     "$SMPROGRAMS\t-gtk\subversion.url"                   "InternetShortcut" "URL" "http://www.gtxbase.org/devel"


SectionEnd



;--------------------------------
;Uninstaller Section

Section "Uninstall"

  DeleteRegKey HKLM "Software\t-gtk"

  ;ADD YOUR OWN FILES HERE...

  Delete "$INSTDIR\*.*"
;  Delete "$INSTDIR\Uninstall.exe"

  RMDir /r "$INSTDIR"

  RMDir /r "$SMPROGRAMS\t-gtk"
  Delete "$DESKTOP\t-gtk.lnk"

!ifdef FULL
  RMDir /r "$SMPROGRAMS\Harbour Project"
  Delete "$DESKTOP\Harbour Project.lnk"
!endif

  DeleteRegKey /ifempty HKCU "Software\t-gtk"


SectionEnd

