/*
    This is a list of possible error codes that can be returned by
    vr_compositor_get_error and vr_init_get_error
 */
enum GMVR_ERROR_INIT
{
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

enum GMVR_ERROR_COMPOSITOR
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

enum GMVR_CHAPERONE_STATE
{
    okay = 1,                       // No errors
    
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
