; Copyright © 2021 by Brett Kuntz. All rights reserved.

;STDMETHOD(QueryInterface)(THIS_ REFIID riid, void** ppvObj) PURE;
    QueryInterface_proto typedef proto :dword, :dword, :dword
    QueryInterface_proc typedef ptr QueryInterface_proto
    QueryInterfaceHook proto :dword, :dword, :dword
    QUERYINTERFACE EQU 000
    .data?
    QueryInterface QueryInterface_proc ?
    .code
    LQueryInterface db "<font color=A0A000>%08X: RETURNED %08X IDirect3DDevice9->QueryInterface(%08X, %08X, %08X)</font><br>", 0
;STDMETHOD_(ULONG,AddRef)(THIS) PURE;
    AddRef_proto typedef proto :dword
    AddRef_proc typedef ptr AddRef_proto
    AddRefHook proto :dword
    ADDREF EQU 004
    .data?
    AddRef AddRef_proc ?
    .code
    LAddRef db "<font color=A0A000>%08X: RETURNED %08X IDirect3DDevice9->AddRef(%08X)</font><br>", 0
;STDMETHOD_(ULONG,Release)(THIS) PURE;
    Release_proto typedef proto :dword
    Release_proc typedef ptr Release_proto
    ReleaseHook proto :dword
    RELEASE EQU 008
    .data?
    Release Release_proc ?
    .code
    LRelease db "<font color=A0A000>%08X: RETURNED %08X IDirect3DDevice9->Release(%08X)</font><br>", 0
;STDMETHOD(TestCooperativeLevel)(THIS) PURE;
    TestCooperativeLevel_proto typedef proto :dword
    TestCooperativeLevel_proc typedef ptr TestCooperativeLevel_proto
    TestCooperativeLevelHook proto :dword
    TESTCOOPERATIVELEVEL EQU 012
    .data?
    TestCooperativeLevel TestCooperativeLevel_proc ?
    .code
    LTestCooperativeLevel db "%08X: RETURNED %08X IDirect3DDevice9->TestCooperativeLevel(%08X)<br>", 0
;STDMETHOD_(UINT, GetAvailableTextureMem)(THIS) PURE;
    GetAvailableTextureMem_proto typedef proto :dword
    GetAvailableTextureMem_proc typedef ptr GetAvailableTextureMem_proto
    GetAvailableTextureMemHook proto :dword
    GETAVAILABLETEXTUREMEM EQU 016
    .data?
    GetAvailableTextureMem GetAvailableTextureMem_proc ?
    .code
    LGetAvailableTextureMem db "%08X: RETURNED %08X IDirect3DDevice9->GetAvailableTextureMem(%08X)<br>", 0
;STDMETHOD(EvictManagedResources)(THIS) PURE;
    EvictManagedResources_proto typedef proto :dword
    EvictManagedResources_proc typedef ptr EvictManagedResources_proto
    EvictManagedResourcesHook proto :dword
    EVICTMANAGEDRESOURCES EQU 020
    .data?
    EvictManagedResources EvictManagedResources_proc ?
    .code
    LEvictManagedResources db "<font color=FF0000>CRITICAL> %08X: RETURNED %08X IDirect3DDevice9->EvictManagedResources(%08X)</font><br>", 0
;STDMETHOD(GetDirect3D)(THIS_ IDirect3D9** ppD3D9) PURE;
    GetDirect3D_proto typedef proto :dword, :dword
    GetDirect3D_proc typedef ptr GetDirect3D_proto
    GetDirect3DHook proto :dword, :dword
    GETDIRECT3D EQU 024
    .data?
    GetDirect3D GetDirect3D_proc ?
    .code
    LGetDirect3D db "%08X: RETURNED %08X IDirect3DDevice9->GetDirect3D(%08X, %08X)<br>", 0
;STDMETHOD(GetDeviceCaps)(THIS_ D3DCAPS9* pCaps) PURE;
    GetDeviceCaps_proto typedef proto :dword, :dword
    GetDeviceCaps_proc typedef ptr GetDeviceCaps_proto
    GetDeviceCapsHook proto :dword, :dword
    GETDEVICECAPS EQU 028
    .data?
    GetDeviceCaps GetDeviceCaps_proc ?
    .code
    LGetDeviceCaps db "%08X: RETURNED %08X IDirect3DDevice9->GetDeviceCaps(%08X, %08X)<br>", 0
;STDMETHOD(GetDisplayMode)(THIS_ UINT iSwapChain,D3DDISPLAYMODE* pMode) PURE;
    GetDisplayMode_proto typedef proto :dword, :dword, :dword
    GetDisplayMode_proc typedef ptr GetDisplayMode_proto
    GetDisplayModeHook proto :dword, :dword, :dword
    GETDISPLAYMODE EQU 032
    .data?
    GetDisplayMode GetDisplayMode_proc ?
    .code
    LGetDisplayMode db "%08X: RETURNED %08X IDirect3DDevice9->GetDisplayMode(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetCreationParameters)(THIS_ D3DDEVICE_CREATION_PARAMETERS *pParameters) PURE;
    GetCreationParameters_proto typedef proto :dword, :dword
    GetCreationParameters_proc typedef ptr GetCreationParameters_proto
    GetCreationParametersHook proto :dword, :dword
    GETCREATIONPARAMETERS EQU 036
    .data?
    GetCreationParameters GetCreationParameters_proc ?
    .code
    LGetCreationParameters db "%08X: RETURNED %08X IDirect3DDevice9->GetCreationParameters(%08X, %08X)<br>", 0
;STDMETHOD(SetCursorProperties)(THIS_ UINT XHotSpot,UINT YHotSpot,IDirect3DSurface9* pCursorBitmap) PURE;
    SetCursorProperties_proto typedef proto :dword, :dword, :dword, :dword
    SetCursorProperties_proc typedef ptr SetCursorProperties_proto
    SetCursorPropertiesHook proto :dword, :dword, :dword, :dword
    SETCURSORPROPERTIES equ 040
    .data?
    SetCursorProperties SetCursorProperties_proc ?
    .code
    LSetCursorProperties db "%08X: RETURNED %08X IDirect3DDevice9->SetCursorProperties(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD_(void, SetCursorPosition)(THIS_ int X,int Y,DWORD Flags) PURE;
    SetCursorPosition_proto typedef proto :dword, :dword, :dword, :dword
    SetCursorPosition_proc typedef ptr SetCursorPosition_proto
    SetCursorPositionHook proto :dword, :dword, :dword, :dword
    SETCURSORPOSITION equ 044
    .data?
    SetCursorPosition SetCursorPosition_proc ?
    .code
    LSetCursorPosition db "%08X: RETURNED %08X IDirect3DDevice9->SetCursorPosition(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD_(BOOL, ShowCursor)(THIS_ BOOL bShow) PURE;
    ShowCursor_proto typedef proto :dword, :dword
    ShowCursor_proc typedef ptr ShowCursor_proto
    ShowCursorHook proto :dword, :dword
    SHOWCURSOR EQU 048
    .data?
    xShowCursor ShowCursor_proc ?
    .code
    LShowCursor db "%08X: RETURNED %08X IDirect3DDevice9->ShowCursor(%08X, %08X)<br>", 0
;STDMETHOD(CreateAdditionalSwapChain)(THIS_ D3DPRESENT_PARAMETERS* pPresentationParameters,IDirect3DSwapChain9** pSwapChain) PURE;
    CreateAdditionalSwapChain_proto typedef proto :dword, :dword, :dword
    CreateAdditionalSwapChain_proc typedef ptr CreateAdditionalSwapChain_proto
    CreateAdditionalSwapChainHook proto :dword, :dword, :dword
    CREATEADDITIONALSWAPCHAIN EQU 052
    .data?
    CreateAdditionalSwapChain CreateAdditionalSwapChain_proc ?
    .code
    LCreateAdditionalSwapChain db "%08X: RETURNED %08X IDirect3DDevice9->CreateAdditionalSwapChain(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetSwapChain)(THIS_ UINT iSwapChain,IDirect3DSwapChain9** pSwapChain) PURE;
    GetSwapChain_proto typedef proto :dword, :dword, :dword
    GetSwapChain_proc typedef ptr GetSwapChain_proto
    GetSwapChainHook proto :dword, :dword, :dword
    GETSWAPCHAIN EQU 056
    .data?
    GetSwapChain GetSwapChain_proc ?
    .code
    LGetSwapChain db "%08X: RETURNED %08X IDirect3DDevice9->GetSwapChain(%08X, %08X, %08X)<br>", 0
;STDMETHOD_(UINT, GetNumberOfSwapChains)(THIS) PURE;
    GetNumberOfSwapChains_proto typedef proto :dword
    GetNumberOfSwapChains_proc typedef ptr GetNumberOfSwapChains_proto
    GetNumberOfSwapChainsHook proto :dword
    GETNUMBEROFSWAPCHAINS EQU 060
    .data?
    GetNumberOfSwapChains GetNumberOfSwapChains_proc ?
    .code
    LGetNumberOfSwapChains db "%08X: RETURNED %08X IDirect3DDevice9->GetNumberOfSwapChains(%08X)<br>", 0
;STDMETHOD(Reset)(THIS_ D3DPRESENT_PARAMETERS* pPresentationParameters) PURE;
    Reset_proto typedef proto :dword, :dword
    Reset_proc typedef ptr Reset_proto
    ResetHook proto :dword, :dword
    RESET EQU 064
    .data?
    Reset Reset_proc ?
    .code
    LReset db "%08X: RETURNED %08X IDirect3DDevice9->Reset(%08X, %08X)<br>", 0
;STDMETHOD(Present)(THIS_ CONST RECT* pSourceRect,CONST RECT* pDestRect,HWND hDestWindowOverride,CONST RGNDATA* pDirtyRegion) PURE;
    Present_proto typedef proto :dword, :dword, :dword, :dword, :dword
    Present_proc typedef ptr Present_proto
    PresentHook proto :dword, :dword, :dword, :dword, :dword
    PRESENT equ 068
    .data?
    Present Present_proc ?
    .code
    LPresent db "<font color=00A000>INFORMAT> %08X: RETURNED %08X IDirect3DDevice9->Present(%08X, %08X, %08X, %08X, %08X)</font>", 0
;STDMETHOD(GetBackBuffer)(THIS_ UINT iSwapChain,UINT iBackBuffer,D3DBACKBUFFER_TYPE Type,IDirect3DSurface9** ppBackBuffer) PURE;
    GetBackBuffer_proto typedef proto :dword, :dword, :dword, :dword, :dword
    GetBackBuffer_proc typedef ptr GetBackBuffer_proto
    GetBackBufferHook proto :dword, :dword, :dword, :dword, :dword
    GETBACKBUFFER EQU 072
    .data?
    GetBackBuffer GetBackBuffer_proc ?
    .code
    LGetBackBuffer db "%08X: RETURNED %08X IDirect3DDevice9->GetBackBuffer(%08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(GetRasterStatus)(THIS_ UINT iSwapChain,D3DRASTER_STATUS* pRasterStatus) PURE;
    GetRasterStatus_proto typedef proto :dword, :dword, :dword
    GetRasterStatus_proc typedef ptr GetRasterStatus_proto
    GetRasterStatusHook proto :dword, :dword, :dword
    GETRASTERSTATUS EQU 076
    .data?
    GetRasterStatus GetRasterStatus_proc ?
    .code
    LGetRasterStatus db "%08X: RETURNED %08X IDirect3DDevice9->GetRasterStatus(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetDialogBoxMode)(THIS_ BOOL bEnableDialogs) PURE;
    SetDialogBoxMode_proto typedef proto :dword, :dword
    SetDialogBoxMode_proc typedef ptr SetDialogBoxMode_proto
    SetDialogBoxModeHook proto :dword, :dword
    SETDIALOGBOXMODE EQU 080
    .data?
    SetDialogBoxMode SetDialogBoxMode_proc ?
    .code
    LSetDialogBoxMode db "%08X: RETURNED %08X IDirect3DDevice9->SetDialogBoxMode(%08X, %08X)<br>", 0
;STDMETHOD_(void, SetGammaRamp)(THIS_ UINT iSwapChain,DWORD Flags,CONST D3DGAMMARAMP* pRamp) PURE;
    SetGammaRamp_proto typedef proto :dword, :dword, :dword, :dword
    SetGammaRamp_proc typedef ptr SetGammaRamp_proto
    SetGammaRampHook proto :dword, :dword, :dword, :dword
    SETGAMMARAMP EQU 084
    .data?
    SetGammaRamp SetGammaRamp_proc ?
    .code
    LSetGammaRamp db "%08X: RETURNED %08X IDirect3DDevice9->SetGammaRamp(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD_(void, GetGammaRamp)(THIS_ UINT iSwapChain,D3DGAMMARAMP* pRamp) PURE;
    GetGammaRamp_proto typedef proto :dword, :dword, :dword
    GetGammaRamp_proc typedef ptr GetGammaRamp_proto
    GetGammaRampHook proto :dword, :dword, :dword
    GETGAMMARAMP EQU 088
    .data?
    GetGammaRamp GetGammaRamp_proc ?
    .code
    LGetGammaRamp db "%08X: RETURNED %08X IDirect3DDevice9->GetGammaRamp(%08X, %08X, %08X)<br>", 0
;STDMETHOD(CreateTexture)(THIS_ UINT Width,UINT Height,UINT Levels,DWORD Usage,D3DFORMAT Format,D3DPOOL Pool,IDirect3DTexture9** ppTexture,HANDLE* pSharedHandle) PURE;
    CreateTexture_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CreateTexture_proc typedef ptr CreateTexture_proto
    CreateTextureHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CREATETEXTURE EQU 092
    .data?
    CreateTexture CreateTexture_proc ?
    .code
    LCreateTexture db "%08X: RETURNED %08X IDirect3DDevice9->CreateTexture(%08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(CreateVolumeTexture)(THIS_ UINT Width,UINT Height,UINT Depth,UINT Levels,DWORD Usage,D3DFORMAT Format,D3DPOOL Pool,IDirect3DVolumeTexture9** ppVolumeTexture,HANDLE* pSharedHandle) PURE;
    CreateVolumeTexture_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CreateVolumeTexture_proc typedef ptr CreateVolumeTexture_proto
    CreateVolumeTextureHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CREATEVOLUMETEXTURE EQU 096
    .data?
    CreateVolumeTexture CreateVolumeTexture_proc ?
    .code
    LCreateVolumeTexture db "%08X: RETURNED %08X IDirect3DDevice9->CreateVolumeTexture(%08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(CreateCubeTexture)(THIS_ UINT EdgeLength,UINT Levels,DWORD Usage,D3DFORMAT Format,D3DPOOL Pool,IDirect3DCubeTexture9** ppCubeTexture,HANDLE* pSharedHandle) PURE;
    CreateCubeTexture_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CreateCubeTexture_proc typedef ptr CreateCubeTexture_proto
    CreateCubeTextureHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CREATECUBETEXTURE EQU 100
    .data?
    CreateCubeTexture CreateCubeTexture_proc ?
    .code
    LCreateCubeTexture db "%08X: RETURNED %08X IDirect3DDevice9->CreateCubeTexture(%08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(CreateVertexBuffer)(THIS_ UINT Length,DWORD Usage,DWORD FVF,D3DPOOL Pool,IDirect3DVertexBuffer9** ppVertexBuffer,HANDLE* pSharedHandle) PURE;
    CreateVertexBuffer_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CreateVertexBuffer_proc typedef ptr CreateVertexBuffer_proto
    CreateVertexBufferHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CREATEVERTEXBUFFER EQU 104
    .data?
    CreateVertexBuffer CreateVertexBuffer_proc ?
    .code
    LCreateVertexBuffer db "%08X: RETURNED %08X IDirect3DDevice9->CreateVertexBuffer(%08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(CreateIndexBuffer)(THIS_ UINT Length,DWORD Usage,D3DFORMAT Format,D3DPOOL Pool,IDirect3DIndexBuffer9** ppIndexBuffer,HANDLE* pSharedHandle) PURE;
    CreateIndexBuffer_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CreateIndexBuffer_proc typedef ptr CreateIndexBuffer_proto
    CreateIndexBufferHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CREATEINDEXBUFFER EQU 108
    .data?
    CreateIndexBuffer CreateIndexBuffer_proc ?
    .code
    LCreateIndexBuffer db "%08X: RETURNED %08X IDirect3DDevice9->CreateIndexBuffer(%08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(CreateRenderTarget)(THIS_ UINT Width,UINT Height,D3DFORMAT Format,D3DMULTISAMPLE_TYPE MultiSample,DWORD MultisampleQuality,BOOL Lockable,IDirect3DSurface9** ppSurface,HANDLE* pSharedHandle) PURE;
    CreateRenderTarget_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CreateRenderTarget_proc typedef ptr CreateRenderTarget_proto
    CreateRenderTargetHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CREATERENDERTARGET EQU 112
    .data?
    CreateRenderTarget CreateRenderTarget_proc ?
    .code
    LCreateRenderTarget db "%08X: RETURNED %08X IDirect3DDevice9->CreateRenderTarget(%08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(CreateDepthStencilSurface)(THIS_ UINT Width,UINT Height,D3DFORMAT Format,D3DMULTISAMPLE_TYPE MultiSample,DWORD MultisampleQuality,BOOL Discard,IDirect3DSurface9** ppSurface,HANDLE* pSharedHandle) PURE;
    CreateDepthStencilSurface_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CreateDepthStencilSurface_proc typedef ptr CreateDepthStencilSurface_proto
    CreateDepthStencilSurfaceHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CREATEDEPTHSTENCILSURFACE EQU 116
    .data?
    CreateDepthStencilSurface CreateDepthStencilSurface_proc ?
    .code
    LCreateDepthStencilSurface db "%08X: RETURNED %08X IDirect3DDevice9->CreateDepthStencilSurface(%08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(UpdateSurface)(THIS_ IDirect3DSurface9* pSourceSurface,CONST RECT* pSourceRect,IDirect3DSurface9* pDestinationSurface,CONST POINT* pDestPoint) PURE;
    UpdateSurface_proto typedef proto :dword, :dword, :dword, :dword, :dword
    UpdateSurface_proc typedef ptr UpdateSurface_proto
    UpdateSurfaceHook proto :dword, :dword, :dword, :dword, :dword
    UPDATESURFACE EQU 120
    .data?
    UpdateSurface UpdateSurface_proc ?
    .code
    LUpdateSurface db "%08X: RETURNED %08X IDirect3DDevice9->UpdateSurface(%08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(UpdateTexture)(THIS_ IDirect3DBaseTexture9* pSourceTexture,IDirect3DBaseTexture9* pDestinationTexture) PURE;
    UpdateTexture_proto typedef proto :dword, :dword, :dword
    UpdateTexture_proc typedef ptr UpdateTexture_proto
    UpdateTextureHook proto :dword, :dword, :dword
    UPDATETEXTURE EQU 124
    .data?
    UpdateTexture UpdateTexture_proc ?
    .code
    LUpdateTexture db "%08X: RETURNED %08X IDirect3DDevice9->UpdateTexture(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetRenderTargetData)(THIS_ IDirect3DSurface9* pRenderTarget,IDirect3DSurface9* pDestSurface) PURE;
    GetRenderTargetData_proto typedef proto :dword, :dword, :dword
    GetRenderTargetData_proc typedef ptr GetRenderTargetData_proto
    GetRenderTargetDataHook proto :dword, :dword, :dword
    GETRENDERTARGERDATA EQU 128
    .data?
    GetRenderTargetData GetRenderTargetData_proc ?
    .code
    LGetRenderTargetData db "%08X: RETURNED %08X IDirect3DDevice9->GetRenderTargetData(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetFrontBufferData)(THIS_ UINT iSwapChain,IDirect3DSurface9* pDestSurface) PURE;
    GetFrontBufferData_proto typedef proto :dword, :dword, :dword
    GetFrontBufferData_proc typedef ptr GetFrontBufferData_proto
    GetFrontBufferDataHook proto :dword, :dword, :dword
    GETFRONTBUFFERDATA EQU 132
    .data?
    GetFrontBufferData GetFrontBufferData_proc ?
    .code
    LGetFrontBufferData db "%08X: RETURNED %08X IDirect3DDevice9->GetFrontBufferData(%08X, %08X, %08X)<br>", 0
;STDMETHOD(StretchRect)(THIS_ IDirect3DSurface9* pSourceSurface,CONST RECT* pSourceRect,IDirect3DSurface9* pDestSurface,CONST RECT* pDestRect,D3DTEXTUREFILTERTYPE Filter) PURE;
    StretchRect_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword
    StretchRect_proc typedef ptr StretchRect_proto
    StretchRectHook proto :dword, :dword, :dword, :dword, :dword, :dword
    STRETCHRECT EQU 136
    .data?
    StretchRect StretchRect_proc ?
    .code
    LStretchRect db "%08X: RETURNED %08X IDirect3DDevice9->StretchRect(%08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(ColorFill)(THIS_ IDirect3DSurface9* pSurface,CONST RECT* pRect,D3DCOLOR color) PURE;
    ColorFill_proto typedef proto :dword, :dword, :dword, :dword
    ColorFill_proc typedef ptr ColorFill_proto
    ColorFillHook proto :dword, :dword, :dword, :dword
    COLORFILL EQU 140
    .data?
    ColorFill ColorFill_proc ?
    .code
    LColorFill db "%08X: RETURNED %08X IDirect3DDevice9->ColorFill(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(CreateOffscreenPlainSurface)(THIS_ UINT Width,UINT Height,D3DFORMAT Format,D3DPOOL Pool,IDirect3DSurface9** ppSurface,HANDLE* pSharedHandle) PURE;
    CreateOffscreenPlainSurface_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CreateOffscreenPlainSurface_proc typedef ptr CreateOffscreenPlainSurface_proto
    CreateOffscreenPlainSurfaceHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CREATEOFFSCREENPLAINSURFACE EQU 144
    .data?
    CreateOffscreenPlainSurface CreateOffscreenPlainSurface_proc ?
    .code
    LCreateOffscreenPlainSurface db "%08X: RETURNED %08X IDirect3DDevice9->CreateOffscreenPlainSurface(%08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(SetRenderTarget)(THIS_ DWORD RenderTargetIndex,IDirect3DSurface9* pRenderTarget) PURE;
    SetRenderTarget_proto typedef proto :dword, :dword, :dword
    SetRenderTarget_proc typedef ptr SetRenderTarget_proto
    SetRenderTargetHook proto :dword, :dword, :dword
    SETRENDERTARGET EQU 148
    .data?
    SetRenderTarget SetRenderTarget_proc ?
    .code
    LSetRenderTarget db "%08X: RETURNED %08X IDirect3DDevice9->SetRenderTarget(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetRenderTarget)(THIS_ DWORD RenderTargetIndex,IDirect3DSurface9** ppRenderTarget) PURE;
    GetRenderTarget_proto typedef proto :dword, :dword, :dword
    GetRenderTarget_proc typedef ptr GetRenderTarget_proto
    GetRenderTargetHook proto :dword, :dword, :dword
    GETRENDERTARGET EQU 152
    .data?
    GetRenderTarget GetRenderTarget_proc ?
    .code
    LGetRenderTarget db "%08X: RETURNED %08X IDirect3DDevice9->GetRenderTarget(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetDepthStencilSurface)(THIS_ IDirect3DSurface9* pNewZStencil) PURE;
    SetDepthStencilSurface_proto typedef proto :dword, :dword
    SetDepthStencilSurface_proc typedef ptr SetDepthStencilSurface_proto
    SetDepthStencilSurfaceHook proto :dword, :dword
    SETDEPTHSTENCILSURFACE EQU 156
    .data?
    SetDepthStencilSurface SetDepthStencilSurface_proc ?
    .code
    LSetDepthStencilSurface db "%08X: RETURNED %08X IDirect3DDevice9->SetDepthStencilSurface(%08X, %08X)<br>", 0
;STDMETHOD(GetDepthStencilSurface)(THIS_ IDirect3DSurface9** ppZStencilSurface) PURE;
    GetDepthStencilSurface_proto typedef proto :dword, :dword
    GetDepthStencilSurface_proc typedef ptr GetDepthStencilSurface_proto
    GetDepthStencilSurfaceHook proto :dword, :dword
    GETDEPTHSTENCILSURFACE EQU 160
    .data?
    GetDepthStencilSurface GetDepthStencilSurface_proc ?
    .code
    LGetDepthStencilSurface db "%08X: RETURNED %08X IDirect3DDevice9->GetDepthStencilSurface(%08X, %08X)<br>", 0
;STDMETHOD(BeginScene)(THIS) PURE;
    BeginScene_proto typedef proto :dword
    BeginScene_proc typedef ptr BeginScene_proto
    BeginSceneHook proto :dword
    BEGINSCENE equ 164
    .data?
    BeginScene BeginScene_proc ?
    .code
    LBeginScene db "<font color=00A000>INFORMAT> %08X: RETURNED %08X IDirect3DDevice9->BeginScene(%08X)</font><br>", 0
;STDMETHOD(EndScene)(THIS) PURE;
    EndScene_proto typedef proto :dword
    EndScene_proc typedef ptr EndScene_proto
    EndSceneHook proto :dword
    ENDSCENE equ 168
    .data?
    EndScene EndScene_proc ?
    .code
    LEndScene db "<font color=00A000>INFORMAT> %08X: RETURNED %08X IDirect3DDevice9->EndScene(%08X)</font><br>", 0
;STDMETHOD(Clear)(THIS_ DWORD Count,CONST D3DRECT* pRects,DWORD Flags,D3DCOLOR Color,float Z,DWORD Stencil) PURE;
    Clear_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    Clear_proc typedef ptr Clear_proto
    ClearHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    CLEAR EQU 172
    .data?
    Clear Clear_proc ?
    .code
    LClear db "%08X: RETURNED %08X IDirect3DDevice9->Clear(%08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(SetTransform)(THIS_ D3DTRANSFORMSTATETYPE State,CONST D3DMATRIX* pMatrix) PURE;
    SetTransform_proto typedef proto :dword, :dword, :dword
    SetTransform_proc typedef ptr SetTransform_proto
    SetTransformHook proto :dword, :dword, :dword
    SETTRANSFORM EQU 176
    .data?
    SetTransform SetTransform_proc ?
    .code
    LSetTransform db "%08X: RETURNED %08X IDirect3DDevice9->SetTransform(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetTransform)(THIS_ D3DTRANSFORMSTATETYPE State,D3DMATRIX* pMatrix) PURE;
    GetTransform_proto typedef proto :dword, :dword, :dword
    GetTransform_proc typedef ptr GetTransform_proto
    GetTransformHook proto :dword, :dword, :dword
    GETTRANSFORM EQU 180
    .data?
    GetTransform GetTransform_proc ?
    .code
    LGetTransform db "%08X: RETURNED %08X IDirect3DDevice9->GetTransform(%08X, %08X, %08X)<br>", 0
;STDMETHOD(MultiplyTransform)(THIS_ D3DTRANSFORMSTATETYPE,CONST D3DMATRIX*) PURE;
    MultiplyTransform_proto typedef proto :dword, :dword, :dword
    MultiplyTransform_proc typedef ptr MultiplyTransform_proto
    MultiplyTransformHook proto :dword, :dword, :dword
    MULTIPLYTRANSFORM EQU 184
    .data?
    MultiplyTransform MultiplyTransform_proc ?
    .code
    LMultiplyTransform db "%08X: RETURNED %08X IDirect3DDevice9->MultiplyTransform(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetViewport)(THIS_ CONST D3DVIEWPORT9* pViewport) PURE;
    SetViewport_proto typedef proto :dword, :dword
    SetViewport_proc typedef ptr SetViewport_proto
    SetViewportHook proto :dword, :dword
    SETVIEWPORT EQU 188
    .data?
    SetViewport SetViewport_proc ?
    .code
    LSetViewport db "%08X: RETURNED %08X IDirect3DDevice9->SetViewport(%08X, %08X)<br>", 0
;STDMETHOD(GetViewport)(THIS_ D3DVIEWPORT9* pViewport) PURE;
    GetViewport_proto typedef proto :dword, :dword
    GetViewport_proc typedef ptr GetViewport_proto
    GetViewportHook proto :dword, :dword
    GETVIEWPORT EQU 192
    .data?
    GetViewport GetViewport_proc ?
    .code
    LGetViewport db "%08X: RETURNED %08X IDirect3DDevice9->GetViewport(%08X, %08X)<br>", 0
;STDMETHOD(SetMaterial)(THIS_ CONST D3DMATERIAL9* pMaterial) PURE;
    SetMaterial_proto typedef proto :dword, :dword
    SetMaterial_proc typedef ptr SetMaterial_proto
    SetMaterialHook proto :dword, :dword
    SETMATERIAL EQU 196
    .data?
    SetMaterial SetMaterial_proc ?
    .code
    LSetMaterial db "%08X: RETURNED %08X IDirect3DDevice9->SetMaterial(%08X, %08X)<br>", 0
;STDMETHOD(GetMaterial)(THIS_ D3DMATERIAL9* pMaterial) PURE;
    GetMaterial_proto typedef proto :dword, :dword
    GetMaterial_proc typedef ptr GetMaterial_proto
    GetMaterialHook proto :dword, :dword
    GETMATERIAL EQU 200
    .data?
    GetMaterial GetMaterial_proc ?
    .code
    LGetMaterial db "%08X: RETURNED %08X IDirect3DDevice9->GetMaterial(%08X, %08X)<br>", 0
;STDMETHOD(SetLight)(THIS_ DWORD Index,CONST D3DLIGHT9*) PURE;
    SetLight_proto typedef proto :dword, :dword, :dword
    SetLight_proc typedef ptr SetLight_proto
    SetLightHook proto :dword, :dword, :dword
    SETLIGHT EQU 204
    .data?
    SetLight SetLight_proc ?
    .code
    LSetLight db "%08X: RETURNED %08X IDirect3DDevice9->SetLight(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetLight)(THIS_ DWORD Index,D3DLIGHT9*) PURE;
    GetLight_proto typedef proto :dword, :dword, :dword
    GetLight_proc typedef ptr GetLight_proto
    GetLightHook proto :dword, :dword, :dword
    GETLIGHT EQU 208
    .data?
    GetLight GetLight_proc ?
    .code
    LGetLight db "%08X: RETURNED %08X IDirect3DDevice9->GetLight(%08X, %08X, %08X)<br>", 0
;STDMETHOD(LightEnable)(THIS_ DWORD Index,BOOL Enable) PURE;
    LightEnable_proto typedef proto :dword, :dword, :dword
    LightEnable_proc typedef ptr LightEnable_proto
    LightEnableHook proto :dword, :dword, :dword
    LIGHTENABLE EQU 212
    .data?
    LightEnable LightEnable_proc ?
    .code
    LLightEnable db "%08X: RETURNED %08X IDirect3DDevice9->LightEnable(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetLightEnable)(THIS_ DWORD Index,BOOL* pEnable) PURE;
    GetLightEnable_proto typedef proto :dword, :dword, :dword
    GetLightEnable_proc typedef ptr GetLightEnable_proto
    GetLightEnableHook proto :dword, :dword, :dword
    GETLIGHTENABLE EQU 216
    .data?
    GetLightEnable GetLightEnable_proc ?
    .code
    LGetLightEnable db "%08X: RETURNED %08X IDirect3DDevice9->GetLightEnable(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetClipPlane)(THIS_ DWORD Index,CONST float* pPlane) PURE;
    SetClipPlane_proto typedef proto :dword, :dword, :dword
    SetClipPlane_proc typedef ptr SetClipPlane_proto
    SetClipPlaneHook proto :dword, :dword, :dword
    SETCLIPPLANE EQU 220
    .data?
    SetClipPlane SetClipPlane_proc ?
    .code
    LSetClipPlane db "%08X: RETURNED %08X IDirect3DDevice9->SetClipPlane(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetClipPlane)(THIS_ DWORD Index,float* pPlane) PURE;
    GetClipPlane_proto typedef proto :dword, :dword, :dword
    GetClipPlane_proc typedef ptr GetClipPlane_proto
    GetClipPlaneHook proto :dword, :dword, :dword
    GETCLIPPLANE EQU 224
    .data?
    GetClipPlane GetClipPlane_proc ?
    .code
    LGetClipPlane db "%08X: RETURNED %08X IDirect3DDevice9->GetClipPlane(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetRenderState)(THIS_ D3DRENDERSTATETYPE State,DWORD Value) PURE;
    SetRenderState_proto typedef proto :dword, :dword, :dword
    SetRenderState_proc typedef ptr SetRenderState_proto
    SetRenderStateHook proto :dword, :dword, :dword
    SETRENDERSTATE EQU 228
    .data?
    SetRenderState SetRenderState_proc ?
    .code
    LSetRenderState db "%08X: RETURNED %08X IDirect3DDevice9->SetRenderState(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetRenderState)(THIS_ D3DRENDERSTATETYPE State,DWORD* pValue) PURE;
    GetRenderState_proto typedef proto :dword, :dword, :dword
    GetRenderState_proc typedef ptr GetRenderState_proto
    GetRenderStateHook proto :dword, :dword, :dword
    GETRENDERSTATE EQU 232
    .data?
    GetRenderState GetRenderState_proc ?
    .code
    LGetRenderState db "%08X: RETURNED %08X IDirect3DDevice9->GetRenderState(%08X, %08X, %08X)<br>", 0
;STDMETHOD(CreateStateBlock)(THIS_ D3DSTATEBLOCKTYPE Type,IDirect3DStateBlock9** ppSB) PURE;
    CreateStateBlock_proto typedef proto :dword, :dword, :dword
    CreateStateBlock_proc typedef ptr CreateStateBlock_proto
    CreateStateBlockHook proto :dword, :dword, :dword
    CREATESTATEBLOCK EQU 236
    .data?
    CreateStateBlock CreateStateBlock_proc ?
    .code
    LCreateStateBlock db "%08X: RETURNED %08X IDirect3DDevice9->CreateStateBlock(%08X, %08X, %08X)<br>", 0
;STDMETHOD(BeginStateBlock)(THIS) PURE;
    BeginStateBlock_proto typedef proto :dword
    BeginStateBlock_proc typedef ptr BeginStateBlock_proto
    BeginStateBlockHook proto :dword
    BEGINSTATEBLOCK EQU 240
    .data?
    BeginStateBlock BeginStateBlock_proc ?
    .code
    LBeginStateBlock db "%08X: RETURNED %08X IDirect3DDevice9->BeginStateBlock(%08X)<br>", 0
;STDMETHOD(EndStateBlock)(THIS_ IDirect3DStateBlock9** ppSB) PURE;
    EndStateBlock_proto typedef proto :dword, :dword
    EndStateBlock_proc typedef ptr EndStateBlock_proto
    EndStateBlockHook proto :dword, :dword
    ENDSTATEBLOCK EQU 244
    .data?
    EndStateBlock EndStateBlock_proc ?
    .code
    LEndStateBlock db "%08X: RETURNED %08X IDirect3DDevice9->EndStateBlock(%08X, %08X)<br>", 0
;STDMETHOD(SetClipStatus)(THIS_ CONST D3DCLIPSTATUS9* pClipStatus) PURE;
    SetClipStatus_proto typedef proto :dword, :dword
    SetClipStatus_proc typedef ptr SetClipStatus_proto
    SetClipStatusHook proto :dword, :dword
    SETCLIPSTATUS EQU 248
    .data?
    SetClipStatus SetClipStatus_proc ?
    .code
    LSetClipStatus db "%08X: RETURNED %08X IDirect3DDevice9->SetClipStatus(%08X, %08X)<br>", 0
;STDMETHOD(GetClipStatus)(THIS_ D3DCLIPSTATUS9* pClipStatus) PURE;
    GetClipStatus_proto typedef proto :dword, :dword
    GetClipStatus_proc typedef ptr GetClipStatus_proto
    GetClipStatusHook proto :dword, :dword
    GETCLIPSTATUS EQU 252
    .data?
    GetClipStatus GetClipStatus_proc ?
    .code
    LGetClipStatus db "%08X: RETURNED %08X IDirect3DDevice9->GetClipStatus(%08X, %08X)<br>", 0
;STDMETHOD(GetTexture)(THIS_ DWORD Stage,IDirect3DBaseTexture9** ppTexture) PURE;
    GetTexture_proto typedef proto :dword, :dword, :dword
    GetTexture_proc typedef ptr GetTexture_proto
    GetTextureHook proto :dword, :dword, :dword
    GETTEXTURE EQU 256
    .data?
    GetTexture GetTexture_proc ?
    .code
    LGetTexture db "%08X: RETURNED %08X IDirect3DDevice9->GetTexture(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetTexture)(THIS_ DWORD Stage,IDirect3DBaseTexture9* pTexture) PURE;
    SetTexture_proto typedef proto :dword, :dword, :dword
    SetTexture_proc typedef ptr SetTexture_proto
    SetTextureHook proto :dword, :dword, :dword
    SETTEXTURE equ 260
    .data?
    SetTexture SetTexture_proc ?
    .code
    LSetTexture db "%08X: RETURNED %08X IDirect3DDevice9->SetTexture(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetTextureStageState)(THIS_ DWORD Stage,D3DTEXTURESTAGESTATETYPE Type,DWORD* pValue) PURE;
    GetTextureStageState_proto typedef proto :dword, :dword, :dword, :dword
    GetTextureStageState_proc typedef ptr GetTextureStageState_proto
    GetTextureStageStateHook proto :dword, :dword, :dword, :dword
    GETTEXTURESTAGESTATE EQU 264
    .data?
    GetTextureStageState GetTextureStageState_proc ?
    .code
    LGetTextureStageState db "%08X: RETURNED %08X IDirect3DDevice9->GetTextureStageState(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(SetTextureStageState)(THIS_ DWORD Stage,D3DTEXTURESTAGESTATETYPE Type,DWORD Value) PURE;
    SetTextureStageState_proto typedef proto :dword, :dword, :dword, :dword
    SetTextureStageState_proc typedef ptr SetTextureStageState_proto
    SetTextureStageStateHook proto :dword, :dword, :dword, :dword
    SETTEXTURESTAGESTATE EQU 268
    .data?
    SetTextureStageState SetTextureStageState_proc ?
    .code
    LSetTextureStageState db "%08X: RETURNED %08X IDirect3DDevice9->SetTextureStageState(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(GetSamplerState)(THIS_ DWORD Sampler,D3DSAMPLERSTATETYPE Type,DWORD* pValue) PURE;
    GetSamplerState_proto typedef proto :dword, :dword, :dword, :dword
    GetSamplerState_proc typedef ptr GetSamplerState_proto
    GetSamplerStateHook proto :dword, :dword, :dword, :dword
    GETSAMPLERSTATE EQU 272
    .data?
    GetSamplerState GetSamplerState_proc ?
    .code
    LGetSamplerState db "%08X: RETURNED %08X IDirect3DDevice9->GetSamplerState(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(SetSamplerState)(THIS_ DWORD Sampler,D3DSAMPLERSTATETYPE Type,DWORD Value) PURE;
    SetSamplerState_proto typedef proto :dword, :dword, :dword, :dword
    SetSamplerState_proc typedef ptr SetSamplerState_proto
    SetSamplerStateHook proto :dword, :dword, :dword, :dword
    SETSAMPLERSTATE EQU 276
    .data?
    SetSamplerState SetSamplerState_proc ?
    .code
    LSetSamplerState db "%08X: RETURNED %08X IDirect3DDevice9->SetSamplerState(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(ValidateDevice)(THIS_ DWORD* pNumPasses) PURE;
    ValidateDevice_proto typedef proto :dword, :dword
    ValidateDevice_proc typedef ptr ValidateDevice_proto
    ValidateDeviceHook proto :dword, :dword
    VALIDATEDEVICE EQU 280
    .data?
    ValidateDevice ValidateDevice_proc ?
    .code
    LValidateDevice db "%08X: RETURNED %08X IDirect3DDevice9->ValidateDevice(%08X, %08X)<br>", 0
;STDMETHOD(SetPaletteEntries)(THIS_ UINT PaletteNumber,CONST PALETTEENTRY* pEntries) PURE;
    SetPaletteEntries_proto typedef proto :dword, :dword, :dword
    SetPaletteEntries_proc typedef ptr SetPaletteEntries_proto
    SetPaletteEntriesHook proto :dword, :dword, :dword
    SETPALETTEENTRIES EQU 284
    .data?
    SetPaletteEntries SetPaletteEntries_proc ?
    .code
    LSetPaletteEntries db "%08X: RETURNED %08X IDirect3DDevice9->SetPaletteEntries(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetPaletteEntries)(THIS_ UINT PaletteNumber,PALETTEENTRY* pEntries) PURE;
    GetPaletteEntries_proto typedef proto :dword, :dword, :dword
    GetPaletteEntries_proc typedef ptr GetPaletteEntries_proto
    GetPaletteEntriesHook proto :dword, :dword, :dword
    GETPALETTEENTRIES EQU 288
    .data?
    GetPaletteEntries GetPaletteEntries_proc ?
    .code
    LGetPaletteEntries db "%08X: RETURNED %08X IDirect3DDevice9->GetPaletteEntries(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetCurrentTexturePalette)(THIS_ UINT PaletteNumber) PURE;
    SetCurrentTexturePalette_proto typedef proto :dword, :dword
    SetCurrentTexturePalette_proc typedef ptr SetCurrentTexturePalette_proto
    SetCurrentTexturePaletteHook proto :dword, :dword
    SETCURRENTTEXTUREPALETTE EQU 292
    .data?
    SetCurrentTexturePalette SetCurrentTexturePalette_proc ?
    .code
    LSetCurrentTexturePalette db "%08X: RETURNED %08X IDirect3DDevice9->SetCurrentTexturePalette(%08X, %08X)<br>", 0
;STDMETHOD(GetCurrentTexturePalette)(THIS_ UINT *PaletteNumber) PURE;
    GetCurrentTexturePalette_proto typedef proto :dword, :dword
    GetCurrentTexturePalette_proc typedef ptr GetCurrentTexturePalette_proto
    GetCurrentTexturePaletteHook proto :dword, :dword
    GETCURRENTTEXTUREPALETTE EQU 296
    .data?
    GetCurrentTexturePalette GetCurrentTexturePalette_proc ?
    .code
    LGetCurrentTexturePalette db "%08X: RETURNED %08X IDirect3DDevice9->GetCurrentTexturePalette(%08X, %08X)<br>", 0
;STDMETHOD(SetScissorRect)(THIS_ CONST RECT* pRect) PURE;
    SetScissorRect_proto typedef proto :dword, :dword
    SetScissorRect_proc typedef ptr SetScissorRect_proto
    SetScissorRectHook proto :dword, :dword
    SETSCISSORRECT EQU 300
    .data?
    SetScissorRect SetScissorRect_proc ?
    .code
    LSetScissorRect db "%08X: RETURNED %08X IDirect3DDevice9->SetScissorRect(%08X, %08X)<br>", 0
;STDMETHOD(GetScissorRect)(THIS_ RECT* pRect) PURE;
    GetScissorRect_proto typedef proto :dword, :dword
    GetScissorRect_proc typedef ptr GetScissorRect_proto
    GetScissorRectHook proto :dword, :dword
    GETSCISSORRECT EQU 304
    .data?
    GetScissorRect GetScissorRect_proc ?
    .code
    LGetScissorRect db "%08X: RETURNED %08X IDirect3DDevice9->GetScissorRect(%08X, %08X)<br>", 0
;STDMETHOD(SetSoftwareVertexProcessing)(THIS_ BOOL bSoftware) PURE;
    SetSoftwareVertexProcessing_proto typedef proto :dword, :dword
    SetSoftwareVertexProcessing_proc typedef ptr SetSoftwareVertexProcessing_proto
    SetSoftwareVertexProcessingHook proto :dword, :dword
    SETSOFTWAREVERTEXPROCESSING EQU 308
    .data?
    SetSoftwareVertexProcessing SetSoftwareVertexProcessing_proc ?
    .code
    LSetSoftwareVertexProcessing db "%08X: RETURNED %08X IDirect3DDevice9->SetSoftwareVertexProcessing(%08X, %08X)<br>", 0
;STDMETHOD_(BOOL, GetSoftwareVertexProcessing)(THIS) PURE;
    GetSoftwareVertexProcessing_proto typedef proto :dword
    GetSoftwareVertexProcessing_proc typedef ptr GetSoftwareVertexProcessing_proto
    GetSoftwareVertexProcessingHook proto :dword
    GETSOFTWAREVERTEXPROCESSING EQU 312
    .data?
    GetSoftwareVertexProcessing GetSoftwareVertexProcessing_proc ?
    .code
    LGetSoftwareVertexProcessing db "%08X: RETURNED %08X IDirect3DDevice9->GetSoftwareVertexProcessing(%08X)<br>", 0
;STDMETHOD(SetNPatchMode)(THIS_ float nSegments) PURE;
    SetNPatchMode_proto typedef proto :dword, :dword
    SetNPatchMode_proc typedef ptr SetNPatchMode_proto
    SetNPatchModeHook proto :dword, :dword
    SETNPATCHMODE EQU 316
    .data?
    SetNPatchMode SetNPatchMode_proc ?
    .code
    LSetNPatchMode db "%08X: RETURNED %08X IDirect3DDevice9->SetNPatchMode(%08X, %08X)<br>", 0
;STDMETHOD_(float, GetNPatchMode)(THIS) PURE;
    GetNPatchMode_proto typedef proto :dword
    GetNPatchMode_proc typedef ptr GetNPatchMode_proto
    GetNPatchModeHook proto :dword
    GETNPATCHMODE EQU 320
    .data?
    GetNPatchMode GetNPatchMode_proc ?
    .code
    LGetNPatchMode db "%08X: RETURNED %08X IDirect3DDevice9->GetNPatchMode(%08X)<br>", 0
;STDMETHOD(DrawPrimitive)(THIS_ D3DPRIMITIVETYPE PrimitiveType,UINT StartVertex,UINT PrimitiveCount) PURE;
    DrawPrimitive_proto typedef proto :dword, :dword, :dword, :dword
    DrawPrimitive_proc typedef ptr DrawPrimitive_proto
    DrawPrimitiveHook proto :dword, :dword, :dword, :dword
    DRAWPRIMITIVE EQU 324
    .data?
    DrawPrimitive DrawPrimitive_proc ?
    .code
    LDrawPrimitive db "%08X: RETURNED %08X IDirect3DDevice9->DrawPrimitive(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(DrawIndexedPrimitive)(THIS_ D3DPRIMITIVETYPE,INT BaseVertexIndex,UINT MinVertexIndex,UINT NumVertices,UINT startIndex,UINT primCount) PURE;
    DrawIndexedPrimitive_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    DrawIndexedPrimitive_proc typedef ptr DrawIndexedPrimitive_proto
    DrawIndexedPrimitiveHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    DRAWINDEXEDPRIMITIVE EQU 328
    .data?
    DrawIndexedPrimitive DrawIndexedPrimitive_proc ?
    .code
    LDrawIndexedPrimitive db "%08X: RETURNED %08X IDirect3DDevice9->DrawIndexedPrimitive(%08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(DrawPrimitiveUP)(THIS_ D3DPRIMITIVETYPE PrimitiveType,UINT PrimitiveCount,CONST void* pVertexStreamZeroData,UINT VertexStreamZeroStride) PURE;
    DrawPrimitiveUP_proto typedef proto :dword, :dword, :dword, :dword, :dword
    DrawPrimitiveUP_proc typedef ptr DrawPrimitiveUP_proto
    DrawPrimitiveUPHook proto :dword, :dword, :dword, :dword, :dword
    DRAWPRIMITIVEUP EQU 332
    .data?
    DrawPrimitiveUP DrawPrimitiveUP_proc ?
    .code
    LDrawPrimitiveUP db "%08X: RETURNED %08X IDirect3DDevice9->DrawPrimitiveUP(%08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(DrawIndexedPrimitiveUP)(THIS_ D3DPRIMITIVETYPE PrimitiveType,UINT MinVertexIndex,UINT NumVertices,UINT PrimitiveCount,CONST void* pIndexData,D3DFORMAT IndexDataFormat,CONST void* pVertexStreamZeroData,UINT VertexStreamZeroStride) PURE;
    DrawIndexedPrimitiveUP_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    DrawIndexedPrimitiveUP_proc typedef ptr DrawIndexedPrimitiveUP_proto
    DrawIndexedPrimitiveUPHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword, :dword
    DRAWINDEXEDPRIMITIVEUP EQU 336
    .data?
    DrawIndexedPrimitiveUP DrawIndexedPrimitiveUP_proc ?
    .code
    LDrawIndexedPrimitiveUP db "%08X: RETURNED %08X IDirect3DDevice9->DrawPrimitiveUP(%08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(ProcessVertices)(THIS_ UINT SrcStartIndex,UINT DestIndex,UINT VertexCount,IDirect3DVertexBuffer9* pDestBuffer,IDirect3DVertexDeclaration9* pVertexDecl,DWORD Flags) PURE;
    ProcessVertices_proto typedef proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    ProcessVertices_proc typedef ptr ProcessVertices_proto
    ProcessVerticesHook proto :dword, :dword, :dword, :dword, :dword, :dword, :dword
    PROCESSVERTICES EQU 340
    .data?
    ProcessVertices ProcessVertices_proc ?
    .code
    LProcessVertices db "%08X: RETURNED %08X IDirect3DDevice9->ProcessVertices(%08X, %08X, %08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(CreateVertexDeclaration)(THIS_ CONST D3DVERTEXELEMENT9* pVertexElements,IDirect3DVertexDeclaration9** ppDecl) PURE;
    CreateVertexDeclaration_proto typedef proto :dword, :dword, :dword
    CreateVertexDeclaration_proc typedef ptr CreateVertexDeclaration_proto
    CreateVertexDeclarationHook proto :dword, :dword, :dword
    CREATEVERTEXDECLARATION EQU 344
    .data?
    CreateVertexDeclaration CreateVertexDeclaration_proc ?
    .code
    LCreateVertexDeclaration db "%08X: RETURNED %08X IDirect3DDevice9->CreateVertexDeclaration(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetVertexDeclaration)(THIS_ IDirect3DVertexDeclaration9* pDecl) PURE;
    SetVertexDeclaration_proto typedef proto :dword, :dword
    SetVertexDeclaration_proc typedef ptr SetVertexDeclaration_proto
    SetVertexDeclarationHook proto :dword, :dword
    SETVERTEXDECLARATION EQU 348
    .data?
    SetVertexDeclaration SetVertexDeclaration_proc ?
    .code
    LSetVertexDeclaration db "%08X: RETURNED %08X IDirect3DDevice9->SetVertexDeclaration(%08X, %08X)<br>", 0
;STDMETHOD(GetVertexDeclaration)(THIS_ IDirect3DVertexDeclaration9** ppDecl) PURE;
    GetVertexDeclaration_proto typedef proto :dword, :dword
    GetVertexDeclaration_proc typedef ptr GetVertexDeclaration_proto
    GetVertexDeclarationHook proto :dword, :dword
    GETVERTEXDECLARATION EQU 352
    .data?
    GetVertexDeclaration GetVertexDeclaration_proc ?
    .code
    LGetVertexDeclaration db "%08X: RETURNED %08X IDirect3DDevice9->GetVertexDeclaration(%08X, %08X)<br>", 0
;STDMETHOD(SetFVF)(THIS_ DWORD FVF) PURE;
    SetFVF_proto typedef proto :dword, :dword
    SetFVF_proc typedef ptr SetFVF_proto
    SetFVFHook proto :dword, :dword
    SETFVF EQU 356
    .data?
    SetFVF SetFVF_proc ?
    .code
    LSetFVF db "%08X: RETURNED %08X IDirect3DDevice9->SetFVF(%08X, %08X)<br>", 0
;STDMETHOD(GetFVF)(THIS_ DWORD* pFVF) PURE;
    GetFVF_proto typedef proto :dword, :dword
    GetFVF_proc typedef ptr GetFVF_proto
    GetFVFHook proto :dword, :dword
    GETFVF EQU 360
    .data?
    GetFVF GetFVF_proc ?
    .code
    LGetFVF db "%08X: RETURNED %08X IDirect3DDevice9->GetFVF(%08X, %08X)<br>", 0
;STDMETHOD(CreateVertexShader)(THIS_ CONST DWORD* pFunction,IDirect3DVertexShader9** ppShader) PURE;
    CreateVertexShader_proto typedef proto :dword, :dword, :dword
    CreateVertexShader_proc typedef ptr CreateVertexShader_proto
    CreateVertexShaderHook proto :dword, :dword, :dword
    CREATEVERTEXSHADER EQU 364
    .data?
    CreateVertexShader CreateVertexShader_proc ?
    .code
    LCreateVertexShader db "%08X: RETURNED %08X IDirect3DDevice9->CreateVertexShader(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetVertexShader)(THIS_ IDirect3DVertexShader9* pShader) PURE;
    SetVertexShader_proto typedef proto :dword, :dword
    SetVertexShader_proc typedef ptr SetVertexShader_proto
    SetVertexShaderHook proto :dword, :dword
    SETVERTEXSHADER EQU 368
    .data?
    SetVertexShader SetVertexShader_proc ?
    .code
    LSetVertexShader db "%08X: RETURNED %08X IDirect3DDevice9->SetVertexShader(%08X, %08X)<br>", 0
;STDMETHOD(GetVertexShader)(THIS_ IDirect3DVertexShader9** ppShader) PURE;
    GetVertexShader_proto typedef proto :dword, :dword
    GetVertexShader_proc typedef ptr GetVertexShader_proto
    GetVertexShaderHook proto :dword, :dword
    GETVERTEXSHADER EQU 372
    .data?
    GetVertexShader GetVertexShader_proc ?
    .code
    LGetVertexShader db "%08X: RETURNED %08X IDirect3DDevice9->GetVertexShader(%08X, %08X)<br>", 0
;STDMETHOD(SetVertexShaderConstantF)(THIS_ UINT StartRegister,CONST float* pConstantData,UINT Vector4fCount) PURE;
    SetVertexShaderConstantF_proto typedef proto :dword, :dword, :dword, :dword
    SetVertexShaderConstantF_proc typedef ptr SetVertexShaderConstantF_proto
    SetVertexShaderConstantFHook proto :dword, :dword, :dword, :dword
    SETVERTEXSHADERCONSTANTF EQU 376
    .data?
    SetVertexShaderConstantF SetVertexShaderConstantF_proc ?
    .code
    LSetVertexShaderConstantF db "%08X: RETURNED %08X IDirect3DDevice9->SetVertexShaderConstantF(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(GetVertexShaderConstantF)(THIS_ UINT StartRegister,float* pConstantData,UINT Vector4fCount) PURE;
    GetVertexShaderConstantF_proto typedef proto :dword, :dword, :dword, :dword
    GetVertexShaderConstantF_proc typedef ptr GetVertexShaderConstantF_proto
    GetVertexShaderConstantFHook proto :dword, :dword, :dword, :dword
    GETVERTEXSHADERCONSTANTF EQU 380
    .data?
    GetVertexShaderConstantF GetVertexShaderConstantF_proc ?
    .code
    LGetVertexShaderConstantF db "%08X: RETURNED %08X IDirect3DDevice9->GetVertexShaderConstantF(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(SetVertexShaderConstantI)(THIS_ UINT StartRegister,CONST int* pConstantData,UINT Vector4iCount) PURE;
    SetVertexShaderConstantI_proto typedef proto :dword, :dword, :dword, :dword
    SetVertexShaderConstantI_proc typedef ptr SetVertexShaderConstantI_proto
    SetVertexShaderConstantIHook proto :dword, :dword, :dword, :dword
    SETVERTEXSHADERCONSTANTI EQU 384
    .data?
    SetVertexShaderConstantI SetVertexShaderConstantI_proc ?
    .code
    LSetVertexShaderConstantI db "%08X: RETURNED %08X IDirect3DDevice9->SetVertexShaderConstantI(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(GetVertexShaderConstantI)(THIS_ UINT StartRegister,int* pConstantData,UINT Vector4iCount) PURE;
    GetVertexShaderConstantI_proto typedef proto :dword, :dword, :dword, :dword
    GetVertexShaderConstantI_proc typedef ptr GetVertexShaderConstantI_proto
    GetVertexShaderConstantIHook proto :dword, :dword, :dword, :dword
    GETVERTEXSHADERCONSTANTI EQU 388
    .data?
    GetVertexShaderConstantI GetVertexShaderConstantI_proc ?
    .code
    LGetVertexShaderConstantI db "%08X: RETURNED %08X IDirect3DDevice9->GetVertexShaderConstantI(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(SetVertexShaderConstantB)(THIS_ UINT StartRegister,CONST BOOL* pConstantData,UINT  BoolCount) PURE;
    SetVertexShaderConstantB_proto typedef proto :dword, :dword, :dword, :dword
    SetVertexShaderConstantB_proc typedef ptr SetVertexShaderConstantB_proto
    SetVertexShaderConstantBHook proto :dword, :dword, :dword, :dword
    SETVERTEXSHADERCONSTANTB EQU 392
    .data?
    SetVertexShaderConstantB SetVertexShaderConstantB_proc ?
    .code
    LSetVertexShaderConstantB db "%08X: RETURNED %08X IDirect3DDevice9->SetVertexShaderConstantB(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(GetVertexShaderConstantB)(THIS_ UINT StartRegister,BOOL* pConstantData,UINT BoolCount) PURE;
    GetVertexShaderConstantB_proto typedef proto :dword, :dword, :dword, :dword
    GetVertexShaderConstantB_proc typedef ptr GetVertexShaderConstantB_proto
    GetVertexShaderConstantBHook proto :dword, :dword, :dword, :dword
    GETVERTEXSHADERCONSTANTB EQU 396
    .data?
    GetVertexShaderConstantB GetVertexShaderConstantB_proc ?
    .code
    LGetVertexShaderConstantB db "%08X: RETURNED %08X IDirect3DDevice9->GetVertexShaderConstantB(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(SetStreamSource)(THIS_ UINT StreamNumber,IDirect3DVertexBuffer9* pStreamData,UINT OffsetInBytes,UINT Stride) PURE;
    SetStreamSource_proto typedef proto :dword, :dword, :dword, :dword, :dword
    SetStreamSource_proc typedef ptr SetStreamSource_proto
    SetStreamSourceHook proto :dword, :dword, :dword, :dword, :dword
    SETSTREAMSOURCE equ 400
    .data?
    SetStreamSource SetStreamSource_proc ?
    .code
    LSetStreamSource db "%08X: RETURNED %08X IDirect3DDevice9->SetStreamSource(%08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(GetStreamSource)(THIS_ UINT StreamNumber,IDirect3DVertexBuffer9** ppStreamData,UINT* pOffsetInBytes,UINT* pStride) PURE;
    GetStreamSource_proto typedef proto :dword, :dword, :dword, :dword, :dword
    GetStreamSource_proc typedef ptr GetStreamSource_proto
    GetStreamSourceHook proto :dword, :dword, :dword, :dword, :dword
    GETSTREAMSOURCE equ 404
    .data?
    GetStreamSource GetStreamSource_proc ?
    .code
    LGetStreamSource db "%08X: RETURNED %08X IDirect3DDevice9->GetStreamSource(%08X, %08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(SetStreamSourceFreq)(THIS_ UINT StreamNumber,UINT Setting) PURE;
    SetStreamSourceFreq_proto typedef proto :dword, :dword, :dword
    SetStreamSourceFreq_proc typedef ptr SetStreamSourceFreq_proto
    SetStreamSourceFreqHook proto :dword, :dword, :dword
    SETSTREAMSOURCEFREQ EQU 408
    .data?
    SetStreamSourceFreq SetStreamSourceFreq_proc ?
    .code
    LSetStreamSourceFreq db "%08X: RETURNED %08X IDirect3DDevice9->SetStreamSourceFreq(%08X, %08X, %08X)<br>", 0
;STDMETHOD(GetStreamSourceFreq)(THIS_ UINT StreamNumber,UINT* pSetting) PURE;
    GetStreamSourceFreq_proto typedef proto :dword, :dword, :dword
    GetStreamSourceFreq_proc typedef ptr GetStreamSourceFreq_proto
    GetStreamSourceFreqHook proto :dword, :dword, :dword
    GETSTREAMSOURCEFREQ EQU 412
    .data?
    GetStreamSourceFreq GetStreamSourceFreq_proc ?
    .code
    LGetStreamSourceFreq db "%08X: RETURNED %08X IDirect3DDevice9->GetStreamSourceFreq(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetIndices)(THIS_ IDirect3DIndexBuffer9* pIndexData) PURE;
    SetIndices_proto typedef proto :dword, :dword
    SetIndices_proc typedef ptr SetIndices_proto
    SetIndicesHook proto :dword, :dword
    SETINDICES EQU 416
    .data?
    SetIndices SetIndices_proc ?
    .code
    LSetIndices db "%08X: RETURNED %08X IDirect3DDevice9->SetIndices(%08X, %08X)<br>", 0
;STDMETHOD(GetIndices)(THIS_ IDirect3DIndexBuffer9** ppIndexData) PURE;
    GetIndices_proto typedef proto :dword, :dword
    GetIndices_proc typedef ptr GetIndices_proto
    GetIndicesHook proto :dword, :dword
    GETINDICES EQU 420
    .data?
    GetIndices GetIndices_proc ?
    .code
    LGetIndices db "%08X: RETURNED %08X IDirect3DDevice9->GetIndices(%08X, %08X)<br>", 0
;STDMETHOD(CreatePixelShader)(THIS_ CONST DWORD* pFunction,IDirect3DPixelShader9** ppShader) PURE;
    CreatePixelShader_proto typedef proto :dword, :dword, :dword
    CreatePixelShader_proc typedef ptr CreatePixelShader_proto
    CreatePixelShaderHook proto :dword, :dword, :dword
    CREATEPIXELSHADER EQU 424
    .data?
    CreatePixelShader CreatePixelShader_proc ?
    .code
    LCreatePixelShader db "%08X: RETURNED %08X IDirect3DDevice9->CreatePixelShader(%08X, %08X, %08X)<br>", 0
;STDMETHOD(SetPixelShader)(THIS_ IDirect3DPixelShader9* pShader) PURE;
    SetPixelShader_proto typedef proto :dword, :dword
    SetPixelShader_proc typedef ptr SetPixelShader_proto
    SetPixelShaderHook proto :dword, :dword
    SETPIXELSHADER EQU 428
    .data?
    SetPixelShader SetPixelShader_proc ?
    .code
    LSetPixelShader db "%08X: RETURNED %08X IDirect3DDevice9->SetPixelShader(%08X, %08X)<br>", 0
;STDMETHOD(GetPixelShader)(THIS_ IDirect3DPixelShader9** ppShader) PURE;
    GetPixelShader_proto typedef proto :dword, :dword
    GetPixelShader_proc typedef ptr GetPixelShader_proto
    GetPixelShaderHook proto :dword, :dword
    GETPIXELSHADER EQU 432
    .data?
    GetPixelShader GetPixelShader_proc ?
    .code
    LGetPixelShader db "%08X: RETURNED %08X IDirect3DDevice9->GetPixelShader(%08X, %08X)<br>", 0
;STDMETHOD(SetPixelShaderConstantF)(THIS_ UINT StartRegister,CONST float* pConstantData,UINT Vector4fCount) PURE;
    SetPixelShaderConstantF_proto typedef proto :dword, :dword, :dword, :dword
    SetPixelShaderConstantF_proc typedef ptr SetPixelShaderConstantF_proto
    SetPixelShaderConstantFHook proto :dword, :dword, :dword, :dword
    SETPIXELSHADERCONSTANTF EQU 436
    .data?
    SetPixelShaderConstantF SetPixelShaderConstantF_proc ?
    .code
    LSetPixelShaderConstantF db "%08X: RETURNED %08X IDirect3DDevice9->SetPixelShaderConstantF(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(GetPixelShaderConstantF)(THIS_ UINT StartRegister,float* pConstantData,UINT Vector4fCount) PURE;
    GetPixelShaderConstantF_proto typedef proto :dword, :dword, :dword, :dword
    GetPixelShaderConstantF_proc typedef ptr GetPixelShaderConstantF_proto
    GetPixelShaderConstantFHook proto :dword, :dword, :dword, :dword
    GETPIXELSHADERCONSTANTF EQU 440
    .data?
    GetPixelShaderConstantF GetPixelShaderConstantF_proc ?
    .code
    LGetPixelShaderConstantF db "%08X: RETURNED %08X IDirect3DDevice9->GetPixelShaderConstantF(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(SetPixelShaderConstantI)(THIS_ UINT StartRegister,CONST int* pConstantData,UINT Vector4iCount) PURE;
    SetPixelShaderConstantI_proto typedef proto :dword, :dword, :dword, :dword
    SetPixelShaderConstantI_proc typedef ptr SetPixelShaderConstantI_proto
    SetPixelShaderConstantIHook proto :dword, :dword, :dword, :dword
    SETPIXELSHADERCONSTANTI EQU 444
    .data?
    SetPixelShaderConstantI SetPixelShaderConstantI_proc ?
    .code
    LSetPixelShaderConstantI db "%08X: RETURNED %08X IDirect3DDevice9->SetPixelShaderConstantI(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(GetPixelShaderConstantI)(THIS_ UINT StartRegister,int* pConstantData,UINT Vector4iCount) PURE;
    GetPixelShaderConstantI_proto typedef proto :dword, :dword, :dword, :dword
    GetPixelShaderConstantI_proc typedef ptr GetPixelShaderConstantI_proto
    GetPixelShaderConstantIHook proto :dword, :dword, :dword, :dword
    GETPIXELSHADERCONSTANTI EQU 448
    .data?
    GetPixelShaderConstantI GetPixelShaderConstantI_proc ?
    .code
    LGetPixelShaderConstantI db "%08X: RETURNED %08X IDirect3DDevice9->GetPixelShaderConstantI(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(SetPixelShaderConstantB)(THIS_ UINT StartRegister,CONST BOOL* pConstantData,UINT BoolCount) PURE;
    SetPixelShaderConstantB_proto typedef proto :dword, :dword, :dword, :dword
    SetPixelShaderConstantB_proc typedef ptr SetPixelShaderConstantB_proto
    SetPixelShaderConstantBHook proto :dword, :dword, :dword, :dword
    SETPIXELSHADERCONSTANTB EQU 452
    .data?
    SetPixelShaderConstantB SetPixelShaderConstantB_proc ?
    .code
    LSetPixelShaderConstantB db "%08X: RETURNED %08X IDirect3DDevice9->SetPixelShaderConstantB(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(GetPixelShaderConstantB)(THIS_ UINT StartRegister,BOOL* pConstantData,UINT BoolCount) PURE;
    GetPixelShaderConstantB_proto typedef proto :dword, :dword, :dword, :dword
    GetPixelShaderConstantB_proc typedef ptr GetPixelShaderConstantB_proto
    GetPixelShaderConstantBHook proto :dword, :dword, :dword, :dword
    GETPIXELSHADERCONSTANTB EQU 456
    .data?
    GetPixelShaderConstantB GetPixelShaderConstantB_proc ?
    .code
    LGetPixelShaderConstantB db "%08X: RETURNED %08X IDirect3DDevice9->GetPixelShaderConstantB(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(DrawRectPatch)(THIS_ UINT Handle,CONST float* pNumSegs,CONST D3DRECTPATCH_INFO* pRectPatchInfo) PURE;
    DrawRectPatch_proto typedef proto :dword, :dword, :dword, :dword
    DrawRectPatch_proc typedef ptr DrawRectPatch_proto
    DrawRectPatchHook proto :dword, :dword, :dword, :dword
    DRAWRECTPATCH EQU 460
    .data?
    DrawRectPatch DrawRectPatch_proc ?
    .code
    LDrawRectPatch db "%08X: RETURNED %08X IDirect3DDevice9->DrawRectPatch(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(DrawTriPatch)(THIS_ UINT Handle,CONST float* pNumSegs,CONST D3DTRIPATCH_INFO* pTriPatchInfo) PURE;
    DrawTriPatch_proto typedef proto :dword, :dword, :dword, :dword
    DrawTriPatch_proc typedef ptr DrawTriPatch_proto
    DrawTriPatchHook proto :dword, :dword, :dword, :dword
    DRAWTRIPATCH EQU 464
    .data?
    DrawTriPatch DrawTriPatch_proc ?
    .code
    LDrawTriPatch db "%08X: RETURNED %08X IDirect3DDevice9->DrawTriPatch(%08X, %08X, %08X, %08X)<br>", 0
;STDMETHOD(DeletePatch)(THIS_ UINT Handle) PURE;
    DeletePatch_proto typedef proto :dword, :dword
    DeletePatch_proc typedef ptr DeletePatch_proto
    DeletePatchHook proto :dword, :dword
    DELETEPATCH EQU 468
    .data?
    DeletePatch DeletePatch_proc ?
    .code
    LDeletePatch db "%08X: RETURNED %08X IDirect3DDevice9->DeletePatch(%08X, %08X)<br>", 0
;STDMETHOD(CreateQuery)(THIS_ D3DQUERYTYPE Type,IDirect3DQuery9** ppQuery) PURE;
    CreateQuery_proto typedef proto :dword, :dword, :dword
    CreateQuery_proc typedef ptr CreateQuery_proto
    CreateQueryHook proto :dword, :dword, :dword
    CREATEQUERY EQU 472
    .data?
    CreateQuery CreateQuery_proc ?
    .code
    LCreateQuery db "%08X: RETURNED %08X IDirect3DDevice9->CreateQuery(%08X, %08X, %08X)<br>", 0