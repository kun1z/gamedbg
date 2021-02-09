; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    vsQueryInterface_proto typedef proto :dword, :dword, :dword
    vsQueryInterface_proc typedef ptr vsQueryInterface_proto
    vsQueryInterfaceHook proto :dword, :dword, :dword
    vsQUERYINTERFACE EQU 000
    .data?
    vsQueryInterface vsQueryInterface_proc ?
    .code
    TQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVertexShader9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    vsAddRef_proto typedef proto :dword
    vsAddRef_proc typedef ptr vsAddRef_proto
    vsAddRefHook proto :dword
    vsADDREF EQU 004
    .data?
    vsAddRef vsAddRef_proc ?
    .code
    TAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVertexShader9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    vsRelease_proto typedef proto :dword
    vsRelease_proc typedef ptr vsRelease_proto
    vsReleaseHook proto :dword
    vsRELEASE EQU 008
    .data?
    vsRelease vsRelease_proc ?
    .code
    TRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVertexShader9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    vsGetDevice_proto typedef proto :dword, :dword
    vsGetDevice_proc typedef ptr vsGetDevice_proto
    vsGetDeviceHook proto :dword, :dword
    vsGETDEVICE EQU 012
    .data?
    vsGetDevice vsGetDevice_proc ?
    .code
    TGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexShader9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(GetFunction)(THIS_ void*,UINT* pSizeOfData) PURE;
    vsGetFunction_proto typedef proto :dword, :dword, :dword
    vsGetFunction_proc typedef ptr vsGetFunction_proto
    vsGetFunctionHook proto :dword, :dword, :dword
    vsGETFUNCTION EQU 016
    .data?
    vsGetFunction vsGetFunction_proc ?
    .code
    TGetFunction db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexShader9->GetFunction(%08X, %08X, %08X)</font><br>", 0