///matrix_get_position(matrix)
/*
    Returns an array containing the x,y,z positions from the matrix.
 */
 
if (!is_array(argument0))
    show_error("MATRIX (argument0): Expected type [gm_matrix]!", true);
    
if (array_length_1d(argument0) != 16)
    show_error("MATRIX (argument0): Expected type [gm_matrix]!", true);
    
var __array = 0;
__array[2] = 0; // Allocate space

__array[0] = argument0[12];
__array[1] = argument0[13];
__array[2] = argument0[14];

return __array;
