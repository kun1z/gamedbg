; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    ttQueryInterface_proto typedef proto :dword, :dword, :dword
    ttQueryInterface_proc typedef ptr ttQueryInterface_proto
    ttQueryInterfaceHook proto :dword, :dword, :dword
    ttQUERYINTERFACE EQU 000
    .data?
    ttQueryInterface ttQueryInterface_proc ?
    .code
    AQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DTexture9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    ttAddRef_proto typedef proto :dword
    ttAddRef_proc typedef ptr ttAddRef_proto
    ttAddRefHook proto :dword
    ttADDREF EQU 004
    .data?
    ttAddRef ttAddRef_proc ?
    .code
    AAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DTexture9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    ttRelease_proto typedef proto :dword
    ttRelease_proc typedef ptr ttRelease_proto
    ttReleaseHook proto :dword
    ttRELEASE EQU 008
    .data?
    ttRelease ttRelease_proc ?
    .code
    ARelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DTexture9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    ttGetDevice_proto typedef proto :dword, :dword
    ttGetDevice_proc typedef ptr ttGetDevice_proto
    ttGetDeviceHook proto :dword, :dword
    ttGETDEVICE EQU 012
    .data?
    ttGetDevice ttGetDevice_proc ?
    .code
    AGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(SetPrivateData)(THIS_ REFGUID refguid,CONST void* pData,DWORD SizeOfData,DWORD Flags) PURE;
    ttSetPrivateData_proto typedef proto :dword, :dword, :dword, :dword, :dword
    ttSetPrivateData_proc typedef ptr ttSetPrivateData_proto
    ttSetPrivateDataHook proto :dword, :dword, :dword, :dword, :dword
    ttSETPRIVATEDATA EQU 016
    .data?
    ttSetPrivateData ttSetPrivateData_proc ?
    .code
    ASetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->SetPrivateData(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetPrivateData)(THIS_ REFGUID refguid,void* pData,DWORD* pSizeOfData) PURE;
    ttGetPrivateData_proto typedef proto :dword, :dword, :dword, :dword
    ttGetPrivateData_proc typedef ptr ttGetPrivateData_proto
    ttGetPrivateDataHook proto :dword, :dword, :dword, :dword
    ttGETPRIVATEDATA EQU 020
    .data?
    ttGetPrivateData ttGetPrivateData_proc ?
    .code
    AGetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->GetPrivateData(%08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(FreePrivateData)(THIS_ REFGUID refguid) PURE;
    ttFreePrivateData_proto typedef proto :dword, :dword
    ttFreePrivateData_proc typedef ptr ttFreePrivateData_proto
    ttFreePrivateDataHook proto :dword, :dword
    ttFREEPRIVATEDATA EQU 024
    .data?
    ttFreePrivateData ttFreePrivateData_proc ?
    .code
    AFreePrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->FreePrivateData(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, SetPriority)(THIS_ DWORD PriorityNew) PURE;
    ttSetPriority_proto typedef proto :dword, :dword
    ttSetPriority_proc typedef ptr ttSetPriority_proto
    ttSetPriorityHook proto :dword, :dword
    ttSETPRIORITY EQU 028
    .data?
    ttSetPriority ttSetPriority_proc ?
    .code
    ASetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->SetPriority(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, GetPriority)(THIS) PURE;
    ttGetPriority_proto typedef proto :dword
    ttGetPriority_proc typedef ptr ttGetPriority_proto
    ttGetPriorityHook proto :dword
    ttGETPRIORITY EQU 032
    .data?
    ttGetPriority ttGetPriority_proc ?
    .code
    AGetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->GetPriority(%08X)</font><br>", 0
;STDMETHOD_(void, PreLoad)(THIS) PURE;
    ttPreLoad_proto typedef proto :dword
    ttPreLoad_proc typedef ptr ttPreLoad_proto
    ttPreLoadHook proto :dword
    ttPRELOAD EQU 036
    .data?
    ttPreLoad ttPreLoad_proc ?
    .code
    APreLoad db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->PreLoad(%08X)</font><br>", 0
;STDMETHOD_(D3DRESOURCETYPE, GetType)(THIS) PURE;
    ttGetType_proto typedef proto :dword
    ttGetType_proc typedef ptr ttGetType_proto
    ttGetTypeHook proto :dword
    ttGETTYPE EQU 040
    .data?
    ttGetType ttGetType_proc ?
    .code
    AGetType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->GetType(%08X)</font><br>", 0
;STDMETHOD_(DWORD, SetLOD)(THIS_ DWORD LODNew) PURE;
    ttSetLOD_proto typedef proto :dword, :dword
    ttSetLOD_proc typedef ptr ttSetLOD_proto
    ttSetLODHook proto :dword, :dword
    ttSETLOD EQU 044
    .data?
    ttSetLOD ttSetLOD_proc ?
    .code
    ASetLOD db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->SetLOD(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, GetLOD)(THIS) PURE;
    ttGetLOD_proto typedef proto :dword
    ttGetLOD_proc typedef ptr ttGetLOD_proto
    ttGetLODHook proto :dword
    ttGETLOD EQU 048
    .data?
    ttGetLOD ttGetLOD_proc ?
    .code
    AGetLOD db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->GetLOD(%08X)</font><br>", 0
;STDMETHOD_(DWORD, GetLevelCount)(THIS) PURE;
    ttGetLevelCount_proto typedef proto :dword
    ttGetLevelCount_proc typedef ptr ttGetLevelCount_proto
    ttGetLevelCountHook proto :dword
    ttGETLEVELCOUNT EQU 052
    .data?
    ttGetLevelCount ttGetLevelCount_proc ?
    .code
    AGetLevelCount db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->GetLevelCount(%08X)</font><br>", 0
;STDMETHOD(SetAutoGenFilterType)(THIS_ D3DTEXTUREFILTERTYPE FilterType) PURE;
    ttSetAutoGenFilterType_proto typedef proto :dword, :dword
    ttSetAutoGenFilterType_proc typedef ptr ttSetAutoGenFilterType_proto
    ttSetAutoGenFilterTypeHook proto :dword, :dword
    ttSETAUTOGENFILTERTYPE EQU 056
    .data?
    ttSetAutoGenFilterType ttSetAutoGenFilterType_proc ?
    .code
    ASetAutoGenFilterType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->SetAutoGenFilterType(%08X, %08X)</font><br>", 0
;STDMETHOD_(D3DTEXTUREFILTERTYPE, GetAutoGenFilterType)(THIS) PURE;
    ttGetAutoGenFilterType_proto typedef proto :dword
    ttGetAutoGenFilterType_proc typedef ptr ttGetAutoGenFilterType_proto
    ttGetAutoGenFilterTypeHook proto :dword
    ttGETAUTOGENFILTERTYPE EQU 060
    .data?
    ttGetAutoGenFilterType ttGetAutoGenFilterType_proc ?
    .code
    AGetAutoGenFilterType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->GetAutoGenFilterType(%08X)</font><br>", 0
;STDMETHOD_(void, GenerateMipSubLevels)(THIS) PURE;
    ttGenerateMipSubLevels_proto typedef proto :dword
    ttGenerateMipSubLevels_proc typedef ptr ttGenerateMipSubLevels_proto
    ttGenerateMipSubLevelsHook proto :dword
    ttGENERATEMIPSUBLEVELS EQU 064
    .data?
    ttGenerateMipSubLevels ttGenerateMipSubLevels_proc ?
    .code
    AGenerateMipSubLevels db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->GenerateMipSubLevels(%08X)</font><br>", 0
;STDMETHOD(GetLevelDesc)(THIS_ UINT Level,D3DSURFACE_DESC *pDesc) PURE;
    ttGetLevelDesc_proto typedef proto :dword, :dword, :dword
    ttGetLevelDesc_proc typedef ptr ttGetLevelDesc_proto
    ttGetLevelDescHook proto :dword, :dword, :dword
    ttGETLEVELDESC EQU 068
    .data?
    ttGetLevelDesc ttGetLevelDesc_proc ?
    .code
    AGetLevelDesc db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->GetLevelDesc(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetSurfaceLevel)(THIS_ UINT Level,IDirect3DSurface9** ppSurfaceLevel) PURE;
    ttGetSurfaceLevel_proto typedef proto :dword, :dword, :dword
    ttGetSurfaceLevel_proc typedef ptr ttGetSurfaceLevel_proto
    ttGetSurfaceLevelHook proto :dword, :dword, :dword
    ttGETSURFACELEVEL EQU 072
    .data?
    ttGetSurfaceLevel ttGetSurfaceLevel_proc ?
    .code
    AGetSurfaceLevel db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->GetSurfaceLevel(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD(LockRect)(THIS_ UINT Level,D3DLOCKED_RECT* pLockedRect,CONST RECT* pRect,DWORD Flags) PURE;
    ttLockRect_proto typedef proto :dword, :dword, :dword, :dword, :dword
    ttLockRect_proc typedef ptr ttLockRect_proto
    ttLockRectHook proto :dword, :dword, :dword, :dword, :dword
    ttLOCKRECT EQU 076
    .data?
    ttLockRect ttLockRect_proc ?
    .code
    ALockRect db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->LockRect(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(UnlockRect)(THIS_ UINT Level) PURE;
    ttUnlockRect_proto typedef proto :dword, :dword
    ttUnlockRect_proc typedef ptr ttUnlockRect_proto
    ttUnlockRectHook proto :dword, :dword
    ttUNLOCKRECT EQU 080
    .data?
    ttUnlockRect ttUnlockRect_proc ?
    .code
    AUnlockRect db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->UnlockRect(%08X, %08X)</font><br>", 0
;STDMETHOD(AddDirtyRect)(THIS_ CONST RECT* pDirtyRect) PURE;
    ttAddDirtyRect_proto typedef proto :dword, :dword
    ttAddDirtyRect_proc typedef ptr ttAddDirtyRect_proto
    ttAddDirtyRectHook proto :dword, :dword
    ttADDDIRTYRECT EQU 084
    .data?
    ttAddDirtyRect ttAddDirtyRect_proc ?
    .code
    AAddDirtyRect db "<font color=0000A0>%08X: RETURNED %08X IDirect3DTexture9->AddDirtyRect(%08X, %08X)</font><br>", 0