///vr_controller_get_count([ptr] handle)
/*
    Returns the number of controllers currently detected by the
    VR system.
    
    Argument0:  [ptr] VR system handle
    Returns:    [real] number of detected controllers
 */
 
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
 
return external_call(global.__gmvr_external[GMVR_DLL.get_controllercount], argument0[0]);
