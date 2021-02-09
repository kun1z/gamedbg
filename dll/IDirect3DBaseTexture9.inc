; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    btQueryInterface_proto typedef proto :dword, :dword, :dword
    btQueryInterface_proc typedef ptr btQueryInterface_proto
    btQueryInterfaceHook proto :dword, :dword, :dword
    btQUERYINTERFACE EQU 000
    .data?
    btQueryInterface btQueryInterface_proc ?
    .code
    SQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DBaseTexture9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    btAddRef_proto typedef proto :dword
    btAddRef_proc typedef ptr btAddRef_proto
    btAddRefHook proto :dword
    btADDREF EQU 004
    .data?
    btAddRef btAddRef_proc ?
    .code
    SAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DBaseTexture9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    btRelease_proto typedef proto :dword
    btRelease_proc typedef ptr btRelease_proto
    btReleaseHook proto :dword
    btRELEASE EQU 008
    .data?
    btRelease btRelease_proc ?
    .code
    SRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DBaseTexture9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    btGetDevice_proto typedef proto :dword, :dword
    btGetDevice_proc typedef ptr btGetDevice_proto
    btGetDeviceHook proto :dword, :dword
    btGETDEVICE EQU 012
    .data?
    btGetDevice btGetDevice_proc ?
    .code
    SGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(SetPrivateData)(THIS_ REFGUID refguid,CONST void* pData,DWORD SizeOfData,DWORD Flags) PURE;
    btSetPrivateData_proto typedef proto :dword, :dword, :dword, :dword, :dword
    btSetPrivateData_proc typedef ptr btSetPrivateData_proto
    btSetPrivateDataHook proto :dword, :dword, :dword, :dword, :dword
    btSETPRIVATEDATA EQU 016
    .data?
    btSetPrivateData btSetPrivateData_proc ?
    .code
    SSetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->SetPrivateData(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(GetPrivateData)(THIS_ REFGUID refguid,void* pData,DWORD* pSizeOfData) PURE;
    btGetPrivateData_proto typedef proto :dword, :dword, :dword, :dword
    btGetPrivateData_proc typedef ptr btGetPrivateData_proto
    btGetPrivateDataHook proto :dword, :dword, :dword, :dword
    btGETPRIVATEDATA EQU 020
    .data?
    btGetPrivateData btGetPrivateData_proc ?
    .code
    SGetPrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->GetPrivateData(%08X, %08X, %08X, %08X, %08X)</font><br>", 0
;STDMETHOD(FreePrivateData)(THIS_ REFGUID refguid) PURE;
    btFreePrivateData_proto typedef proto :dword, :dword
    btFreePrivateData_proc typedef ptr btFreePrivateData_proto
    btFreePrivateDataHook proto :dword, :dword
    btFREEPRIVATEDATA EQU 024
    .data?
    btFreePrivateData btFreePrivateData_proc ?
    .code
    SFreePrivateData db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->FreePrivateData(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, SetPriority)(THIS_ DWORD PriorityNew) PURE;
    btSetPriority_proto typedef proto :dword, :dword
    btSetPriority_proc typedef ptr btSetPriority_proto
    btSetPriorityHook proto :dword, :dword
    btSETPRIORITY EQU 028
    .data?
    btSetPriority btSetPriority_proc ?
    .code
    SSetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->SetPriority(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, GetPriority)(THIS) PURE;
    btGetPriority_proto typedef proto :dword
    btGetPriority_proc typedef ptr btGetPriority_proto
    btGetPriorityHook proto :dword
    btGETPRIORITY EQU 032
    .data?
    btGetPriority btGetPriority_proc ?
    .code
    SGetPriority db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->GetPriority(%08X)</font><br>", 0
;STDMETHOD_(void, PreLoad)(THIS) PURE;
    btPreLoad_proto typedef proto :dword
    btPreLoad_proc typedef ptr btPreLoad_proto
    btPreLoadHook proto :dword
    btPRELOAD EQU 036
    .data?
    btPreLoad btPreLoad_proc ?
    .code
    SPreLoad db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->PreLoad(%08X)</font><br>", 0
;STDMETHOD_(D3DRESOURCETYPE, GetType)(THIS) PURE;
    btGetType_proto typedef proto :dword
    btGetType_proc typedef ptr btGetType_proto
    btGetTypeHook proto :dword
    btGETTYPE EQU 040
    .data?
    btGetType btGetType_proc ?
    .code
    SGetType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->GetType(%08X)</font><br>", 0
;STDMETHOD_(DWORD, SetLOD)(THIS_ DWORD LODNew) PURE;
    btSetLOD_proto typedef proto :dword, :dword
    btSetLOD_proc typedef ptr btSetLOD_proto
    btSetLODHook proto :dword, :dword
    btSETLOD EQU 044
    .data?
    btSetLOD btSetLOD_proc ?
    .code
    SSetLOD db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->SetLOD(%08X, %08X)</font><br>", 0
;STDMETHOD_(DWORD, GetLOD)(THIS) PURE;
    btGetLOD_proto typedef proto :dword
    btGetLOD_proc typedef ptr btGetLOD_proto
    btGetLODHook proto :dword
    btGETLOD EQU 048
    .data?
    btGetLOD btGetLOD_proc ?
    .code
    SGetLOD db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->GetLOD(%08X)</font><br>", 0
;STDMETHOD_(DWORD, GetLevelCount)(THIS) PURE;
    btGetLevelCount_proto typedef proto :dword
    btGetLevelCount_proc typedef ptr btGetLevelCount_proto
    btGetLevelCountHook proto :dword
    btGETLEVELCOUNT EQU 052
    .data?
    btGetLevelCount btGetLevelCount_proc ?
    .code
    SGetLevelCount db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->GetLevelCount(%08X)</font><br>", 0
;STDMETHOD(SetAutoGenFilterType)(THIS_ D3DTEXTUREFILTERTYPE FilterType) PURE;
    btSetAutoGenFilterType_proto typedef proto :dword, :dword
    btSetAutoGenFilterType_proc typedef ptr btSetAutoGenFilterType_proto
    btSetAutoGenFilterTypeHook proto :dword, :dword
    btSETAUTOGENFILTERTYPE EQU 056
    .data?
    btSetAutoGenFilterType btSetAutoGenFilterType_proc ?
    .code
    SSetAutoGenFilterType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->SetAutoGenFilterType3(%08X, %08X)</font><br>", 0
;STDMETHOD_(D3DTEXTUREFILTERTYPE, GetAutoGenFilterType)(THIS) PURE;
    btGetAutoGenFilterType_proto typedef proto :dword
    btGetAutoGenFilterType_proc typedef ptr btGetAutoGenFilterType_proto
    btGetAutoGenFilterTypeHook proto :dword
    btGETAUTOGENFILTERTYPE EQU 060
    .data?
    btGetAutoGenFilterType btGetAutoGenFilterType_proc ?
    .code
    SGetAutoGenFilterType db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->GetAutoGenFilterType(%08X)</font><br>", 0
;STDMETHOD_(void, GenerateMipSubLevels)(THIS) PURE;
    btGenerateMipSubLevels_proto typedef proto :dword
    btGenerateMipSubLevels_proc typedef ptr btGenerateMipSubLevels_proto
    btGenerateMipSubLevelsHook proto :dword
    btGENERATEMIPSUBLEVELS EQU 064
    .data?
    btGenerateMipSubLevels btGenerateMipSubLevels_proc ?
    .code
    SGenerateMipSubLevels db "<font color=0000A0>%08X: RETURNED %08X IDirect3DBaseTexture9->GenerateMipSubLevels(%08X)</font><br>", 0