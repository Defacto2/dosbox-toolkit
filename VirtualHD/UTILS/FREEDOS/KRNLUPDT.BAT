wget --output-document=%dosdir%\kernel.sys http://www.fdos.org/kernel/KERNEL.dev.SYS
wget --output-document=%dosdir%\command.zip http://www.fdos.org/kernel/cmdxms.HEAD.zip
wget --output-document=%dosdir%\kernel16.zip http://www.fdos.org/kernel/kwc8616.dev.zip
wget --output-document=%dosdir%\sys.com http://www.fdos.org/kernel/SYS.dev.COM
if not exist %dosdir%\kernel.sys goto error
if not exist %dosdir%\kernel16.zip
if not exist %dosdir%\command.zip goto error
if not exist %dosdir%\sys.com goto error
unzip -d %temp%\ -o -qq %dosdir%\command.zip
unzip -d %temp%\ -o -qq %dosdir%\kernel16.zip
copy /y %temp%\command.com %dosdir%\bin
copy /y %dosdir%\kernel.sys %dosdir%\bin
copy /y %temp%\kwc8616.sys %dosdir%\bin\kernel16.sys
copy /y %dosdir%\sys.com %dosdir%\bin
copy /y %dosdir%\bin\command.com c:\
copy /y c:\kernel.sys c:\kernel.bak
echo Old kernel backed up to C:\KERNEL.BAK
copy /y %dosdir%\bin\kernel.sys c:\
del %dosdir%\command.zip
del %dosdir%\kernel.sys
del %dosdir%\kernel16.zip
del %dosdir%\sys.com
del %temp%\*.*
goto end
:error
echo Something failed.  Be sure that a packet driver is installed.
goto end
:end
