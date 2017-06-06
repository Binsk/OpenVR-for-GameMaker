///vr_compositor_get_error([ptr] handle)
/*
    If you are coming across problems, you can call this function to get the
    last compositor error code.
    
    Argument0:  [ptr] VR system handle
    Returns:    [real] error code
 */
 
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
    
return external_call(global.__gmvr_external[GMVR_DLL.get_errorcompositor]);
