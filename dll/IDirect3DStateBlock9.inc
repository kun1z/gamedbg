; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    sbQueryInterface_proto typedef proto :dword, :dword, :dword
    sbQueryInterface_proc typedef ptr sbQueryInterface_proto
    sbQueryInterfaceHook proto :dword, :dword, :dword
    sbQUERYINTERFACE EQU 000
    .data?
    sbQueryInterface sbQueryInterface_proc ?
    .code
    UQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DStateBlock9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    sbAddRef_proto typedef proto :dword
    sbAddRef_proc typedef ptr sbAddRef_proto
    sbAddRefHook proto :dword
    sbADDREF EQU 004
    .data?
    sbAddRef sbAddRef_proc ?
    .code
    UAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DStateBlock9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    sbRelease_proto typedef proto :dword
    sbRelease_proc typedef ptr sbRelease_proto
    sbReleaseHook proto :dword
    sbRELEASE EQU 008
    .data?
    sbRelease sbRelease_proc ?
    .code
    URelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DStateBlock9->Release(%08X)</font><br>", 0
;STDMETHOD(GetDevice)(THIS_ IDirect3DDevice9** ppDevice) PURE;
    sbGetDevice_proto typedef proto :dword, :dword
    sbGetDevice_proc typedef ptr sbGetDevice_proto
    sbGetDeviceHook proto :dword, :dword
    sbGETDEVICE EQU 012
    .data?
    sbGetDevice sbGetDevice_proc ?
    .code
    UGetDevice db "<font color=0000A0>%08X: RETURNED %08X IDirect3DStateBlock9->GetDevice(%08X, %08X)</font><br>", 0
;STDMETHOD(Capture)(THIS) PURE;
    sbCapture_proto typedef proto :dword
    sbCapture_proc typedef ptr sbCapture_proto
    sbCaptureHook proto :dword
    sbCAPTURE EQU 016
    .data?
    sbCapture sbCapture_proc ?
    .code
    UCapture db "<font color=0000A0>%08X: RETURNED %08X IDirect3DStateBlock9->Capture(%08X)</font><br>", 0
;STDMETHOD(Apply)(THIS) PURE;
    sbApply_proto typedef proto :dword
    sbApply_proc typedef ptr sbApply_proto
    sbApplyHook proto :dword
    sbAPPLY EQU 020
    .data?
    sbApply sbApply_proc ?
    .code
    UApply db "<font color=0000A0>%08X: RETURNED %08X IDirect3DStateBlock9->Apply(%08X)</font><br>", 0