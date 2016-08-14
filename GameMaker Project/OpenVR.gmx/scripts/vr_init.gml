///vr_init()
/*
    Initializes variables and needed data for the system to run correctly
    on the GameMaker end.
    
    Returns     -   undefined
 */
 
global.vive_lsurface = undefined;   // Render targets
global.vive_rsurface = undefined;
global.vive_displayw = 1080;        // Render size
global.vive_displayh = 1200;
global.vive_isrunning = false;
global.vive_lbuffer = undefined;    // Render buffer
global.vive_rbuffer = undefined;

// Initialization error codes:
enum VR_INIT_ERROR
{
    none =                                  0,
    unknown =                               1,
    steamInstallationNotFound =             2000,
    sdlInitFailure =                        3,
    compositorFailure =                     4,
    sdlWindowFailure =                      5,
    sdlContextFailure =                     6,
    glewInitFailure =                       7,
    systemAlreadyInitialized =              8,
    
    
    init_installationNotFound =             100,
    init_installationCorrupt =              101,
    init_vrClientDLLNotFound =              102,
    init_fileNotFound =                     103,
    init_factoryNotFound =                  104,
    init_interfaceNotFound =                105,
    init_invalidInterface =                 106,
    init_userConfigDirectoryInvalid =       107,
    init_hmdNotFound =                      108,
    init_notInitialized =                   109,
    init_pathRegistryNotFound =             110,
    init_noConfigPath =                     111,
    init_noLogPath =                        112,
    init_pathRegistryNotWritable =          113,
    init_appInfoInitFailed =                114,
    init_retry =                            115,
    init_initCanceledByUser =               116,
    init_anotherAppLaunching =              117,
    init_settingsInitFailed =               118,
    init_shuttingDown =                     119,
    init_tooManyObjects =                   120,
    init_noServerForBackgroundApp =         121,
    init_notSupportedWithCompositor =       122,
    init_notAvailableToUtilityApps =        123,
    init_internal =                         124,
    
    driver_failed =                         200,
    driver_unknown =                        201,
    driver_hmdUnknown =                     202,
    driver_notLoaded =                      203,
    driver_runtimeOutOfDate =               204,
    driver_hmdInUse =                       205,
    driver_notCalibrated =                  206,
    driver_calibrationInvalid =             207,
    driver_hmdDisplayNotFound =             208,
    
    ipc_serverInitFailed =                  300,
    ipc_connectFailed =                     301,
    ipc_sharedStateInitFailed =             302,
    ipc_compositorInitFailed =              303,
    ipc_mutexInitFailed =                   304,
    ipc_failed =                            305,
    
    compositor_failed =                     400,
    compositor_d3d11HardwareRequired =      401,
    compositor_firmwareRequiresUpdate =     402,
    compositor_overlayInitFailed =          403,
    compositor_screenshotsInitFailed =      404
    
    // Error codes 1000 or higher (excluding steam error) are marked as "vendor specific"
    // and not included in this list.
}

enum VR_COMPOSITOR_ERROR
{
    none                            = 0,
    requestFailed                   = 1,
    incompatibleVersion             = 100,
    doNotHaveFocus                  = 101,
    invalidTexture                  = 102,
    isNotSceneApplication           = 103,
    textureIsOnWrongDevice          = 104,
    textureUsesUnsupportedFormat    = 105,
    sharedTexturesNotSupported      = 106,
    indexOutOfRange                 = 107
}

enum VR_CHAPERONE_STATE
{
    ok = 1,                       // No errors
    
    warning = 100,                  // Basic warning
    warning_bs_moved = 101,         // Base station may have moved
    warning_bs_removed = 102,       // Missing base station(s)
    warning_sb_invalid = 103,       // Seated bounds not calibrated
    
    error = 200,                    // Basic error
    error_bs_uninitialized = 201,   // Base station(s) not calibrated correctly
    error_bs_conflict = 202,        // Base stations calibrated but disagreeing
    error_pa_invalid = 203,         // Play area not calibrated correctly
    error_cb_invalid = 204          // Collision bounds not calibrated correctly
}

enum VR_EVENT_TYPE
{
    controller_button_pressed,
    controller_button_released
}

enum VR_EVENT_DETAIL
{
    // Controller:
    menu_btn,
    grip_btn,
    touchpad_btn,       // No location tracking yet
    trigger_btn,        // Over half-pressed triggers (digital, not analog)
}

enum HMD_DISPLAY_MODE
{
    direct,
    extended
}

enum HMD_EYE
{
    right,
    left
}

enum HMD
{
    hresolution = 1080,
    vresolution = 1200
}

enum VR_CONTROLLER_LOADSTATE
{
    idle,
    loading,
    finished
}

// DLL Handling:
var __viveDLLFilename = "htcvive.dll";

if (!file_exists(__viveDLLFilename))
    show_error("Failed to locate " + __viveDLLFilename + "!", true);
    
global.vive_external_bootup = external_define(__viveDLLFilename, "systemInit", dll_cdecl, ty_real, 2, 
                                              ty_real, ty_real);
global.vive_external_shutdown = external_define(__viveDLLFilename, "systemFree", dll_cdecl, ty_real, 0);
global.vive_external_updatehmdtex = external_define(__viveDLLFilename, "updateHMDTextures", dll_cdecl, ty_real, 
                                                    2, ty_string, ty_string);
global.vive_external_updatehmddisplay = external_define(__viveDLLFilename, "updateHMDDisplay", dll_cdecl, ty_real, 0);
global.vive_external_hmdexists = external_define(__viveDLLFilename, "headsetExists", dll_cdecl, ty_real, 0);
global.vive_external_getmathmd = external_define(__viveDLLFilename, "getHMDMatrix", dll_cdecl, ty_real, 1, ty_string);
global.vive_external_geteyepos = external_define(__viveDLLFilename, "getEyePosMatrix", dll_cdecl, ty_real, 2, 
                                                 ty_string, ty_real);
    // WARNING: This function might need a buffer for argument passing because it has 4 args and a string!
global.vive_external_geteyeproj = external_define(__viveDLLFilename, "getEyeProjMatrix", dll_cdecl, ty_real, 4, 
                                                  ty_string, ty_real, ty_real, ty_real);
                                                  
global.vive_external_getplaywidth = external_define(__viveDLLFilename, "getPlayWidth", dll_cdecl, ty_real, 0);
global.vive_external_getplayheight = external_define(__viveDLLFilename, "getPlayHeight", dll_cdecl, ty_real, 0);
global.vive_external_getcontrollercount = external_define(__viveDLLFilename, "getControllerCount", dll_cdecl, ty_real, 0);
global.vive_external_getcontrollermatrix = external_define(__viveDLLFilename, "getControllerMatrix", dll_cdecl, ty_real, 2, ty_real, ty_string);

global.vive_external_fadegridout = external_define(__viveDLLFilename, "fadeGridOut", dll_cdecl, ty_real, 1, ty_real);
global.vive_external_fadegridin = external_define(__viveDLLFilename, "fadeGridIn", dll_cdecl, ty_real, 1, ty_real);
global.vive_external_fadecolor = external_define(__viveDLLFilename, "fadeColor", dll_cdecl, ty_real, 5, ty_real, ty_real, ty_real, ty_real, ty_real);

global.vive_external_getchaperonestate = external_define(__viveDLLFilename, "getChaperoneState", dll_cdecl, ty_real, 0);

global.vive_external_updateevents = external_define(__viveDLLFilename, "updateEvents", dll_cdecl, ty_real, 0);
global.vive_external_pullevent = external_define(__viveDLLFilename, "pullEvent", dll_cdecl, ty_real, 1, ty_string);

return undefined;
