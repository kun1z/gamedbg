; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    ibQueryInterface_proto typedef proto :dword, :dword, :dword
    ibQueryInterface_proc typedef ptr ibQueryInterface_proto
    ibQueryInterfaceHook proto :dword, :dword, :dword
    ibQUERYINTERFACE EQU 000
    .data?
    ibQueryInterface ibQueryInterface_proc ?
    .code
    EQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DIndexBuffer9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    ibAddRef_proto typedef proto :dword
    ibAddRef_proc typedef ptr ibAddRef_proto
    ibAddRefHook proto :dword
    ibADDREF EQU 004
    .data?
    ibAddRef ibAddRef_proc ?
    .code
    EAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DIndexBuffer9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    ibRelease_proto typedef proto :dword
    ibRelease_proc typedef ptr ibRelease_proto
    ibReleaseHook proto :dword
    ibRELEASE EQU 008
    .data?
    ibRelease ibRelease_proc ?
    .code
    ERelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DIndexBuffer9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    ibGetDevice_proto typedef proto :dword, :dword
    ibGetDevice_proc typedef ptr ibGetDevice_proto
    ibGetDeviceHook proto :dword, :dword
    ibGETDEVICE EQU 012
    .data?
    ibGetDevice ibGetDevice_proc ?
    .code
    EGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(SetPrivateData)(THIS_ REFGUID refguid,CONST void* pData,DWORD SizeOfData,DWORD Flags) PURE;
    ibSetPrivateData_proto typedef proto :dword, :dword, :dword, :dword, :dword
    ibSetPrivateData_proc typedef ptr ibSetPrivateData_proto
    ibSetPrivateDataHook proto :dword, :dword, :dword, :dword, :dword
    ibSETPRIVATEDATA EQU 016
    .data?
    ibSetPrivateData ibSetPrivateData_proc ?
    .code
    ESetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->SetPrivateData(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetPrivateData)(THIS_ REFGUID refguid,void* pData,DWORD* pSizeOfData) PURE;
    ibGetPrivateData_proto typedef proto :dword, :dword, :dword, :dword
    ibGetPrivateData_proc typedef ptr ibGetPrivateData_proto
    ibGetPrivateDataHook proto :dword, :dword, :dword, :dword
    ibGETPRIVATEDATA EQU 020
    .data?
    ibGetPrivateData ibGetPrivateData_proc ?
    .code
    EGetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->GetPrivateData(%08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(FreePrivateData)(THIS_ REFGUID refguid) PURE;
    ibFreePrivateData_proto typedef proto :dword, :dword
    ibFreePrivateData_proc typedef ptr ibFreePrivateData_proto
    ibFreePrivateDataHook proto :dword, :dword
    ibFREEPRIVATEDATA EQU 024
    .data?
    ibFreePrivateData ibFreePrivateData_proc ?
    .code
    EFreePrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->FreePrivateData(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, SetPriority)(THIS_ DWORD PriorityNew) PURE;
    ibSetPriority_proto typedef proto :dword, :dword
    ibSetPriority_proc typedef ptr ibSetPriority_proto
    ibSetPriorityHook proto :dword, :dword
    ibSETPRIORITY EQU 028
    .data?
    ibSetPriority ibSetPriority_proc ?
    .code
    ESetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->SetPriority(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, GetPriority)(THIS) PURE;
    ibGetPriority_proto typedef proto :dword
    ibGetPriority_proc typedef ptr ibGetPriority_proto
    ibGetPriorityHook proto :dword
    ibGETPRIORITY EQU 032
    .data?
    ibGetPriority ibGetPriority_proc ?
    .code
    EGetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->GetPriority(%08X)</font><br>", 0
;STDMETHOD_(void, PreLoad)(THIS) PURE;
    ibPreLoad_proto typedef proto :dword
    ibPreLoad_proc typedef ptr ibPreLoad_proto
    ibPreLoadHook proto :dword
    ibPRELOAD EQU 036
    .data?
    ibPreLoad ibPreLoad_proc ?
    .code
    EPreLoad db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->PreLoad(%08X)</font><br>", 0
;STDMETHOD_(D3DRESOURCETYPE, GetType)(THIS) PURE;
    ibGetType_proto typedef proto :dword
    ibGetType_proc typedef ptr ibGetType_proto
    ibGetTypeHook proto :dword
    ibGETTYPE EQU 040
    .data?
    ibGetType ibGetType_proc ?
    .code
    EGetType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->GetType(%08X)</font><br>", 0
;STDMETHOD(Lock)(THIS_ UINT OffsetToLock,UINT SizeToLock,void** ppbData,DWORD Flags) PURE;
    ibLock_proto typedef proto :dword, :dword, :dword, :dword, :dword
    ibLock_proc typedef ptr ibLock_proto
    ibLockHook proto :dword, :dword, :dword, :dword, :dword
    ibLOCK EQU 044
    .data?
    ibLock ibLock_proc ?
    .code
    ELock db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->Lock(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(Unlock)(THIS) PURE;
    ibUnlock_proto typedef proto :dword
    ibUnlock_proc typedef ptr ibUnlock_proto
    ibUnlockHook proto :dword
    ibUNLOCK EQU 048
    .data?
    ibUnlock ibUnlock_proc ?
    .code
    EUnlock db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->Unlock(%08X)</font><br>", 0
;STDMETHOD(GetDesc)(THIS_ D3DINDEXBUFFER_DESC *pDesc) PURE;
    ibGetDesc_proto typedef proto :dword, :dword
    ibGetDesc_proc typedef ptr ibGetDesc_proto
    ibGetDescHook proto :dword, :dword
    ibGETDESC EQU 052
    .data?
    ibGetDesc ibGetDesc_proc ?
    .code
    EGetDesc db "<font color=0000A0>%08X: RETURNED %08X IDirect3DIndexBuffer9->GetDesc(%08X, %08X)</font><br>", 0