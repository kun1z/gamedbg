; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    vlQueryInterface_proto typedef proto :dword, :dword, :dword
    vlQueryInterface_proc typedef ptr vlQueryInterface_proto
    vlQueryInterfaceHook proto :dword, :dword, :dword
    vlQUERYINTERFACE EQU 000
    .data?
    vlQueryInterface vlQueryInterface_proc ?
    .code
    DQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVertexBuffer9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    vlAddRef_proto typedef proto :dword
    vlAddRef_proc typedef ptr vlAddRef_proto
    vlAddRefHook proto :dword
    vlADDREF EQU 004
    .data?
    vlAddRef vlAddRef_proc ?
    .code
    DAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVertexBuffer9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    vlRelease_proto typedef proto :dword
    vlRelease_proc typedef ptr vlRelease_proto
    vlReleaseHook proto :dword
    vlRELEASE EQU 008
    .data?
    vlRelease vlRelease_proc ?
    .code
    DRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVertexBuffer9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    vlGetDevice_proto typedef proto :dword, :dword
    vlGetDevice_proc typedef ptr vlGetDevice_proto
    vlGetDeviceHook proto :dword, :dword
    vlGETDEVICE EQU 012
    .data?
    vlGetDevice vlGetDevice_proc ?
    .code
    DGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(SetPrivateData)(THIS_ REFGUID refguid,CONST void* pData,DWORD SizeOfData,DWORD Flags) PURE;
    vlSetPrivateData_proto typedef proto :dword, :dword, :dword, :dword, :dword
    vlSetPrivateData_proc typedef ptr vlSetPrivateData_proto
    vlSetPrivateDataHook proto :dword, :dword, :dword, :dword, :dword
    vlSETPRIVATEDATA EQU 016
    .data?
    vlSetPrivateData vlSetPrivateData_proc ?
    .code
    DSetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->SetPrivateData(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetPrivateData)(THIS_ REFGUID refguid,void* pData,DWORD* pSizeOfData) PURE;
    vlGetPrivateData_proto typedef proto :dword, :dword, :dword, :dword
    vlGetPrivateData_proc typedef ptr vlGetPrivateData_proto
    vlGetPrivateDataHook proto :dword, :dword, :dword, :dword
    vlGETPRIVATEDATA EQU 020
    .data?
    vlGetPrivateData vlGetPrivateData_proc ?
    .code
    DGetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->GetPrivateData(%08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(FreePrivateData)(THIS_ REFGUID refguid) PURE;
    vlFreePrivateData_proto typedef proto :dword, :dword
    vlFreePrivateData_proc typedef ptr vlFreePrivateData_proto
    vlFreePrivateDataHook proto :dword, :dword
    vlFREEPRIVATEDATA EQU 024
    .data?
    vlFreePrivateData vlFreePrivateData_proc ?
    .code
    DFreePrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->FreePrivateData(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, SetPriority)(THIS_ DWORD PriorityNew) PURE;
    vlSetPriority_proto typedef proto :dword, :dword
    vlSetPriority_proc typedef ptr vlSetPriority_proto
    vlSetPriorityHook proto :dword, :dword
    vlSETPRIORITY EQU 028
    .data?
    vlSetPriority vlSetPriority_proc ?
    .code
    DSetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->SetPriority(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, GetPriority)(THIS) PURE;
    vlGetPriority_proto typedef proto :dword
    vlGetPriority_proc typedef ptr vlGetPriority_proto
    vlGetPriorityHook proto :dword
    vlGETPRIORITY EQU 032
    .data?
    vlGetPriority vlGetPriority_proc ?
    .code
    DGetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->GetPriority(%08X)</font><br>", 0
;STDMETHOD_(void, PreLoad)(THIS) PURE;
    vlPreLoad_proto typedef proto :dword
    vlPreLoad_proc typedef ptr vlPreLoad_proto
    vlPreLoadHook proto :dword
    vlPRELOAD EQU 036
    .data?
    vlPreLoad vlPreLoad_proc ?
    .code
    DPreLoad db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->PreLoad(%08X)</font><br>", 0
;STDMETHOD_(D3DRESOURCETYPE, GetType)(THIS) PURE;
    vlGetType_proto typedef proto :dword
    vlGetType_proc typedef ptr vlGetType_proto
    vlGetTypeHook proto :dword
    vlGETTYPE EQU 040
    .data?
    vlGetType vlGetType_proc ?
    .code
    DGetType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->GetType(%08X)</font><br>", 0
;STDMETHOD(Lock)(THIS_ UINT OffsetToLock,UINT SizeToLock,void** ppbData,DWORD Flags) PURE;
    vlLock_proto typedef proto :dword, :dword, :dword, :dword, :dword
    vlLock_proc typedef ptr vlLock_proto
    vlLockHook proto :dword, :dword, :dword, :dword, :dword
    vlLOCK EQU 044
    .data?
    vlLock vlLock_proc ?
    .code
    DLock db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->Lock(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(Unlock)(THIS) PURE;
    vlUnlock_proto typedef proto :dword
    vlUnlock_proc typedef ptr vlUnlock_proto
    vlUnlockHook proto :dword
    vlUNLOCK EQU 048
    .data?
    vlUnlock vlUnlock_proc ?
    .code
    DUnlock db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->Unlock(%08X)</font><br>", 0
;STDMETHOD(GetDesc)(THIS_ D3DVERTEXBUFFER_DESC *pDesc) PURE;
    vlGetDesc_proto typedef proto :dword, :dword
    vlGetDesc_proc typedef ptr vlGetDesc_proto
    vlGetDescHook proto :dword, :dword
    vlGETDESC EQU 052
    .data?
    vlGetDesc vlGetDesc_proc ?
    .code
    DGetDesc db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexBuffer9->GetDesc(%08X, %08X)</font><br>", 0