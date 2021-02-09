; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    vdQueryInterface_proto typedef proto :dword, :dword, :dword
    vdQueryInterface_proc typedef ptr vdQueryInterface_proto
    vdQueryInterfaceHook proto :dword, :dword, :dword
    vdQUERYINTERFACE EQU 000
    .data?
    vdQueryInterface vdQueryInterface_proc ?
    .code
    XQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVertexDeclaration9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    vdAddRef_proto typedef proto :dword
    vdAddRef_proc typedef ptr vdAddRef_proto
    vdAddRefHook proto :dword
    vdADDREF EQU 004
    .data?
    vdAddRef vdAddRef_proc ?
    .code
    XAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVertexDeclaration9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    vdRelease_proto typedef proto :dword
    vdRelease_proc typedef ptr vdRelease_proto
    vdReleaseHook proto :dword
    vdRELEASE EQU 008
    .data?
    vdRelease vdRelease_proc ?
    .code
    XRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DVertexDeclaration9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    vdGetDevice_proto typedef proto :dword, :dword
    vdGetDevice_proc typedef ptr vdGetDevice_proto
    vdGetDeviceHook proto :dword, :dword
    vdGETDEVICE EQU 012
    .data?
    vdGetDevice vdGetDevice_proc ?
    .code
    XGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexDeclaration9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(GetDeclaration)(THIS_ D3DVERTEXELEMENT9* pElement,UINT* pNumElements) PURE;
    vdGetDeclaration_proto typedef proto :dword, :dword, :dword
    vdGetDeclaration_proc typedef ptr vdGetDeclaration_proto
    vdGetDeclarationHook proto :dword, :dword, :dword
    vdGETDECLARATION EQU 016
    .data?
    vdGetDeclaration vdGetDeclaration_proc ?
    .code
    XGetDeclaration db "<font color=0000A0>%08X: RETURNED %08X IDirect3DVertexDeclaration9->GetDeclaration(%08X, %08X, %08X)</font><br>", 0