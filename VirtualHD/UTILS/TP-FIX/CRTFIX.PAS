uses DOS;

{ Global constants }
const BUF_SIZE=61440;           { read buffer size           }
      FIRST_LEN = 30;           { length of first proc       }
      CODE_LEN=44;              { code length in bytes       }
      BackupExt='.CRT';         { extension for backup files }
      MaskExt='*.EXE';          { default mask extension     }
      { code as it is in buggy files }
      BUG_CODE:array[0..CODE_LEN-1] of byte=($FF, $DC, $36, $8B, $4F, $00, $E3,
                                             $13, $8E, $06, $00, $00, $33, $FF,
                                             $26, $8A, $1D, $A1, $00, $00, $33,
                                             $D2, $E8, $00, $00, $E2, $F6, $CA,
                                             $02, $00, $2D, $01, $00, $83, $DA,
                                             $00, $72, $05, $26, $3A, $1D, $74,
                                             $F3, $C3);
      { code as it should be }
      FIX_CODE:array[0..CODE_LEN-1] of byte=($FF, $DC, $36, $8B, $4F, $04, $E3,
                                             $13, $8E, $06, $44, $00, $33, $FF,
                                             $26, $8A, $1D, $A1, $00, $00, $51,
                                             $E8, $00, $00, $59, $E2, $F6, $CA,
                                             $02, $00, $48, $B9, $2A, $00, $E2,
                                             $FE, $74, $05, $26, $3A, $1D, $74,
                                             $F3, $C3);

var s, mask: string;                       { temp string; search mask      }
    p: DirStr; n: NameStr; e: ExtStr;      { temp strings                  }
    buf: array[0..BUF_SIZE-1] of byte;     { read buffer                   }
    i, code, proc, patch, found: integer;  { some stuff;; number of processed,
                                             found and patched files       }
    MaxDelay: word;                        { Maximal delay factor          }
    IOerrs, del: word;                     { # of I/O errors, delay factor }
    backup, test, ask, log, recur: boolean;{ backup files, only test, ask
                                             before patching, write log file,
                                             recursive search              }
    norefix: boolean;                      { do not reapply fix            }
    patchonly: boolean;                    { log patched files only        }
    logfile: text;                         { log file                      }

{ ReadKey - just like in CRT }
function ReadKey: char;
begin
  asm
    mov ah, 0
    int 16h
    mov @Result, al
  end
end;

{ Write string with specified color }
procedure ColorWrite(str: string; color: byte);assembler;
asm
  push bp          { save BP or pascal will die }
  { get cursor coordinates }
  mov ah, 03h      { function number            }
  xor bh, bh       { video page number          }
  int 10h
  { write string }
  mov ah, 13h      { function number            }
  mov al, 01       { write mode - update cursor }
  mov bl, color    { string attributes          }
  les bp, str      { load string                }
  xor ch, ch       { clear CH                   }
  mov cl, es:[di]  { read string lenght in CX   }
  inc bp           { ES:BP point to string data }
  int 10h
  pop bp           { restore BP                 }
end;

{ makes string consisting of given substring }
function MakeStr(sub: string; count: integer): string;
var res: string;
    i: integer;

begin
  res:='';
  for i:=1 to count do
      res:=res+sub;
  MakeStr:=res;
end;

{ writes integer in hex }
function IntToHex(val: longint): string;
const HexChars: array[0..15] of char='0123456789ABCDEF';

var res: string;
    i: integer;

begin
  res:='h';
  for i:=1 to 8 do begin
      res:=HexChars[val and $F]+res;
      val:=val shr 4;
  end;
  IntToHex:=res;
end;

{ show warning if maximal delay factor is low }
procedure Warning;
begin
  WriteLn;
  WriteLn('WARNING: Current maximal delay factor (', MaxDelay, ') is low for your computer.');
  WriteLn('         Use /m option to make it higher.');
  Readkey;
end;

{ auto-detect required delay factor }
function DelDetect: word;
var left, right: word;

begin
  asm
    { initialize }
    mov ax, 40h       { set ES:DI to $40:$6C }
    mov es, ax        { (timer counter)      }
    mov di, 6Ch
    mov left, 0       { find delay factor in }
    mov dx, MaxDelay  { range 0..MaxDelay    }
    mov right, dx
@test:
    mov dx, left
    add dx, right
    shr dx, 1
    mov ax, 0FFFFh    { set AX to maximum        }
    { wait to the end of this tick }
    mov bl, es:[di]   { save current timer value }
@start:               { wait until it changes    }
    cmp bl, es:[di]
    je @start
    { emulate Delay()'s work }
    mov bl, es:[di]   { save current timer value }
@loop:
    dec ax            { decrease AX              }
    mov cx, dx        { make pause for a while   }
@pause: loop @pause
    je @end
    cmp bl, es:[di]   { until timer changes      }
    je @loop
@end:
    cmp ax, 6000      { Test AX: 1) normal values  }
    ja @dec           { bigger - decrease delay    }
    cmp ax, 800       { 2) small values            }
    jb @inc           { - increase delay           }
    jmp @done         { AX is ok - detection done  }
@dec:
    mov right, dx     { decrease delay             }
    jmp @test         { retest                     }
@inc:
    mov ax, MaxDelay  { test if maximal delay is   }
    dec ax            { reached                    }
    cmp dx, ax        { if so                      }
    jz @smallmax      { show warning and return    }
    mov left, dx      { increase delay             }
    jmp @test         { retest                     }
@smallmax:
    call Warning      { show warning               }
    mov dx, right     { set delay to maximum       }
@done:
    mov @Result, dx   { return delay factor        }
  end;
end;

{ Backups file }
procedure BackupFile(oldname: string);
var oldf, newf: file;
    size: longint;
    newname: string;

begin
  { make new name - with extension BackupExt }
  size:=Pos('.', oldname);                             { find dot's position }
  if i=0 then newname:=oldname+BackupExt               { dot not found       }
     else newname:=copy(oldname, 1, size-1)+BackupExt; { dot found           }
  { write info }
  Write('Backuping (', oldname, ' -> ', newname, ')... ');
  { try to open files }
  Assign(oldf, oldname);
  Assign(newf, newname);
  {$I-}
  Reset(oldf, 1);
  if IOResult<>0 then begin
     { failed }
     WriteLn('Can''t open file "'+oldname+'"!');
     inc(IOerrs);
     exit;
  end;
  Rewrite(newf, 1);
  if IOResult<>0 then begin
     { failed }
     WriteLn('Can''t create file "'+newname+'"!');
     inc(IOerrs);
     exit;
  end;
  {$I+}
  { read file and write it to new destination }
  while not EOF(oldf) do begin
    if FileSize(oldf)-FilePos(oldf)>BUF_SIZE then size:=BUF_SIZE
       else size:=FileSize(oldf)-FilePos(oldf);
    BlockRead(oldf, buf, size);
    BlockWrite(newf, buf, size);
  end;
  { close all }
  Close(newf);
  Close(oldf);
  { write info }
  WriteLn('Done.');
end;

{ try to fix file }
procedure Fix(fname: string);
var f: file;
    i, size, fpos, ps: longint;
    BugPos, FixPos: integer;
    key: char;
    attr: word;

label _FIX_;

begin
  { try to open file }
  Assign(f, fname);
  { readonly file }
  GetFAttr(f, attr);
  if attr and ReadOnly>0 then SetFAttr(f, attr - ReadOnly);
  {$I-}
  Reset(f, 1);
  if IOResult<>0 then begin
     { failed }
     WriteLn('Can''t open file "', fname, '"!');
     if log and not patchonly then Write(logfile, 'Can not open file!');
     inc(IOerrs);
     exit;
  end;
  {$I+}
  { set positions in BUGGY and FIXED code to 0 }
  BugPos:=0;
  FixPos:=0;
  { search for it... }
  Write('Searching for buggy subroutine... ');
  while not EOF(f) do begin
    { get size to read }
    if FileSize(f)-FilePos(f)>BUF_SIZE then size:=BUF_SIZE else
       size:=FileSize(f)-FilePos(f);
    { read file to buffer }
    BlockRead(f, buf, size);
    ps:=FilePos(f);
    { search in buffer }
    i:=0;
    while i<size do begin
        { on some positions we have to remember original contents }
        if (BugPos=5) or (BugPos=10) or (BugPos=11) or
           (BugPos=18) or (BugPos=19) then FIX_CODE[BugPos]:=buf[i];
        if (BugPos=23) then FIX_CODE[22]:=buf[i];
        if (FixPos=5) or (FixPos=10) or (FixPos=11) or
           (FixPos=18) or (FixPos=19) or (FixPos=22) then FIX_CODE[FixPos]:=buf[i];
        { check for original code }
        if (buf[i]=BUG_CODE[BugPos]) or (BugPos=5) or (BugPos=10)
           or (BugPos=11) or (BugPos=18) or (BugPos=19) or (BugPos=23) then inc(BugPos) else
              if BugPos>0 then begin           { we should unroll         }
                 BugPos:=0;                    { search for the beginning }
                 continue;                     { unroll in buffer         }
              end;
        { original code found }
        if BugPos=CODE_LEN then begin
           { write info }
           ColorWrite('Found!', $A);
           WriteLn;
           { remember position of code in file and go to fix it }
           fpos:=ps-size+i-FIX_CODE[22]+5-CODE_LEN+1;
           inc(FIX_CODE[22]);
           goto _FIX_;
        end;
        { check for patched code }
        if (buf[i]=FIX_CODE[FixPos]) or (FixPos=32) or (FixPos=33)
           then inc(FixPos) else
              if FixPos>0 then begin           { we should unroll         }
                 FixPos:=0;                    { search for the beginning }
                 if BugPos>0 then dec(BugPos); { update BUG_CODE position }
                 continue;                     { unroll in buffer         }
              end;
        { patched code found }
        if FixPos=CODE_LEN then begin
           { write info }
           ColorWrite('Fixed code found!', $E);
           WriteLn;
           { remember position of code in file and go to fix it }
           fpos:=ps-size+i-FIX_CODE[22]+6-CODE_LEN+1;
           goto _FIX_;
        end;
        { skip sadly piece of code }
        if (BugPos=FIRST_LEN) or (FixPos=FIRST_LEN) then begin
           inc(i, FIX_CODE[22] - 5);
           if (FixPos=FIRST_LEN) then dec(i);
           if (i>=size) then seek(f, ps+i-size+1);
        end;
        inc(i);
    end;
  end;
  { nothing was found }
  WriteLn('NOT found!');
  if log and not patchonly then Write(logfile, '    Not found       No        No');
  if attr and ReadOnly>0 then SetFAttr(f, attr); { restore readonly attrib }
  Close(f);
  exit;
  { fix code }
_FIX_:
  inc(found);
  Close(f);                              { close file                     }
  { logging }
  if log and patchonly then Write(logfile, FExpand(fname), MakeStr(' ', 46-Length(FExpand(fname))));
  if log then Write(logfile, IntToHex(fpos):13);
  if test or ((FixPos=CODE_LEN) and norefix) then begin { test mode or no refix }
     if log then Write(logfile, '       No        No');
     if log and patchonly then WriteLn(logfile);
     { restore readonly attribute }
     if attr and ReadOnly>0 then SetFAttr(f, attr);
     exit;
  end;
  if ask then begin                      { ask for patching               }
     repeat                              { force user to press <Y> or <N> }
        if backup then                   { prompt                         }
           Write('Patch this file (Y/N/Q)? ')
        else
           Write('Patch this file (Y/N/B/Q)? ');
        key:=UpCase(ReadKey);
        WriteLn(key);
        { analys pressed key }
        if (key='B') and not backup then begin
           BackUpFile(fname);
           if log then Write(logfile, '      Yes       Yes');
           break;
        end;
        if key='N' then begin      { exit if we shouldn't patch this file }
           if log then Write(logfile, '       No        No');
           { restore readonly attribute }
           if attr and ReadOnly>0 then SetFAttr(f, attr);
           exit;
        end;
        if key='Q' then begin      { exit from program              }
           { restore readonly attribute }
           if attr and ReadOnly>0 then SetFAttr(f, attr);
           halt(0);
        end;
     until (key='Y');
  end;
  if backup then begin             { if we need to backup file            }
     BackUpFile(fname);
     if log then Write(logfile, '      Yes       Yes');
  end else if log then Write(logfile, '      Yes        No');
  { try to reopen file }
  Assign(f, fname);
  {$I-}
  Reset(f, 1);
  if IOResult<>0 then begin              { failed                         }
     WriteLn('Can''t open file "', fname, '"!');
     if log and not patchonly then Write(logfile, 'Can not open file!');
     inc(IOerrs);
     exit;
  end;
  {$I+}
  { write info }
  if BugPos=CODE_LEN then Write('Fixing code... ')
     else Write('Refixing code... ');
  { fix first part of code }
  Seek(f, fpos);
  BlockWrite(f, FIX_CODE, FIRST_LEN);
  { fix second part }
  Seek(f, fpos+FIRST_LEN + FIX_CODE[22]-6);
  BlockWrite(f, FIX_CODE[FIRST_LEN], CODE_LEN-FIRST_LEN);
  WriteLn('Fixed.');                  { write info                         }
  if attr and ReadOnly>0 then SetFAttr(f, attr); { restore readonly attrib }
  Close(f);                           { close file            }
  inc(patch);                         { one more file fixed   }
  { logging }
  if log and patchonly then WriteLn(logfile);
end;

{ Search files in current directory }
procedure Search;
var srch: SearchRec;
    curmask, msk: string;
    mpos: byte;

begin
  msk:=mask; mpos:=1;          { init mask extracting    }
  while mpos>0 do begin        { while some masks left   }
      mpos:=pos(';', msk);     { find mask separator (;) }
      if mpos>0 then begin     { if found                }
         curmask:=copy(msk, 1, mpos-1); { - extract mask }
         delete(msk, 1, mpos); { and delete it in place  }
      end else curmask:=msk;   { if not - copy last mask }
      { try to find first matching file }
      FindFirst(curmask, AnyFile-VolumeID-Directory, srch);
      while DosError=0 do begin  { while we can find anything }
          WriteLn('Processing file "', FExpand(srch.name), '".');  { write info }
          { logging }
          if log and not patchonly then Write(logfile, FExpand(srch.name), MakeStr(' ', 46-Length(FExpand(srch.name))));
          Fix(srch.name);      { try to fix file          }
          { logging }
          if log and not patchonly then WriteLn(logfile);
          inc(proc);           { one more file is checked }
          FindNext(srch);      { try to find next         }
      end;
  end;
  if recur then begin      { if resursive search - find all subdirictories }
     FindFirst('*.*', AnyFile-VolumeID, srch);
     while DosError=0 do begin  { while we can find anything }
        { if this is real directory }
        if (srch.attr and Directory>0) and (srch.name<>'.') and (srch.name<>'..') then begin
            {$I-}
            ChDir(srch.name);   { change directory   }
            if IOResult<>0 then begin
               WriteLn('Can not change directory to ''', srch.name, '''!');
               inc(IOerrs);
               ReadKey;
               continue;
            end;
            {$I+}
            Search;             { search in current  }
            ChDir('..');        { restore directory  }
        end;
        FindNext(srch);         { try to find next   }
     end;
  end;
end;

{ Teachs user }
procedure GetHelp;
begin
  WriteLn('USAGE: CRTFix [options] <file_masks>');
  WriteLn('  where: file_masks are masks of files to be patched and options are:');
  WriteLn('         /a - ask before patching files;');
  WriteLn('         /b - backup files;');
  WriteLn('         /d## - set delay factor to ## (0 for autodetect);');
  WriteLn('         /m## - set maximal delay factor to ##;');
  WriteLn('         /e - do not reapply patch;');
  WriteLn('         /l - write log file;');
  WriteLn('         /p - write to log only files, containing CRT code;');
  WriteLn('         /r - recursive search;');
  WriteLn('         /t - test mode: only search for code, but don''t patch;');
  WriteLn('         /h or /? - this help.');
  WriteLn;
  halt(0);
end;

begin
  { Write header }
  WriteLn;
  WriteLn('CRTFix version 1.16');
  WriteLn('by Eugene Toder, 2001.');
  WriteLn('Fixes error that cases run-time error 200 in programms that uses CRT unit.');
  WriteLn('Can be applied to EXEs, TPUs, TPLs,.. Support ALL versions of BP (I hope;)');
  WriteLn;
  { set default values }
  del:=0;               { auto-detect delay factor   }
  backup:=false;        { don't backup files         }
  test:=false;          { don't just test            }
  ask:=false;           { don't ask before patching  }
  log:=false;           { don't write log            }
  patchonly:=false;     { log patched files only     }
  recur:=false;         { don't use recursive search }
  norefix:=false;       { reapply fix                }
  mask:='';             { empty search mask          }
  MaxDelay:=400;        { Maximal delay - rather big }
  { read command-line parameters }
  for i:=1 to ParamCount do begin
      s:=ParamStr(i);             { read parameter }
      { if parameter starts with / or - it's a switch, else - a search mask }
      if (s[1]<>'/') and (s[1]<>'-') then begin { file mask }
         { if mask isn't full (dont have '.') - extend it with '.exe' }
         if Pos('.', s)=0 then s:=s+MaskExt;
         if mask='' then mask:=s else mask:=mask+';'+s;   { save mask }
      end else begin
         s[2]:=UpCase(s[2]);
         if (Length(s)>2) and not ((s[2]='D') or (s[2]='M')) then begin { wrong long switch }
            WriteLn('Invalid parameter: "'+s+'"!');
            WriteLn;
            GetHelp;
         end;
         case s[2] of                             { analys switch           }
           'A': ask:=true;                        { /a - ask                }
           'B': backup:=true;                     { /b - backup files       }
           'D': begin                             { /d - delay factor       }
                  Val(copy(s, 3, 100), del, code);
                  if code<>0 then begin           { error converting to int }
                     WriteLn('Invalid delay factor: "'+copy(s, 3, 100)+'"!');
                     WriteLn;
                     GetHelp;
                  end;
                end;
           'M': begin                             { /m - max delay factor   }
                  Val(copy(s, 3, 100), MaxDelay, code);
                  if code<>0 then begin           { error converting to int }
                     WriteLn('Invalid delay factor: "'+copy(s, 3, 100)+'"!');
                     WriteLn;
                     GetHelp;
                  end;
                end;
           'E': norefix:=true;                    { /e - don't reapply fix  }
           'L': log:=true;                        { /l - write log file     }
           'P': patchonly:=true;                  { /p - log patched only   }
           'R': recur:=true;                      { /r - recursive search   }
           'H', '?': GetHelp;                     { /h, /? show help        }
           'T': test:=true;                       { /t - test mode          }
         else
           { unknown switch }
           WriteLn('Invalid parameter: "'+s+'"!');
           WriteLn;
           GetHelp;
         end;
      end;
  end;
  if mask='' then begin { mask wasn't specified }
     WriteLn('Not enough actual parameters!');
     WriteLn;
     GetHelp;
  end;
  if (del=0) and not test then begin { auto-detect delay factor }
     Write('Determining delay factor... ');
     del:=DelDetect;
     WriteLn('Done.');
  end;
  { write info }
  if test then WriteLn('Test mode.') else
     WriteLn('Delay factor is ', del, '.');
  WriteLn;
  { place delay factor in code }
  FIX_CODE[32]:=Lo(del);
  FIX_CODE[33]:=Hi(del);
  { anti-self-patching trick }
  BUG_CODE[0]:=$8B;
  FIX_CODE[0]:=$8B;
  { nothing found or patched yet }
  proc:=0;
  patch:=0;
  found:=0;
  IOerrs:=0;    { not I/O errors yet }
  { logging }
  if log then begin
     Assign(logfile, 'crtfix.log');
     {$I-}
     Rewrite(logfile);
     if IOResult<>0 then begin
        WriteLn('Can not create log file!');
        inc(IOerrs);
        exit;
     end;
     {$I+}
     WriteLn(logfile, 'FILE NAME                                     CODE POSITION  PATCHED  BACKUPED');
     WriteLn(logfile, '------------------------------------------------------------------------------');
  end;
  { get path from 1st mask }
  FSplit(mask, p, n, e);
  if pos(';', mask)>0 then             { if there are several masks }
     delete(mask, 1, pos(';', mask)-1) { we'll add them to the tail }
  else mask:='';
  mask:=n+e+mask;                      { reassemble mask            }
  GetDir(0, s);                        { save current directory     }
  {$I-}
  ChDir(p);                            { try to change directory    }
  if IOResult<>0 then begin
     WriteLn('Can not change directory to ''', p, '''!');
     inc(IOerrs);
     exit;
  end;
  {$I+}
  Search;                              { search for files           }
  ChDir(s);                            { restore directory          }
  if proc>0 then WriteLn;
  { write statictis }
  if proc=0 then WriteLn('No files found!')
     else WriteLn(proc, ' file(s) processed, code found in ', found, ' file(s), ', patch, ' file(s) patched.');
  WriteLn(IOerrs, ' I/O error(s).');
  { logging }
  if log then begin
     if proc=0 then WriteLn(logfile, 'No files found!')
        else WriteLn(logfile, proc, ' file(s) processed, code found in ', found, ' file(s), ', patch, ' file(s) patched.');
     WriteLn(logfile, IOerrs, ' I/O error(s).');
  end;
  { close log }
  if log then Close(logfile);
  WriteLn;
end.