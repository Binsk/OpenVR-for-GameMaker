///matrix_get_transpose([gm_matrix] mat)
/*
    Returns the transpose of the specified matrix.
    Given matrix must be in GameMaker's matrix format.
    For example, the data returned by matrix_get(matrix_view)
    
    Argument0   -   matrix to convert
    Returns     -   transpose of matrix
 */
 
// Determine if it is a proper matrix:
if (!is_array(argument0))
    show_error("MATRIX (argument0): Expected type [gm_matrix]!", true);
    
if (array_length_1d(argument0) != 16)
    show_error("MATRIX (argument0): Expected type [gm_matrix]!", true);
    
var __transpose = 0;
__transpose[15] = 0; // Allocate space

// Calculate transpose:
__transpose[0] = argument0[0];
__transpose[1] = argument0[4];
__transpose[2] = argument0[8];
__transpose[3] = argument0[12];

__transpose[4] = argument0[1];
__transpose[5] = argument0[5];
__transpose[6] = argument0[9];
__transpose[7] = argument0[13];

__transpose[8] = argument0[2];
__transpose[9] = argument0[6];
__transpose[10]= argument0[10];
__transpose[11]= argument0[14];

__transpose[12]= argument0[3];
__transpose[13]= argument0[7];
__transpose[14]= argument0[11];
__transpose[15]= argument0[15];

return __transpose;

