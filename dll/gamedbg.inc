; Copyright © 2021 by Brett Kuntz. All rights reserved.

    include \masm32\include\windows.inc
    include \masm32\include\kernel32.inc
    include \masm32\include\user32.inc
    include \masm32\include\fpu.inc

    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\fpu.lib

    UNSET equ 0
    WAITING equ 1
    SET equ 2
    ONCREATE EQU 3
    ONCREATETEXTURE EQU 4
    ONCREATEMODEL EQU 5

    pz macro
        jmp @F
        pstring db "Error", 0
        @@: test eax, eax
        jnz @F
        invoke MessageBox, 0, addr pstring, 0, 0
        @@:
    endm

    pnz macro
        .data?
        pbuffer db 32 dup(?)
        .code
        jmp @F
        pstring db "Error: %u - %08X", 0
        @@: test eax, eax
        jz @F
        invoke wsprintf, addr pbuffer, addr pstring, eax, eax
        invoke MessageBox, 0, addr pbuffer, 0, 0
        @@:
    endm

.data?
    prev_seh dd ?
    framedump dd ?
    tracedump dd ?
    dll_lower dd ?
    dll_upper dd ?
    d3dx_lower dd ?
    d3dx_upper dd ?
    d3d9_lower dd ?
    d3d9_upper dd ?
    hook_hwnd dd ?

    last_frame_time dq ?

    frame_time dt ?
    cpu_freq dt ?

    wnd_name db 64 dup(?)
.code
    errormsg db "There was an error loading GameDbg.", 13, 10, "The application may not be using DirectX 9.", 0
    d3d9dll db "d3d9.dll", 0
    LDirect3DCreate9 db "Direct3DCreate9", 0
    dxprofilerdll db "gamedbg.dll", 0
    cfg_name db "settings.ini", 0
    appname db "Settings", 0
    keyname db "Window_Name", 0
    seh_er db "The following exception has occured:", 13, 10, 13, 10, "[incomplete]", 0