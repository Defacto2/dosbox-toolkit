README for DOSBox SVN-lfn: DOSBox with Long File Name (LFN) and mouse copy/paste support by Wengier

== Introduction ==
DOSBox is a great software which will emulate DOS under various operating systems such as Windows, Linux and Mac OS X. Unfortunately, the latest official version of DOSBox still lacks Long File Name (LFN) support and mouse copy/paste support, which are two very useful features. The LFN feature for example is implemented since MS-DOS 7.x and Windows 95. I have seen many DOSBox users requested these two features in the past years in various forums, but no solutions were yet given. So I decided to go ahead myself and was able to implement both LFN and mouse copy/paste support for DOSBox. 

== Features ==
This enhanced SVN build of DOSBox, known simply as DOSBox SVN-lfn, is based on the latest official DOSBox SVN version, currently at r3995 as of 2016. LFN support in DOSBox SVN-lfn comes with two parts, one is LFN support for DOSBox shell commands such as DIR, CD and COPY (as well as the auto-completion feature of the Tab key), and the other is the implementation of Int21/AX=71xx functions for LFN-aware DOS programs. Currently the first part should generally work fine, and for the second part - the great majority of Int21/AX=71xx functions have been fully or mostly implemented, so many or most LFN-aware DOS programs should work fine with LFN in DOSBox SVN-lfn now. There are many such programs, and to name a few: MS-DOS 7 EDIT, PKUNZIP 2.50, MPXPLAY, QuickView Pro and Doszip Commander. Since some of the LFN functions have not been implemented completely, issues with certain LFN-aware DOS programs may occur. Besides providing Long File Name support, it will also use the actual Windows 8.3 names instead of generating random 8.3 names by itself on Windows platforms (the latter approach is used by probably all official versions of DOSBox), although it will still generate random 8.3 names by itself on non-Windows platforms or if 8.3 name generations are disabled on the host systems. For the mouse copy/paste feature, you can now use the right mouse button to select, copy and paste text from and to DOSBox (when the mouse is not locked). There will be a marker when you select text on the screen by mouse. The KEYBUF.COM program is included and automatically loaded in dosbox.conf to set the size of the BIOS keyboard buffer (to 1024 by default, which is easily expandable). The keyboard shortcut Alt-F10 can also be used to paste text into the DOSBox SVN-lfn window. Furthermore, it also includes DBCS support patches by cyberwalker and myself for displaying CJK (East Asian) characters as well as accessing paths containing these characters. Automatic drive mounting is now also supported and turned on by default, as well as LPT1 parallel port passthrough for printing support. If you want to send a form feed to the printer at LPT1 for example, simply enter "ECHO ^L >LPT1" (^L means Ctrl+L) in the DOSBox SVN-lfn command line as in a real DOS system to start printing a page immediately. In addition, powering off DOSBox SVN-lfn using the Advanced Power Management (APM) is supported (e.g. you can use "FDAPM PUREOFF" to shut down DOSBox SVN-lfn if you have the FreeDOS FDAPM utility) rather than using the standard EXIT command.

The Windows binary (along with required DLLs, zipped) is provided (compiled with either Visual Studio or MinGW), and it has been tested to run on recent versions of Windows such as Windows 7/8 and Windows 10 (both 32-bit and 64-bit) as well as older Windows versions such as Windows 98 and Windows 2000/XP. For DOS enthusiasts, the Win32 executable built with MinGW can also be launched from a real DOS system with the help of HX DOS Extender (verified with version 2.16; make sure DOSLFN is loaded and then use the -g option for DPMILD32). Moreover, the source code is provided and it has been tested to work on other operating systems such as Unix-like OSes too (the pdcurses library may be required for cross-platform clipboard copy/paste support; make sure C_CLIPBOARD is defined to be 1 in config.h after configuring but before compiling if you want this feature). For more information and download links (both binary and source code) relating to my LFN-supporting versions of DOSBox and vDos (i.e. vDos-lfn, another DOS emulator for Windows, which is derived from DOSBox), please visit the page made by Edward Mendelson (emendelson) here: http://www.wpdos.org/dosbox-vdos-lfn.html

You can also visit the following threads for related discussions regarding support for long file names and mouse copy/paste in the DOSBox Patches forum:

Long File Name (LFN) support: http://www.vogons.org/viewtopic.php?t=40610
Mouse copy/paste support: http://www.vogons.org/viewtopic.php?t=41179

== Settings ==
You can change the settings of both Long File Name (LFN) and mouse copy/paste support in dosbox.conf.

1. For LFN feature, there is a setting named "lfn" in the [dos] section of dosbox.conf, which can be set to either true, false, or auto. When setting to "auto", LFN support will be enabled if and only if the major DOS version to report is set to at least 7 in dosbox.conf (e.g. by setting for example "ver=7" or "ver=7.10" in the file; the latter [=7.10] is the default DOS version) or using the "ver set" command within DOSBox SVN-lfn. If "lfn" is set to true or false in dosbox.conf, then LFN support will be enabled or disabled regardless of what the DOS version to report is set to be.

2. For mouse copy/paste support, there is a setting named "clipboardmodifier" in the [sdl] section of dosbox.conf, which can be set to none, alt, lalt, ralt, and disabled. When setting to none (default), there will be no keyboard modifier required when using the right mouse button to select, copy or paste. When setting to lalt, or ralt, or alt, then the left ALT, right ALT, or either ALT will be used as the keyboard modifier for the mouse copy/paste function. When setting to disabled, then the mouse copy/paste function will be disabled.

3. In addition, you can enable or disable automatic drive mounting by modifying the "automount" setting in the [dos] section of dosbox.conf. Direct passthrough of parallel ports (LPT1, LPT2, LPT3, and PRN) can also be set in the [parallel] section of dosbox.conf. You can also change the string displayed in the DOSBox title bar by modifying the value of the setting called "titlebar" in the [sdl] section of dosbox.conf.

== Credits ==
This program is free software. You can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

Official DOSBox SVN version, by the DOSBox Team, Copyright (C) 2002-2013.
Long File Name (LFN) and mouse copy/paste support, by Wengier, 2014-2016.

Acknowledgements:
LFN support from the idea of the DOSLFN authors, Henrik Haftmann and Jason Hood.
Mouse copy/paste support from the idea of the PC-BASIC author, Rob Hagemans, and my contact Roy Tam.

And many ideas from the DOSBox Patches forum, such as those from truth5678, ripsaw8080, emendelson, and Dominus.

Also thanks other people who have support it too!

If you have any comments, feedbacks or bug reports, you can also contact me via email: wengierwu@yahoo.com

Wengier
September 2016