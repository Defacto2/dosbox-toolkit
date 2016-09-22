if "%1" == "" goto help
if "%1" == "/?" goto help
if "%1" == "-h" goto help
if "%1" == "--help" goto help
if "%1" == "-help" goto help
if "%1" == "--h" goto help
choice /b /c:yn Are you REALLY sure you want to delete ALL data on HD %1 
if errorlevel 2 goto end
if errorlevel 1 goto yes
goto end
:help
echo HDCLEAR
echo.
echo Use this batch file to erase the partition table on a hard drive.
echo Valid hard drives are 0, 1, 2, and 3.  For you first hard disk,
echo you would type 0, for your second, 2, etc..
echo.
echo Examples:
echo.
echo hdclear 0              - Erases first hard disk
echo hdclear 2              - Erases third hard disk
goto end
:yes
echo After this there is no turning back!!!
choice /b /c:yn Do you REALLY want to do this?
if errorlevel 2 goto end
if errorlevel 1 goto really
goto end
:really
if "%1" == "0" debug < g:\fdos\bin\hd1clean.dbg
if "%1" == "1" debug < g:\fdos\bin\hd2clean.dbg
if "%1" == "2" debug < g:\fdos\bin\hd3clean.dbg
if "%1" == "3" debug < g:\fdos\bin\hd4clean.dbg
if "%1" == "4" goto help
if "%1" == "5" goto help
if "%1" == "5" goto help
if "%1" == "6" goto help
if "%1" == "7" goto help
if "%1" == "8" goto help
if "%1" == "9" goto help
goto end
:end