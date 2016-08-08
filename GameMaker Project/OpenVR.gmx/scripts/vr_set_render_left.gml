///vr_set_render_left(znear, zfar)
/*
    Sets up the camera matrices so that you can render the scene as needed for
    the left eye.
    
    You will want to save the desired matrices so you can reset them as needed.
 */
 
if (!global.vive_isrunning)
    return undefined;
    
// -- WARNING -- // GetEyeToHeadTransform() is currently crashing under
// MinGW (OpenVR Bug)! Ugh.
// There is a sloppy work-around here:
// https://github.com/ValveSoftware/openvr/issues/133
    
var __hmdPos = vr_get_matrix_hmd(),
    __eyePos = vr_get_matrix_pos(HMD_EYE.left);
    __eyeProj = vr_get_matrix_proj(HMD_EYE.left, argument0, argument1);
    
if (is_undefined(__hmdPos) || is_undefined(__eyePos) || is_undefined(__eyeProj))
    return undefined;
    
matrix_set(matrix_view, matrix_multiply(__hmdPos, __eyePos));
matrix_set(matrix_projection, __eyeProj);

return undefined;
    

