///vr_eye_get_projmatrix([ptr] handle, [enum: GMVR_EYE] eye, znear, zfar)
/*
    Returns a GameMaker matrix containing the EYEs view matrix.
    
    Argument0:  [ptr] VR system handle
    Argument1:  [enum: GMVR_EYE] which eye to pull the matrix from
    Argument2:  znear value of the camera
    Argument3:  zfar value of the camera
    Returns:    GameMaker matrix
 */
 
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
    
var __eye = floor(clamp(real(argument1), 0, 1));
var __buffer = external_generate_matrix_buffer();
var __args = external_arguments_wrap(__eye, argument2, argument3);
external_call(global.__gmvr_external[GMVR_DLL.load_eyeprojmatrix], argument0[0], buffer_get_address(__buffer), buffer_get_address(__args));
external_arguments_cleanup(__args);
return external_convert_matrix_buffer(__buffer);

