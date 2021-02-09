; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    scQueryInterface_proto typedef proto :dword, :dword, :dword
    scQueryInterface_proc typedef ptr scQueryInterface_proto
    scQueryInterfaceHook proto :dword, :dword, :dword
    scQUERYINTERFACE EQU 000
    .data?
    scQueryInterface scQueryInterface_proc ?
    .code
    VQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DSwapChain9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    scAddRef_proto typedef proto :dword
    scAddRef_proc typedef ptr scAddRef_proto
    scAddRefHook proto :dword
    scADDREF EQU 004
    .data?
    scAddRef scAddRef_proc ?
    .code
    VAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DSwapChain9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    scRelease_proto typedef proto :dword
    scRelease_proc typedef ptr scRelease_proto
    scReleaseHook proto :dword
    scRELEASE EQU 008
    .data?
    scRelease scRelease_proc ?
    .code
    VRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DSwapChain9->Release(%08X)</font><br>", 0
;STDMETHOD(Present)(THIS_ CONST RECT* pSourceRect,CONST RECT* pDestRect,HWND hDestWindowOverride,CONST RGNDATA* pDirtyRegion,DWORD dwFlags) PURE;
    scPresent_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword
    scPresent_proc typedef ptr scPresent_proto
    scPresentHook proto :dword, :dword, :dword, :dword, :dword, :dword
    scPRESENT EQU 012
    .data?
    scPresent scPresent_proc ?
    .code
    VPresent db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSwapChain9->Present(%08X, %08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetFrontBufferData)(THIS_ IDirect3DSurface9* pDestSurface) PURE;
    scGetFrontBufferData_proto typedef proto :dword, :dword
    scGetFrontBufferData_proc typedef ptr scGetFrontBufferData_proto
    scGetFrontBufferDataHook proto :dword, :dword
    scGETFRONTBUFFERDATA EQU 016
    .data?
    scGetFrontBufferData scGetFrontBufferData_proc ?
    .code
    VGetFrontBufferData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSwapChain9->GetFrontBufferData(%08X, %08X)</font><br>", 0
;STDMETHOD(GetBackBuffer)(THIS_ UINT iBackBuffer,D3DBACKBUFFER_TYPE Type,IDirect3DSurface9** ppBackBuffer) PURE;
    scGetBackBuffer_proto typedef proto :dword, :dword, :dword, :dword
    scGetBackBuffer_proc typedef ptr scGetBackBuffer_proto
    scGetBackBufferHook proto :dword, :dword, :dword, :dword
    scGETBACKBUFFER EQU 020
    .data?
    scGetBackBuffer scGetBackBuffer_proc ?
    .code
    VGetBackBuffer db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSwapChain9->GetBackBuffer(%08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetRasterStatus)(THIS_ D3DRASTER_STATUS* pRasterStatus) PURE;
    scGetRasterStatus_proto typedef proto :dword, :dword
    scGetRasterStatus_proc typedef ptr scGetRasterStatus_proto
    scGetRasterStatusHook proto :dword, :dword
    scGETRASTERSTATUS EQU 024
    .data?
    scGetRasterStatus scGetRasterStatus_proc ?
    .code
    VGetRasterStatus db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSwapChain9->GetRasterStatus(%08X, %08X)</font><br>", 0
;STDMETHOD(GetDisplayMode)(THIS_ D3DDISPLAYMODE* pMode) PURE;
    scGetDisplayMode_proto typedef proto :dword, :dword
    scGetDisplayMode_proc typedef ptr scGetDisplayMode_proto
    scGetDisplayModeHook proto :dword, :dword
    scGETDISPLAYMODE EQU 028
    .data?
    scGetDisplayMode scGetDisplayMode_proc ?
    .code
    VGetDisplayMode db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSwapChain9->GetDisplayMode(%08X, %08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    scGetDevice_proto typedef proto :dword, :dword
    scGetDevice_proc typedef ptr scGetDevice_proto
    scGetDeviceHook proto :dword, :dword
    scGETDEVICE EQU 032
    .data?
    scGetDevice scGetDevice_proc ?
    .code
    VGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSwapChain9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(GetPresentParameters)(THIS_ D3DPRESENT_PARAMETERS* pPresentationParameters) PURE;
    scGetPresentParameters_proto typedef proto :dword, :dword
    scGetPresentParameters_proc typedef ptr scGetPresentParameters_proto
    scGetPresentParametersHook proto :dword, :dword
    scGETPRESENTPARAMETERS EQU 036
    .data?
    scGetPresentParameters scGetPresentParameters_proc ?
    .code
    VGetPresentParameters db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSwapChain9->GetPresentParameters(%08X, %08X)</font><br>", 0