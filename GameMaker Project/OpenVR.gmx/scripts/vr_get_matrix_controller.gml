///vr_get_matrix_controller(index)
/*
    Returns the positional matrix for the specified controller.
    You should specify the index of the controller to grab the matrix
    for. For example, if you have 2 controllers you could specify
    1 or 2.
    
    Specifying an incorrect index will result in a matrix full of 0s.
    
    Argument0   -   index of controller to retrieve data for
    Returns     -   matrix of positional data (undefined for error)
 */
 
if (!global.vive_isrunning)
    return undefined;
    
var __matrixBuffer = buffer_create(16 * 8, buffer_wrap, 8);
external_call(global.vive_external_getcontrollermatrix, real(argument0), buffer_get_address(__matrixBuffer))

var __matrix;
__matrix[15] = 0;
buffer_seek(__matrixBuffer, buffer_seek_start, 0);

for (var i = 0; i < 16; ++i)
    __matrix[i] = buffer_read(__matrixBuffer, buffer_u64);

buffer_delete(__matrixBuffer);

return __matrix;

