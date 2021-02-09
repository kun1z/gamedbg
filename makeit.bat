rem Copyright © 2021 by Brett Kuntz. All rights reserved.

@echo off

if not exist rsrc.rc goto over1
\masm32\bin\rc /v rsrc.rc
\masm32\bin\cvtres /machine:ix86 rsrc.res
:over1

if exist "gamedbg.obj" del "gamedbg.obj"
if exist "gamedbg.exe" del "gamedbg.exe"

\masm32\bin\ml /c /coff "gamedbg.asm"
if errorlevel 1 goto errasm

if not exist rsrc.obj goto nores

\masm32\bin\Link /SUBSYSTEM:WINDOWS "gamedbg.obj" rsrc.res
if errorlevel 1 goto errlink

dir "gamedbg.*"
goto TheEnd

:nores
\masm32\bin\Link /SUBSYSTEM:WINDOWS "gamedbg.obj"
if errorlevel 1 goto errlink
dir "gamedbg.exe"
goto TheEnd

:errlink
echo _
echo Link error
goto TheEnd

:errasm
echo _
echo Assembly Error
goto TheEnd

:TheEnd

pause