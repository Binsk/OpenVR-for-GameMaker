///vr_eye_get_viewmatrix([ptr] handle, [enum: GMVR_EYE] eye)
/*
    Returns a GameMaker matrix containing the EYEs view matrix.
    
    Argument0:  [ptr] VR system handle
    Argument1:  [enum: GMVR_EYE] which eye to pull the matrix from
    Returns:    GameMaker matrix
 */
 
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
    
var __eye = floor(clamp(real(argument1), 0, 1));
var __buffer = external_generate_matrix_buffer();
var __args = external_arguments_wrap(__eye);
external_call(global.__gmvr_external[GMVR_DLL.load_eyeviewmatrix], argument0[0], buffer_get_address(__buffer), buffer_get_address(__args));
external_arguments_cleanup(__args);
return matrix_get_inverse(external_convert_matrix_buffer(__buffer));
