rem Copyright © 2021 by Brett Kuntz. All rights reserved.

@echo off

if exist gamedbg.obj del gamedbg.obj
if exist gamedbg.dll del gamedbg.dll
if exist gamedbg.lib del gamedbg.lib
if exist gamedbg.exp del gamedbg.exp
if exist gamedbg.exe del gamedbg.exe

\masm32\bin\ml /c /coff gamedbg.asm
\masm32\bin\Link /SUBSYSTEM:WINDOWS /DLL gamedbg.obj

if exist gamedbg.obj del gamedbg.obj
if exist gamedbg.lib del gamedbg.lib
if exist gamedbg.exp del gamedbg.exp

if exist gamedbg.dll dir gamedbg.dll

pause