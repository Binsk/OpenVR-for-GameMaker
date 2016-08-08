///vr_get_matrix_pos([enum: HMD_EYE] eye)
/*
    Returns the positional matrix for the specified eye.
 */
 
if (!global.vive_isrunning)
    return undefined;
    
var __matrixBuffer = buffer_create(16 * 8, buffer_wrap, 8);
if (!external_call(global.vive_external_geteyepos, buffer_get_address(__matrixBuffer), argument0))
    return undefined;

var __matrix;
__matrix[15] = 0;
buffer_seek(__matrixBuffer, buffer_seek_start, 0);

for (var i = 0; i < 16; ++i)
    __matrix[i] = buffer_read(__matrixBuffer, buffer_u64);
    
__matrix = matrix_get_inverse(__matrix);

buffer_delete(__matrixBuffer);

return __matrix;

