; Copyright © 2021 by Brett Kuntz. All rights reserved.

    custom_output proto :dword
    loadlib proto
    getaddresses proto
    d3dx_init proto :dword
    d3dx_uninit proto
    draw_text proto :dword, :dword, :dword, :dword
    D3DXCreateFontA_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    D3DXCreateFontA_proc typedef ptr D3DXCreateFontA_proto
.data?
    init dd ?
    hmod dd ?
    triangles dd ?
    d3dx_normfont dd ?
    D3DXCreateFontA D3DXCreateFontA_proc ?
    time1 dd ?
    time2 dd ?
    display dd ?
.code
    font_family db "Arial", 0
    d3dx9_29 db "d3dx9_28.dll", 0
    d3dx9_err db "The d3dx9_28.dll library could not be found. Please update your version of DirectX.", 0
    addy_err db "Unable to extract the d3dx9_28.dll library procedures. Please update your version of DirectX.", 0
    proc_CreateFontA db "D3DXCreateFontA", 0
    dx_triangles db "Triangles: %u", 0
    dx_availmem db "Available Texture Memory: %u Bytes (%u MB)", 0
    dx_displaym db "Display Mode: %ux%u %u Hz", 0
    dx_raster db "Scanline: %u", 0
    dx_cyclecount db "Frame Time: %u Hz (%u MHz)", 0
; ##########################################################################
custom_output proc device:dword

    local buff[128]:byte
    local displaymode[4]:dword
    local rasterstat[2]:dword

    .if init == 1 && framedump != SET && display != 0
        mov eax, device
        push eax
        mov eax, [eax]
        call dword ptr [eax+164]

        invoke wsprintf, addr buff, addr dx_triangles, triangles
        and triangles, 0
        invoke draw_text, 2, 0, addr buff, 0FF00FF00h
        mov eax, device
        push eax
        mov eax, [eax]
        call dword ptr [eax+16]
        mov ecx, 1048576
        xor edx, edx
        push eax
        div ecx
        pop ecx
        invoke wsprintf, addr buff, addr dx_availmem, ecx, eax
        invoke draw_text, 2, 15, addr buff, 0FF00FF00h
        lea eax, displaymode
        push eax
        push 0
        mov eax, device
        push eax
        mov eax, [eax]
        call dword ptr [eax+32]
        invoke wsprintf, addr buff, addr dx_displaym, displaymode[0], displaymode[4], displaymode[8]
        invoke draw_text, 2, 30, addr buff, 0FF00FF00h
        lea eax, rasterstat
        push eax
        push 0
        mov eax, device
        push eax
        mov eax, [eax]
        call dword ptr [eax+76]
        invoke wsprintf, addr buff, addr dx_raster, rasterstat[4]
        invoke draw_text, 2, 45, addr buff, 0FF00FF00h
        rdtsc
        push edx
        push eax
        sub eax, time1
        sbb edx, time2
        pop time1
        pop time2
        mov ecx, 1000000
        xor edx, edx
        push eax
        div ecx
        pop ecx
        invoke wsprintf, addr buff, addr dx_cyclecount, ecx, eax
        invoke draw_text, 2, 60, addr buff, 0FF00FF00h

        mov eax, device
        push eax
        mov eax, [eax]
        call dword ptr [eax+168]
    .endif
    ret

custom_output endp
; ##########################################################################
loadlib proc

    invoke LoadLibrary, addr d3dx9_29
    test eax, eax
    jz @F
    mov hmod, eax
    ret
@@: invoke MessageBox, 0, addr d3dx9_err, 0, MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL
    xor eax, eax
    ret

loadlib endp
; ##########################################################################
getaddresses proc

    invoke GetProcAddress, hmod, addr proc_CreateFontA
    mov D3DXCreateFontA, eax
    test eax, eax
    jz @F
    ret
@@: invoke MessageBox, 0, addr addy_err, 0, MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL
    xor eax, eax
    ret

getaddresses endp
; ##########################################################################
d3dx_init proc device:dword

    .if init == 0
        mov init, 1
        invoke D3DXCreateFontA, device, 16, 0, 400, 0, 0, 0, 0, 4, 0, addr font_family, addr d3dx_normfont
        .if eax != 0
            mov init, 0
            ret
        .endif
    .endif
    ret

d3dx_init endp
; ##########################################################################
d3dx_uninit proc

    .if init == 1
        mov eax, d3dx_normfont
        push eax
        mov eax, [eax]
        call dword ptr [eax+8]
        mov init, 0
    .endif
    ret

d3dx_uninit endp
; ##########################################################################
draw_text proc x:dword, y:dword, text:dword, color:dword

    local rect:RECT

    mov eax, x
    mov rect.left, eax
    mov rect.right, eax
    mov eax, y
    mov rect.top, eax
    mov rect.bottom, eax
    push color
    push 100h
    lea eax, rect
    push eax
    push -1
    push text
    push 0
    mov eax, d3dx_normfont
    push eax
    mov eax, [eax]
    call dword ptr [eax+56]
    ret

draw_text endp
; ##########################################################################