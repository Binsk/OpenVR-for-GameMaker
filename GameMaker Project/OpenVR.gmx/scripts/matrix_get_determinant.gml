///matrix_get_determinant([gm_matrix] mat)
/*
    Returns the determinant of the specified GameMaker matrix.
    These matrices must be in the format provided by GameMaker.
    For example, the format returned by matrix_get(maatrix_view)
    
    Argument0   -   matrix to use
    Returns     -   determinant of matrix
 */
 
if (!is_array(argument0))
    show_error("MATRIX (argument0): Expected type [gm_matrix]!", true);
    
if (array_length_1d(argument0) != 16)
    show_error("MATRIX (argument0): Expected type [gm_matrix]!", true);
 
var __determinant = 0;

var __a11 = argument0[0],
    __a12 = argument0[1],
    __a13 = argument0[2],
    __a14 = argument0[3],
    
    __a21 = argument0[4],
    __a22 = argument0[5],
    __a23 = argument0[6],
    __a24 = argument0[7],
    
    __a31 = argument0[8],
    __a32 = argument0[9],
    __a33 = argument0[10],
    __a34 = argument0[11],
    
    __a41 = argument0[12],
    __a42 = argument0[13],
    __a43 = argument0[14],
    __a44 = argument0[15];

__determinant = __a11 * __a22 * __a33 * __a44 +
                __a11 * __a23 * __a34 * __a42 +
                __a11 * __a24 * __a32 * __a43 +
                
                __a12 * __a21 * __a34 * __a43 +
                __a12 * __a23 * __a31 * __a44 +
                __a12 * __a24 * __a33 * __a41 +
                
                __a13 * __a21 * __a32 * __a44 +
                __a13 * __a22 * __a34 * __a41 +
                __a13 * __a24 * __a31 * __a42 +
                
                __a14 * __a21 * __a33 * __a42 +
                __a14 * __a22 * __a31 * __a43 +
                __a14 * __a23 * __a32 * __a41;
                
    // Part two:
__determinant += -__a11 * __a22 * __a34 * __a43
                 -__a11 * __a23 * __a32 * __a44
                 -__a11 * __a24 * __a33 * __a42
                 
                 -__a12 * __a21 * __a33 * __a44
                 -__a12 * __a23 * __a34 * __a41
                 -__a12 * __a24 * __a31 * __a43
                 
                 -__a13 * __a21 * __a34 * __a42
                 -__a13 * __a22 * __a31 * __a44
                 -__a13 * __a24 * __a32 * __a41
                 
                 -__a14 * __a21 * __a32 * __a43
                 -__a14 * __a22 * __a33 * __a41
                 -__a14 * __a23 * __a31 * __a42;
                 
return __determinant;
