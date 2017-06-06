///external_convert_matrix_buffer(buffer)
/*
    Converts the buffer into a GameMaker matrix and
    frees the buffer.
    
    Argument0:  Id of the buffer
    Returns:    GameMaker matrix
 */
 
var __array = 0;
__array[15] = 0; // Allocate space

buffer_seek(argument0, buffer_seek_start, 0);
for (var i = 0; i < 16; ++i)
    __array[i] = buffer_read(argument0, buffer_f64);

buffer_delete(argument0);
return __array;
