///vr_system_init([string] filepath)
/*
    Initializes the gmvr.dll and sets up all the external calls.
    This function should be called only once and at the very
    beginning of the game.
    
    Argument0:  [string]    local location of the dll file
    Returns:    [undefined]
 */
// Make sure the DLL is available:
if (!file_exists(argument0))
    show_error("GMVR:   Failed to locate " + argument0 + "!", true);
    
// Define external call references::
enum GMVR_DLL
{
    system_hmdexists,
    system_create,
    system_destroy,
    system_errormessage,
    system_fadetohome,
    system_fadefromhome,
    
    load_hmdviewmatrix,
    load_eyeviewmatrix,
    load_eyeprojmatrix,
    get_playspacewidth,
    get_playspaceheight,
    get_errorcompositor,
    get_errorinit,
    get_chaperonestate,
    get_controllercount,
    get_controllerdata,
    
    set_hmdtextures,
    set_forcedreprojection
}

enum GMVR_EYE
{
    left,
    right
}

    // DO NOT change the resolution! 
    // This is hard-coded in the DLL
    // If you must change it, you can modify
    // the RENDER_WIDTH and RENDER_HEIGHT
    // macros in the DLL as well
enum GMVR_RESOLUTION
{
    width = 1080,
    height = 1200
}

enum GMVR_CONTROLLER_DATA
{
    index,              // Index of the controller
    stateHasChanged,    // Whether anything has changed since last check
    matrix,             // Positional / rotational values of controller (relative to playspace)
    btnSystem_Pressed,  // Whether or not the vive system button is being pressed
    btnApp_Pressed,     // Whether or not the application button is being pressed
    btnGrip_Pressed,    // Whether or not the grip is being pressed
    btnTouchpad_Pressed,// Whether or not the touchpad is being pushed inward
    
    btnTouchpad_Touched,// Whether or not a finger is touching the touchpad (with or without pressing)
    
    axisTouchpad_X,     // X-axis value of touchpad between [-1..1]
    axisTouchpad_Y,     // Y-axis value of touchpad between [-1..1]
    axisTrigger_X       // Value of trigger between [0..1] where 0 is released and 1 is held down
}

global.__gmvr_external = 0;

// Link external calls:
global.__gmvr_external[GMVR_DLL.system_hmdexists] = external_define(argument0, "gm_getHmdExists", dll_cdecl, ty_real, 0);
global.__gmvr_external[GMVR_DLL.system_create] = external_define(argument0, "gm_systemCreate", dll_cdecl, ty_real, 0);
global.__gmvr_external[GMVR_DLL.system_destroy] = external_define(argument0, "gm_systemDestroy", dll_cdecl, ty_real, 1, ty_string);
global.__gmvr_external[GMVR_DLL.system_errormessage] = external_define(argument0, "gm_getErrorMessage", dll_cdecl, ty_string, 0);
global.__gmvr_external[GMVR_DLL.system_fadetohome] = external_define(argument0, "gm_fadeToHome", dll_cdecl, ty_real, 1, ty_real);
global.__gmvr_external[GMVR_DLL.system_fadefromhome] = external_define(argument0, "gm_fadeFromHome", dll_cdecl, ty_real, 1, ty_real);

global.__gmvr_external[GMVR_DLL.load_hmdviewmatrix] = external_define(argument0, "gm_loadHmdViewMatrix", dll_cdecl, ty_real, 2, ty_string, ty_string);
global.__gmvr_external[GMVR_DLL.load_eyeviewmatrix] = external_define(argument0, "gm_loadEyeViewMatrix", dll_cdecl, ty_real, 3, ty_string, ty_string, ty_string);
global.__gmvr_external[GMVR_DLL.load_eyeprojmatrix] = external_define(argument0, "gm_loadEyeProjectionMatrix", dll_cdecl, ty_real, 3, ty_string, ty_string, ty_string);
global.__gmvr_external[GMVR_DLL.get_playspacewidth] = external_define(argument0, "gm_getPlayspaceWidth", dll_cdecl, ty_real, 0);
global.__gmvr_external[GMVR_DLL.get_playspaceheight] = external_define(argument0, "gm_getPlayspaceHeight", dll_cdecl, ty_real, 0);
global.__gmvr_external[GMVR_DLL.get_errorcompositor] = external_define(argument0, "gm_getCompositorError", dll_cdecl, ty_real, 0); 
global.__gmvr_external[GMVR_DLL.get_errorinit] = external_define(argument0, "gm_getInitError", dll_cdecl, ty_real, 0);    
global.__gmvr_external[GMVR_DLL.get_chaperonestate] = external_define(argument0, "gm_getChaperoneState", dll_cdecl, ty_real, 0);
global.__gmvr_external[GMVR_DLL.get_controllercount] = external_define(argument0, "gm_getControllerCount", dll_cdecl, ty_real, 1, ty_string);
global.__gmvr_external[GMVR_DLL.get_controllerdata] = external_define(argument0, "gm_getControllerData", dll_cdecl, ty_real, 3, ty_string, ty_real, ty_string);

global.__gmvr_external[GMVR_DLL.set_hmdtextures] = external_define(argument0, "gm_setHmdTextures", dll_cdecl, ty_real, 3, ty_string, ty_string, ty_string);
global.__gmvr_external[GMVR_DLL.set_forcedreprojection] = external_define(argument0, "gm_setForcedInterleavedReprojection", dll_cdecl, ty_real, 1, ty_real);

// Generate surface buffers:
    // BGRA format, u8bit ints
global.__gmvr_bufferLeft = buffer_create(GMVR_RESOLUTION.width * GMVR_RESOLUTION.height * 4, buffer_fast, 1);
global.__gmvr_bufferRight = buffer_create(GMVR_RESOLUTION.width * GMVR_RESOLUTION.height * 4, buffer_fast, 1);

return undefined;
