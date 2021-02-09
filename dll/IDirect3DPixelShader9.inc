; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    psQueryInterface_proto typedef proto :dword, :dword, :dword
    psQueryInterface_proc typedef ptr psQueryInterface_proto
    psQueryInterfaceHook proto :dword, :dword, :dword
    psQUERYINTERFACE EQU 000
    .data?
    psQueryInterface psQueryInterface_proc ?
    .code
    ZQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DPixelShader9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    psAddRef_proto typedef proto :dword
    psAddRef_proc typedef ptr psAddRef_proto
    psAddRefHook proto :dword
    psADDREF EQU 004
    .data?
    psAddRef psAddRef_proc ?
    .code
    ZAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DPixelShader9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    psRelease_proto typedef proto :dword
    psRelease_proc typedef ptr psRelease_proto
    psReleaseHook proto :dword
    psRELEASE EQU 008
    .data?
    psRelease psRelease_proc ?
    .code
    ZRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DPixelShader9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    psGetDevice_proto typedef proto :dword, :dword
    psGetDevice_proc typedef ptr psGetDevice_proto
    psGetDeviceHook proto :dword, :dword
    psGETDEVICE EQU 012
    .data?
    psGetDevice psGetDevice_proc ?
    .code
    ZGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DPixelShader9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(GetFunction)(THIS_ void*,UINT* pSizeOfData) PURE;
    psGetFunction_proto typedef proto :dword, :dword, :dword
    psGetFunction_proc typedef ptr psGetFunction_proto
    psGetFunctionHook proto :dword, :dword, :dword
    psGETFUNCTION EQU 016
    .data?
    psGetFunction psGetFunction_proc ?
    .code
    ZGetFunction db "<font color=0000A0>%08X: RETURNED %08X IDirect3DPixelShader9->GetFunction(%08X, %08X, %08X)</font><br>", 0