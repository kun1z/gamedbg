; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    vaQueryInterface_proto typedef proto :dword, :dword, :dword
    vaQueryInterface_proc typedef ptr vaQueryInterface_proto
    vaQueryInterfaceHook proto :dword, :dword, :dword
    vaQUERYINTERFACE EQU 000
    .data?
    vaQueryInterface vaQueryInterface_proc ?
    .code
    BQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVolumeTexture9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    vaAddRef_proto typedef proto :dword
    vaAddRef_proc typedef ptr vaAddRef_proto
    vaAddRefHook proto :dword
    vaADDREF EQU 004
    .data?
    vaAddRef vaAddRef_proc ?
    .code
    BAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVolumeTexture9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    vaRelease_proto typedef proto :dword
    vaRelease_proc typedef ptr vaRelease_proto
    vaReleaseHook proto :dword
    vaRELEASE EQU 008
    .data?
    vaRelease vaRelease_proc ?
    .code
    BRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVolumeTexture9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    vaGetDevice_proto typedef proto :dword, :dword
    vaGetDevice_proc typedef ptr vaGetDevice_proto
    vaGetDeviceHook proto :dword, :dword
    vaGETDEVICE EQU 012
    .data?
    vaGetDevice vaGetDevice_proc ?
    .code
    BGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(SetPrivateData)(THIS_ REFGUID refguid,CONST void* pData,DWORD SizeOfData,DWORD Flags) PURE;
    vaSetPrivateData_proto typedef proto :dword, :dword, :dword, :dword, :dword
    vaSetPrivateData_proc typedef ptr vaSetPrivateData_proto
    vaSetPrivateDataHook proto :dword, :dword, :dword, :dword, :dword
    vaSETPRIVATEDATA EQU 016
    .data?
    vaSetPrivateData vaSetPrivateData_proc ?
    .code
    BSetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->SetPrivateData(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetPrivateData)(THIS_ REFGUID refguid,void* pData,DWORD* pSizeOfData) PURE;
    vaGetPrivateData_proto typedef proto :dword, :dword, :dword, :dword
    vaGetPrivateData_proc typedef ptr vaGetPrivateData_proto
    vaGetPrivateDataHook proto :dword, :dword, :dword, :dword
    vaGETPRIVATEDATA EQU 020
    .data?
    vaGetPrivateData vaGetPrivateData_proc ?
    .code
    BGetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->GetPrivateData(%08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(FreePrivateData)(THIS_ REFGUID refguid) PURE;
    vaFreePrivateData_proto typedef proto :dword, :dword
    vaFreePrivateData_proc typedef ptr vaFreePrivateData_proto
    vaFreePrivateDataHook proto :dword, :dword
    vaFREEPRIVATEDATA EQU 024
    .data?
    vaFreePrivateData vaFreePrivateData_proc ?
    .code
    BFreePrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->FreePrivateData(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, SetPriority)(THIS_ DWORD PriorityNew) PURE;
    vaSetPriority_proto typedef proto :dword, :dword
    vaSetPriority_proc typedef ptr vaSetPriority_proto
    vaSetPriorityHook proto :dword, :dword
    vaSETPRIORITY EQU 028
    .data?
    vaSetPriority vaSetPriority_proc ?
    .code
    BSetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->SetPriority(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, GetPriority)(THIS) PURE;
    vaGetPriority_proto typedef proto :dword
    vaGetPriority_proc typedef ptr vaGetPriority_proto
    vaGetPriorityHook proto :dword
    vaGETPRIORITY EQU 032
    .data?
    vaGetPriority vaGetPriority_proc ?
    .code
    BGetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->GetPriority(%08X)</font><br>", 0
;STDMETHOD_(void, PreLoad)(THIS) PURE;
    vaPreLoad_proto typedef proto :dword
    vaPreLoad_proc typedef ptr vaPreLoad_proto
    vaPreLoadHook proto :dword
    vaPRELOAD EQU 036
    .data?
    vaPreLoad vaPreLoad_proc ?
    .code
    BPreLoad db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->PreLoad(%08X)</font><br>", 0
;STDMETHOD_(D3DRESOURCETYPE, GetType)(THIS) PURE;
    vaGetType_proto typedef proto :dword
    vaGetType_proc typedef ptr vaGetType_proto
    vaGetTypeHook proto :dword
    vaGETTYPE EQU 040
    .data?
    vaGetType vaGetType_proc ?
    .code
    BGetType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->GetType(%08X)</font><br>", 0
;STDMETHOD_(DWORD, SetLOD)(THIS_ DWORD LODNew) PURE;
    vaSetLOD_proto typedef proto :dword
    vaSetLOD_proc typedef ptr vaSetLOD_proto
    vaSetLODHook proto :dword
    vaSETLOD EQU 044
    .data?
    vaSetLOD vaSetLOD_proc ?
    .code
    BSetLOD db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->SetLOD(%08X)</font><br>", 0
;STDMETHOD_(DWORD, GetLOD)(THIS) PURE;
    vaGetLOD_proto typedef proto :dword
    vaGetLOD_proc typedef ptr vaGetLOD_proto
    vaGetLODHook proto :dword
    vaGETLOD EQU 048
    .data?
    vaGetLOD vaGetLOD_proc ?
    .code
    BGetLOD db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->GetLOD(%08X)</font><br>", 0
;STDMETHOD_(DWORD, GetLevelCount)(THIS) PURE;
    vaGetLevelCount_proto typedef proto :dword
    vaGetLevelCount_proc typedef ptr vaGetLevelCount_proto
    vaGetLevelCountHook proto :dword
    vaGETLEVELCOUNT EQU 052
    .data?
    vaGetLevelCount vaGetLevelCount_proc ?
    .code
    BGetLevelCount db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->GetLevelCount(%08X)</font><br>", 0
;STDMETHOD(SetAutoGenFilterType)(THIS_ D3DTEXTUREFILTERTYPE FilterType) PURE;
    vaSetAutoGenFilterType_proto typedef proto :dword, :dword
    vaSetAutoGenFilterType_proc typedef ptr vaSetAutoGenFilterType_proto
    vaSetAutoGenFilterTypeHook proto :dword, :dword
    vaSETAUTOGENFILTERTYPE EQU 056
    .data?
    vaSetAutoGenFilterType vaSetAutoGenFilterType_proc ?
    .code
    BSetAutoGenFilterType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->SetAutoGenFilterType(%08X, %08X)</font><br>", 0
;STDMETHOD_(D3DTEXTUREFILTERTYPE, GetAutoGenFilterType)(THIS) PURE;
    vaGetAutoGenFilterType_proto typedef proto :dword
    vaGetAutoGenFilterType_proc typedef ptr vaGetAutoGenFilterType_proto
    vaGetAutoGenFilterTypeHook proto :dword
    vaGETAUTOGENFILTERTYPE EQU 060
    .data?
    vaGetAutoGenFilterType vaGetAutoGenFilterType_proc ?
    .code
    BGetAutoGenFilterType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->GetAutoGenFilterType(%08X)</font><br>", 0
;STDMETHOD_(void, GenerateMipSubLevels)(THIS) PURE;
    vaGenerateMipSubLevels_proto typedef proto :dword
    vaGenerateMipSubLevels_proc typedef ptr vaGenerateMipSubLevels_proto
    vaGenerateMipSubLevelsHook proto :dword
    vaGENERATEMIPSUBLEVELS EQU 064
    .data?
    vaGenerateMipSubLevels vaGenerateMipSubLevels_proc ?
    .code
    BGenerateMipSubLevels db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->GenerateMipSubLevels(%08X)</font><br>", 0
;STDMETHOD(GetLevelDesc)(THIS_ UINT Level,D3DVOLUME_DESC *pDesc) PURE;
    vaGetLevelDesc_proto typedef proto :dword, :dword, :dword
    vaGetLevelDesc_proc typedef ptr vaGetLevelDesc_proto
    vaGetLevelDescHook proto :dword, :dword, :dword
    vaGETLEVELDESC EQU 068
    .data?
    vaGetLevelDesc vaGetLevelDesc_proc ?
    .code
    BGetLevelDesc db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->GetLevelDesc(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetVolumeLevel)(THIS_ UINT Level,IDirect3DVolume9** ppVolumeLevel) PURE;
    vaGetVolumeLevel_proto typedef proto :dword, :dword, :dword
    vaGetVolumeLevel_proc typedef ptr vaGetVolumeLevel_proto
    vaGetVolumeLevelHook proto :dword, :dword, :dword
    vaGETVOLUMELEVEL EQU 072
    .data?
    vaGetVolumeLevel vaGetVolumeLevel_proc ?
    .code
    BGetVolumeLevel db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->GetVolumeLevel(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD(LockBox)(THIS_ UINT Level,D3DLOCKED_BOX* pLockedVolume,CONST D3DBOX* pBox,DWORD Flags) PURE;
    vaLockBox_proto typedef proto :dword, :dword, :dword, :dword, :dword
    vaLockBox_proc typedef ptr vaLockBox_proto
    vaLockBoxHook proto :dword, :dword, :dword, :dword, :dword
    vaLOCKBOX EQU 076
    .data?
    vaLockBox vaLockBox_proc ?
    .code
    BLockBox db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->LockBox(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(UnlockBox)(THIS_ UINT Level) PURE;
    vaUnlockBox_proto typedef proto :dword, :dword
    vaUnlockBox_proc typedef ptr vaUnlockBox_proto
    vaUnlockBoxHook proto :dword, :dword
    vaUNLOCKBOX EQU 080
    .data?
    vaUnlockBox vaUnlockBox_proc ?
    .code
    BUnlockBox db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->UnlockBox(%08X, %08X)</font><br>", 0
;STDMETHOD(AddDirtyBox)(THIS_ CONST D3DBOX* pDirtyBox) PURE;
    vaAddDirtyBox_proto typedef proto :dword, :dword
    vaAddDirtyBox_proc typedef ptr vaAddDirtyBox_proto
    vaAddDirtyBoxHook proto :dword, :dword
    vaADDDIRTYBOX EQU 084
    .data?
    vaAddDirtyBox vaAddDirtyBox_proc ?
    .code
    BAddDirtyBox db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVolumeTexture9->AddDirtyBox(%08X, %08X)</font><br>", 0