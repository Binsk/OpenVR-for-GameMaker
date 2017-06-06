///vr_system_destroy([ptr] handle)
/*
    Destroys the VR system and frees up all associated data.
    
    Argument0:  [ptr]       handle of VR system
    Returns:    [undefined]
 */
 
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
    
    // Delete the system:
external_call(global.__gmvr_external[GMVR_DLL.system_destroy], argument0[0]);

    // Invalidate the handle in case this function is called again:
argument0[@ 0] = undefined;
 
return undefined;
