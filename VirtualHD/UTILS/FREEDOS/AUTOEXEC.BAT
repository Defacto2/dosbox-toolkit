@echo off 
set PATH=A:
set temp=A:
set tmp=A:
set helppath=a:\ 
SET BLASTER=A220 I5 D1 H5 P330
REM LH DISPLAY CON=(EGA,,1)
REM MODE CON CP PREP=((858) A:\cpi\EGA.CPX)
REM MODE CON CP SEL=858
rem below is the mscdex clone. Gives a driveletter to your cdrom-drive,
rem if you have loaded a cdrom-driver driver in config.sys first
REM Shsucdx /D:?FDCD0001 /D:?FDCD0002 /D:?FDCD0003
REM LH KEYB US,,C:\FDOS\bin\KEY\US.KL  
CTMOUSE
