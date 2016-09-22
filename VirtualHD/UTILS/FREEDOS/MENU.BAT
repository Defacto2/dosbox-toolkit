@echo off
set autofile=nul
set cfgfile=nul
if /I "%debug%"=="Y" set pause=pause
:menu
cls
echo Select the type of program from the list:
echo.
echo      (a) Applications
echo      (d) Development
if not "%xms%"=="0" echo      (e) OpenGEM
echo      (g) Games
echo      (l) Load Drivers
echo      (m) Media
echo      (n) Networking
echo      (p) Power - Shutdown or Reboot
echo      (s) System Utilities
echo      (u) Utilities
echo      (y) Create bootdisk for CD
echo      (x) Exit this menu
echo.
choice /n /c:adegilmnpsuyx
if "%errorlevel%"=="1" goto apps
if "%errorlevel%"=="2" goto dev
if "%errorlevel%"=="3" goto gemini
if "%errorlevel%"=="4" goto games
if "%errorlevel%"=="6" goto driver
if "%errorlevel%"=="7" goto media
if "%errorlevel%"=="8" goto net
if "%errorlevel%"=="9" goto power
if "%errorlevel%"=="10" goto sys
if "%errorlevel%"=="11" goto util
if "%errorlevel%"=="12" goto mkbt
if "%errorlevel%"=="13" goto end
goto menu
:apps
cls
echo Select the program from the list
echo.
echo      (d) FreeDOS edit
if not "%xms%"=="0" echo      (v) Temporarily install VIM to C:\ or %RD%\
echo      (x) Go to previous menu
echo.
choice /n /c:dvx
if "%errorlevel%"=="1" goto ed1
if "%errorlevel%"=="2" goto vi
if "%errorlevel%"=="3" goto menu
goto apps
:ed1
edit
%pause%
goto apps
:vi
pushd
set dosdir=c:
freetest %rd% 5 > NUL
if errorlevel 8 set dosdir=%rd%
unzip -qqod %dosdir%\ x:\freedos\packages\edit\vimrtx.zip
unzip -qqod %dosdir%\ x:\freedos\packages\edit\vim32x.zip
deltree /z /y %dosdir%\packages
echo @deltree /z /y %rd%\vim > %dosdir%\REMVIM.BAT
set vim=%dosdir%\vim
cdd %dest%vim\vim70
%pause%
.\vim
cd\
popd
set dest=
echo To remove VIM from your hard drive, execute %dosdir%\REMVIM.BAT
pause
goto apps
:dev
cls
echo Select the program from the list
echo.
echo      (b) BWBasic
echo      (w) Temporarily install Open Watcom to C:\ or %rd%\
echo      (x) Go to previous menu
echo.
choice /n /c:bwx
if "%errorlevel%"=="1" goto bwb
if "%errorlevel%"=="2" goto wat
if "%errorlevel%"=="3" goto menu
goto dev
:bwb
bwbasic
%pause%
goto dev
:wat
set dest=c:\
freetest %rd% 5 > NUL
if errorlevel 30 set dest=%rd%\
unzip -qqod %dest% x:\freedos\packages\lang\owatcomx.zip
set watcom=%dest%watcom
deltree /y /z %dest%PACKAGES\OWATCOM > NUL
rd %dest%PACKAGES
%pause%
echo @deltree /y /z c:\watcom > %dest%remwat.bat
echo Remove Open Watcom from your hard drive by executing %dest%REMWAT.BAT
pause
goto dev
:gemini
pushd
cdd x:\
%pause%
call .\gem.bat
cd\
popd
%pause%
goto menu
:games
cls
echo Select the program from the list
echo.
if not "%xms%"=="0" echo      (b) Bolitaire
if not "%xms%"=="0" echo      (d) Doom
: echo      (i) Invaders
if not "%xms%"=="0" echo      (j) Jump'n'Bump
if not "%xms%"=="0" echo      (n) Nethack
: echo      (r) Tetris
echo      (x) Go to previous menu
echo.
choice /n /c:bdijnrx
if "%errorlevel%"=="1" goto bol
if "%errorlevel%"=="2" goto doom
if "%errorlevel%"=="3" goto invad
if "%errorlevel%"=="4" goto jnb
if "%errorlevel%"=="5" goto hack
if "%errorlevel%"=="6" goto tetris
if "%errorlevel%"=="7" goto menu
goto games
:bol
pushd
unzip -qqod %rd%\ x:\freedos\packages\games\bolitarx.zip
deltree /y /z %rd%\packages > NUL
cdd %rd%\games\bolitare
%pause%
bolitare
cd\
popd
deltree /y /z %rd%\games\bolitare
rd %rd%\games
%pause%
goto games
:doom
pushd
unzip -qqod %rd%\ x:\freedos\packages\games\doomx.zip
deltree /y /z %rd%\packages > NUL
cdd %rd%\games\doom
%pause%
doom3
cd\
popd
deltree /y /z %rd%\games\doom
rd %rd%\games
%pause%
goto games
:invad
invaders
%pause%
goto games
:jnb
pushd
unzip -qqod %rd%\ x:\freedos\packages\games\jmpbumpx.zip
deltree /y /z %rd%\packages > NUL
cdd %rd%\games\jumpbump
%pause%
jumpbump
cd\
popd
deltree /y /z %rd%\games\jumpbump
rd %rd%\games
%pause%
goto games
:hack
pushd
unzip -qqod %rd%\ x:\freedos\packages\games\nethackx.zip
deltree /y /z %rd%\packages > NUL
cdd %rd%\games\nethack
%pause%
nethack
cd\
popd
deltree /y /z %rd%\games\nethack
rd %rd%\games
%pause%
goto games
:tetris
tetris
%pause%
goto games
:driver
cls
echo Select the driver from the list
echo.
echo      (c) Crynwr drivers
echo      (i) iHPFS filesystem driver
echo      (l) DOSLFN
echo      (x) Go to previous menu
echo.
choice /n /c:cilx
if "%errorlevel%"=="1" goto cryn
if "%errorlevel%"=="2" goto ihpfs
if "%errorlevel%"=="3" goto lfn
if "%errorlevel%"=="4" goto menu
goto driver
:cryn
call %dosdir%\crynwr.bat
%pause%
goto driver
:ihpfs
ihpfs
%pause%
goto driver
:lfn
lh doslfn
%pause%
goto driver
:media
cls
echo Select the program from the list
echo.
echo      (m) MPXPlay
echo      (x) Go to previous menu
echo.
choice /n /c:mx
if "%errorlevel%"=="1" goto mpxp
if "%errorlevel%"=="2" goto menu
goto media
:mpxp
mpxplay
%pause%
goto media
:net
cls
echo Select the program from the list
echo.
if not "%xms%"=="0" echo      (a) Arachne
echo      (i) BSFIRC
if not "%xms%"=="0" echo      (l) Lynx
: echo      (n) NewsABI
echo      (w) Edit WattCP.cfg (default is DHCP)
echo      (x) Go to previous menu
echo.
choice /n /c:ailnwx
if "%errorlevel%"=="1" goto arach
if "%errorlevel%"=="2" goto irc
if "%errorlevel%"=="3" goto lynx
if "%errorlevel%"=="4" goto news
if "%errorlevel%"=="5" goto wattcp
if "%errorlevel%"=="6" goto menu
goto net
:arach
pushd
unzip -qqod %rd%\ x:\freedos\packages\net\arachnex.zip
deltree /y /z %rd%\appinfo
deltree /y /z %rd%\packages
cdd %rd%\arachne
%pause%
call setup.bat
cd\
popd
deltree /y /z %rd%\arachne
%pause%
goto net
:irc
bsfirc
%pause%
goto net
:lynx
pushd
unzip -qqod %rd%\ x:\freedos\packages\net\lynxx.zip
deltree /y /z %rd%\packages
deltree /y /z %rd%\appinfo
cdd %rd%\lynx
%pause%
call lynxbat http://www.google.ca
cd\
popd
deltree /y /z %rd%\lynx
%pause%
goto net
:news
newsabi
%pause%
goto net
:wattcp
choice /c:yn Would you like to view a sample file first (do not edit)
if "%errorlevel%"=="1" edit %dosdir%\bin\wattcp.sam
if not exist %rd%\wattcp.cfg set wattcp.cfg=%rd%
if not exist %rd%\wattcp.cfg copy %dosdir%\bin\wattcp.cfg %rd%\
%pause%
edit %rd%\wattcp.cfg
%pause%
goto net
:power
cls
echo Please make a choice
echo.
echo      (r) Reboot
echo      (s) Shutdown
echo      (x) Cancel and return to menu
echo.
choice /n /c:rsx
if "%errorlevel%"=="1" goto reb
if "%errorlevel%"=="2" goto shut
if "%errorlevel%"=="3" goto menu
goto power
:reb
fdapm warmboot
%pause%
goto power
:shut
fdapm poweroff
%pause%
goto power
:sys
cls
echo Select the program from the list
echo.
: echo      (b) Bootmgr
: echo      (c) Compinfo
echo      (d) XFdisk
echo      (e) Erase ALL data on first Hard Disk
echo      (f) Fdisk
echo      (x) Go to previous menu
echo.
choice /n /c:bcdefx
if "%errorlevel%"=="1" goto bmgr
if "%errorlevel%"=="2" goto compinf
if "%errorlevel%"=="3" goto xfd
if "%errorlevel%"=="4" goto hdc
if "%errorlevel%"=="5" goto fdisk
if "%errorlevel%"=="6" goto menu
goto sys
:bmgr
bootmgr
%pause%
goto sys
:compinf
compinfo
%pause%
goto sys
:xfd
xfdisk
%pause%
goto sys
:hdc
call hdclear 0
%pause%
goto sys
:fdisk
fdisk
%pause%
goto sys
:util
cls
echo Select the program from the list
echo.
echo      (c) Check C: and fix all errors (no FAT32)
echo      (h) Help
echo      (x) Go to previous menu
echo.
choice /n /c:chx
if "%errorlevel%"=="1" goto chk
if "%errorlevel%"=="2" goto help
if "%errorlevel%"=="3" goto menu
goto util
:chk
chkdsk c: /f
%pause%
goto util
:help
help
%pause%
goto util
:mkbt
choice /c:yn Have you booted from the CD-ROM?
if "%errorlevel%"=="1" echo This will only create a boot disk with the first drive.
: if "%errorlevel%"=="2" echo This process will copy the contents of A: to B:
if "%errorlevel%"=="2" echo Not supported at this time
if "%errorlevel%"=="2" pause
if "%errorlevel%"=="2" goto menu
pause
choice /c:yn Do you wish to format the destination disk
if "%errorlevel%"=="1" format /Z:SERIOUSLY B:
%pause%
cp -r A:\*.* B:\
if not "%errorlevel%"=="0" echo Copy process failed.
if not "%errorlevel%"=="0" pause
if not "%errorlevel%"=="0" goto menu
%pause%
sys B: /BOOTONLY
%pause%
echo Boot disk created.
pause
goto menu
:end
%pause%
