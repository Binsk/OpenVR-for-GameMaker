///vr_system_fadetohome([ptr] handle, [real] seconds)
/*
    Will fade the scene from your game's render to the SteamVR home
    screen in the amount of seconds specified.
    
    Argument0:  [ptr] VR system handle
    Argument1:  [real] seconds to take while fading
    Returns:    [undefined]
 */
 
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
    
external_call(global.__gmvr_external[GMVR_DLL.system_fadetohome], argument1);
return undefined;
