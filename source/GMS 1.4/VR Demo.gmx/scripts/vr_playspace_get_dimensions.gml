///vr_playspace_get_dimensions([ptr] handle)
/*
    Returns the playspace dimensions in a measurement of meters.
    An array with 2 values is returned where:
        0:  width
        1:  height
        
    Argument0:  [ptr] VR system handle
    Returns:    [array] playspace size
 */
 
// We only require the handle to make sure the VR system is working
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
 
var __width = external_call(global.__gmvr_external[GMVR_DLL.get_playspacewidth]),
    __height = external_call(global.__gmvr_external[GMVR_DLL.get_playspaceheight]);
    
var __array = 0;
__array[1] = __height;
__array[0] = __width;
return __array;
