///vr_hmd_get_viewmatrix([ptr] handle)
/*
    Returns a GameMaker matrix containing the HMDs view matrix.
    
    Argument0:  [ptr] VR system handle
    Returns:    GameMaker matrix
 */
 
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
    
var __buffer = external_generate_matrix_buffer();
external_call(global.__gmvr_external[GMVR_DLL.load_hmdviewmatrix], argument0[0], buffer_get_address(__buffer));
var __matrix = external_convert_matrix_buffer(__buffer);
return matrix_get_inverse(__matrix);
