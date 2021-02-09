; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    cxQueryInterface_proto typedef proto :dword, :dword, :dword
    cxQueryInterface_proc typedef ptr cxQueryInterface_proto
    cxQueryInterfaceHook proto :dword, :dword, :dword
    cxQUERYINTERFACE EQU 000
    .data?
    cxQueryInterface cxQueryInterface_proc ?
    .code
    CQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DCubeTexture9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    cxAddRef_proto typedef proto :dword
    cxAddRef_proc typedef ptr cxAddRef_proto
    cxAddRefHook proto :dword
    cxADDREF EQU 004
    .data?
    cxAddRef cxAddRef_proc ?
    .code
    CAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DCubeTexture9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    cxRelease_proto typedef proto :dword
    cxRelease_proc typedef ptr cxRelease_proto
    cxReleaseHook proto :dword
    cxRELEASE EQU 008
    .data?
    cxRelease cxRelease_proc ?
    .code
    CRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DCubeTexture9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    cxGetDevice_proto typedef proto :dword, :dword
    cxGetDevice_proc typedef ptr cxGetDevice_proto
    cxGetDeviceHook proto :dword, :dword
    cxGETDEVICE EQU 012
    .data?
    cxGetDevice cxGetDevice_proc ?
    .code
    CGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(SetPrivateData)(THIS_ REFGUID refguid,CONST void* pData,DWORD SizeOfData,DWORD Flags) PURE;
    cxSetPrivateData_proto typedef proto :dword, :dword, :dword, :dword, :dword
    cxSetPrivateData_proc typedef ptr cxSetPrivateData_proto
    cxSetPrivateDataHook proto :dword, :dword, :dword, :dword, :dword
    cxSETPRIVATEDATA EQU 016
    .data?
    cxSetPrivateData cxSetPrivateData_proc ?
    .code
    CSetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->SetPrivateData(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetPrivateData)(THIS_ REFGUID refguid,void* pData,DWORD* pSizeOfData) PURE;
    cxGetPrivateData_proto typedef proto :dword, :dword, :dword, :dword
    cxGetPrivateData_proc typedef ptr cxGetPrivateData_proto
    cxGetPrivateDataHook proto :dword, :dword, :dword, :dword
    cxGETPRIVATEDATA EQU 020
    .data?
    cxGetPrivateData cxGetPrivateData_proc ?
    .code
    CGetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->GetPrivateData(%08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(FreePrivateData)(THIS_ REFGUID refguid) PURE;
    cxFreePrivateData_proto typedef proto :dword, :dword
    cxFreePrivateData_proc typedef ptr cxFreePrivateData_proto
    cxFreePrivateDataHook proto :dword, :dword
    cxFREEPRIVATEDATA EQU 024
    .data?
    cxFreePrivateData cxFreePrivateData_proc ?
    .code
    CFreePrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->FreePrivateData(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, SetPriority)(THIS_ DWORD PriorityNew) PURE;
    cxSetPriority_proto typedef proto :dword, :dword
    cxSetPriority_proc typedef ptr cxSetPriority_proto
    cxSetPriorityHook proto :dword, :dword
    cxSETPRIORITY EQU 028
    .data?
    cxSetPriority cxSetPriority_proc ?
    .code
    CSetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->SetPriority(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, GetPriority)(THIS) PURE;
    cxGetPriority_proto typedef proto :dword
    cxGetPriority_proc typedef ptr cxGetPriority_proto
    cxGetPriorityHook proto :dword
    cxGETPRIORITY EQU 032
    .data?
    cxGetPriority cxGetPriority_proc ?
    .code
    CGetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->GetPriority(%08X)</font><br>", 0
;STDMETHOD_(void, PreLoad)(THIS) PURE;
    cxPreLoad_proto typedef proto :dword
    cxPreLoad_proc typedef ptr cxPreLoad_proto
    cxPreLoadHook proto :dword
    cxPRELOAD EQU 036
    .data?
    cxPreLoad cxPreLoad_proc ?
    .code
    CPreLoad db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->PreLoad(%08X)</font><br>", 0
;STDMETHOD_(D3DRESOURCETYPE, GetType)(THIS) PURE;
    cxGetType_proto typedef proto :dword
    cxGetType_proc typedef ptr cxGetType_proto
    cxGetTypeHook proto :dword
    cxGETTYPE EQU 040
    .data?
    cxGetType cxGetType_proc ?
    .code
    CGetType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->GetType(%08X)</font><br>", 0
;STDMETHOD_(DWORD, SetLOD)(THIS_ DWORD LODNew) PURE;
    cxSetLOD_proto typedef proto :dword, :dword
    cxSetLOD_proc typedef ptr cxSetLOD_proto
    cxSetLODHook proto :dword, :dword
    cxSETLOD EQU 044
    .data?
    cxSetLOD cxSetLOD_proc ?
    .code
    CSetLOD db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->SetLOD(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, GetLOD)(THIS) PURE;
    cxGetLOD_proto typedef proto :dword
    cxGetLOD_proc typedef ptr cxGetLOD_proto
    cxGetLODHook proto :dword
    cxGETLOD EQU 048
    .data?
    cxGetLOD cxGetLOD_proc ?
    .code
    CGetLOD db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->GetLOD(%08X)</font><br>", 0
;STDMETHOD_(DWORD, GetLevelCount)(THIS) PURE;
    cxGetLevelCount_proto typedef proto :dword
    cxGetLevelCount_proc typedef ptr cxGetLevelCount_proto
    cxGetLevelCountHook proto :dword
    cxGETLEVELCOUNT EQU 052
    .data?
    cxGetLevelCount cxGetLevelCount_proc ?
    .code
    CGetLevelCount db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->GetLevelCount(%08X)</font><br>", 0
;STDMETHOD(SetAutoGenFilterType)(THIS_ D3DTEXTUREFILTERTYPE FilterType) PURE;
    cxSetAutoGenFilterType_proto typedef proto :dword, :dword
    cxSetAutoGenFilterType_proc typedef ptr cxSetAutoGenFilterType_proto
    cxSetAutoGenFilterTypeHook proto :dword, :dword
    cxSETAUTOGENFILTERTYPE EQU 056
    .data?
    cxSetAutoGenFilterType cxSetAutoGenFilterType_proc ?
    .code
    CSetAutoGenFilterType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->SetAutoGenFilterType(%08X, %08X)</font><br>", 0
;STDMETHOD_(D3DTEXTUREFILTERTYPE, GetAutoGenFilterType)(THIS) PURE;
    cxGetAutoGenFilterType_proto typedef proto :dword
    cxGetAutoGenFilterType_proc typedef ptr cxGetAutoGenFilterType_proto
    cxGetAutoGenFilterTypeHook proto :dword
    cxGETAUTOGENFILTERTYPE EQU 060
    .data?
    cxGetAutoGenFilterType cxGetAutoGenFilterType_proc ?
    .code
    CGetAutoGenFilterType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->GetAutoGenFilterType(%08X)</font><br>", 0
;STDMETHOD_(void, GenerateMipSubLevels)(THIS) PURE;
    cxGenerateMipSubLevels_proto typedef proto :dword
    cxGenerateMipSubLevels_proc typedef ptr cxGenerateMipSubLevels_proto
    cxGenerateMipSubLevelsHook proto :dword
    cxGENERATEMIPSUBLEVELS EQU 064
    .data?
    cxGenerateMipSubLevels cxGenerateMipSubLevels_proc ?
    .code
    CGenerateMipSubLevels db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->GenerateMipSubLevels(%08X)</font><br>", 0
;STDMETHOD(GetLevelDesc)(THIS_ UINT Level,D3DSURFACE_DESC *pDesc) PURE;
    cxGetLevelDesc_proto typedef proto :dword, :dword, :dword
    cxGetLevelDesc_proc typedef ptr cxGetLevelDesc_proto
    cxGetLevelDescHook proto :dword, :dword, :dword
    cxGETLEVELDESC EQU 068
    .data?
    cxGetLevelDesc cxGetLevelDesc_proc ?
    .code
    CGetLevelDesc db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->GetLevelDesc(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetCubeMapSurface)(THIS_ D3DCUBEMAP_FACES FaceType,UINT Level,IDirect3DSurface9** ppCubeMapSurface) PURE;
    cxGetCubeMapSurface_proto typedef proto :dword, :dword, :dword, :dword
    cxGetCubeMapSurface_proc typedef ptr cxGetCubeMapSurface_proto
    cxGetCubeMapSurfaceHook proto :dword, :dword, :dword, :dword
    cxGETCUBEMAPSURFACE EQU 072
    .data?
    cxGetCubeMapSurface cxGetCubeMapSurface_proc ?
    .code
    CGetCubeMapSurface db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->GetCubeMapSurface(%08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(LockRect)(THIS_ D3DCUBEMAP_FACES FaceType,UINT Level,D3DLOCKED_RECT* pLockedRect,CONST RECT* pRect,DWORD Flags) PURE;
    cxLockRect_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword
    cxLockRect_proc typedef ptr cxLockRect_proto
    cxLockRectHook proto :dword, :dword, :dword, :dword, :dword, :dword
    cxLOCKRECT EQU 076
    .data?
    cxLockRect cxLockRect_proc ?
    .code
    CLockRect db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->LockRect(%08X, %08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(UnlockRect)(THIS_ D3DCUBEMAP_FACES FaceType,UINT Level) PURE;
    cxUnlockRect_proto typedef proto :dword, :dword, :dword
    cxUnlockRect_proc typedef ptr cxUnlockRect_proto
    cxUnlockRectHook proto :dword, :dword, :dword
    cxUNLOCKRECT EQU 080
    .data?
    cxUnlockRect cxUnlockRect_proc ?
    .code
    CUnlockRect db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->UnlockRect(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD(AddDirtyRect)(THIS_ D3DCUBEMAP_FACES FaceType,CONST RECT* pDirtyRect) PURE;
    cxAddDirtyRect_proto typedef proto :dword, :dword, :dword
    cxAddDirtyRect_proc typedef ptr cxAddDirtyRect_proto
    cxAddDirtyRectHook proto :dword, :dword, :dword
    cxADDDIRTYRECT EQU 084
    .data?
    cxAddDirtyRect cxAddDirtyRect_proc ?
    .code
    CAddDirtyRect db "<font color=0000A0>%08X: RETURNED %08X IDirect3DCubeTexture9->AddDirtyRect(%08X, %08X, %08X)</font><br>", 0