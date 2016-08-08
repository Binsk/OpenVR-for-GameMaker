///vr_get_matrix_proj([enum: HMD_EYE] eye, znear, zfar)
/*
    Returns the projection matrix for the specified eye.
 */
 
if (!global.vive_isrunning)
    return undefined;
    
var __matrixBuffer = buffer_create(16 * 8, buffer_wrap, 8);

if (!external_call(global.vive_external_geteyeproj, buffer_get_address(__matrixBuffer), argument0, argument1, argument2))
    return undefined;

var __matrix;
__matrix[15] = 0;
buffer_seek(__matrixBuffer, buffer_seek_start, 0);

for (var i = 0; i < 16; ++i)
    __matrix[i] = buffer_read(__matrixBuffer, buffer_u64);

buffer_delete(__matrixBuffer);

return __matrix;

