///vr_chaperone_get_state([ptr] handle)
/*
    Returns the chaperone state code. This can be used to check on the base-stations
    and SteamVR initialization. 
    
    The error code definitions can be found in the VR_ERROR_CODES script.
    
    Argument0:  [ptr] VR system handle
    Returns:    [real] chaperone error code
 */
 
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
 
return external_call(global.__gmvr_external[GMVR_DLL.get_chaperonestate]);
