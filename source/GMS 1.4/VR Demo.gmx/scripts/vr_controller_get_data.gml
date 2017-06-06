///vr_controller_get_data([ptr] handle, [real] index)
/*
    Returns all the controller data for the specified index.
    If the index is invalid then the data returned will be 
    inaccurate.
    
    Argument0:  [ptr] VR system handle
    Argument1:  [real] index of the controller to read from [0..total controllers)
    Returns:    [array] structure containing all [enum: GMVR_CONTROLLER_DATA] controller data values
 */
 
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
    
var __index = clamp(floor(real(argument1)), 0, 15);
var __buffer = buffer_create(200, buffer_fixed, 1);

// Grab data into buffer:
external_call(global.__gmvr_external[GMVR_DLL.get_controllerdata], argument0[0], __index, buffer_get_address(__buffer));

// Grab data from buffer into our structure:
var __array = 0;
__array[GMVR_CONTROLLER_DATA.axisTrigger_X] = 0; // Allocate space
var __matrix = 0;
__matrix[15] = 0; // Allocate space
buffer_seek(__buffer, buffer_seek_start, 0);
    // Record matrix:
for (var i = 0; i < 16; ++i)
    __matrix[i] = buffer_read(__buffer, buffer_f64);
    
__array[GMVR_CONTROLLER_DATA.matrix] = __matrix;
    // Read our trigger values:
__array[GMVR_CONTROLLER_DATA.axisTouchpad_X] = buffer_read(__buffer, buffer_f64);
__array[GMVR_CONTROLLER_DATA.axisTouchpad_Y] = buffer_read(__buffer, buffer_f64);
__array[GMVR_CONTROLLER_DATA.axisTrigger_X] = buffer_read(__buffer, buffer_f64);

    // Read our boolean values:
__array[GMVR_CONTROLLER_DATA.stateHasChanged] = buffer_read(__buffer, buffer_u8);
__array[GMVR_CONTROLLER_DATA.btnSystem_Pressed] = buffer_read(__buffer, buffer_u8);
__array[GMVR_CONTROLLER_DATA.btnApp_Pressed] = buffer_read(__buffer, buffer_u8);
__array[GMVR_CONTROLLER_DATA.btnGrip_Pressed] = buffer_read(__buffer, buffer_u8);
__array[GMVR_CONTROLLER_DATA.btnTouchpad_Pressed] = buffer_read(__buffer, buffer_u8);
__array[GMVR_CONTROLLER_DATA.btnTouchpad_Touched] = buffer_read(__buffer, buffer_u8);

buffer_delete(__buffer);

return __array;
