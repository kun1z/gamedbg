; Copyright © 2021 by Brett Kuntz. All rights reserved.

    logheader proto
    logfooter proto
    logframetime proto
    log proto C :dword, :dword, :dword, :dword, :vararg
.data?
    fhnd dd ?
    com_calls dd ?
    prof_num dd ?
.code
    tlogheader db "<html><head><title>Frame Dump</title></head><body bgcolor=#C0C0C0 text=#000000 link=#000080 vlink=#000080 alink=#000080><pre><font face=Fixedsys>"
    tlogframetime db " (<font color=00A000>Frame Time: %sms</font>)<br>", 0
    tlogcrittime db " (<font color=FF0000>CRITICAL> Frame Time: %sms</font>)<br>", 0
    tlogfooter db "</pre>COM Calls: %u</font></body></html>", 0
    logname db "d:\prf_%03u.htm", 0
; ##########################################################################
log proc C pCount:dword, pText:dword, pAddr:dword, pEax:dword, pArgs:vararg

    local filebuff[1024]:byte
    local dout:dword

    push eax
    push ecx
    push edx
    mov eax, pCount
    shl eax, 2
    add eax, 20
@@: push [ebp+eax]
    sub eax, 4
    cmp eax, 20
    jne @B
    push pEax
    push pAddr
    push pText
    invoke wsprintf, addr filebuff
    invoke lstrlen, addr filebuff
    mov ecx, eax
    invoke WriteFile, fhnd, addr filebuff, ecx, addr dout, 0
    inc com_calls
    pop edx
    pop ecx
    pop eax
    ret

log endp
; ##########################################################################
logheader proc

    local dout:dword
    local file_buff[32]:byte

    push eax
    push ecx
    push edx
    mov com_calls, 0
    invoke wsprintf, addr file_buff, addr logname, prof_num
    inc prof_num
    invoke CreateFile, addr file_buff, FILE_WRITE_DATA, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov fhnd, eax
    invoke WriteFile, fhnd, addr tlogheader, sizeof tlogheader, addr dout, 0
    invoke QueryPerformanceCounter, addr last_frame_time
    pop edx
    pop ecx
    pop eax
    ret

logheader endp
; ##########################################################################
logfooter proc

    local filebuff[1024]:byte
    local dout:dword

    push eax
    push ecx
    push edx
    invoke wsprintf, addr filebuff, addr tlogfooter, com_calls
    invoke lstrlen, addr filebuff
    mov ecx, eax
    invoke WriteFile, fhnd, addr filebuff, ecx, addr dout, 0
    invoke CloseHandle, fhnd
    mov fhnd, 0
    pop edx
    pop ecx
    pop eax
    ret

logfooter endp
; ##########################################################################
logframetime proc

    local li:LARGE_INTEGER
    local fbuf[128]:byte
    local filebuff[128]:byte
    local dout:dword

    push eax
    push ecx
    push edx
    invoke QueryPerformanceCounter, addr li
    sub esp, 4
    fld tbyte ptr [cpu_freq]
    fild qword ptr [li]
    fild qword ptr [last_frame_time]
    fsub
    fmul
    fist dword ptr [esp]
    fstp tbyte ptr [frame_time]
    mov eax, dword ptr [li]
    mov ecx, dword ptr [li+4]
    mov dword ptr [last_frame_time], eax
    mov dword ptr [last_frame_time+4], ecx
    pop eax
    mov ecx, offset tlogcrittime
    .if eax < 100
        mov ecx, offset tlogframetime
    .endif
    invoke FpuFLtoA, addr frame_time, 3, addr fbuf, SRC1_REAL or STR_REG
    invoke wsprintf, addr filebuff, ecx, addr fbuf
    invoke lstrlen, addr filebuff
    mov ecx, eax
    invoke WriteFile, fhnd, addr filebuff, ecx, addr dout, 0
    pop edx
    pop ecx
    pop eax
    ret

logframetime endp
; ##########################################################################