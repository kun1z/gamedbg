; Copyright © 2021 by Brett Kuntz. All rights reserved.

    .686p
    .model flat, stdcall
    option casemap :none

    include gamedbg.inc
    include log.asm
    include output.asm
    include IDirect3DBaseTexture9.inc
    include IDirect3DCubeTexture9.inc
    include IDirect3DDevice9.inc
    include IDirect3DIndexBuffer9.inc
    include IDirect3DPixelShader9.inc
    include IDirect3DQuery9.inc
    include IDirect3DStateBlock9.inc
    include IDirect3DSurface9.inc
    include IDirect3DSwapChain9.inc
    include IDirect3DTexture9.inc
    include IDirect3DVertexBuffer9.inc
    include IDirect3DVertexDeclaration9.inc
    include IDirect3DVertexShader9.inc
    include IDirect3DVolumeTexture9.inc

    thread proto :dword
    masterhook proto
    HookVectorTableProc proto :dword, :dword, :dword

    HookVectorTable macro pAddr, pFunc, pHook
        invoke HookVectorTableProc, pAddr, addr pFunc, addr pHook
    endm

.code
; ##########################################################################
LibMain proc hint:dword, reason:dword, param:dword

    local device:dword
    local meminfo:MEMORY_BASIC_INFORMATION
    local pp[56]:byte
    local li:LARGE_INTEGER
    local cmd_line[512]:byte

    ; PRESERVE ESI

    .if reason == DLL_PROCESS_ATTACH

        ; Initialize Varibles
        or display, -1
        lea edi, pp
        xor eax, eax
        mov ecx, (sizeof pp / 4)
        rep stosd
        or dword ptr [pp+24], 1
        or dword ptr [pp+32], 1

        ; Get Window Name & Handle
        invoke GetModuleFileName, hint, addr cmd_line, sizeof cmd_line
        lea edi, cmd_line
        or ecx, -1
        add edi, eax
        push esi
        mov al, '\'
        std
        repnz scasb
        cld
        add edi, 2
        mov esi, offset cfg_name
        mov ecx, sizeof cfg_name
        rep movsb
        pop esi
        invoke GetPrivateProfileString, addr appname, addr keyname, 0, addr wnd_name, sizeof wnd_name, addr cmd_line
        test eax, eax
        jz er
        invoke FindWindow, 0, addr wnd_name
        test eax, eax
        jnz sk
        invoke FindWindow, addr wnd_name, 0
        test eax, eax
        jz er
sk:     mov hook_hwnd, eax

        ; Get CPU Frequency
        invoke QueryPerformanceFrequency, addr li
        mov eax, 1000
        push eax
        fld1
        fild qword ptr [li]
        fild dword ptr [esp]
        fdiv
        fdiv
        fstp tbyte ptr [cpu_freq]
        pop eax

        ; Get DLL Memory Ranges
        invoke loadlib
        test eax, eax
        jz er
        invoke getaddresses
        test eax, eax
        jz er
        invoke GetModuleHandle, addr d3dx9_29
        add eax, 1000h
        mov ebx, eax
        mov d3dx_lower, eax
        invoke VirtualQuery, ebx, addr meminfo, sizeof MEMORY_BASIC_INFORMATION
        test eax, eax
        jz er
        add ebx, meminfo.RegionSize
        mov d3dx_upper, ebx
        invoke GetModuleHandle, addr dxprofilerdll
        add eax, 1000h
        mov ebx, eax
        mov dll_lower, eax
        invoke VirtualQuery, ebx, addr meminfo, sizeof MEMORY_BASIC_INFORMATION
        test eax, eax
        jz er
        add ebx, meminfo.RegionSize
        mov dll_upper, ebx
        invoke GetModuleHandle, addr d3d9dll
        test eax, eax
        jz er
        add eax, 1000h
        mov ebx, eax
        mov d3d9_lower, ebx
        invoke VirtualQuery, ebx, addr meminfo, sizeof MEMORY_BASIC_INFORMATION
        test eax, eax
        jz er
        mov ecx, ebx
        add ecx, meminfo.RegionSize
        mov d3d9_upper, ecx

        ; Hook D3D9
        invoke VirtualProtect, ebx, meminfo.RegionSize, PAGE_READWRITE, addr device
        test eax, eax
        jz er
        sub ebx, 1000h
        invoke GetProcAddress, ebx, addr LDirect3DCreate9
        test eax, eax
        jz er
        push 20h
        call eax
        test eax, eax
        jz er
        mov edi, eax
        lea ecx, device
        push ecx
        lea ecx, pp
        push ecx
        push 20h
        push hook_hwnd
        push 1
        push 0
        push edi
        mov eax, [edi]
        call dword ptr [eax+64] ; IDirect3D9->CreateDevice
        test eax, eax
        jnz er
        mov eax, device
        mov eax, [eax]
        add eax, 164
        mov eax, [eax]
        mov ebx, eax
        add eax, 5
        mov ecx, masterhook
        sub ecx, eax
        mov byte ptr [ebx], 0E8h ; Patch d3d9.dll
        mov dword ptr [ebx+1], ecx ; Patch d3d9.dll
        mov eax, device
        push eax
        mov eax, [eax]
        call dword ptr [eax+8] ; IDirect3DDevice9->Release
        test eax, eax
        jnz er
        push edi
        mov eax, [edi]
        call dword ptr [eax+8] ; IDirect3D9->Release
        test eax, eax
        jnz er

        ; Create Thread
        invoke CreateThread, 0, 0, addr thread, 0, 0, 0
        test eax, eax
        jz er

    .endif
    mov eax, 1
    ret
er: invoke MessageBox, 0, addr errormsg, 0, MB_OK or MB_ICONEXCLAMATION or MB_SYSTEMMODAL
    xor eax, eax
    ret

LibMain Endp
; ##########################################################################
thread proc param:dword

@@: invoke GetAsyncKeyState, VK_F1
    .if eax == 0FFFF8001h
        not display
    .endif
    invoke GetAsyncKeyState, VK_F5
    .if eax == 0FFFF8001h
        mov framedump, ONCREATEMODEL
    .endif
    invoke GetAsyncKeyState, VK_F6
    .if eax == 0FFFF8001h
        mov framedump, ONCREATETEXTURE
    .endif
    invoke GetAsyncKeyState, VK_F7
    .if eax == 0FFFF8001h
        mov framedump, ONCREATE
    .endif
    invoke GetAsyncKeyState, VK_F8
    .if eax == 0FFFF8001h
        mov framedump, WAITING
    .endif
    invoke GetAsyncKeyState, VK_F9
    .if eax == 0FFFF8001h
        invoke logheader
        mov tracedump, SET
        mov framedump, SET
    .endif
    invoke GetAsyncKeyState, VK_F10
    .if eax == 0FFFF8001h
        and tracedump, UNSET
        and framedump, UNSET
        invoke logfooter
    .endif

    invoke Sleep, 0
    jmp @B

thread endp
; ##########################################################################
OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE
HookVectorTableProc proc pAddr:dword, pFunc:dword, pHook:dword

@@: mov eax, dword ptr [esp+4]
    mov eax, dword ptr [ecx+eax]
    cmp eax, dword ptr [esp+12]
    je mk
    cmp eax, dll_lower
    jb @F
    cmp eax, dll_upper
    jb mk
@@: mov edx, dword ptr [esp+8]
    mov dword ptr [edx], eax
    mov edx, dword ptr [esp+4]
    mov eax, dword ptr [esp+12]
    mov dword ptr [ecx+edx], eax
mk: ret 12

HookVectorTableProc endp
OPTION PROLOGUE:PrologueDef
OPTION EPILOGUE:EpilogueDef
; ##########################################################################
masterhook proc

    pop eax
    push ebp
    mov ebp, esp
    push eax
    mov ecx, [ebp+8]
    mov ecx, [ecx]

    HookVectorTable QUERYINTERFACE, QueryInterface, QueryInterfaceHook
    HookVectorTable ADDREF, AddRef, AddRefHook
    HookVectorTable RELEASE, Release, ReleaseHook
    HookVectorTable TESTCOOPERATIVELEVEL, TestCooperativeLevel, TestCooperativeLevelHook
    HookVectorTable GETAVAILABLETEXTUREMEM, GetAvailableTextureMem, GetAvailableTextureMemHook
    HookVectorTable EVICTMANAGEDRESOURCES, EvictManagedResources, EvictManagedResourcesHook
    HookVectorTable GETDIRECT3D, GetDirect3D, GetDirect3DHook
    HookVectorTable GETDEVICECAPS, GetDeviceCaps, GetDeviceCapsHook
    HookVectorTable GETDISPLAYMODE, GetDisplayMode, GetDisplayModeHook
    HookVectorTable GETCREATIONPARAMETERS, GetCreationParameters, GetCreationParametersHook

    HookVectorTable SETCURSORPROPERTIES, SetCursorProperties, SetCursorPropertiesHook
    HookVectorTable SETCURSORPOSITION, SetCursorPosition, SetCursorPositionHook
    HookVectorTable SHOWCURSOR, xShowCursor, ShowCursorHook
    HookVectorTable CREATEADDITIONALSWAPCHAIN, CreateAdditionalSwapChain, CreateAdditionalSwapChainHook
    HookVectorTable GETSWAPCHAIN, GetSwapChain, GetSwapChainHook
    HookVectorTable GETNUMBEROFSWAPCHAINS, GetNumberOfSwapChains, GetNumberOfSwapChainsHook
    HookVectorTable RESET, Reset, ResetHook
    HookVectorTable PRESENT, Present, PresentHook
    HookVectorTable GETBACKBUFFER, GetBackBuffer, GetBackBufferHook
    HookVectorTable GETRASTERSTATUS, GetRasterStatus, GetRasterStatusHook

    HookVectorTable SETDIALOGBOXMODE, SetDialogBoxMode, SetDialogBoxModeHook
    HookVectorTable SETGAMMARAMP, SetGammaRamp, SetGammaRampHook
    HookVectorTable GETGAMMARAMP, GetGammaRamp, GetGammaRampHook
    HookVectorTable CREATETEXTURE, CreateTexture, CreateTextureHook
    HookVectorTable CREATEVOLUMETEXTURE, CreateVolumeTexture, CreateVolumeTextureHook
    HookVectorTable CREATECUBETEXTURE, CreateCubeTexture, CreateCubeTextureHook
    HookVectorTable CREATEVERTEXBUFFER, CreateVertexBuffer, CreateVertexBufferHook
    HookVectorTable CREATEINDEXBUFFER, CreateIndexBuffer, CreateIndexBufferHook
    HookVectorTable CREATERENDERTARGET, CreateRenderTarget, CreateRenderTargetHook
    HookVectorTable CREATEDEPTHSTENCILSURFACE, CreateDepthStencilSurface, CreateDepthStencilSurfaceHook

    HookVectorTable UPDATESURFACE, UpdateSurface, UpdateSurfaceHook
    HookVectorTable UPDATETEXTURE, UpdateTexture, UpdateTextureHook
    HookVectorTable GETRENDERTARGERDATA, GetRenderTargetData, GetRenderTargetDataHook
    HookVectorTable GETFRONTBUFFERDATA, GetFrontBufferData, GetFrontBufferDataHook
    HookVectorTable STRETCHRECT, StretchRect, StretchRectHook
    HookVectorTable COLORFILL, ColorFill, ColorFillHook
    HookVectorTable CREATEOFFSCREENPLAINSURFACE, CreateOffscreenPlainSurface, CreateOffscreenPlainSurfaceHook
    HookVectorTable SETRENDERTARGET, SetRenderTarget, SetRenderTargetHook
    HookVectorTable GETRENDERTARGET, GetRenderTarget, GetRenderTargetHook
    HookVectorTable SETDEPTHSTENCILSURFACE, SetDepthStencilSurface, SetDepthStencilSurfaceHook

    HookVectorTable GETDEPTHSTENCILSURFACE, GetDepthStencilSurface, GetDepthStencilSurfaceHook
    HookVectorTable BEGINSCENE, BeginScene, BeginSceneHook
    HookVectorTable ENDSCENE, EndScene, EndSceneHook
    HookVectorTable CLEAR, Clear, ClearHook
    HookVectorTable SETTRANSFORM, SetTransform, SetTransformHook
    HookVectorTable GETTRANSFORM, GetTransform, GetTransformHook
    HookVectorTable MULTIPLYTRANSFORM, MultiplyTransform, MultiplyTransformHook
    HookVectorTable SETVIEWPORT, SetViewport, SetViewportHook
    HookVectorTable GETVIEWPORT, GetViewport, GetViewportHook
    HookVectorTable SETMATERIAL, SetMaterial, SetMaterialHook

    HookVectorTable GETMATERIAL, GetMaterial, GetMaterialHook
    HookVectorTable SETLIGHT, SetLight, SetLightHook
    HookVectorTable GETLIGHT, GetLight, GetLightHook
    HookVectorTable LIGHTENABLE, LightEnable, LightEnableHook
    HookVectorTable GETLIGHTENABLE, GetLightEnable, GetLightEnableHook
    HookVectorTable SETCLIPPLANE, SetClipPlane, SetClipPlaneHook
    HookVectorTable GETCLIPPLANE, GetClipPlane, GetClipPlaneHook
    HookVectorTable SETRENDERSTATE, SetRenderState, SetRenderStateHook
    HookVectorTable GETRENDERSTATE, GetRenderState, GetRenderStateHook
    HookVectorTable CREATESTATEBLOCK, CreateStateBlock, CreateStateBlockHook

    HookVectorTable BEGINSTATEBLOCK, BeginStateBlock, BeginStateBlockHook
    HookVectorTable ENDSTATEBLOCK, EndStateBlock, EndStateBlockHook
    HookVectorTable SETCLIPSTATUS, SetClipStatus, SetClipStatusHook
    HookVectorTable GETCLIPSTATUS, GetClipStatus, GetClipStatusHook
    HookVectorTable GETTEXTURE, GetTexture, GetTextureHook
    HookVectorTable SETTEXTURE, SetTexture, SetTextureHook
    HookVectorTable GETTEXTURESTAGESTATE, GetTextureStageState, GetTextureStageStateHook
    HookVectorTable SETTEXTURESTAGESTATE, SetTextureStageState, SetTextureStageStateHook
    HookVectorTable GETSAMPLERSTATE, GetSamplerState, GetSamplerStateHook
    HookVectorTable SETSAMPLERSTATE, SetSamplerState, SetSamplerStateHook

    HookVectorTable VALIDATEDEVICE, ValidateDevice, ValidateDeviceHook
    HookVectorTable SETPALETTEENTRIES, SetPaletteEntries, SetPaletteEntriesHook
    HookVectorTable GETPALETTEENTRIES, GetPaletteEntries, GetPaletteEntriesHook
    HookVectorTable SETCURRENTTEXTUREPALETTE, SetCurrentTexturePalette, SetCurrentTexturePaletteHook
    HookVectorTable GETCURRENTTEXTUREPALETTE, GetCurrentTexturePalette, GetCurrentTexturePaletteHook
    HookVectorTable SETSCISSORRECT, SetScissorRect, SetScissorRectHook
    HookVectorTable GETSCISSORRECT, GetScissorRect, GetScissorRectHook
    HookVectorTable SETSOFTWAREVERTEXPROCESSING, SetSoftwareVertexProcessing, SetSoftwareVertexProcessingHook
    HookVectorTable GETSOFTWAREVERTEXPROCESSING, GetSoftwareVertexProcessing, GetSoftwareVertexProcessingHook
    HookVectorTable SETNPATCHMODE, SetNPatchMode, SetNPatchModeHook

    HookVectorTable GETNPATCHMODE, GetNPatchMode, GetNPatchModeHook
    HookVectorTable DRAWPRIMITIVE, DrawPrimitive, DrawPrimitiveHook
    HookVectorTable DRAWINDEXEDPRIMITIVE, DrawIndexedPrimitive, DrawIndexedPrimitiveHook
    HookVectorTable DRAWPRIMITIVEUP, DrawPrimitiveUP, DrawPrimitiveUPHook
    HookVectorTable DRAWINDEXEDPRIMITIVEUP, DrawIndexedPrimitiveUP, DrawIndexedPrimitiveUPHook
    HookVectorTable PROCESSVERTICES, ProcessVertices, ProcessVerticesHook
    HookVectorTable CREATEVERTEXDECLARATION, CreateVertexDeclaration, CreateVertexDeclarationHook
    HookVectorTable SETVERTEXDECLARATION, SetVertexDeclaration, SetVertexDeclarationHook
    HookVectorTable GETVERTEXDECLARATION, GetVertexDeclaration, GetVertexDeclarationHook
    HookVectorTable SETFVF, SetFVF, SetFVFHook

    HookVectorTable GETFVF, GetFVF, GetFVFHook
    HookVectorTable CREATEVERTEXSHADER, CreateVertexShader, CreateVertexShaderHook
    HookVectorTable SETVERTEXSHADER, SetVertexShader, SetVertexShaderHook
    HookVectorTable GETVERTEXSHADER, GetVertexShader, GetVertexShaderHook
    HookVectorTable SETVERTEXSHADERCONSTANTF, SetVertexShaderConstantF, SetVertexShaderConstantFHook
    HookVectorTable GETVERTEXSHADERCONSTANTF, GetVertexShaderConstantF, GetVertexShaderConstantFHook
    HookVectorTable SETVERTEXSHADERCONSTANTI, SetVertexShaderConstantI, SetVertexShaderConstantIHook
    HookVectorTable GETVERTEXSHADERCONSTANTI, GetVertexShaderConstantI, GetVertexShaderConstantIHook
    HookVectorTable SETVERTEXSHADERCONSTANTB, SetVertexShaderConstantB, SetVertexShaderConstantBHook
    HookVectorTable GETVERTEXSHADERCONSTANTB, GetVertexShaderConstantB, GetVertexShaderConstantBHook

    HookVectorTable SETSTREAMSOURCE, SetStreamSource, SetStreamSourceHook
    HookVectorTable GETSTREAMSOURCE, GetStreamSource, GetStreamSourceHook
    HookVectorTable SETSTREAMSOURCEFREQ, SetStreamSourceFreq, SetStreamSourceFreqHook
    HookVectorTable GETSTREAMSOURCEFREQ, GetStreamSourceFreq, GetStreamSourceFreqHook
    HookVectorTable SETINDICES, SetIndices, SetIndicesHook
    HookVectorTable GETINDICES, GetIndices, GetIndicesHook
    HookVectorTable CREATEPIXELSHADER, CreatePixelShader, CreatePixelShaderHook
    HookVectorTable SETPIXELSHADER, SetPixelShader, SetPixelShaderHook
    HookVectorTable GETPIXELSHADER, GetPixelShader, GetPixelShaderHook
    HookVectorTable SETPIXELSHADERCONSTANTF, SetPixelShaderConstantF, SetPixelShaderConstantFHook

    HookVectorTable GETPIXELSHADERCONSTANTF, GetPixelShaderConstantF, GetPixelShaderConstantFHook
    HookVectorTable SETPIXELSHADERCONSTANTI, SetPixelShaderConstantI, SetPixelShaderConstantIHook
    HookVectorTable GETPIXELSHADERCONSTANTI, GetPixelShaderConstantI, GetPixelShaderConstantIHook
    HookVectorTable SETPIXELSHADERCONSTANTB, SetPixelShaderConstantB, SetPixelShaderConstantBHook
    HookVectorTable GETPIXELSHADERCONSTANTB, GetPixelShaderConstantB, GetPixelShaderConstantBHook
    HookVectorTable DRAWRECTPATCH, DrawRectPatch, DrawRectPatchHook
    HookVectorTable DRAWTRIPATCH, DrawTriPatch, DrawTriPatchHook
    HookVectorTable DELETEPATCH, DeletePatch, DeletePatchHook
    HookVectorTable CREATEQUERY, CreateQuery, CreateQueryHook

    ret

masterhook endp
; ##########################################################################
PresentHook proc pThis:dword, pSourceRect:dword, pDestRect:dword, hDestWindowOverride:dword, pDirtyRegion:dword

    invoke d3dx_init, pThis
    invoke custom_output, pThis

    invoke Present, pThis, pSourceRect, pDestRect, hDestWindowOverride, pDirtyRegion

    .if framedump == WAITING
        invoke logheader
        mov framedump, SET
    .elseif framedump == SET
        invoke log, 5, offset LPresent, dword ptr [ebp+4], eax, pThis, pSourceRect, pDestRect, hDestWindowOverride, pDirtyRegion
        invoke logframetime
        .if tracedump == UNSET
            invoke logfooter
            mov framedump, UNSET
        .endif
    .endif
    ret

PresentHook endp
; ##########################################################################
BeginSceneHook proc pThis:dword

    invoke BeginScene, pThis
    .if framedump == SET
        invoke log, 1, offset LBeginScene, dword ptr [ebp+4], eax, pThis
    .endif
    ret

BeginSceneHook endp
; ##########################################################################
EndSceneHook proc pThis:dword

    invoke EndScene, pThis
    .if framedump == SET
        invoke log, 1, offset LEndScene, dword ptr [ebp+4], eax, pThis
    .endif
    ret

EndSceneHook endp
; ##########################################################################
SetCursorPositionHook proc pThis:dword, X:dword, Y:dword, Flags:dword

    invoke SetCursorPosition, pThis, X, Y, Flags
    .if framedump == SET
        invoke log, 4, offset LSetCursorPosition, dword ptr [ebp+4], eax, pThis, X, Y, Flags
    .endif
    ret

SetCursorPositionHook endp
; ##########################################################################
SetCursorPropertiesHook proc pThis:dword, XHotSpot:dword, YHotSpot:dword, pCursorBitmap:dword

    .if pCursorBitmap != 0
        mov ecx, pCursorBitmap
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    invoke SetCursorProperties, pThis, XHotSpot, YHotSpot, pCursorBitmap
    .if framedump == SET
        invoke log, 4, offset LSetCursorProperties, dword ptr [ebp+4], eax, pThis, XHotSpot, YHotSpot, pCursorBitmap
    .endif
    ret

SetCursorPropertiesHook endp
; ##########################################################################
SetTextureHook proc pThis:dword, Stage:dword, pTexture:dword

    .if pTexture != 0
        mov ecx, pTexture
        mov ecx, [ecx]
        HookVectorTable btQUERYINTERFACE, btQueryInterface, btQueryInterfaceHook
        HookVectorTable btADDREF, btAddRef, btAddRefHook
        HookVectorTable btRELEASE, btRelease, btReleaseHook
        HookVectorTable btGETDEVICE, btGetDevice, btGetDeviceHook
        HookVectorTable btSETPRIVATEDATA, btSetPrivateData, btSetPrivateDataHook
        HookVectorTable btGETPRIVATEDATA, btGetPrivateData, btGetPrivateDataHook
        HookVectorTable btFREEPRIVATEDATA, btFreePrivateData, btFreePrivateDataHook
        HookVectorTable btSETPRIORITY, btSetPriority, btSetPriorityHook
        HookVectorTable btGETPRIORITY, btGetPriority, btGetPriorityHook
        HookVectorTable btPRELOAD, btPreLoad, btPreLoadHook
        HookVectorTable btGETTYPE, btGetType, btGetTypeHook
        HookVectorTable btSETLOD, btSetLOD, btSetLODHook
        HookVectorTable btGETLOD, btGetLOD, btGetLODHook
        HookVectorTable btGETLEVELCOUNT, btGetLevelCount, btGetLevelCountHook
        HookVectorTable btSETAUTOGENFILTERTYPE, btSetAutoGenFilterType, btSetAutoGenFilterTypeHook
        HookVectorTable btGETAUTOGENFILTERTYPE, btGetAutoGenFilterType, btGetAutoGenFilterTypeHook
        HookVectorTable btGENERATEMIPSUBLEVELS, btGenerateMipSubLevels, btGenerateMipSubLevelsHook
    .endif
    invoke SetTexture, pThis, Stage, pTexture
    .if framedump == SET
        invoke log, 3, offset LSetTexture, dword ptr [ebp+4], eax, pThis, Stage, pTexture
    .endif
    ret

SetTextureHook endp
; ##########################################################################
SetStreamSourceHook proc pThis:dword, StreamNumber:dword, pStreamData:dword, OffsetInBytes:dword, Stride:dword

    .if pStreamData != 0
        mov ecx, pStreamData
        mov ecx, [ecx]
        HookVectorTable vlQUERYINTERFACE, vlQueryInterface, vlQueryInterfaceHook
        HookVectorTable vlADDREF, vlAddRef, vlAddRefHook
        HookVectorTable vlRELEASE, vlRelease, vlReleaseHook
        HookVectorTable vlGETDEVICE, vlGetDevice, vlGetDeviceHook
        HookVectorTable vlSETPRIVATEDATA, vlSetPrivateData, vlSetPrivateDataHook
        HookVectorTable vlGETPRIVATEDATA, vlGetPrivateData, vlGetPrivateDataHook
        HookVectorTable vlFREEPRIVATEDATA, vlFreePrivateData, vlFreePrivateDataHook
        HookVectorTable vlSETPRIORITY, vlSetPriority, vlSetPriorityHook
        HookVectorTable vlGETPRIORITY, vlGetPriority, vlGetPriorityHook
        HookVectorTable vlPRELOAD, vlPreLoad, vlPreLoadHook
        HookVectorTable vlGETTYPE, vlGetType, vlGetTypeHook
        HookVectorTable vlLOCK, vlLock, vlLockHook
        HookVectorTable vlUNLOCK, vlUnlock, vlUnlockHook
        HookVectorTable vlGETDESC, vlGetDesc, vlGetDescHook
    .endif
    invoke SetStreamSource, pThis, StreamNumber, pStreamData, OffsetInBytes, Stride
    .if framedump == SET
        invoke log, 5, offset LSetStreamSource, dword ptr [ebp+4], eax, pThis, StreamNumber, pStreamData, OffsetInBytes, Stride
    .endif
    ret

SetStreamSourceHook endp
; ##########################################################################
QueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke QueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset LQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

QueryInterfaceHook endp
; ##########################################################################
AddRefHook proc pThis:dword

    invoke AddRef, pThis
    .if framedump == SET
        invoke log, 1, offset LAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

AddRefHook endp
; ##########################################################################
ReleaseHook proc pThis:dword

    invoke Release, pThis
    .if framedump == SET
        invoke log, 1, offset LRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ReleaseHook endp
; ##########################################################################
TestCooperativeLevelHook proc pThis:dword

    invoke TestCooperativeLevel, pThis
    .if framedump == SET
        invoke log, 1, offset LTestCooperativeLevel, dword ptr [ebp+4], eax, pThis
    .endif
    ret

TestCooperativeLevelHook endp
; ##########################################################################
GetAvailableTextureMemHook proc pThis:dword

    invoke GetAvailableTextureMem, pThis
    .if framedump == SET
        invoke log, 1, offset LGetAvailableTextureMem, dword ptr [ebp+4], eax, pThis
    .endif
    ret

GetAvailableTextureMemHook endp
; ##########################################################################
EvictManagedResourcesHook proc pThis:dword

    invoke EvictManagedResources, pThis
    .if framedump == SET
        invoke log, 1, offset LEvictManagedResources, dword ptr [ebp+4], eax, pThis
    .endif
    ret

EvictManagedResourcesHook endp
; ##########################################################################
GetDirect3DHook proc pThis:dword, ppD3D9:dword

    invoke GetDirect3D, pThis, ppD3D9
    .if framedump == SET
        invoke log, 2, offset LGetDirect3D, dword ptr [ebp+4], eax, pThis, ppD3D9
    .endif
    ret

GetDirect3DHook endp
; ##########################################################################
GetDeviceCapsHook proc pThis:dword, pCaps:dword

    invoke GetDeviceCaps, pThis, pCaps
    .if framedump == SET
        invoke log, 2, offset LGetDeviceCaps, dword ptr [ebp+4], eax, pThis, pCaps
    .endif
    ret

GetDeviceCapsHook endp
; ##########################################################################
GetDisplayModeHook proc pThis:dword, iSwapChain:dword, pMode:dword

    invoke GetDisplayMode, pThis, iSwapChain, pMode
    .if framedump == SET
        invoke log, 3, offset LGetDisplayMode, dword ptr [ebp+4], eax, pThis, iSwapChain, pMode
    .endif
    ret

GetDisplayModeHook endp
; ##########################################################################
GetCreationParametersHook proc pThis:dword, pParameters:dword

    invoke GetCreationParameters, pThis, pParameters
    .if framedump == SET
        invoke log, 2, offset LGetCreationParameters, dword ptr [ebp+4], eax, pThis, pParameters
    .endif
    ret

GetCreationParametersHook endp
; ##########################################################################
ShowCursorHook proc pThis:dword, bShow:dword

    invoke xShowCursor, pThis, bShow
    .if framedump == SET
        invoke log, 2, offset LShowCursor, dword ptr [ebp+4], eax, pThis, bShow
    .endif
    ret

ShowCursorHook endp
; ##########################################################################
CreateAdditionalSwapChainHook proc pThis:dword, pPresentationParameters:dword, pSwapChain:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateAdditionalSwapChain, pThis, pPresentationParameters, pSwapChain
    push eax
    mov ecx, pSwapChain
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable scQUERYINTERFACE, scQueryInterface, scQueryInterfaceHook
        HookVectorTable scADDREF, scAddRef, scAddRefHook
        HookVectorTable scRELEASE, scRelease, scReleaseHook
        HookVectorTable scPRESENT, scPresent, scPresentHook
        HookVectorTable scGETFRONTBUFFERDATA, scGetFrontBufferData, scGetFrontBufferDataHook
        HookVectorTable scGETBACKBUFFER, scGetBackBuffer, scGetBackBufferHook
        HookVectorTable scGETRASTERSTATUS, scGetRasterStatus, scGetRasterStatusHook
        HookVectorTable scGETDISPLAYMODE, scGetDisplayMode, scGetDisplayModeHook
        HookVectorTable scGETDEVICE, scGetDevice, scGetDeviceHook
        HookVectorTable scGETPRESENTPARAMETERS, scGetPresentParameters, scGetPresentParametersHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 3, offset LCreateAdditionalSwapChain, dword ptr [ebp+4], eax, pThis, pPresentationParameters, pSwapChain
    .endif
    ret

CreateAdditionalSwapChainHook endp
; ##########################################################################
GetSwapChainHook proc pThis:dword, iSwapChain:dword, pSwapChain:dword

    invoke GetSwapChain, pThis, iSwapChain, pSwapChain
    push eax
    mov ecx, pSwapChain
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable scQUERYINTERFACE, scQueryInterface, scQueryInterfaceHook
        HookVectorTable scADDREF, scAddRef, scAddRefHook
        HookVectorTable scRELEASE, scRelease, scReleaseHook
        HookVectorTable scPRESENT, scPresent, scPresentHook
        HookVectorTable scGETFRONTBUFFERDATA, scGetFrontBufferData, scGetFrontBufferDataHook
        HookVectorTable scGETBACKBUFFER, scGetBackBuffer, scGetBackBufferHook
        HookVectorTable scGETRASTERSTATUS, scGetRasterStatus, scGetRasterStatusHook
        HookVectorTable scGETDISPLAYMODE, scGetDisplayMode, scGetDisplayModeHook
        HookVectorTable scGETDEVICE, scGetDevice, scGetDeviceHook
        HookVectorTable scGETPRESENTPARAMETERS, scGetPresentParameters, scGetPresentParametersHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 3, offset LGetSwapChain, dword ptr [ebp+4], eax, pThis, iSwapChain, pSwapChain
    .endif
    ret

GetSwapChainHook endp
; ##########################################################################
GetNumberOfSwapChainsHook proc pThis:dword

    invoke GetNumberOfSwapChains, pThis
    .if framedump == SET
        invoke log, 1, offset LGetNumberOfSwapChains, dword ptr [ebp+4], eax, pThis
    .endif
    ret

GetNumberOfSwapChainsHook endp
; ##########################################################################
ResetHook proc pThis:dword, pPresentationParameters:dword

    invoke d3dx_uninit

    invoke Reset, pThis, pPresentationParameters
    .if framedump == SET
        invoke log, 2, offset LReset, dword ptr [ebp+4], eax, pThis, pPresentationParameters
    .endif
    ret

ResetHook endp
; ##########################################################################
GetBackBufferHook proc pThis:dword, iSwapChain:dword, iBackBuffer:dword, pType:dword, ppBackBuffer:dword

    invoke GetBackBuffer, pThis, iSwapChain, iBackBuffer, pType, ppBackBuffer
    push eax
    mov ecx, ppBackBuffer
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 5, offset LGetBackBuffer, dword ptr [ebp+4], eax, pThis, iSwapChain, iBackBuffer, pType, ppBackBuffer
    .endif
    ret

GetBackBufferHook endp
; ##########################################################################
GetRasterStatusHook proc pThis:dword, iSwapChain:dword, pRasterStatus:dword

    invoke GetRasterStatus, pThis, iSwapChain, pRasterStatus
    .if framedump == SET
        invoke log, 3, offset LGetRasterStatus, dword ptr [ebp+4], eax, pThis, iSwapChain, pRasterStatus
    .endif
    ret

GetRasterStatusHook endp
; ##########################################################################
SetDialogBoxModeHook proc pThis:dword, bEnableDialogs:dword

    invoke SetDialogBoxMode, pThis, bEnableDialogs
    .if framedump == SET
        invoke log, 2, offset LSetDialogBoxMode, dword ptr [ebp+4], eax, pThis, bEnableDialogs
    .endif
    ret

SetDialogBoxModeHook endp
; ##########################################################################
SetGammaRampHook proc pThis:dword, iSwapChain:dword, Flags:dword, pRamp:dword

    invoke SetGammaRamp, pThis, iSwapChain, Flags, pRamp
    .if framedump == SET
        invoke log, 4, offset LSetGammaRamp, dword ptr [ebp+4], eax, pThis, iSwapChain, Flags, pRamp
    .endif
    ret

SetGammaRampHook endp
; ##########################################################################
GetGammaRampHook proc pThis:dword, iSwapChain:dword, pRamp:dword

    invoke GetGammaRamp, pThis, iSwapChain, pRamp
    .if framedump == SET
        invoke log, 3, offset LGetGammaRamp, dword ptr [ebp+4], eax, pThis, iSwapChain, pRamp
    .endif
    ret

GetGammaRampHook endp
; ##########################################################################
CreateTextureHook proc pThis:dword, pWidth:dword, Height:dword, Levels:dword, Usage:dword, Format:dword, Pool:dword, ppTexture:dword, pSharedHandle:dword

    .if framedump == ONCREATE || framedump == ONCREATETEXTURE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateTexture, pThis, pWidth, Height, Levels, Usage, Format, Pool, ppTexture, pSharedHandle
    push eax
    mov ecx, ppTexture
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable ttQUERYINTERFACE, ttQueryInterface, ttQueryInterfaceHook
        HookVectorTable ttADDREF, ttAddRef, ttAddRefHook
        HookVectorTable ttRELEASE, ttRelease, ttReleaseHook
        HookVectorTable ttGETDEVICE, ttGetDevice, ttGetDeviceHook
        HookVectorTable ttSETPRIVATEDATA, ttSetPrivateData, ttSetPrivateDataHook
        HookVectorTable ttGETPRIVATEDATA, ttGetPrivateData, ttGetPrivateDataHook
        HookVectorTable ttFREEPRIVATEDATA, ttFreePrivateData, ttFreePrivateDataHook
        HookVectorTable ttSETPRIORITY, ttSetPriority, ttSetPriorityHook
        HookVectorTable ttGETPRIORITY, ttGetPriority, ttGetPriorityHook
        HookVectorTable ttPRELOAD, ttPreLoad, ttPreLoadHook
        HookVectorTable ttGETTYPE, ttGetType, ttGetTypeHook
        HookVectorTable ttSETLOD, ttSetLOD, ttSetLODHook
        HookVectorTable ttGETLOD, ttGetLOD, ttGetLODHook
        HookVectorTable ttGETLEVELCOUNT, ttGetLevelCount, ttGetLevelCountHook
        HookVectorTable ttSETAUTOGENFILTERTYPE, ttSetAutoGenFilterType, ttSetAutoGenFilterTypeHook
        HookVectorTable ttGETAUTOGENFILTERTYPE, ttGetAutoGenFilterType, ttGetAutoGenFilterTypeHook
        HookVectorTable ttGENERATEMIPSUBLEVELS, ttGenerateMipSubLevels, ttGenerateMipSubLevelsHook
        HookVectorTable ttGETLEVELDESC, ttGetLevelDesc, ttGetLevelDescHook
        HookVectorTable ttGETSURFACELEVEL, ttGetSurfaceLevel, ttGetSurfaceLevelHook
        HookVectorTable ttLOCKRECT, ttLockRect, ttLockRectHook
        HookVectorTable ttUNLOCKRECT, ttUnlockRect, ttUnlockRectHook
        HookVectorTable ttADDDIRTYRECT, ttAddDirtyRect, ttAddDirtyRectHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 9, offset LCreateTexture, dword ptr [ebp+4], eax, pThis, pWidth, Height, Levels, Usage, Format, Pool, ppTexture, pSharedHandle
    .endif
    ret

CreateTextureHook endp
; ##########################################################################
CreateVolumeTextureHook proc pThis:dword, pWidth:dword, Height:dword, Depth:dword, Levels:dword, Usage:dword, Format:dword, Pool:dword, ppVolumeTexture:dword, pSharedHandle:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateVolumeTexture, pThis, pWidth, Height, Depth, Levels, Usage, Format, Pool, ppVolumeTexture, pSharedHandle
    push eax
    mov ecx, ppVolumeTexture
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable vaQUERYINTERFACE, vaQueryInterface, vaQueryInterfaceHook
        HookVectorTable vaADDREF, vaAddRef, vaAddRefHook
        HookVectorTable vaRELEASE, vaRelease, vaReleaseHook
        HookVectorTable vaGETDEVICE, vaGetDevice, vaGetDeviceHook
        HookVectorTable vaSETPRIVATEDATA, vaSetPrivateData, vaSetPrivateDataHook
        HookVectorTable vaGETPRIVATEDATA, vaGetPrivateData, vaGetPrivateDataHook
        HookVectorTable vaFREEPRIVATEDATA, vaFreePrivateData, vaFreePrivateDataHook
        HookVectorTable vaSETPRIORITY, vaSetPriority, vaSetPriorityHook
        HookVectorTable vaGETPRIORITY, vaGetPriority, vaGetPriorityHook
        HookVectorTable vaPRELOAD, vaPreLoad, vaPreLoadHook
        HookVectorTable vaGETTYPE, vaGetType, vaGetTypeHook
        HookVectorTable vaSETLOD, vaSetLOD, vaSetLODHook
        HookVectorTable vaGETLOD, vaGetLOD, vaGetLODHook
        HookVectorTable vaGETLEVELCOUNT, vaGetLevelCount, vaGetLevelCountHook
        HookVectorTable vaSETAUTOGENFILTERTYPE, vaSetAutoGenFilterType, vaSetAutoGenFilterTypeHook
        HookVectorTable vaGETAUTOGENFILTERTYPE, vaGetAutoGenFilterType, vaGetAutoGenFilterTypeHook
        HookVectorTable vaGENERATEMIPSUBLEVELS, vaGenerateMipSubLevels, vaGenerateMipSubLevelsHook
        HookVectorTable vaGETLEVELDESC, vaGetLevelDesc, vaGetLevelDescHook
        HookVectorTable vaGETVOLUMELEVEL, vaGetVolumeLevel, vaGetVolumeLevelHook
        HookVectorTable vaLOCKBOX, vaLockBox, vaLockBoxHook
        HookVectorTable vaUNLOCKBOX, vaUnlockBox, vaUnlockBoxHook
        HookVectorTable vaADDDIRTYBOX, vaAddDirtyBox, vaAddDirtyBoxHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 10, offset LCreateVolumeTexture, dword ptr [ebp+4], eax, pThis, pWidth, Height, Depth, Levels, Usage, Format, Pool, ppVolumeTexture, pSharedHandle
    .endif
    ret

CreateVolumeTextureHook endp
; ##########################################################################
CreateCubeTextureHook proc pThis:dword, EdgeLength:dword, Levels:dword, Usage:dword, Format:dword, Pool:dword, ppCubeTexture:dword, pSharedHandle:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateCubeTexture, pThis, EdgeLength, Levels, Usage, Format, Pool, ppCubeTexture, pSharedHandle
    push eax
    mov ecx, ppCubeTexture
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable cxQUERYINTERFACE, cxQueryInterface, cxQueryInterfaceHook
        HookVectorTable cxADDREF, cxAddRef, cxAddRefHook
        HookVectorTable cxRELEASE, cxRelease, cxReleaseHook
        HookVectorTable cxGETDEVICE, cxGetDevice, cxGetDeviceHook
        HookVectorTable cxSETPRIVATEDATA, cxSetPrivateData, cxSetPrivateDataHook
        HookVectorTable cxGETPRIVATEDATA, cxGetPrivateData, cxGetPrivateDataHook
        HookVectorTable cxFREEPRIVATEDATA, cxFreePrivateData, cxFreePrivateDataHook
        HookVectorTable cxSETPRIORITY, cxSetPriority, cxSetPriorityHook
        HookVectorTable cxGETPRIORITY, cxGetPriority, cxGetPriorityHook
        HookVectorTable cxPRELOAD, cxPreLoad, cxPreLoadHook
        HookVectorTable cxGETTYPE, cxGetType, cxGetTypeHook
        HookVectorTable cxSETLOD, cxSetLOD, cxSetLODHook
        HookVectorTable cxGETLOD, cxGetLOD, cxGetLODHook
        HookVectorTable cxGETLEVELCOUNT, cxGetLevelCount, cxGetLevelCountHook
        HookVectorTable cxSETAUTOGENFILTERTYPE, cxSetAutoGenFilterType, cxSetAutoGenFilterTypeHook
        HookVectorTable cxGETAUTOGENFILTERTYPE, cxGetAutoGenFilterType, cxGetAutoGenFilterTypeHook
        HookVectorTable cxGENERATEMIPSUBLEVELS, cxGenerateMipSubLevels, cxGenerateMipSubLevelsHook
        HookVectorTable cxGETLEVELDESC, cxGetLevelDesc, cxGetLevelDescHook
        HookVectorTable cxGETCUBEMAPSURFACE, cxGetCubeMapSurface, cxGetCubeMapSurfaceHook
        HookVectorTable cxLOCKRECT, cxLockRect, cxLockRectHook
        HookVectorTable cxUNLOCKRECT, cxUnlockRect, cxUnlockRectHook
        HookVectorTable cxADDDIRTYRECT, cxAddDirtyRect, cxAddDirtyRectHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 8, offset LCreateCubeTexture, dword ptr [ebp+4], eax, pThis, EdgeLength, Levels, Usage, Format, Pool, ppCubeTexture, pSharedHandle
    .endif
    ret

CreateCubeTextureHook endp
; ##########################################################################
CreateVertexBufferHook proc pThis:dword, pLength:dword, Usage:dword, FVF:dword, Pool:dword, ppVertexBuffer:dword, pSharedHandle:dword

    .if framedump == ONCREATE || framedump == ONCREATEMODEL
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateVertexBuffer, pThis, pLength, Usage, FVF, Pool, ppVertexBuffer, pSharedHandle
    push eax
    mov ecx, ppVertexBuffer
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable vlQUERYINTERFACE, vlQueryInterface, vlQueryInterfaceHook
        HookVectorTable vlADDREF, vlAddRef, vlAddRefHook
        HookVectorTable vlRELEASE, vlRelease, vlReleaseHook
        HookVectorTable vlGETDEVICE, vlGetDevice, vlGetDeviceHook
        HookVectorTable vlSETPRIVATEDATA, vlSetPrivateData, vlSetPrivateDataHook
        HookVectorTable vlGETPRIVATEDATA, vlGetPrivateData, vlGetPrivateDataHook
        HookVectorTable vlFREEPRIVATEDATA, vlFreePrivateData, vlFreePrivateDataHook
        HookVectorTable vlSETPRIORITY, vlSetPriority, vlSetPriorityHook
        HookVectorTable vlGETPRIORITY, vlGetPriority, vlGetPriorityHook
        HookVectorTable vlPRELOAD, vlPreLoad, vlPreLoadHook
        HookVectorTable vlGETTYPE, vlGetType, vlGetTypeHook
        HookVectorTable vlLOCK, vlLock, vlLockHook
        HookVectorTable vlUNLOCK, vlUnlock, vlUnlockHook
        HookVectorTable vlGETDESC, vlGetDesc, vlGetDescHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 7, offset LCreateVertexBuffer, dword ptr [ebp+4], eax, pThis, pLength, Usage, FVF, Pool, ppVertexBuffer, pSharedHandle
    .endif
    ret

CreateVertexBufferHook endp
; ##########################################################################
CreateIndexBufferHook proc pThis:dword, pLength:dword, Usage:dword, Format:dword, Pool:dword, ppIndexBuffer:dword, pSharedHandle:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateIndexBuffer, pThis, pLength, Usage, Format, Pool, ppIndexBuffer, pSharedHandle
    push eax
    mov ecx, ppIndexBuffer
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable ibQUERYINTERFACE, ibQueryInterface, ibQueryInterfaceHook
        HookVectorTable ibADDREF, ibAddRef, ibAddRefHook
        HookVectorTable ibRELEASE, ibRelease, ibReleaseHook
        HookVectorTable ibGETDEVICE, ibGetDevice, ibGetDeviceHook
        HookVectorTable ibSETPRIVATEDATA, ibSetPrivateData, ibSetPrivateDataHook
        HookVectorTable ibGETPRIVATEDATA, ibGetPrivateData, ibGetPrivateDataHook
        HookVectorTable ibFREEPRIVATEDATA, ibFreePrivateData, ibFreePrivateDataHook
        HookVectorTable ibSETPRIORITY, ibSetPriority, ibSetPriorityHook
        HookVectorTable ibGETPRIORITY, ibGetPriority, ibGetPriorityHook
        HookVectorTable ibPRELOAD, ibPreLoad, ibPreLoadHook
        HookVectorTable ibGETTYPE, ibGetType, ibGetTypeHook
        mov eax, dword ptr [ebp+4]
        .if eax < d3dx_lower || eax > d3dx_upper
            HookVectorTable ibLOCK, ibLock, ibLockHook
        .endif
        HookVectorTable ibUNLOCK, ibUnlock, ibUnlockHook
        HookVectorTable ibGETDESC, ibGetDesc, ibGetDescHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 7, offset LCreateIndexBuffer, dword ptr [ebp+4], eax, pThis, pLength, Usage, Format, Pool, ppIndexBuffer, pSharedHandle
    .endif
    ret

CreateIndexBufferHook endp
; ##########################################################################
CreateRenderTargetHook proc pThis:dword, pWidth:dword, Height:dword, Format:dword, MultiSample:dword, MultisampleQuality:dword, Lockable:dword, ppSurface:dword, pSharedHandle:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateRenderTarget, pThis, pWidth, Height, Format, MultiSample, MultisampleQuality, Lockable, ppSurface, pSharedHandle
    push eax
    mov ecx, ppSurface
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 9, offset LCreateRenderTarget, dword ptr [ebp+4], eax, pThis, pWidth, Height, Format, MultiSample, MultisampleQuality, Lockable, ppSurface, pSharedHandle
    .endif
    ret

CreateRenderTargetHook endp
; ##########################################################################
CreateDepthStencilSurfaceHook proc pThis:dword, pWidth:dword, Height:dword, Format:dword, MultiSample:dword, MultisampleQuality:dword, Discard:dword, ppSurface:dword, pSharedHandle:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateDepthStencilSurface, pThis, pWidth, Height, Format, MultiSample, MultisampleQuality, Discard, ppSurface, pSharedHandle
    push eax
    mov ecx, ppSurface
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 9, offset LCreateDepthStencilSurface, dword ptr [ebp+4], eax, pThis, pWidth, Height, Format, MultiSample, MultisampleQuality, Discard, ppSurface, pSharedHandle
    .endif
    ret

CreateDepthStencilSurfaceHook endp
; ##########################################################################
UpdateSurfaceHook proc pThis:dword, pSourceSurface:dword, pSourceRect:dword, pDestinationSurface:dword, pDestPoint:dword

    .if pSourceSurface != 0
        mov ecx, pSourceSurface
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    .if pDestinationSurface != 0
        mov ecx, pDestinationSurface
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    invoke UpdateSurface, pThis, pSourceSurface, pSourceRect, pDestinationSurface, pDestPoint
    .if framedump == SET
        invoke log, 5, offset LUpdateSurface, dword ptr [ebp+4], eax, pThis, pSourceSurface, pSourceRect, pDestinationSurface, pDestPoint
    .endif
    ret

UpdateSurfaceHook endp
; ##########################################################################
UpdateTextureHook proc pThis:dword, pSourceTexture:dword, pDestinationTexture:dword

    .if pSourceTexture != 0
        mov ecx, pSourceTexture
        mov ecx, [ecx]
        HookVectorTable btQUERYINTERFACE, btQueryInterface, btQueryInterfaceHook
        HookVectorTable btADDREF, btAddRef, btAddRefHook
        HookVectorTable btRELEASE, btRelease, btReleaseHook
        HookVectorTable btGETDEVICE, btGetDevice, btGetDeviceHook
        HookVectorTable btSETPRIVATEDATA, btSetPrivateData, btSetPrivateDataHook
        HookVectorTable btGETPRIVATEDATA, btGetPrivateData, btGetPrivateDataHook
        HookVectorTable btFREEPRIVATEDATA, btFreePrivateData, btFreePrivateDataHook
        HookVectorTable btSETPRIORITY, btSetPriority, btSetPriorityHook
        HookVectorTable btGETPRIORITY, btGetPriority, btGetPriorityHook
        HookVectorTable btPRELOAD, btPreLoad, btPreLoadHook
        HookVectorTable btGETTYPE, btGetType, btGetTypeHook
        HookVectorTable btSETLOD, btSetLOD, btSetLODHook
        HookVectorTable btGETLOD, btGetLOD, btGetLODHook
        HookVectorTable btGETLEVELCOUNT, btGetLevelCount, btGetLevelCountHook
        HookVectorTable btSETAUTOGENFILTERTYPE, btSetAutoGenFilterType, btSetAutoGenFilterTypeHook
        HookVectorTable btGETAUTOGENFILTERTYPE, btGetAutoGenFilterType, btGetAutoGenFilterTypeHook
        HookVectorTable btGENERATEMIPSUBLEVELS, btGenerateMipSubLevels, btGenerateMipSubLevelsHook
    .endif
    .if pDestinationTexture != 0
        mov ecx, pDestinationTexture
        mov ecx, [ecx]
        HookVectorTable btQUERYINTERFACE, btQueryInterface, btQueryInterfaceHook
        HookVectorTable btADDREF, btAddRef, btAddRefHook
        HookVectorTable btRELEASE, btRelease, btReleaseHook
        HookVectorTable btGETDEVICE, btGetDevice, btGetDeviceHook
        HookVectorTable btSETPRIVATEDATA, btSetPrivateData, btSetPrivateDataHook
        HookVectorTable btGETPRIVATEDATA, btGetPrivateData, btGetPrivateDataHook
        HookVectorTable btFREEPRIVATEDATA, btFreePrivateData, btFreePrivateDataHook
        HookVectorTable btSETPRIORITY, btSetPriority, btSetPriorityHook
        HookVectorTable btGETPRIORITY, btGetPriority, btGetPriorityHook
        HookVectorTable btPRELOAD, btPreLoad, btPreLoadHook
        HookVectorTable btGETTYPE, btGetType, btGetTypeHook
        HookVectorTable btSETLOD, btSetLOD, btSetLODHook
        HookVectorTable btGETLOD, btGetLOD, btGetLODHook
        HookVectorTable btGETLEVELCOUNT, btGetLevelCount, btGetLevelCountHook
        HookVectorTable btSETAUTOGENFILTERTYPE, btSetAutoGenFilterType, btSetAutoGenFilterTypeHook
        HookVectorTable btGETAUTOGENFILTERTYPE, btGetAutoGenFilterType, btGetAutoGenFilterTypeHook
        HookVectorTable btGENERATEMIPSUBLEVELS, btGenerateMipSubLevels, btGenerateMipSubLevelsHook
    .endif
    invoke UpdateTexture, pThis, pSourceTexture, pDestinationTexture
    .if framedump == SET
        invoke log, 3, offset LUpdateTexture, dword ptr [ebp+4], eax, pThis, pSourceTexture, pDestinationTexture
    .endif
    ret

UpdateTextureHook endp
; ##########################################################################
GetRenderTargetDataHook proc pThis:dword, pRenderTarget:dword, pDestSurface:dword

    .if pRenderTarget != 0
        mov ecx, pRenderTarget
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    .if pDestSurface != 0
        mov ecx, pDestSurface
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    invoke GetRenderTargetData, pThis, pRenderTarget, pDestSurface
    .if framedump == SET
        invoke log, 3, offset LGetRenderTargetData, dword ptr [ebp+4], eax, pThis, pRenderTarget, pDestSurface
    .endif
    ret

GetRenderTargetDataHook endp
; ##########################################################################
GetFrontBufferDataHook proc pThis:dword, iSwapChain:dword, pDestSurface:dword

    .if pDestSurface != 0
        mov ecx, pDestSurface
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    invoke GetFrontBufferData, pThis, iSwapChain, pDestSurface
    .if framedump == SET
        invoke log, 3, offset LGetFrontBufferData, dword ptr [ebp+4], eax, pThis, iSwapChain, pDestSurface
    .endif
    ret

GetFrontBufferDataHook endp
; ##########################################################################
StretchRectHook proc pThis:dword, pSourceSurface:dword, pSourceRect:dword, pDestSurface:dword, pDestRect:dword, Filter:dword

    .if pSourceSurface != 0
        mov ecx, pSourceSurface
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    invoke StretchRect, pThis, pSourceSurface, pSourceRect, pDestSurface, pDestRect, Filter
    .if framedump == SET
        invoke log, 6, offset LStretchRect, dword ptr [ebp+4], eax, pThis, pSourceSurface, pSourceRect, pDestSurface, pDestRect, Filter
    .endif
    ret

StretchRectHook endp
; ##########################################################################
ColorFillHook proc pThis:dword, pSurface:dword, pRect:dword, color:dword

    .if pSurface != 0
        mov ecx, pSurface
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    invoke ColorFill, pThis, pSurface, pRect, color
    .if framedump == SET
        invoke log, 4, offset LColorFill, dword ptr [ebp+4], eax, pThis, pSurface, pRect, color
    .endif
    ret

ColorFillHook endp
; ##########################################################################
CreateOffscreenPlainSurfaceHook proc pThis:dword, pWidth:dword, Height:dword, Format:dword, Pool:dword, ppSurface:dword, pSharedHandle:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateOffscreenPlainSurface, pThis, pWidth, Height, Format, Pool, ppSurface, pSharedHandle
    push eax
    mov ecx, ppSurface
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 7, offset LCreateOffscreenPlainSurface, dword ptr [ebp+4], eax, pThis, pWidth, Height, Format, Pool, ppSurface, pSharedHandle
    .endif
    ret

CreateOffscreenPlainSurfaceHook endp
; ##########################################################################
SetRenderTargetHook proc pThis:dword, RenderTargetIndex:dword, pRenderTarget:dword

    invoke SetRenderTarget, pThis, RenderTargetIndex, pRenderTarget
    .if framedump == SET
        invoke log, 3, offset LSetRenderTarget, dword ptr [ebp+4], eax, pThis, RenderTargetIndex, pRenderTarget
    .endif
    ret

SetRenderTargetHook endp
; ##########################################################################
GetRenderTargetHook proc pThis:dword, RenderTargetIndex:dword, ppRenderTarget:dword

    invoke GetRenderTarget, pThis, RenderTargetIndex, ppRenderTarget
    push eax
    mov ecx, ppRenderTarget
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 3, offset LGetRenderTarget, dword ptr [ebp+4], eax, pThis, RenderTargetIndex, ppRenderTarget
    .endif
    ret

GetRenderTargetHook endp
; ##########################################################################
SetDepthStencilSurfaceHook proc pThis:dword, pNewZStencil:dword

    .if pNewZStencil != 0
        mov ecx, pNewZStencil
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    invoke SetDepthStencilSurface, pThis, pNewZStencil
    .if framedump == SET
        invoke log, 2, offset LSetDepthStencilSurface, dword ptr [ebp+4], eax, pThis, pNewZStencil
    .endif
    ret

SetDepthStencilSurfaceHook endp
; ##########################################################################
GetDepthStencilSurfaceHook proc pThis:dword, ppZStencilSurface:dword

    invoke GetDepthStencilSurface, pThis, ppZStencilSurface
    push eax
    mov ecx, ppZStencilSurface
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable seQUERYINTERFACE, seQueryInterface, seQueryInterfaceHook
        HookVectorTable seADDREF, seAddRef, seAddRefHook
        HookVectorTable seRELEASE, seRelease, seReleaseHook
        HookVectorTable seGETDEVICE, seGetDevice, seGetDeviceHook
        HookVectorTable seSETPRIVATEDATA, seSetPrivateData, seSetPrivateDataHook
        HookVectorTable seGETPRIVATEDATA, seGetPrivateData, seGetPrivateDataHook
        HookVectorTable seFREEPRIVATEDATA, seFreePrivateData, seFreePrivateDataHook
        HookVectorTable seSETPRIORITY, seSetPriority, seSetPriorityHook
        HookVectorTable seGETPRIORITY, seGetPriority, seGetPriorityHook
        HookVectorTable sePRELOAD, sePreLoad, sePreLoadHook
        HookVectorTable seGETTYPE, seGetType, seGetTypeHook
        HookVectorTable seGETCONTAINER, seGetContainer, seGetContainerHook
        HookVectorTable seGETDESC, seGetDesc, seGetDescHook
        HookVectorTable seLOCKRECT, seLockRect, seLockRectHook
        HookVectorTable seUNLOCKRECT, seUnlockRect, seUnlockRectHook
        HookVectorTable seGETDC, seGetDC, seGetDCHook
        HookVectorTable seRELEASEDC, seReleaseDC, seReleaseDCHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 2, offset LGetDepthStencilSurface, dword ptr [ebp+4], eax, pThis, ppZStencilSurface
    .endif
    ret

GetDepthStencilSurfaceHook endp
; ##########################################################################
ClearHook proc pThis:dword, Count:dword, pRects:dword, Flags:dword, Color:dword, Z:dword, Stencil:dword

    invoke Clear, pThis, Count, pRects, Flags, Color, Z, Stencil
    .if framedump == SET
        invoke log, 7, offset LClear, dword ptr [ebp+4], eax, pThis, Count, pRects, Flags, Color, Z, Stencil
    .endif
    ret

ClearHook endp
; ##########################################################################
SetTransformHook proc pThis:dword, State:dword, pMatrix:dword

    invoke SetTransform, pThis, State, pMatrix
    .if framedump == SET
        invoke log, 3, offset LSetTransform, dword ptr [ebp+4], eax, pThis, State, pMatrix
    .endif
    ret

SetTransformHook endp
; ##########################################################################
GetTransformHook proc pThis:dword, State:dword, pMatrix:dword

    invoke GetTransform, pThis, State, pMatrix
    .if framedump == SET
        invoke log, 3, offset LGetTransform, dword ptr [ebp+4], eax, pThis, State, pMatrix
    .endif
    ret

GetTransformHook endp
; ##########################################################################
MultiplyTransformHook proc pThis:dword, State:dword, pMatrix:dword

    invoke MultiplyTransform, pThis, State, pMatrix
    .if framedump == SET
        invoke log, 3, offset LMultiplyTransform, dword ptr [ebp+4], eax, pThis, State, pMatrix
    .endif
    ret

MultiplyTransformHook endp
; ##########################################################################
SetViewportHook proc pThis:dword, pViewport:dword

    invoke SetViewport, pThis, pViewport
    .if framedump == SET
        invoke log, 2, offset LSetViewport, dword ptr [ebp+4], eax, pThis, pViewport
    .endif
    ret

SetViewportHook endp
; ##########################################################################
GetViewportHook proc pThis:dword, pViewport:dword

    invoke GetViewport, pThis, pViewport
    .if framedump == SET
        invoke log, 2, offset LGetViewport, dword ptr [ebp+4], eax, pThis, pViewport
    .endif
    ret

GetViewportHook endp
; ##########################################################################
SetMaterialHook proc pThis:dword, pMaterial:dword

    invoke SetMaterial, pThis, pMaterial
    .if framedump == SET
        invoke log, 2, offset LSetMaterial, dword ptr [ebp+4], eax, pThis, pMaterial
    .endif
    ret

SetMaterialHook endp
; ##########################################################################
GetMaterialHook proc pThis:dword, pMaterial:dword

    invoke GetMaterial, pThis, pMaterial
    .if framedump == SET
        invoke log, 2, offset LGetMaterial, dword ptr [ebp+4], eax, pThis, pMaterial
    .endif
    ret

GetMaterialHook endp
; ##########################################################################
SetLightHook proc pThis:dword, Index:dword, pLight:dword

    invoke SetLight, pThis, Index, pLight
    .if framedump == SET
        invoke log, 3, offset LSetLight, dword ptr [ebp+4], eax, pThis, Index, pLight
    .endif
    ret

SetLightHook endp
; ##########################################################################
GetLightHook proc pThis:dword, Index:dword, pLight:dword

    invoke GetLight, pThis, Index, pLight
    .if framedump == SET
        invoke log, 3, offset LGetLight, dword ptr [ebp+4], eax, pThis, Index, pLight
    .endif
    ret

GetLightHook endp
; ##########################################################################
LightEnableHook proc pThis:dword, Index:dword, Enable:dword

    invoke LightEnable, pThis, Index, Enable
    .if framedump == SET
        invoke log, 3, offset LLightEnable, dword ptr [ebp+4], eax, pThis, Index, Enable
    .endif
    ret

LightEnableHook endp
; ##########################################################################
GetLightEnableHook proc pThis:dword, Index:dword, pEnable:dword

    invoke GetLightEnable, pThis, Index, pEnable
    .if framedump == SET
        invoke log, 3, offset LGetLightEnable, dword ptr [ebp+4], eax, pThis, Index, pEnable
    .endif
    ret

GetLightEnableHook endp
; ##########################################################################
SetClipPlaneHook proc pThis:dword, Index:dword, pPlane:dword

    invoke SetClipPlane, pThis, Index, pPlane
    .if framedump == SET
        invoke log, 3, offset LSetClipPlane, dword ptr [ebp+4], eax, pThis, Index, pPlane
    .endif
    ret

SetClipPlaneHook endp
; ##########################################################################
GetClipPlaneHook proc pThis:dword, Index:dword, pPlane:dword

    invoke GetClipPlane, pThis, Index, pPlane
    .if framedump == SET
        invoke log, 3, offset LGetClipPlane, dword ptr [ebp+4], eax, pThis, Index, pPlane
    .endif
    ret

GetClipPlaneHook endp
; ##########################################################################
SetRenderStateHook proc pThis:dword, State:dword, Value:dword

    invoke SetRenderState, pThis, State, Value
    .if framedump == SET
        invoke log, 3, offset LSetRenderState, dword ptr [ebp+4], eax, pThis, State, Value
    .endif
    ret

SetRenderStateHook endp
; ##########################################################################
GetRenderStateHook proc pThis:dword, State:dword, pValue:dword

    invoke GetRenderState, pThis, State, pValue
    .if framedump == SET
        invoke log, 3, offset LGetRenderState, dword ptr [ebp+4], eax, pThis, State, pValue
    .endif
    ret

GetRenderStateHook endp
; ##########################################################################
CreateStateBlockHook proc pThis:dword, pType:dword, ppSB:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateStateBlock, pThis, pType, ppSB
    push eax
    mov ecx, ppSB
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable sbQUERYINTERFACE, sbQueryInterface, sbQueryInterfaceHook
        HookVectorTable sbADDREF, sbAddRef, sbAddRefHook
        HookVectorTable sbRELEASE, sbRelease, sbReleaseHook
        HookVectorTable sbGETDEVICE, sbGetDevice, sbGetDeviceHook
        HookVectorTable sbCAPTURE, sbCapture, sbCaptureHook
        HookVectorTable sbAPPLY, sbApply, sbApplyHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 3, offset LCreateStateBlock, dword ptr [ebp+4], eax, pThis, pType, ppSB
    .endif
    ret

CreateStateBlockHook endp
; ##########################################################################
BeginStateBlockHook proc pThis:dword

    invoke BeginStateBlock, pThis
    .if framedump == SET
        invoke log, 1, offset LBeginStateBlock, dword ptr [ebp+4], eax, pThis
    .endif
    ret

BeginStateBlockHook endp
; ##########################################################################
EndStateBlockHook proc pThis:dword, ppSB:dword

    invoke EndStateBlock, pThis, ppSB
    push eax
    mov ecx, ppSB
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable sbQUERYINTERFACE, sbQueryInterface, sbQueryInterfaceHook
        HookVectorTable sbADDREF, sbAddRef, sbAddRefHook
        HookVectorTable sbRELEASE, sbRelease, sbReleaseHook
        HookVectorTable sbGETDEVICE, sbGetDevice, sbGetDeviceHook
        HookVectorTable sbCAPTURE, sbCapture, sbCaptureHook
        HookVectorTable sbAPPLY, sbApply, sbApplyHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 2, offset LEndStateBlock, dword ptr [ebp+4], eax, pThis, ppSB
    .endif
    ret

EndStateBlockHook endp
; ##########################################################################
SetClipStatusHook proc pThis:dword, pClipStatus:dword

    invoke SetClipStatus, pThis, pClipStatus
    .if framedump == SET
        invoke log, 2, offset LSetClipStatus, dword ptr [ebp+4], eax, pThis, pClipStatus
    .endif
    ret

SetClipStatusHook endp
; ##########################################################################
GetClipStatusHook proc pThis:dword, pClipStatus:dword

    invoke GetClipStatus, pThis, pClipStatus
    .if framedump == SET
        invoke log, 2, offset LGetClipStatus, dword ptr [ebp+4], eax, pThis, pClipStatus
    .endif
    ret

GetClipStatusHook endp
; ##########################################################################
GetTextureHook proc pThis:dword, Stage:dword, ppTexture:dword

    invoke GetTexture, pThis, Stage, ppTexture
    push eax
    mov ecx, ppTexture
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable btQUERYINTERFACE, btQueryInterface, btQueryInterfaceHook
        HookVectorTable btADDREF, btAddRef, btAddRefHook
        HookVectorTable btRELEASE, btRelease, btReleaseHook
        HookVectorTable btGETDEVICE, btGetDevice, btGetDeviceHook
        HookVectorTable btSETPRIVATEDATA, btSetPrivateData, btSetPrivateDataHook
        HookVectorTable btGETPRIVATEDATA, btGetPrivateData, btGetPrivateDataHook
        HookVectorTable btFREEPRIVATEDATA, btFreePrivateData, btFreePrivateDataHook
        HookVectorTable btSETPRIORITY, btSetPriority, btSetPriorityHook
        HookVectorTable btGETPRIORITY, btGetPriority, btGetPriorityHook
        HookVectorTable btPRELOAD, btPreLoad, btPreLoadHook
        HookVectorTable btGETTYPE, btGetType, btGetTypeHook
        HookVectorTable btSETLOD, btSetLOD, btSetLODHook
        HookVectorTable btGETLOD, btGetLOD, btGetLODHook
        HookVectorTable btGETLEVELCOUNT, btGetLevelCount, btGetLevelCountHook
        HookVectorTable btSETAUTOGENFILTERTYPE, btSetAutoGenFilterType, btSetAutoGenFilterTypeHook
        HookVectorTable btGETAUTOGENFILTERTYPE, btGetAutoGenFilterType, btGetAutoGenFilterTypeHook
        HookVectorTable btGENERATEMIPSUBLEVELS, btGenerateMipSubLevels, btGenerateMipSubLevelsHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 3, offset LGetTexture, dword ptr [ebp+4], eax, pThis, Stage, ppTexture
    .endif
    ret

GetTextureHook endp
; ##########################################################################
GetTextureStageStateHook proc pThis:dword, Stage:dword, pType:dword, pValue:dword

    invoke GetTextureStageState, pThis, Stage, pType, pValue
    .if framedump == SET
        invoke log, 4, offset LGetTextureStageState, dword ptr [ebp+4], eax, pThis, Stage, pType, pValue
    .endif
    ret

GetTextureStageStateHook endp
; ##########################################################################
SetTextureStageStateHook proc pThis:dword, Stage:dword, pType:dword, Value:dword

    invoke SetTextureStageState, pThis, Stage, pType, Value
    .if framedump == SET
        invoke log, 4, offset LSetTextureStageState, dword ptr [ebp+4], eax, pThis, Stage, pType, Value
    .endif
    ret

SetTextureStageStateHook endp
; ##########################################################################
GetSamplerStateHook proc pThis:dword, Sampler:dword, pType:dword, pValue:dword

    invoke GetSamplerState, pThis, Sampler, pType, pValue
    .if framedump == SET
        invoke log, 4, offset LGetSamplerState, dword ptr [ebp+4], eax, pThis, Sampler, pType, pValue
    .endif
    ret

GetSamplerStateHook endp
; ##########################################################################
SetSamplerStateHook proc pThis:dword, Sampler:dword, pType:dword, Value:dword

    invoke SetSamplerState, pThis, Sampler, pType, Value
    .if framedump == SET
        invoke log, 4, offset LSetSamplerState, dword ptr [ebp+4], eax, pThis, Sampler, pType, Value
    .endif
    ret

SetSamplerStateHook endp
; ##########################################################################
ValidateDeviceHook proc pThis:dword, pNumPasses:dword

    invoke ValidateDevice, pThis, pNumPasses
    .if framedump == SET
        invoke log, 2, offset LValidateDevice, dword ptr [ebp+4], eax, pThis, pNumPasses
    .endif
    ret

ValidateDeviceHook endp
; ##########################################################################
SetPaletteEntriesHook proc pThis:dword, PaletteNumber:dword, pEntries:dword

    invoke SetPaletteEntries, pThis, PaletteNumber, pEntries
    .if framedump == SET
        invoke log, 3, offset LSetPaletteEntries, dword ptr [ebp+4], eax, pThis, PaletteNumber, pEntries
    .endif
    ret

SetPaletteEntriesHook endp
; ##########################################################################
GetPaletteEntriesHook proc pThis:dword, PaletteNumber:dword, pEntries:dword

    invoke GetPaletteEntries, pThis, PaletteNumber, pEntries
    .if framedump == SET
        invoke log, 3, offset LGetPaletteEntries, dword ptr [ebp+4], eax, pThis, PaletteNumber, pEntries
    .endif
    ret

GetPaletteEntriesHook endp
; ##########################################################################
SetCurrentTexturePaletteHook proc pThis:dword, PaletteNumber:dword

    invoke SetCurrentTexturePalette, pThis, PaletteNumber
    .if framedump == SET
        invoke log, 2, offset LSetCurrentTexturePalette, dword ptr [ebp+4], eax, pThis, PaletteNumber
    .endif
    ret

SetCurrentTexturePaletteHook endp
; ##########################################################################
GetCurrentTexturePaletteHook proc pThis:dword, PaletteNumber:dword

    invoke GetCurrentTexturePalette, pThis, PaletteNumber
    .if framedump == SET
        invoke log, 2, offset LGetCurrentTexturePalette, dword ptr [ebp+4], eax, pThis, PaletteNumber
    .endif
    ret

GetCurrentTexturePaletteHook endp
; ##########################################################################
SetScissorRectHook proc pThis:dword, pRect:dword

    invoke SetScissorRect, pThis, pRect
    .if framedump == SET
        invoke log, 2, offset LSetScissorRect, dword ptr [ebp+4], eax, pThis, pRect
    .endif
    ret

SetScissorRectHook endp
; ##########################################################################
GetScissorRectHook proc pThis:dword, pRect:dword

    invoke GetScissorRect, pThis, pRect
    .if framedump == SET
        invoke log, 2, offset LGetScissorRect, dword ptr [ebp+4], eax, pThis, pRect
    .endif
    ret

GetScissorRectHook endp
; ##########################################################################
SetSoftwareVertexProcessingHook proc pThis:dword, bSoftware:dword

    invoke SetSoftwareVertexProcessing, pThis, bSoftware
    .if framedump == SET
        invoke log, 2, offset LSetSoftwareVertexProcessing, dword ptr [ebp+4], eax, pThis, bSoftware
    .endif
    ret

SetSoftwareVertexProcessingHook endp
; ##########################################################################
GetSoftwareVertexProcessingHook proc pThis:dword

    invoke GetSoftwareVertexProcessing, pThis
    .if framedump == SET
        invoke log, 1, offset LGetSoftwareVertexProcessing, dword ptr [ebp+4], eax, pThis
    .endif
    ret

GetSoftwareVertexProcessingHook endp
; ##########################################################################
SetNPatchModeHook proc pThis:dword, nSegments:dword

    invoke SetNPatchMode, pThis, nSegments
    .if framedump == SET
        invoke log, 2, offset LSetNPatchMode, dword ptr [ebp+4], eax, pThis, nSegments
    .endif
    ret

SetNPatchModeHook endp
; ##########################################################################
GetNPatchModeHook proc pThis:dword

    invoke GetNPatchMode, pThis
    .if framedump == SET
        invoke log, 1, offset LGetNPatchMode, dword ptr [ebp+4], eax, pThis
    .endif
    ret

GetNPatchModeHook endp
; ##########################################################################
DrawPrimitiveHook proc pThis:dword, PrimitiveType:dword, StartVertex:dword, PrimitiveCount:dword

    mov eax, PrimitiveCount
    add triangles, eax
    invoke DrawPrimitive, pThis, PrimitiveType, StartVertex, PrimitiveCount
    .if framedump == SET
        invoke log, 4, offset LDrawPrimitive, dword ptr [ebp+4], eax, pThis, PrimitiveType, StartVertex, PrimitiveCount
    .endif
    ret

DrawPrimitiveHook endp
; ##########################################################################
DrawIndexedPrimitiveHook proc pThis:dword, PrimitiveType:dword, BaseVertexIndex:dword, MinVertexIndex:dword, NumVertices:dword, startIndex:dword, primCount:dword

    mov eax, primCount
    add triangles, eax
    invoke DrawIndexedPrimitive, pThis, PrimitiveType, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount
    .if framedump == SET
        invoke log, 7, offset LDrawIndexedPrimitive, dword ptr [ebp+4], eax, pThis, PrimitiveType, BaseVertexIndex, MinVertexIndex, NumVertices, startIndex, primCount
    .endif
    ret

DrawIndexedPrimitiveHook endp
; ##########################################################################
DrawPrimitiveUPHook proc pThis:dword, PrimitiveType:dword, PrimitiveCount:dword, pVertexStreamZeroData:dword, VertexStreamZeroStride:dword

    mov eax, PrimitiveCount
    add triangles, eax
    invoke DrawPrimitiveUP, pThis, PrimitiveType, PrimitiveCount, pVertexStreamZeroData, VertexStreamZeroStride
    .if framedump == SET
        invoke log, 5, offset LDrawPrimitiveUP, dword ptr [ebp+4], eax, pThis, PrimitiveType, PrimitiveCount, pVertexStreamZeroData, VertexStreamZeroStride
    .endif
    ret

DrawPrimitiveUPHook endp
; ##########################################################################
DrawIndexedPrimitiveUPHook proc pThis:dword, PrimitiveType:dword, MinVertexIndex:dword, NumVertices:dword, PrimitiveCount:dword, pIndexData:dword, IndexDataFormat:dword, pVertexStreamZeroData:dword, VertexStreamZeroStride:dword

    mov eax, PrimitiveCount
    add triangles, eax
    invoke DrawIndexedPrimitiveUP, pThis, PrimitiveType, MinVertexIndex, NumVertices, PrimitiveCount, pIndexData, IndexDataFormat, pVertexStreamZeroData, VertexStreamZeroStride
    .if framedump == SET
        invoke log, 9, offset LDrawIndexedPrimitiveUP, dword ptr [ebp+4], eax, pThis, PrimitiveType, MinVertexIndex, NumVertices, PrimitiveCount, pIndexData, IndexDataFormat, pVertexStreamZeroData, VertexStreamZeroStride
    .endif
    ret

DrawIndexedPrimitiveUPHook endp
; ##########################################################################
ProcessVerticesHook proc pThis:dword, SrcStartIndex:dword, DestIndex:dword, VertexCount:dword, pDestBuffer:dword, pVertexDecl:dword, Flags:dword

    .if pDestBuffer != 0
        mov ecx, pDestBuffer
        mov ecx, [ecx]
        HookVectorTable vlQUERYINTERFACE, vlQueryInterface, vlQueryInterfaceHook
        HookVectorTable vlADDREF, vlAddRef, vlAddRefHook
        HookVectorTable vlRELEASE, vlRelease, vlReleaseHook
        HookVectorTable vlGETDEVICE, vlGetDevice, vlGetDeviceHook
        HookVectorTable vlSETPRIVATEDATA, vlSetPrivateData, vlSetPrivateDataHook
        HookVectorTable vlGETPRIVATEDATA, vlGetPrivateData, vlGetPrivateDataHook
        HookVectorTable vlFREEPRIVATEDATA, vlFreePrivateData, vlFreePrivateDataHook
        HookVectorTable vlSETPRIORITY, vlSetPriority, vlSetPriorityHook
        HookVectorTable vlGETPRIORITY, vlGetPriority, vlGetPriorityHook
        HookVectorTable vlPRELOAD, vlPreLoad, vlPreLoadHook
        HookVectorTable vlGETTYPE, vlGetType, vlGetTypeHook
        HookVectorTable vlLOCK, vlLock, vlLockHook
        HookVectorTable vlUNLOCK, vlUnlock, vlUnlockHook
        HookVectorTable vlGETDESC, vlGetDesc, vlGetDescHook
    .endif
    .if pVertexDecl != 0
        mov ecx, pVertexDecl
        mov ecx, [ecx]
        HookVectorTable vdQUERYINTERFACE, vdQueryInterface, vdQueryInterfaceHook
        HookVectorTable vdADDREF, vdAddRef, vdAddRefHook
        HookVectorTable vdRELEASE, vdRelease, vdReleaseHook
        HookVectorTable vdGETDEVICE, vdGetDevice, vdGetDeviceHook
        HookVectorTable vdGETDECLARATION, vdGetDeclaration, vdGetDeclarationHook
    .endif
    invoke ProcessVertices, pThis, SrcStartIndex, DestIndex, VertexCount, pDestBuffer, pVertexDecl, Flags
    .if framedump == SET
        invoke log, 7, offset LProcessVertices, dword ptr [ebp+4], eax, pThis, SrcStartIndex, DestIndex, VertexCount, pDestBuffer, pVertexDecl, Flags
    .endif
    ret

ProcessVerticesHook endp
; ##########################################################################
CreateVertexDeclarationHook proc pThis:dword, pVertexElements:dword, ppDecl:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateVertexDeclaration, pThis, pVertexElements, ppDecl
    push eax
    mov ecx, ppDecl
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable vdQUERYINTERFACE, vdQueryInterface, vdQueryInterfaceHook
        HookVectorTable vdADDREF, vdAddRef, vdAddRefHook
        HookVectorTable vdRELEASE, vdRelease, vdReleaseHook
        HookVectorTable vdGETDEVICE, vdGetDevice, vdGetDeviceHook
        HookVectorTable vdGETDECLARATION, vdGetDeclaration, vdGetDeclarationHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 3, offset LCreateVertexDeclaration, dword ptr [ebp+4], eax, pThis, pVertexElements, ppDecl
    .endif
    ret

CreateVertexDeclarationHook endp
; ##########################################################################
SetVertexDeclarationHook proc pThis:dword, pDecl:dword

    .if pDecl != 0
        mov ecx, pDecl
        mov ecx, [ecx]
        HookVectorTable vdQUERYINTERFACE, vdQueryInterface, vdQueryInterfaceHook
        HookVectorTable vdADDREF, vdAddRef, vdAddRefHook
        HookVectorTable vdRELEASE, vdRelease, vdReleaseHook
        HookVectorTable vdGETDEVICE, vdGetDevice, vdGetDeviceHook
        HookVectorTable vdGETDECLARATION, vdGetDeclaration, vdGetDeclarationHook
    .endif
    invoke SetVertexDeclaration, pThis, pDecl
    .if framedump == SET
        invoke log, 2, offset LSetVertexDeclaration, dword ptr [ebp+4], eax, pThis, pDecl
    .endif
    ret

SetVertexDeclarationHook endp
; ##########################################################################
GetVertexDeclarationHook proc pThis:dword, ppDecl:dword

    invoke GetVertexDeclaration, pThis, ppDecl
    push eax
    mov ecx, ppDecl
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable vdQUERYINTERFACE, vdQueryInterface, vdQueryInterfaceHook
        HookVectorTable vdADDREF, vdAddRef, vdAddRefHook
        HookVectorTable vdRELEASE, vdRelease, vdReleaseHook
        HookVectorTable vdGETDEVICE, vdGetDevice, vdGetDeviceHook
        HookVectorTable vdGETDECLARATION, vdGetDeclaration, vdGetDeclarationHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 2, offset LGetVertexDeclaration, dword ptr [ebp+4], eax, pThis, ppDecl
    .endif
    ret

GetVertexDeclarationHook endp
; ##########################################################################
SetFVFHook proc pThis:dword, FVF:dword

    invoke SetFVF, pThis, FVF
    .if framedump == SET
        invoke log, 2, offset LSetFVF, dword ptr [ebp+4], eax, pThis, FVF
    .endif
    ret

SetFVFHook endp
; ##########################################################################
GetFVFHook proc pThis:dword, pFVF:dword

    invoke GetFVF, pThis, pFVF
    .if framedump == SET
        invoke log, 2, offset LGetFVF, dword ptr [ebp+4], eax, pThis, pFVF
    .endif
    ret

GetFVFHook endp
; ##########################################################################
CreateVertexShaderHook proc pThis:dword, pFunction:dword, ppShader:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateVertexShader, pThis, pFunction, ppShader
    push eax
    mov ecx, ppShader
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable vsQUERYINTERFACE, vsQueryInterface, vsQueryInterfaceHook
        HookVectorTable vsADDREF, vsAddRef, vsAddRefHook
        HookVectorTable vsRELEASE, vsRelease, vsReleaseHook
        HookVectorTable vsGETDEVICE, vsGetDevice, vsGetDeviceHook
        HookVectorTable vsGETFUNCTION, vsGetFunction, vsGetFunctionHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 3, offset LCreateVertexShader, dword ptr [ebp+4], eax, pThis, pFunction, ppShader
    .endif
    ret

CreateVertexShaderHook endp
; ##########################################################################
SetVertexShaderHook proc pThis:dword, pShader:dword

    .if pShader != 0
        mov ecx, pShader
        mov ecx, [ecx]
        HookVectorTable vsQUERYINTERFACE, vsQueryInterface, vsQueryInterfaceHook
        HookVectorTable vsADDREF, vsAddRef, vsAddRefHook
        HookVectorTable vsRELEASE, vsRelease, vsReleaseHook
        HookVectorTable vsGETDEVICE, vsGetDevice, vsGetDeviceHook
        HookVectorTable vsGETFUNCTION, vsGetFunction, vsGetFunctionHook
    .endif
    invoke SetVertexShader, pThis, pShader
    .if framedump == SET
        invoke log, 2, offset LSetVertexShader, dword ptr [ebp+4], eax, pThis, pShader
    .endif
    ret

SetVertexShaderHook endp
; ##########################################################################
GetVertexShaderHook proc pThis:dword, ppShader:dword

    invoke GetVertexShader, pThis, ppShader
    push eax
    mov ecx, ppShader
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable vsQUERYINTERFACE, vsQueryInterface, vsQueryInterfaceHook
        HookVectorTable vsADDREF, vsAddRef, vsAddRefHook
        HookVectorTable vsRELEASE, vsRelease, vsReleaseHook
        HookVectorTable vsGETDEVICE, vsGetDevice, vsGetDeviceHook
        HookVectorTable vsGETFUNCTION, vsGetFunction, vsGetFunctionHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 2, offset LGetVertexShader, dword ptr [ebp+4], eax, pThis, ppShader
    .endif
    ret

GetVertexShaderHook endp
; ##########################################################################
SetVertexShaderConstantFHook proc pThis:dword, StartRegister:dword, pConstantData:dword, Vector4fCount:dword

    invoke SetVertexShaderConstantF, pThis, StartRegister, pConstantData, Vector4fCount
    .if framedump == SET
        invoke log, 4, offset LSetVertexShaderConstantF, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, Vector4fCount
    .endif
    ret

SetVertexShaderConstantFHook endp
; ##########################################################################
GetVertexShaderConstantFHook proc pThis:dword, StartRegister:dword, pConstantData:dword, Vector4fCount:dword

    invoke GetVertexShaderConstantF, pThis, StartRegister, pConstantData, Vector4fCount
    .if framedump == SET
        invoke log, 4, offset LGetVertexShaderConstantF, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, Vector4fCount
    .endif
    ret

GetVertexShaderConstantFHook endp
; ##########################################################################
SetVertexShaderConstantIHook proc pThis:dword, StartRegister:dword, pConstantData:dword, Vector4iCount:dword

    invoke SetVertexShaderConstantI, pThis, StartRegister, pConstantData, Vector4iCount
    .if framedump == SET
        invoke log, 4, offset LSetVertexShaderConstantI, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, Vector4iCount
    .endif
    ret

SetVertexShaderConstantIHook endp
; ##########################################################################
GetVertexShaderConstantIHook proc pThis:dword, StartRegister:dword, pConstantData:dword, Vector4iCount:dword

    invoke GetVertexShaderConstantI, pThis, StartRegister, pConstantData, Vector4iCount
    .if framedump == SET
        invoke log, 4, offset LGetVertexShaderConstantI, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, Vector4iCount
    .endif
    ret

GetVertexShaderConstantIHook endp
; ##########################################################################
SetVertexShaderConstantBHook proc pThis:dword, StartRegister:dword, pConstantData:dword, BoolCount:dword

    invoke SetVertexShaderConstantB, pThis, StartRegister, pConstantData, BoolCount
    .if framedump == SET
        invoke log, 4, offset LSetVertexShaderConstantB, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, BoolCount
    .endif
    ret

SetVertexShaderConstantBHook endp
; ##########################################################################
GetVertexShaderConstantBHook proc pThis:dword, StartRegister:dword, pConstantData:dword, BoolCount:dword

    invoke GetVertexShaderConstantB, pThis, StartRegister, pConstantData, BoolCount
    .if framedump == SET
        invoke log, 4, offset LGetVertexShaderConstantB, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, BoolCount
    .endif
    ret

GetVertexShaderConstantBHook endp
; ##########################################################################
GetStreamSourceHook proc pThis:dword, StreamNumber:dword, ppStreamData:dword, pOffsetInBytes:dword, pStride:dword

    invoke GetStreamSource, pThis, StreamNumber, ppStreamData, pOffsetInBytes, pStride
    push eax
    mov ecx, ppStreamData
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable vlQUERYINTERFACE, vlQueryInterface, vlQueryInterfaceHook
        HookVectorTable vlADDREF, vlAddRef, vlAddRefHook
        HookVectorTable vlRELEASE, vlRelease, vlReleaseHook
        HookVectorTable vlGETDEVICE, vlGetDevice, vlGetDeviceHook
        HookVectorTable vlSETPRIVATEDATA, vlSetPrivateData, vlSetPrivateDataHook
        HookVectorTable vlGETPRIVATEDATA, vlGetPrivateData, vlGetPrivateDataHook
        HookVectorTable vlFREEPRIVATEDATA, vlFreePrivateData, vlFreePrivateDataHook
        HookVectorTable vlSETPRIORITY, vlSetPriority, vlSetPriorityHook
        HookVectorTable vlGETPRIORITY, vlGetPriority, vlGetPriorityHook
        HookVectorTable vlPRELOAD, vlPreLoad, vlPreLoadHook
        HookVectorTable vlGETTYPE, vlGetType, vlGetTypeHook
        HookVectorTable vlLOCK, vlLock, vlLockHook
        HookVectorTable vlUNLOCK, vlUnlock, vlUnlockHook
        HookVectorTable vlGETDESC, vlGetDesc, vlGetDescHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 5, offset LGetStreamSource, dword ptr [ebp+4], eax, pThis, StreamNumber, ppStreamData, pOffsetInBytes, pStride
    .endif
    ret

GetStreamSourceHook endp
; ##########################################################################
SetStreamSourceFreqHook proc pThis:dword, StreamNumber:dword, Setting:dword

    invoke SetStreamSourceFreq, pThis, StreamNumber, Setting
    .if framedump == SET
        invoke log, 3, offset LSetStreamSourceFreq, dword ptr [ebp+4], eax, pThis, StreamNumber, Setting
    .endif
    ret

SetStreamSourceFreqHook endp
; ##########################################################################
GetStreamSourceFreqHook proc pThis:dword, StreamNumber:dword, pSetting:dword

    invoke GetStreamSourceFreq, pThis, StreamNumber, pSetting
    .if framedump == SET
        invoke log, 3, offset LGetStreamSourceFreq, dword ptr [ebp+4], eax, pThis, StreamNumber, pSetting
    .endif
    ret

GetStreamSourceFreqHook endp
; ##########################################################################
SetIndicesHook proc pThis:dword, pIndexData:dword

    .if pIndexData != 0
        mov ecx, pIndexData
        mov ecx, [ecx]
        HookVectorTable ibQUERYINTERFACE, ibQueryInterface, ibQueryInterfaceHook
        HookVectorTable ibADDREF, ibAddRef, ibAddRefHook
        HookVectorTable ibRELEASE, ibRelease, ibReleaseHook
        HookVectorTable ibGETDEVICE, ibGetDevice, ibGetDeviceHook
        HookVectorTable ibSETPRIVATEDATA, ibSetPrivateData, ibSetPrivateDataHook
        HookVectorTable ibGETPRIVATEDATA, ibGetPrivateData, ibGetPrivateDataHook
        HookVectorTable ibFREEPRIVATEDATA, ibFreePrivateData, ibFreePrivateDataHook
        HookVectorTable ibSETPRIORITY, ibSetPriority, ibSetPriorityHook
        HookVectorTable ibGETPRIORITY, ibGetPriority, ibGetPriorityHook
        HookVectorTable ibPRELOAD, ibPreLoad, ibPreLoadHook
        HookVectorTable ibGETTYPE, ibGetType, ibGetTypeHook
        mov eax, dword ptr [ebp+4]
        .if eax < d3dx_lower || eax > d3dx_upper
            HookVectorTable ibLOCK, ibLock, ibLockHook
        .endif
        HookVectorTable ibUNLOCK, ibUnlock, ibUnlockHook
        HookVectorTable ibGETDESC, ibGetDesc, ibGetDescHook
    .endif
    invoke SetIndices, pThis, pIndexData
    .if framedump == SET
        invoke log, 2, offset LSetIndices, dword ptr [ebp+4], eax, pThis, pIndexData
    .endif
    ret

SetIndicesHook endp
; ##########################################################################
GetIndicesHook proc pThis:dword, ppIndexData:dword

    invoke GetIndices, pThis, ppIndexData
    push eax
    mov ecx, ppIndexData
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable ibQUERYINTERFACE, ibQueryInterface, ibQueryInterfaceHook
        HookVectorTable ibADDREF, ibAddRef, ibAddRefHook
        HookVectorTable ibRELEASE, ibRelease, ibReleaseHook
        HookVectorTable ibGETDEVICE, ibGetDevice, ibGetDeviceHook
        HookVectorTable ibSETPRIVATEDATA, ibSetPrivateData, ibSetPrivateDataHook
        HookVectorTable ibGETPRIVATEDATA, ibGetPrivateData, ibGetPrivateDataHook
        HookVectorTable ibFREEPRIVATEDATA, ibFreePrivateData, ibFreePrivateDataHook
        HookVectorTable ibSETPRIORITY, ibSetPriority, ibSetPriorityHook
        HookVectorTable ibGETPRIORITY, ibGetPriority, ibGetPriorityHook
        HookVectorTable ibPRELOAD, ibPreLoad, ibPreLoadHook
        HookVectorTable ibGETTYPE, ibGetType, ibGetTypeHook
        mov eax, dword ptr [ebp+4]
        .if eax < d3dx_lower || eax > d3dx_upper
            HookVectorTable ibLOCK, ibLock, ibLockHook
        .endif
        HookVectorTable ibUNLOCK, ibUnlock, ibUnlockHook
        HookVectorTable ibGETDESC, ibGetDesc, ibGetDescHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 2, offset LGetIndices, dword ptr [ebp+4], eax, pThis, ppIndexData
    .endif
    ret

GetIndicesHook endp
; ##########################################################################
CreatePixelShaderHook proc pThis:dword, pFunction:dword, ppShader:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreatePixelShader, pThis, pFunction, ppShader
    push eax
    mov ecx, ppShader
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable psQUERYINTERFACE, psQueryInterface, psQueryInterfaceHook
        HookVectorTable psADDREF, psAddRef, psAddRefHook
        HookVectorTable psRELEASE, psRelease, psReleaseHook
        HookVectorTable psGETDEVICE, psGetDevice, psGetDeviceHook
        HookVectorTable psGETFUNCTION, psGetFunction, psGetFunctionHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 3, offset LCreatePixelShader, dword ptr [ebp+4], eax, pThis, pFunction, ppShader
    .endif
    ret

CreatePixelShaderHook endp
; ##########################################################################
SetPixelShaderHook proc pThis:dword, pShader:dword

    .if pShader != 0
        mov ecx, pShader
        mov ecx, [ecx]
        HookVectorTable psQUERYINTERFACE, psQueryInterface, psQueryInterfaceHook
        HookVectorTable psADDREF, psAddRef, psAddRefHook
        HookVectorTable psRELEASE, psRelease, psReleaseHook
        HookVectorTable psGETDEVICE, psGetDevice, psGetDeviceHook
        HookVectorTable psGETFUNCTION, psGetFunction, psGetFunctionHook
    .endif
    invoke SetPixelShader, pThis, pShader
    .if framedump == SET
        invoke log, 2, offset LSetPixelShader, dword ptr [ebp+4], eax, pThis, pShader
    .endif
    ret

SetPixelShaderHook endp
; ##########################################################################
GetPixelShaderHook proc pThis:dword, ppShader:dword

    invoke GetPixelShader, pThis, ppShader
    push eax
    mov ecx, ppShader
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable psQUERYINTERFACE, psQueryInterface, psQueryInterfaceHook
        HookVectorTable psADDREF, psAddRef, psAddRefHook
        HookVectorTable psRELEASE, psRelease, psReleaseHook
        HookVectorTable psGETDEVICE, psGetDevice, psGetDeviceHook
        HookVectorTable psGETFUNCTION, psGetFunction, psGetFunctionHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 2, offset LGetPixelShader, dword ptr [ebp+4], eax, pThis, ppShader
    .endif
    ret

GetPixelShaderHook endp
; ##########################################################################
SetPixelShaderConstantFHook proc pThis:dword, StartRegister:dword, pConstantData:dword, Vector4fCount:dword

    invoke SetPixelShaderConstantF, pThis, StartRegister, pConstantData, Vector4fCount
    .if framedump == SET
        invoke log, 4, offset LSetPixelShaderConstantF, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, Vector4fCount
    .endif
    ret

SetPixelShaderConstantFHook endp
; ##########################################################################
GetPixelShaderConstantFHook proc pThis:dword, StartRegister:dword, pConstantData:dword, Vector4fCount:dword

    invoke GetPixelShaderConstantF, pThis, StartRegister, pConstantData, Vector4fCount
    .if framedump == SET
        invoke log, 4, offset LGetPixelShaderConstantF, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, Vector4fCount
    .endif
    ret

GetPixelShaderConstantFHook endp
; ##########################################################################
SetPixelShaderConstantIHook proc pThis:dword, StartRegister:dword, pConstantData:dword, Vector4iCount:dword

    invoke SetPixelShaderConstantI, pThis, StartRegister, pConstantData, Vector4iCount
    .if framedump == SET
        invoke log, 4, offset LSetPixelShaderConstantI, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, Vector4iCount
    .endif
    ret

SetPixelShaderConstantIHook endp
; ##########################################################################
GetPixelShaderConstantIHook proc pThis:dword, StartRegister:dword, pConstantData:dword, Vector4iCount:dword

    invoke GetPixelShaderConstantI, pThis, StartRegister, pConstantData, Vector4iCount
    .if framedump == SET
        invoke log, 4, offset LGetPixelShaderConstantI, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, Vector4iCount
    .endif
    ret

GetPixelShaderConstantIHook endp
; ##########################################################################
SetPixelShaderConstantBHook proc pThis:dword, StartRegister:dword, pConstantData:dword, BoolCount:dword

    invoke SetPixelShaderConstantB, pThis, StartRegister, pConstantData, BoolCount
    .if framedump == SET
        invoke log, 4, offset LSetPixelShaderConstantB, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, BoolCount
    .endif
    ret

SetPixelShaderConstantBHook endp
; ##########################################################################
GetPixelShaderConstantBHook proc pThis:dword, StartRegister:dword, pConstantData:dword, BoolCount:dword

    invoke GetPixelShaderConstantB, pThis, StartRegister, pConstantData, BoolCount
    .if framedump == SET
        invoke log, 4, offset LGetPixelShaderConstantB, dword ptr [ebp+4], eax, pThis, StartRegister, pConstantData, BoolCount
    .endif
    ret

GetPixelShaderConstantBHook endp
; ##########################################################################
DrawRectPatchHook proc pThis:dword, Handle:dword, pNumSegs:dword, pRectPatchInfo:dword

    invoke DrawRectPatch, pThis, Handle, pNumSegs, pRectPatchInfo
    .if framedump == SET
        invoke log, 4, offset LDrawRectPatch, dword ptr [ebp+4], eax, pThis, Handle, pNumSegs, pRectPatchInfo
    .endif
    ret

DrawRectPatchHook endp
; ##########################################################################
DrawTriPatchHook proc pThis:dword, Handle:dword, pNumSegs:dword, pTriPatchInfo:dword

    invoke DrawTriPatch, pThis, Handle, pNumSegs, pTriPatchInfo
    .if framedump == SET
        invoke log, 4, offset LDrawTriPatch, dword ptr [ebp+4], eax, pThis, Handle, pNumSegs, pTriPatchInfo
    .endif
    ret

DrawTriPatchHook endp
; ##########################################################################
DeletePatchHook proc pThis:dword, Handle:dword

    invoke DeletePatch, pThis, Handle
    .if framedump == SET
        invoke log, 2, offset LDeletePatch, dword ptr [ebp+4], eax, pThis, Handle
    .endif
    ret

DeletePatchHook endp
; ##########################################################################
CreateQueryHook proc pThis:dword, pType:dword, ppQuery:dword

    .if framedump == ONCREATE
        mov framedump, SET
        invoke logheader
    .endif
    invoke CreateQuery, pThis, pType, ppQuery
    push eax
    mov ecx, ppQuery
    mov ecx, [ecx]
    .if ecx != 0
        mov ecx, [ecx]
        HookVectorTable qxQUERYINTERFACE, qxQueryInterface, qxQueryInterfaceHook
        HookVectorTable qxADDREF, qxAddRef, qxAddRefHook
        HookVectorTable qxRELEASE, qxRelease, qxReleaseHook
        HookVectorTable qxGETDEVICE, qxGetDevice, qxGetDeviceHook
        HookVectorTable qxGETTYPE, qxGetType, qxGetTypeHook
        HookVectorTable qxGETDATASIZE, qxGetDataSize, qxGetDataSizeHook
        HookVectorTable qxISSUE, qxIssue, qxIssueHook
        HookVectorTable qxGETDATA, qxGetData, qxGetDataHook
    .endif
    pop eax
    .if framedump == SET
        invoke log, 3, offset LCreateQuery, dword ptr [ebp+4], eax, pThis, pType, ppQuery
    .endif
    ret

CreateQueryHook endp
; ##########################################################################
vsQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke vsQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset TQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

vsQueryInterfaceHook endp
; ##########################################################################
vsAddRefHook proc pThis:dword

    invoke vsAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset TAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vsAddRefHook endp
; ##########################################################################
vsReleaseHook proc pThis:dword

    invoke vsRelease, pThis
    .if framedump == SET
        invoke log, 1, offset TRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vsReleaseHook endp
; ##########################################################################
vsGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke vsGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset TGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

vsGetDeviceHook endp
; ##########################################################################
vsGetFunctionHook proc pThis:dword, pFunc:dword, pSizeOfData:dword

    invoke vsGetFunction, pThis, pFunc, pSizeOfData
    .if framedump == SET
        invoke log, 3, offset TGetFunction, dword ptr [ebp+4], eax, pThis, pFunc, pSizeOfData
    .endif
    ret

vsGetFunctionHook endp
; ##########################################################################
btQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke btQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset SQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

btQueryInterfaceHook endp
; ##########################################################################
btAddRefHook proc pThis:dword

    invoke btAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset SAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

btAddRefHook endp
; ##########################################################################
btReleaseHook proc pThis:dword

    invoke btRelease, pThis
    .if framedump == SET
        invoke log, 1, offset SRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

btReleaseHook endp
; ##########################################################################
btGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke btGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset SGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

btGetDeviceHook endp
; ##########################################################################
btSetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, SizeOfData:dword, Flags:dword

    invoke btSetPrivateData, pThis, refguid, pData, SizeOfData, Flags
    .if framedump == SET
        invoke log, 5, offset SSetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, SizeOfData, Flags
    .endif
    ret

btSetPrivateDataHook endp
; ##########################################################################
btGetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, pSizeOfData:dword

    invoke btGetPrivateData, pThis, refguid, pData, pSizeOfData
    .if framedump == SET
        invoke log, 4, offset SGetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, pSizeOfData
    .endif
    ret

btGetPrivateDataHook endp
; ##########################################################################
btFreePrivateDataHook proc pThis:dword, refguid:dword

    invoke btFreePrivateData, pThis, refguid
    .if framedump == SET
        invoke log, 2, offset SFreePrivateData, dword ptr [ebp+4], eax, pThis, refguid
    .endif
    ret

btFreePrivateDataHook endp
; ##########################################################################
btSetPriorityHook proc pThis:dword, PriorityNew:dword

    invoke btSetPriority, pThis, PriorityNew
    .if framedump == SET
        invoke log, 2, offset SSetPriority, dword ptr [ebp+4], eax, pThis, PriorityNew
    .endif
    ret

btSetPriorityHook endp
; ##########################################################################
btGetPriorityHook proc pThis:dword

    invoke btGetPriority, pThis
    .if framedump == SET
        invoke log, 1, offset SGetPriority, dword ptr [ebp+4], eax, pThis
    .endif
    ret

btGetPriorityHook endp
; ##########################################################################
btPreLoadHook proc pThis:dword

    invoke btPreLoad, pThis
    .if framedump == SET
        invoke log, 1, offset SPreLoad, dword ptr [ebp+4], eax, pThis
    .endif
    ret

btPreLoadHook endp
; ##########################################################################
btGetTypeHook proc pThis:dword

    invoke btGetType, pThis
    .if framedump == SET
        invoke log, 1, offset SGetType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

btGetTypeHook endp
; ##########################################################################
btSetLODHook proc pThis:dword, LODNew:dword

    invoke btSetLOD, pThis, LODNew
    .if framedump == SET
        invoke log, 2, offset SSetLOD, dword ptr [ebp+4], eax, pThis, LODNew
    .endif
    ret

btSetLODHook endp
; ##########################################################################
btGetLODHook proc pThis:dword

    invoke btGetLOD, pThis
    .if framedump == SET
        invoke log, 1, offset SGetLOD, dword ptr [ebp+4], eax, pThis
    .endif
    ret

btGetLODHook endp
; ##########################################################################
btGetLevelCountHook proc pThis:dword

    invoke btGetLevelCount, pThis
    .if framedump == SET
        invoke log, 1, offset SGetLevelCount, dword ptr [ebp+4], eax, pThis
    .endif
    ret

btGetLevelCountHook endp
; ##########################################################################
btSetAutoGenFilterTypeHook proc pThis:dword, FilterType:dword

    invoke btSetAutoGenFilterType, pThis, FilterType
    .if framedump == SET
        invoke log, 2, offset SSetAutoGenFilterType, dword ptr [ebp+4], eax, pThis, FilterType
    .endif
    ret

btSetAutoGenFilterTypeHook endp
; ##########################################################################
btGetAutoGenFilterTypeHook proc pThis:dword

    invoke btGetAutoGenFilterType, pThis
    .if framedump == SET
        invoke log, 1, offset SGetAutoGenFilterType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

btGetAutoGenFilterTypeHook endp
; ##########################################################################
btGenerateMipSubLevelsHook proc pThis:dword

    invoke btGenerateMipSubLevels, pThis
    .if framedump == SET
        invoke log, 1, offset SGenerateMipSubLevels, dword ptr [ebp+4], eax, pThis
    .endif
    ret

btGenerateMipSubLevelsHook endp
; ##########################################################################
ttQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke ttQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset AQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

ttQueryInterfaceHook endp
; ##########################################################################
ttAddRefHook proc pThis:dword

    invoke ttAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset AAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ttAddRefHook endp
; ##########################################################################
ttReleaseHook proc pThis:dword

    invoke ttRelease, pThis
    .if framedump == SET
        invoke log, 1, offset ARelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ttReleaseHook endp
; ##########################################################################
ttGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke ttGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset AGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

ttGetDeviceHook endp
; ##########################################################################
ttSetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, SizeOfData:dword, Flags:dword

    invoke ttSetPrivateData, pThis, refguid, pData, SizeOfData, Flags
    .if framedump == SET
        invoke log, 5, offset ASetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, SizeOfData, Flags
    .endif
    ret

ttSetPrivateDataHook endp
; ##########################################################################
ttGetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, pSizeOfData:dword

    invoke ttGetPrivateData, pThis, refguid, pData, pSizeOfData
    .if framedump == SET
        invoke log, 4, offset AGetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, pSizeOfData
    .endif
    ret

ttGetPrivateDataHook endp
; ##########################################################################
ttFreePrivateDataHook proc pThis:dword, refguid:dword

    invoke ttFreePrivateData, pThis, refguid
    .if framedump == SET
        invoke log, 2, offset AFreePrivateData, dword ptr [ebp+4], eax, pThis, refguid
    .endif
    ret

ttFreePrivateDataHook endp
; ##########################################################################
ttSetPriorityHook proc pThis:dword, PriorityNew:dword

    invoke ttSetPriority, pThis, PriorityNew
    .if framedump == SET
        invoke log, 2, offset ASetPriority, dword ptr [ebp+4], eax, pThis, PriorityNew
    .endif
    ret

ttSetPriorityHook endp
; ##########################################################################
ttGetPriorityHook proc pThis:dword

    invoke ttGetPriority, pThis
    .if framedump == SET
        invoke log, 1, offset AGetPriority, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ttGetPriorityHook endp
; ##########################################################################
ttPreLoadHook proc pThis:dword

    invoke ttPreLoad, pThis
    .if framedump == SET
        invoke log, 1, offset APreLoad, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ttPreLoadHook endp
; ##########################################################################
ttGetTypeHook proc pThis:dword

    invoke ttGetType, pThis
    .if framedump == SET
        invoke log, 1, offset AGetType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ttGetTypeHook endp
; ##########################################################################
ttSetLODHook proc pThis:dword, LODNew:dword

    invoke ttSetLOD, pThis, LODNew
    .if framedump == SET
        invoke log, 2, offset ASetLOD, dword ptr [ebp+4], eax, pThis, LODNew
    .endif
    ret

ttSetLODHook endp
; ##########################################################################
ttGetLODHook proc pThis:dword

    invoke ttGetLOD, pThis
    .if framedump == SET
        invoke log, 1, offset AGetLOD, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ttGetLODHook endp
; ##########################################################################
ttGetLevelCountHook proc pThis:dword

    invoke ttGetLevelCount, pThis
    .if framedump == SET
        invoke log, 1, offset AGetLevelCount, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ttGetLevelCountHook endp
; ##########################################################################
ttSetAutoGenFilterTypeHook proc pThis:dword, FilterType:dword

    invoke ttSetAutoGenFilterType, pThis, FilterType
    .if framedump == SET
        invoke log, 2, offset ASetAutoGenFilterType, dword ptr [ebp+4], eax, pThis, FilterType
    .endif
    ret

ttSetAutoGenFilterTypeHook endp
; ##########################################################################
ttGetAutoGenFilterTypeHook proc pThis:dword

    invoke ttGetAutoGenFilterType, pThis
    .if framedump == SET
        invoke log, 1, offset AGetAutoGenFilterType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ttGetAutoGenFilterTypeHook endp
; ##########################################################################
ttGenerateMipSubLevelsHook proc pThis:dword

    invoke ttGenerateMipSubLevels, pThis
    .if framedump == SET
        invoke log, 1, offset AGenerateMipSubLevels, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ttGenerateMipSubLevelsHook endp
; ##########################################################################
ttGetLevelDescHook proc pThis:dword, Level:dword, pDesc:dword

    invoke ttGetLevelDesc, pThis, Level, pDesc
    .if framedump == SET
        invoke log, 3, offset AGetLevelDesc, dword ptr [ebp+4], eax, pThis, Level, pDesc
    .endif
    ret

ttGetLevelDescHook endp
; ##########################################################################
ttGetSurfaceLevelHook proc pThis:dword, Level:dword, ppSurfaceLevel:dword

    invoke ttGetSurfaceLevel, pThis, Level, ppSurfaceLevel
    .if framedump == SET
        invoke log, 3, offset AGetSurfaceLevel, dword ptr [ebp+4], eax, pThis, Level, ppSurfaceLevel
    .endif
    ret

ttGetSurfaceLevelHook endp
; ##########################################################################
ttLockRectHook proc pThis:dword, Level:dword, pLockedRect:dword, pRect:dword, Flags:dword

    invoke ttLockRect, pThis, Level, pLockedRect, pRect, Flags
    .if framedump == SET
        invoke log, 5, offset ALockRect, dword ptr [ebp+4], eax, pThis, Level, pLockedRect, pRect, Flags
    .endif
    ret

ttLockRectHook  endp
; ##########################################################################
ttUnlockRectHook proc pThis:dword, Level:dword

    invoke ttUnlockRect, pThis, Level
    .if framedump == SET
        invoke log, 2, offset AUnlockRect, dword ptr [ebp+4], eax, pThis, Level
    .endif
    ret

ttUnlockRectHook endp
; ##########################################################################
ttAddDirtyRectHook proc pThis:dword, pDirtyRect:dword

    invoke ttAddDirtyRect, pThis, pDirtyRect
    .if framedump == SET
        invoke log, 2, offset AAddDirtyRect, dword ptr [ebp+4], eax, pThis, pDirtyRect
    .endif
    ret

ttAddDirtyRectHook endp
; ##########################################################################
cxQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke cxQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset CQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

cxQueryInterfaceHook endp
; ##########################################################################
cxAddRefHook proc pThis:dword

    invoke cxAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset CAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

cxAddRefHook endp
; ##########################################################################
cxReleaseHook proc pThis:dword

    invoke cxRelease, pThis
    .if framedump == SET
        invoke log, 1, offset CRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

cxReleaseHook endp
; ##########################################################################
cxGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke cxGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset CGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

cxGetDeviceHook endp
; ##########################################################################
cxSetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, SizeOfData:dword, Flags:dword

    invoke cxSetPrivateData, pThis, refguid, pData, SizeOfData, Flags
    .if framedump == SET
        invoke log, 5, offset CSetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, SizeOfData, Flags
    .endif
    ret

cxSetPrivateDataHook endp
; ##########################################################################
cxGetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, pSizeOfData:dword

    invoke cxGetPrivateData, pThis, refguid, pData, pSizeOfData
    .if framedump == SET
        invoke log, 4, offset CGetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, pSizeOfData
    .endif
    ret

cxGetPrivateDataHook endp
; ##########################################################################
cxFreePrivateDataHook proc pThis:dword, refguid:dword

    invoke cxFreePrivateData, pThis, refguid
    .if framedump == SET
        invoke log, 2, offset CFreePrivateData, dword ptr [ebp+4], eax, pThis, refguid
    .endif
    ret

cxFreePrivateDataHook endp
; ##########################################################################
cxSetPriorityHook proc pThis:dword, PriorityNew:dword

    invoke cxSetPriority, pThis, PriorityNew
    .if framedump == SET
        invoke log, 2, offset CSetPriority, dword ptr [ebp+4], eax, pThis, PriorityNew
    .endif
    ret

cxSetPriorityHook endp
; ##########################################################################
cxGetPriorityHook proc pThis:dword

    invoke cxGetPriority, pThis
    .if framedump == SET
        invoke log, 1, offset CGetPriority, dword ptr [ebp+4], eax, pThis
    .endif
    ret

cxGetPriorityHook endp
; ##########################################################################
cxPreLoadHook proc pThis:dword

    invoke cxPreLoad, pThis
    .if framedump == SET
        invoke log, 1, offset CPreLoad, dword ptr [ebp+4], eax, pThis
    .endif
    ret

cxPreLoadHook endp
; ##########################################################################
cxGetTypeHook proc pThis:dword

    invoke cxGetType, pThis
    .if framedump == SET
        invoke log, 1, offset CGetType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

cxGetTypeHook endp
; ##########################################################################
cxSetLODHook proc pThis:dword, LODNew:dword

    invoke cxSetLOD, pThis, LODNew
    .if framedump == SET
        invoke log, 2, offset CSetLOD, dword ptr [ebp+4], eax, pThis, LODNew
    .endif
    ret

cxSetLODHook endp
; ##########################################################################
cxGetLODHook proc pThis:dword

    invoke cxGetLOD, pThis
    .if framedump == SET
        invoke log, 1, offset CGetLOD, dword ptr [ebp+4], eax, pThis
    .endif
    ret

cxGetLODHook endp
; ##########################################################################
cxGetLevelCountHook proc pThis:dword

    invoke cxGetLevelCount, pThis
    .if framedump == SET
        invoke log, 1, offset CGetLevelCount, dword ptr [ebp+4], eax, pThis
    .endif
    ret

cxGetLevelCountHook endp
; ##########################################################################
cxSetAutoGenFilterTypeHook proc pThis:dword, FilterType:dword

    invoke cxSetAutoGenFilterType, pThis, FilterType
    .if framedump == SET
        invoke log, 2, offset CSetAutoGenFilterType, dword ptr [ebp+4], eax, pThis, FilterType
    .endif
    ret

cxSetAutoGenFilterTypeHook endp
; ##########################################################################
cxGetAutoGenFilterTypeHook proc pThis:dword

    invoke cxGetAutoGenFilterType, pThis
    .if framedump == SET
        invoke log, 1, offset CGetAutoGenFilterType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

cxGetAutoGenFilterTypeHook endp
; ##########################################################################
cxGenerateMipSubLevelsHook proc pThis:dword

    invoke cxGenerateMipSubLevels, pThis
    .if framedump == SET
        invoke log, 1, offset CGenerateMipSubLevels, dword ptr [ebp+4], eax, pThis
    .endif
    ret

cxGenerateMipSubLevelsHook endp
; ##########################################################################
cxGetLevelDescHook proc pThis:dword, Level:dword, pDesc:dword

    invoke cxGetLevelDesc, pThis, Level, pDesc
    .if framedump == SET
        invoke log, 3, offset CGetLevelDesc, dword ptr [ebp+4], eax, pThis, Level, pDesc
    .endif
    ret

cxGetLevelDescHook endp
; ##########################################################################
cxGetCubeMapSurfaceHook proc pThis:dword, FaceType:dword, Level:dword, ppCubeMapSurface:dword

    invoke cxGetCubeMapSurface, pThis, FaceType, Level, ppCubeMapSurface
    .if framedump == SET
        invoke log, 4, offset CGetCubeMapSurface, dword ptr [ebp+4], eax, pThis, FaceType, Level, ppCubeMapSurface
    .endif
    ret

cxGetCubeMapSurfaceHook endp
; ##########################################################################
cxLockRectHook proc pThis:dword, FaceType:dword, Level:dword, pLockedRect:dword, pRect:dword, Flags:dword

    invoke cxLockRect, pThis, FaceType, Level, pLockedRect, pRect, Flags
    .if framedump == SET
        invoke log, 6, offset CLockRect, dword ptr [ebp+4], eax, pThis, FaceType, Level, pLockedRect, pRect, Flags
    .endif
    ret

cxLockRectHook endp
; ##########################################################################
cxUnlockRectHook proc pThis:dword, FaceType:dword, Level:dword

    invoke cxUnlockRect, pThis, FaceType, Level
    .if framedump == SET
        invoke log, 3, offset CUnlockRect, dword ptr [ebp+4], eax, pThis, FaceType, Level
    .endif
    ret

cxUnlockRectHook endp
; ##########################################################################
cxAddDirtyRectHook proc pThis:dword, FaceType:dword, pDirtyRect:dword

    invoke cxAddDirtyRect, pThis, FaceType, pDirtyRect
    .if framedump == SET
        invoke log, 3, offset CAddDirtyRect, dword ptr [ebp+4], eax, pThis, FaceType, pDirtyRect
    .endif
    ret

cxAddDirtyRectHook endp
; ##########################################################################
ibQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke ibQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset EQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

ibQueryInterfaceHook endp
; ##########################################################################
ibAddRefHook proc pThis:dword

    invoke ibAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset EAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ibAddRefHook endp
; ##########################################################################
ibReleaseHook proc pThis:dword

    invoke ibRelease, pThis
    .if framedump == SET
        invoke log, 1, offset ERelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ibReleaseHook endp
; ##########################################################################
ibGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke ibGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset EGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

ibGetDeviceHook endp
; ##########################################################################
ibSetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, SizeOfData:dword, Flags:dword

    invoke ibSetPrivateData, pThis, refguid, pData, SizeOfData, Flags
    .if framedump == SET
        invoke log, 5, offset ESetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, SizeOfData, Flags
    .endif
    ret

ibSetPrivateDataHook endp
; ##########################################################################
ibGetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, pSizeOfData:dword

    invoke ibGetPrivateData, pThis, refguid, pData, pSizeOfData
    .if framedump == SET
        invoke log, 4, offset EGetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, pSizeOfData
    .endif
    ret

ibGetPrivateDataHook endp
; ##########################################################################
ibFreePrivateDataHook proc pThis:dword, refguid:dword

    invoke ibFreePrivateData, pThis, refguid
    .if framedump == SET
        invoke log, 2, offset EFreePrivateData, dword ptr [ebp+4], eax, pThis, refguid
    .endif
    ret

ibFreePrivateDataHook endp
; ##########################################################################
ibSetPriorityHook proc pThis:dword, PriorityNew:dword

    invoke ibSetPriority, pThis, PriorityNew
    .if framedump == SET
        invoke log, 2, offset ESetPriority, dword ptr [ebp+4], eax, pThis, PriorityNew
    .endif
    ret

ibSetPriorityHook endp
; ##########################################################################
ibGetPriorityHook proc pThis:dword

    invoke ibGetPriority, pThis
    .if framedump == SET
        invoke log, 1, offset EGetPriority, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ibGetPriorityHook endp
; ##########################################################################
ibPreLoadHook proc pThis:dword

    invoke ibPreLoad, pThis
    .if framedump == SET
        invoke log, 1, offset EPreLoad, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ibPreLoadHook endp
; ##########################################################################
ibGetTypeHook proc pThis:dword

    invoke ibGetType, pThis
    .if framedump == SET
        invoke log, 1, offset EGetType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ibGetTypeHook endp
; ##########################################################################
ibLockHook proc pThis:dword, OffsetToLock:dword, SizeToLock:dword, ppbData:dword, Flags:dword

    invoke ibLock, pThis, OffsetToLock, SizeToLock, ppbData, Flags
    .if framedump == SET
        invoke log, 5, offset ELock, dword ptr [ebp+4], eax, pThis, OffsetToLock, SizeToLock, ppbData, Flags
    .endif
    ret

ibLockHook endp
; ##########################################################################
ibUnlockHook proc pThis:dword

    invoke ibUnlock, pThis
    .if framedump == SET
        invoke log, 1, offset EUnlock, dword ptr [ebp+4], eax, pThis
    .endif
    ret

ibUnlockHook endp
; ##########################################################################
ibGetDescHook proc pThis:dword, pDesc:dword

    invoke ibGetDesc, pThis, pDesc
    .if framedump == SET
        invoke log, 2, offset EGetDesc, dword ptr [ebp+4], eax, pThis, pDesc
    .endif
    ret

ibGetDescHook endp
; ##########################################################################
psQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke psQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset ZQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

psQueryInterfaceHook endp
; ##########################################################################
psAddRefHook proc pThis:dword

    invoke psAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset ZAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

psAddRefHook endp
; ##########################################################################
psReleaseHook proc pThis:dword

    invoke psRelease, pThis
    .if framedump == SET
        invoke log, 1, offset ZRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

psReleaseHook endp
; ##########################################################################
psGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke psGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset ZGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

psGetDeviceHook endp
; ##########################################################################
psGetFunctionHook proc pThis:dword, void:dword, pSizeOfData:dword

    invoke psGetFunction, pThis, void, pSizeOfData
    .if framedump == SET
        invoke log, 3, offset ZGetFunction, dword ptr [ebp+4], eax, pThis, void, pSizeOfData
    .endif
    ret

psGetFunctionHook endp
; ##########################################################################
qxQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke qxQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset HQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

qxQueryInterfaceHook endp
; ##########################################################################
qxAddRefHook proc pThis:dword

    invoke qxAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset HAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

qxAddRefHook endp
; ##########################################################################
qxReleaseHook proc pThis:dword

    invoke qxRelease, pThis
    .if framedump == SET
        invoke log, 1, offset HRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

qxReleaseHook endp
; ##########################################################################
qxGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke qxGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset HGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

qxGetDeviceHook endp
; ##########################################################################
qxGetTypeHook proc pThis:dword

    invoke qxGetType, pThis
    .if framedump == SET
        invoke log, 1, offset HGetType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

qxGetTypeHook endp
; ##########################################################################
qxGetDataSizeHook proc pThis:dword

    invoke qxGetDataSize, pThis
    .if framedump == SET
        invoke log, 1, offset HGetDataSize, dword ptr [ebp+4], eax, pThis
    .endif
    ret

qxGetDataSizeHook endp
; ##########################################################################
qxIssueHook proc pThis:dword, ppDevice:dword

    invoke qxIssue, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset HIssue, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

qxIssueHook endp
; ##########################################################################
qxGetDataHook proc pThis:dword, refguid:dword, pData:dword, pSizeOfData:dword

    invoke qxGetData, pThis, refguid, pData, pSizeOfData
    .if framedump == SET
        invoke log, 4, offset HGetData, dword ptr [ebp+4], eax, pThis, refguid, pData, pSizeOfData
    .endif
    ret

qxGetDataHook endp
; ##########################################################################
sbQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke sbQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset UQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

sbQueryInterfaceHook endp
; ##########################################################################
sbAddRefHook proc pThis:dword

    invoke sbAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset UAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

sbAddRefHook endp
; ##########################################################################
sbReleaseHook proc pThis:dword

    invoke sbRelease, pThis
    .if framedump == SET
        invoke log, 1, offset URelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

sbReleaseHook endp
; ##########################################################################
sbGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke sbGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset UGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

sbGetDeviceHook endp
; ##########################################################################
sbCaptureHook proc pThis:dword

    invoke sbCapture, pThis
    .if framedump == SET
        invoke log, 1, offset UCapture, dword ptr [ebp+4], eax, pThis
    .endif
    ret

sbCaptureHook endp
; ##########################################################################
sbApplyHook proc pThis:dword

    invoke sbApply, pThis
    .if framedump == SET
        invoke log, 1, offset UApply, dword ptr [ebp+4], eax, pThis
    .endif
    ret

sbApplyHook endp
; ##########################################################################
seQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke seQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset FQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

seQueryInterfaceHook endp
; ##########################################################################
seAddRefHook proc pThis:dword

    invoke seAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset FAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

seAddRefHook endp
; ##########################################################################
seReleaseHook proc pThis:dword

    invoke seRelease, pThis
    .if framedump == SET
        invoke log, 1, offset FRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

seReleaseHook endp
; ##########################################################################
seGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke seGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset FGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

seGetDeviceHook endp
; ##########################################################################
seSetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, SizeOfData:dword, Flags:dword

    invoke seSetPrivateData, pThis, refguid, pData, SizeOfData, Flags
    .if framedump == SET
        invoke log, 5, offset FSetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, SizeOfData, Flags
    .endif
    ret

seSetPrivateDataHook endp
; ##########################################################################
seGetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, pSizeOfData:dword

    invoke seGetPrivateData, pThis, refguid, pData, pSizeOfData
    .if framedump == SET
        invoke log, 4, offset FGetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, pSizeOfData
    .endif
    ret

seGetPrivateDataHook endp
; ##########################################################################
seFreePrivateDataHook proc pThis:dword, refguid:dword

    invoke seFreePrivateData, pThis, refguid
    .if framedump == SET
        invoke log, 2, offset FFreePrivateData, dword ptr [ebp+4], eax, pThis, refguid
    .endif
    ret

seFreePrivateDataHook endp
; ##########################################################################
seSetPriorityHook proc pThis:dword, PriorityNew:dword

    invoke seSetPriority, pThis, PriorityNew
    .if framedump == SET
        invoke log, 2, offset FSetPriority, dword ptr [ebp+4], eax, pThis, PriorityNew
    .endif
    ret

seSetPriorityHook endp
; ##########################################################################
seGetPriorityHook proc pThis:dword

    invoke seGetPriority, pThis
    .if framedump == SET
        invoke log, 1, offset FGetPriority, dword ptr [ebp+4], eax, pThis
    .endif
    ret

seGetPriorityHook endp
; ##########################################################################
sePreLoadHook proc pThis:dword

    invoke sePreLoad, pThis
    .if framedump == SET
        invoke log, 1, offset FPreLoad, dword ptr [ebp+4], eax, pThis
    .endif
    ret

sePreLoadHook endp
; ##########################################################################
seGetTypeHook proc pThis:dword

    invoke seGetType, pThis
    .if framedump == SET
        invoke log, 1, offset FGetType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

seGetTypeHook endp
; ##########################################################################
seGetContainerHook proc pThis:dword, riid:dword, ppContainer:dword

    invoke seGetContainer, pThis, riid, ppContainer
    .if framedump == SET
        invoke log, 3, offset FGetContainer, dword ptr [ebp+4], eax, pThis, riid, ppContainer
    .endif
    ret

seGetContainerHook endp
; ##########################################################################
seGetDescHook proc pThis:dword, pDesc:dword

    invoke seGetDesc, pThis, pDesc
    .if framedump == SET
        invoke log, 2, offset FGetDesc, dword ptr [ebp+4], eax, pThis, pDesc
    .endif
    ret

seGetDescHook endp
; ##########################################################################
seLockRectHook proc pThis:dword, pLockedRect:dword, pRect:dword, Flags:dword

    invoke seLockRect, pThis, pLockedRect, pRect, Flags
    .if framedump == SET
        invoke log, 4, offset FLockRect, dword ptr [ebp+4], eax, pThis, pLockedRect, pRect, Flags
    .endif
    ret

seLockRectHook endp
; ##########################################################################
seUnlockRectHook proc pThis:dword

    invoke seUnlockRect, pThis
    .if framedump == SET
        invoke log, 1, offset FUnlockRect, dword ptr [ebp+4], eax, pThis
    .endif
    ret

seUnlockRectHook endp
; ##########################################################################
seGetDCHook proc pThis:dword, phdc:dword

    invoke seGetDC, pThis, phdc
    .if framedump == SET
        invoke log, 2, offset FGetDC, dword ptr [ebp+4], eax, pThis, phdc
    .endif
    ret

seGetDCHook endp
; ##########################################################################
seReleaseDCHook proc pThis:dword, hdc:dword

    invoke seReleaseDC, pThis, hdc
    .if framedump == SET
        invoke log, 2, offset FReleaseDC, dword ptr [ebp+4], eax, pThis, hdc
    .endif
    ret

seReleaseDCHook endp
; ##########################################################################
scQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke scQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset VQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

scQueryInterfaceHook endp
; ##########################################################################
scAddRefHook proc pThis:dword

    invoke scAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset VAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

scAddRefHook endp
; ##########################################################################
scReleaseHook proc pThis:dword

    invoke scRelease, pThis
    .if framedump == SET
        invoke log, 1, offset VRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

scReleaseHook endp
; ##########################################################################
scPresentHook proc pThis:dword, pSourceRect:dword, pDestRect:dword, hDestWindowOverride:dword, pDirtyRegion:dword, dwFlags:dword

    invoke scPresent, pThis, pSourceRect, pDestRect, hDestWindowOverride, pDirtyRegion, dwFlags
    .if framedump == SET
        invoke log, 6, offset VPresent, dword ptr [ebp+4], eax, pThis, pSourceRect, pDestRect, hDestWindowOverride, pDirtyRegion, dwFlags
    .endif
    ret

scPresentHook endp
; ##########################################################################
scGetFrontBufferDataHook proc pThis:dword, pDestSurface:dword

    invoke scGetFrontBufferData, pThis, pDestSurface
    .if framedump == SET
        invoke log, 2, offset VGetFrontBufferData, dword ptr [ebp+4], eax, pThis, pDestSurface
    .endif
    ret

scGetFrontBufferDataHook endp
; ##########################################################################
scGetBackBufferHook proc pThis:dword, iBackBuffer:dword, pType:dword, ppBackBuffer:dword

    invoke scGetBackBuffer, pThis, iBackBuffer, pType, ppBackBuffer
    .if framedump == SET
        invoke log, 4, offset VGetBackBuffer, dword ptr [ebp+4], eax, pThis, iBackBuffer, pType, ppBackBuffer
    .endif
    ret

scGetBackBufferHook endp
; ##########################################################################
scGetRasterStatusHook proc pThis:dword, pDestSurface:dword

    invoke scGetRasterStatus, pThis, pDestSurface
    .if framedump == SET
        invoke log, 2, offset VGetRasterStatus, dword ptr [ebp+4], eax, pThis, pDestSurface
    .endif
    ret

scGetRasterStatusHook endp
; ##########################################################################
scGetDisplayModeHook proc pThis:dword, pDestSurface:dword

    invoke scGetDisplayMode, pThis, pDestSurface
    .if framedump == SET
        invoke log, 2, offset VGetDisplayMode, dword ptr [ebp+4], eax, pThis, pDestSurface
    .endif
    ret

scGetDisplayModeHook endp
; ##########################################################################
scGetDeviceHook proc pThis:dword, pDestSurface:dword

    invoke scGetDevice, pThis, pDestSurface
    .if framedump == SET
        invoke log, 2, offset VGetDevice, dword ptr [ebp+4], eax, pThis, pDestSurface
    .endif
    ret

scGetDeviceHook endp
; ##########################################################################
scGetPresentParametersHook proc pThis:dword, pDestSurface:dword

    invoke scGetPresentParameters, pThis, pDestSurface
    .if framedump == SET
        invoke log, 2, offset VGetPresentParameters, dword ptr [ebp+4], eax, pThis, pDestSurface
    .endif
    ret

scGetPresentParametersHook endp
; ##########################################################################
vlQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke vlQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset DQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

vlQueryInterfaceHook endp
; ##########################################################################
vlAddRefHook proc pThis:dword

    invoke vlAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset DAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vlAddRefHook endp
; ##########################################################################
vlReleaseHook proc pThis:dword

    invoke vlRelease, pThis
    .if framedump == SET
        invoke log, 1, offset DRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vlReleaseHook endp
; ##########################################################################
vlGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke vlGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset DGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

vlGetDeviceHook endp
; ##########################################################################
vlSetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, SizeOfData:dword, Flags:dword

    invoke vlSetPrivateData, pThis, refguid, pData, SizeOfData, Flags
    .if framedump == SET
        invoke log, 5, offset DSetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, SizeOfData, Flags
    .endif
    ret

vlSetPrivateDataHook endp
; ##########################################################################
vlGetPrivateDataHook proc pThis:dword, iBackBuffer:dword, pType:dword, ppBackBuffer:dword

    invoke vlGetPrivateData, pThis, iBackBuffer, pType, ppBackBuffer
    .if framedump == SET
        invoke log, 4, offset DGetPrivateData, dword ptr [ebp+4], eax, pThis, iBackBuffer, pType, ppBackBuffer
    .endif
    ret

vlGetPrivateDataHook endp
; ##########################################################################
vlFreePrivateDataHook proc pThis:dword, ppDevice:dword

    invoke vlFreePrivateData, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset DFreePrivateData, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

vlFreePrivateDataHook endp
; ##########################################################################
vlSetPriorityHook proc pThis:dword, ppDevice:dword

    invoke vlSetPriority, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset DSetPriority, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

vlSetPriorityHook endp
; ##########################################################################
vlGetPriorityHook proc pThis:dword

    invoke vlGetPriority, pThis
    .if framedump == SET
        invoke log, 1, offset DGetPriority, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vlGetPriorityHook endp
; ##########################################################################
vlPreLoadHook proc pThis:dword

    invoke vlPreLoad, pThis
    .if framedump == SET
        invoke log, 1, offset DPreLoad, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vlPreLoadHook endp
; ##########################################################################
vlGetTypeHook proc pThis:dword

    invoke vlGetType, pThis
    .if framedump == SET
        invoke log, 1, offset DGetType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vlGetTypeHook endp
; ##########################################################################
vlLockHook proc pThis:dword, refguid:dword, pData:dword, SizeOfData:dword, Flags:dword

    invoke vlLock, pThis, refguid, pData, SizeOfData, Flags
    .if framedump == SET
        invoke log, 5, offset DLock, dword ptr [ebp+4], eax, pThis, refguid, pData, SizeOfData, Flags
    .endif
    ret

vlLockHook endp
; ##########################################################################
vlUnlockHook proc pThis:dword

    invoke vlUnlock, pThis
    .if framedump == SET
        invoke log, 1, offset DUnlock, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vlUnlockHook endp
; ##########################################################################
vlGetDescHook proc pThis:dword, ppDevice:dword

    invoke vlGetDesc, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset DGetDesc, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

vlGetDescHook endp
; ##########################################################################
vdQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke vdQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset XQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

vdQueryInterfaceHook endp
; ##########################################################################
vdAddRefHook proc pThis:dword

    invoke vdAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset XAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vdAddRefHook endp
; ##########################################################################
vdReleaseHook proc pThis:dword

    invoke vdRelease, pThis
    .if framedump == SET
        invoke log, 1, offset XRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vdReleaseHook endp
; ##########################################################################
vdGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke vdGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset XGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

vdGetDeviceHook endp
; ##########################################################################
vdGetDeclarationHook proc pThis:dword, pElement:dword, pNumElements:dword

    invoke vdGetDeclaration, pThis, pElement, pNumElements
    .if framedump == SET
        invoke log, 3, offset XGetDeclaration, dword ptr [ebp+4], eax, pThis, pElement, pNumElements
    .endif
    ret

vdGetDeclarationHook endp
; ##########################################################################
vaQueryInterfaceHook proc pThis:dword, riid:dword, ppvObj:dword

    invoke vaQueryInterface, pThis, riid, ppvObj
    .if framedump == SET
        invoke log, 3, offset BQueryInterface, dword ptr [ebp+4], eax, pThis, riid, ppvObj
    .endif
    ret

vaQueryInterfaceHook endp
; ##########################################################################
vaAddRefHook proc pThis:dword

    invoke vaAddRef, pThis
    .if framedump == SET
        invoke log, 1, offset BAddRef, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vaAddRefHook endp
; ##########################################################################
vaReleaseHook proc pThis:dword

    invoke vaRelease, pThis
    .if framedump == SET
        invoke log, 1, offset BRelease, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vaReleaseHook endp
; ##########################################################################
vaGetDeviceHook proc pThis:dword, ppDevice:dword

    invoke vaGetDevice, pThis, ppDevice
    .if framedump == SET
        invoke log, 2, offset BGetDevice, dword ptr [ebp+4], eax, pThis, ppDevice
    .endif
    ret

vaGetDeviceHook endp
; ##########################################################################
vaSetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, SizeOfData:dword, Flags:dword

    invoke vaSetPrivateData, pThis, refguid, pData, SizeOfData, Flags
    .if framedump == SET
        invoke log, 5, offset BSetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, SizeOfData, Flags
    .endif
    ret

vaSetPrivateDataHook endp
; ##########################################################################
vaGetPrivateDataHook proc pThis:dword, refguid:dword, pData:dword, pSizeOfData:dword

    invoke vaGetPrivateData, pThis, refguid, pData, pSizeOfData
    .if framedump == SET
        invoke log, 4, offset BGetPrivateData, dword ptr [ebp+4], eax, pThis, refguid, pData, pSizeOfData
    .endif
    ret

vaGetPrivateDataHook endp
; ##########################################################################
vaFreePrivateDataHook proc pThis:dword, refguid:dword

    invoke vaFreePrivateData, pThis, refguid
    .if framedump == SET
        invoke log, 2, offset BFreePrivateData, dword ptr [ebp+4], eax, pThis, refguid
    .endif
    ret

vaFreePrivateDataHook endp
; ##########################################################################
vaSetPriorityHook proc pThis:dword, PriorityNew:dword

    invoke vaSetPriority, pThis, PriorityNew
    .if framedump == SET
        invoke log, 2, offset BSetPriority, dword ptr [ebp+4], eax, pThis, PriorityNew
    .endif
    ret

vaSetPriorityHook endp
; ##########################################################################
vaGetPriorityHook proc pThis:dword

    invoke vaGetPriority, pThis
    .if framedump == SET
        invoke log, 1, offset BGetPriority, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vaGetPriorityHook endp
; ##########################################################################
vaPreLoadHook proc pThis:dword

    invoke vaPreLoad, pThis
    .if framedump == SET
        invoke log, 1, offset BPreLoad, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vaPreLoadHook endp
; ##########################################################################
vaGetTypeHook proc pThis:dword

    invoke vaGetType, pThis
    .if framedump == SET
        invoke log, 1, offset BGetType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vaGetTypeHook endp
; ##########################################################################
vaSetLODHook proc pThis:dword

    invoke vaSetLOD, pThis
    .if framedump == SET
        invoke log, 1, offset BSetLOD, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vaSetLODHook endp
; ##########################################################################
vaGetLODHook proc pThis:dword

    invoke vaGetLOD, pThis
    .if framedump == SET
        invoke log, 1, offset BGetLOD, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vaGetLODHook endp
; ##########################################################################
vaGetLevelCountHook proc pThis:dword

    invoke vaGetLevelCount, pThis
    .if framedump == SET
        invoke log, 1, offset BGetLevelCount, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vaGetLevelCountHook endp
; ##########################################################################
vaSetAutoGenFilterTypeHook proc pThis:dword, FilterType:dword

    invoke vaSetAutoGenFilterType, pThis, FilterType
    .if framedump == SET
        invoke log, 2, offset BSetAutoGenFilterType, dword ptr [ebp+4], eax, pThis, FilterType
    .endif
    ret

vaSetAutoGenFilterTypeHook endp
; ##########################################################################
vaGetAutoGenFilterTypeHook proc pThis:dword

    invoke vaGetAutoGenFilterType, pThis
    .if framedump == SET
        invoke log, 1, offset BGetAutoGenFilterType, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vaGetAutoGenFilterTypeHook endp
; ##########################################################################
vaGenerateMipSubLevelsHook proc pThis:dword

    invoke vaGenerateMipSubLevels, pThis
    .if framedump == SET
        invoke log, 1, offset BGenerateMipSubLevels, dword ptr [ebp+4], eax, pThis
    .endif
    ret

vaGenerateMipSubLevelsHook endp
; ##########################################################################
vaGetLevelDescHook proc pThis:dword, Level:dword, pDesc:dword

    invoke vaGetLevelDesc, pThis, Level, pDesc
    .if framedump == SET
        invoke log, 3, offset BGetLevelDesc, dword ptr [ebp+4], eax, pThis, Level, pDesc
    .endif
    ret

vaGetLevelDescHook endp
; ##########################################################################
vaGetVolumeLevelHook proc pThis:dword, Level:dword, ppVolumeLevel:dword

    invoke vaGetVolumeLevel, pThis, Level, ppVolumeLevel
    .if framedump == SET
        invoke log, 3, offset BGetVolumeLevel, dword ptr [ebp+4], eax, pThis, Level, ppVolumeLevel
    .endif
    ret

vaGetVolumeLevelHook endp
; ##########################################################################
vaLockBoxHook proc pThis:dword, Level:dword, pLockedVolume:dword, pBox:dword, Flags:dword

    invoke vaLockBox, pThis, Level, pLockedVolume, pBox, Flags
    .if framedump == SET
        invoke log, 5, offset BLockBox, dword ptr [ebp+4], eax, pThis, Level, pLockedVolume, pBox, Flags
    .endif
    ret

vaLockBoxHook endp
; ##########################################################################
vaUnlockBoxHook proc pThis:dword, Level:dword

    invoke vaUnlockBox, pThis, Level
    .if framedump == SET
        invoke log, 2, offset BUnlockBox, dword ptr [ebp+4], eax, pThis, Level
    .endif
    ret

vaUnlockBoxHook endp
; ##########################################################################
vaAddDirtyBoxHook proc pThis:dword, pDirtyBox:dword

    invoke vaAddDirtyBox, pThis, pDirtyBox
    .if framedump == SET
        invoke log, 2, offset BAddDirtyBox, dword ptr [ebp+4], eax, pThis, pDirtyBox
    .endif
    ret

vaAddDirtyBoxHook endp
; ##########################################################################
End LibMain