; Copyright © 2021 by Brett Kuntz. All rights reserved.

    .686p
    .MMX
    .model flat, stdcall
    option casemap :none

    include \masm32\include\windows.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc

    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib

    WinMain proto

.code
    k32module db "Kernel32", 0
    llfunc db "LoadLibraryA", 0
    dll_name db "gamedbg.dll", 0
    cfg_name db "settings.ini", 0
    appname db "Settings", 0
    keyname db "Window_Name", 0
    errormsg db "Unable to find the Program.", 0
start:
    invoke WinMain
; ##########################################################################
WinMain proc

    local cmd_line[512]:byte
    local window_name[128]:byte
    local hpid:dword

    invoke GetFullPathName, addr cfg_name, 512, addr cmd_line, 0
    invoke GetPrivateProfileString, addr appname, addr keyname, 0, addr window_name, sizeof window_name, addr cmd_line
    invoke GetFullPathName, addr dll_name, 512, addr cmd_line, 0
    invoke FindWindow, 0, addr window_name
    test eax, eax
    jz nf
xf: mov ecx, eax
    invoke GetWindowThreadProcessId, ecx, addr hpid
    invoke OpenProcess, PROCESS_ALL_ACCESS, 0, hpid
    mov hpid, eax
    invoke VirtualAllocEx, hpid, 0, sizeof cmd_line, MEM_COMMIT, PAGE_READWRITE
    mov ebx, eax
    invoke WriteProcessMemory, hpid, ebx, addr cmd_line, sizeof cmd_line, 0
    invoke GetModuleHandle, addr k32module
    invoke GetProcAddress, eax, offset llfunc
    invoke CreateRemoteThread, hpid, 0, 0, eax, ebx, 0, 0
    mov esi, eax
    invoke WaitForSingleObject, eax, INFINITE
    invoke VirtualFreeEx, hpid, ebx, 0, MEM_RELEASE
    invoke CloseHandle, esi
ex: invoke ExitProcess, 0
nf: invoke FindWindow, addr window_name, 0
    test eax, eax
    jnz xf
    invoke MessageBox, 0, addr errormsg, 0, MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL
    jmp ex

WinMain endp
; ##########################################################################
end start