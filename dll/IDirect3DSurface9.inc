; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    seQueryInterface_proto typedef proto :dword, :dword, :dword
    seQueryInterface_proc typedef ptr seQueryInterface_proto
    seQueryInterfaceHook proto :dword, :dword, :dword
    seQUERYINTERFACE EQU 000
    .data?
    seQueryInterface seQueryInterface_proc ?
    .code
    FQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DSurface9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    seAddRef_proto typedef proto :dword
    seAddRef_proc typedef ptr seAddRef_proto
    seAddRefHook proto :dword
    seADDREF EQU 004
    .data?
    seAddRef seAddRef_proc ?
    .code
    FAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DSurface9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    seRelease_proto typedef proto :dword
    seRelease_proc typedef ptr seRelease_proto
    seReleaseHook proto :dword
    seRELEASE EQU 008
    .data?
    seRelease seRelease_proc ?
    .code
    FRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DSurface9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    seGetDevice_proto typedef proto :dword, :dword
    seGetDevice_proc typedef ptr seGetDevice_proto
    seGetDeviceHook proto :dword, :dword
    seGETDEVICE EQU 012
    .data?
    seGetDevice seGetDevice_proc ?
    .code
    FGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(SetPrivateData)(THIS_ REFGUID refguid,CONST void* pData,DWORD SizeOfData,DWORD Flags) PURE;
    seSetPrivateData_proto typedef proto :dword, :dword, :dword, :dword, :dword
    seSetPrivateData_proc typedef ptr seSetPrivateData_proto
    seSetPrivateDataHook proto :dword, :dword, :dword, :dword, :dword
    seSETPRIVATEDATA EQU 016
    .data?
    seSetPrivateData seSetPrivateData_proc ?
    .code
    FSetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->SetPrivateData(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetPrivateData)(THIS_ REFGUID refguid,void* pData,DWORD* pSizeOfData) PURE;
    seGetPrivateData_proto typedef proto :dword, :dword, :dword, :dword
    seGetPrivateData_proc typedef ptr seGetPrivateData_proto
    seGetPrivateDataHook proto :dword, :dword, :dword, :dword
    seGETPRIVATEDATA EQU 020
    .data?
    seGetPrivateData seGetPrivateData_proc ?
    .code
    FGetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->GetPrivateData(%08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(FreePrivateData)(THIS_ REFGUID refguid) PURE;
    seFreePrivateData_proto typedef proto :dword, :dword
    seFreePrivateData_proc typedef ptr seFreePrivateData_proto
    seFreePrivateDataHook proto :dword, :dword
    seFREEPRIVATEDATA EQU 024
    .data?
    seFreePrivateData seFreePrivateData_proc ?
    .code
    FFreePrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->FreePrivateData(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, SetPriority)(THIS_ DWORD PriorityNew) PURE;
    seSetPriority_proto typedef proto :dword, :dword
    seSetPriority_proc typedef ptr seSetPriority_proto
    seSetPriorityHook proto :dword, :dword
    seSETPRIORITY EQU 028
    .data?
    seSetPriority seSetPriority_proc ?
    .code
    FSetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->SetPriority(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, GetPriority)(THIS) PURE;
    seGetPriority_proto typedef proto :dword
    seGetPriority_proc typedef ptr seGetPriority_proto
    seGetPriorityHook proto :dword
    seGETPRIORITY EQU 032
    .data?
    seGetPriority seGetPriority_proc ?
    .code
    FGetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->GetPriority(%08X)</font><br>", 0
;STDMETHOD_(void, PreLoad)(THIS) PURE;
    sePreLoad_proto typedef proto :dword
    sePreLoad_proc typedef ptr sePreLoad_proto
    sePreLoadHook proto :dword
    sePRELOAD EQU 036
    .data?
    sePreLoad sePreLoad_proc ?
    .code
    FPreLoad db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->PreLoad(%08X)</font><br>", 0
;STDMETHOD_(D3DRESOURCETYPE, GetType)(THIS) PURE;
    seGetType_proto typedef proto :dword
    seGetType_proc typedef ptr seGetType_proto
    seGetTypeHook proto :dword
    seGETTYPE EQU 040
    .data?
    seGetType seGetType_proc ?
    .code
    FGetType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->GetType(%08X)</font><br>", 0
;STDMETHOD(GetContainer)(THIS_ REFIID riid,void** ppContainer) PURE;
    seGetContainer_proto typedef proto :dword, :dword, :dword
    seGetContainer_proc typedef ptr seGetContainer_proto
    seGetContainerHook proto :dword, :dword, :dword
    seGETCONTAINER EQU 044
    .data?
    seGetContainer seGetContainer_proc ?
    .code
    FGetContainer db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->GetContainer(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetDesc)(THIS_ D3DSURFACE_DESC *pDesc) PURE;
    seGetDesc_proto typedef proto :dword, :dword
    seGetDesc_proc typedef ptr seGetDesc_proto
    seGetDescHook proto :dword, :dword
    seGETDESC EQU 048
    .data?
    seGetDesc seGetDesc_proc ?
    .code
    FGetDesc db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->GetDesc(%08X, %08X)</font><br>", 0
;STDMETHOD(LockRect)(THIS_ D3DLOCKED_RECT* pLockedRect,CONST RECT* pRect,DWORD Flags) PURE;
    seLockRect_proto typedef proto :dword, :dword, :dword, :dword
    seLockRect_proc typedef ptr seLockRect_proto
    seLockRectHook proto :dword, :dword, :dword, :dword
    seLOCKRECT EQU 052
    .data?
    seLockRect seLockRect_proc ?
    .code
    FLockRect db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->LockRect(%08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(UnlockRect)(THIS) PURE;
    seUnlockRect_proto typedef proto :dword
    seUnlockRect_proc typedef ptr seUnlockRect_proto
    seUnlockRectHook proto :dword
    seUNLOCKRECT EQU 056
    .data?
    seUnlockRect seUnlockRect_proc ?
    .code
    FUnlockRect db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->UnlockRect(%08X)</font><br>", 0
;STDMETHOD(GetDC)(THIS_ HDC *phdc) PURE;
    seGetDC_proto typedef proto :dword, :dword
    seGetDC_proc typedef ptr seGetDC_proto
    seGetDCHook proto :dword, :dword
    seGETDC EQU 060
    .data?
    seGetDC seGetDC_proc ?
    .code
    FGetDC db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->GetDC(%08X, %08X)</font><br>", 0
;STDMETHOD(ReleaseDC)(THIS_ HDC hdc) PURE;
    seReleaseDC_proto typedef proto :dword, :dword
    seReleaseDC_proc typedef ptr seReleaseDC_proto
    seReleaseDCHook proto :dword, :dword
    seRELEASEDC EQU 064
    .data?
    seReleaseDC seReleaseDC_proc ?
    .code
    FReleaseDC db "<font color=0000A0>%08X: RETURNED %08X IDirect3DSurface9->ReleaseDC(%08X, %08X)</font><br>", 0