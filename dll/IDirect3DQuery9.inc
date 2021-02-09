; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    qxQueryInterface_proto typedef proto :dword, :dword, :dword
    qxQueryInterface_proc typedef ptr qxQueryInterface_proto
    qxQueryInterfaceHook proto :dword, :dword, :dword
    qxQUERYINTERFACE EQU 000
    .data?
    qxQueryInterface qxQueryInterface_proc ?
    .code
    HQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DQuery9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    qxAddRef_proto typedef proto :dword
    qxAddRef_proc typedef ptr qxAddRef_proto
    qxAddRefHook proto :dword
    qxADDREF EQU 004
    .data?
    qxAddRef qxAddRef_proc ?
    .code
    HAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DQuery9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    qxRelease_proto typedef proto :dword
    qxRelease_proc typedef ptr qxRelease_proto
    qxReleaseHook proto :dword
    qxRELEASE EQU 008
    .data?
    qxRelease qxRelease_proc ?
    .code
    HRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DQuery9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    qxGetDevice_proto typedef proto :dword, :dword
    qxGetDevice_proc typedef ptr qxGetDevice_proto
    qxGetDeviceHook proto :dword, :dword
    qxGETDEVICE EQU 012
    .data?
    qxGetDevice qxGetDevice_proc ?
    .code
    HGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DQuery9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD_(D3DQUERYTYPE, GetType)(THIS) PURE;
    qxGetType_proto typedef proto :dword
    qxGetType_proc typedef ptr qxGetType_proto
    qxGetTypeHook proto :dword
    qxGETTYPE EQU 016
    .data?
    qxGetType qxGetType_proc ?
    .code
    HGetType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DQuery9->GetType(%08X)</font><br>", 0
;STDMETHOD_(DWORD, GetDataSize)(THIS) PURE;
    qxGetDataSize_proto typedef proto :dword
    qxGetDataSize_proc typedef ptr qxGetDataSize_proto
    qxGetDataSizeHook proto :dword
    qxGETDATASIZE EQU 020
    .data?
    qxGetDataSize qxGetDataSize_proc ?
    .code
    HGetDataSize db "<font color=0000A0>%08X: RETURNED %08X IDirect3DQuery9->GetDataSize(%08X)</font><br>", 0
;STDMETHOD(Issue)(THIS_ DWORD dwIssueFlags) PURE;
    qxIssue_proto typedef proto :dword, :dword
    qxIssue_proc typedef ptr qxIssue_proto
    qxIssueHook proto :dword, :dword
    qxISSUE EQU 024
    .data?
    qxIssue qxIssue_proc ?
    .code
    HIssue db "<font color=0000A0>%08X: RETURNED %08X IDirect3DQuery9->Issue(%08X, %08X)</font><br>", 0
;STDMETHOD(GetData)(THIS_ void* pData,DWORD dwSize,DWORD dwGetDataFlags) PURE;
    qxGetData_proto typedef proto :dword, :dword, :dword, :dword
    qxGetData_proc typedef ptr qxGetData_proto
    qxGetDataHook proto :dword, :dword, :dword, :dword
    qxGETDATA EQU 028
    .data?
    qxGetData qxGetData_proc ?
    .code
    HGetData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DQuery9->GetData(%08X, %08X, %08X, %08X)</font><br>", 0