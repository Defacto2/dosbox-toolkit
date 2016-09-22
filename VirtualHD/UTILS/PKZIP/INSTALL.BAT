@echo off
cls
if %1x == x goto help
if %2x == x goto help
echo This will copy all the PKZIP files to %2\PKWARE
echo Press Ctrl Break to abort or any other key to continue
pause >nul
mkdir %2\pkware
copy %1*.* %2\pkware
%1pkunzip -o %1docs %2\pkware
goto END
:help
echo PKWARE PKZIP 2 Installation
echo ------------------------------------------------------------------ 
echo Usage: INSTALL [source:] [destination:]
echo ------------------------------------------------------------------
echo Example:  INSTALL A: C:  -- Will install PKZIP from A: to the C: drive
echo -
:END
