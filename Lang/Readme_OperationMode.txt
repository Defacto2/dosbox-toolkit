D-Fend Reloaded knows 3 operation modes:

1.) D-Fend style:
Configuration data is stored in subdirectories of the D-Fend Reloaded program folder
(like D-Fend does). This works fine under XP if you are Admin. Unter Vista you will have problems.

2.) User directory style:
D-Fend Reloaded will use your personal data folder for settings (under Vista "C:\Users\<YourName>\D-Fend Reloaded\").
This is the most recommended operation mode.

3.) Portable mode:
Like 1.) but additionally the DOSBox directory, the games directory, the games data directory, the ScummVM directory, the path to QBasic, the wave->ogg and the wave->mp3 encoder will be stored relative to the program folder so you can
use D-Fend Reloaded from any drive.


To manually setup the operation mode you have to change the "DFend.dat" in the D-Fend Reloaded program folder.
The "DFend.dat" is a text file which should contain exactly one of the following lines:

PRGDIRMODE
USERDIRMODE
PORTABLEMODE

"PRGDIRMODE" is for operation mode 1, "USERDIRMODE" for operation mode 2 and "PORTABLEMODE" for operation mode 3.

If you have used the installer to install D-Fend Reloaded there ist no need to change the operation mode.