///matrix_get_inverse([gm_matrix] mat)
/*
    Returns the inverse of the specified matrix.
    Given matrix must be in GameMaker's matrix format.
    For example, the data returned by matrix_get(matrix_view)
    
    Argument0   -   matrix to convert
    Returns     -   inverse of matrix
 */
 
// Determine if it is a proper matrix:
if (!is_array(argument0))
    show_error("MATRIX (argument0): Expected type [gm_matrix]!", true);
    
if (array_length_1d(argument0) != 16)
    show_error("MATRIX (argument0): Expected type [gm_matrix]!", true);
    
var __inverse = 0,
    __determinant = matrix_get_determinant(argument0);
                 
/*if (debug_mode && __determinant == 0)
    show_error("MATRIX: Cannot calculate inverse matrix. Determinant = 0!", false);*/
    
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
    
__inverse[15] = 0; // Allocate space

// Calculate second base matrix:
    // [1, 1]
__inverse[0] = __a22 * __a33 * __a44 +
               __a23 * __a34 * __a42 +
               __a24 * __a32 * __a43 -
               __a22 * __a34 * __a43 -
               __a23 * __a32 * __a44 -
               __a24 * __a33 * __a42;
               
    //[1, 2]
__inverse[1] = __a12 * __a34 * __a43 +
               __a13 * __a32 * __a44 +
               __a14 * __a33 * __a42 -
               __a12 * __a33 * __a44 -
               __a13 * __a34 * __a42 -
               __a14 * __a32 * __a43;
        
    //[1, 3]       
__inverse[2] = __a12 * __a23 * __a44 +
               __a13 * __a24 * __a42 +
               __a14 * __a22 * __a43 -
               __a12 * __a24 * __a43 -
               __a13 * __a22 * __a44 -
               __a14 * __a23 * __a42;
    
    //[1, 4]           
__inverse[3] =  __a12 * __a24 * __a33 +
                __a13 * __a22 * __a34 +
                __a14 * __a23 * __a32 -
                __a12 * __a23 * __a34 -
                __a13 * __a24 * __a32 -
                __a14 * __a22 * __a33;
               
   //[2, 1] 
__inverse[4] =  __a21 * __a34 * __a43 +
                __a23 * __a31 * __a44 +
                __a24 * __a33 * __a41 -
                __a21 * __a33 * __a44 -
                __a23 * __a34 * __a41 -
                __a24 * __a31 * __a43;
                
    //[2, 2]
__inverse[5] =  __a11 * __a33 * __a44 +
                __a13 * __a34 * __a41 +
                __a14 * __a31 * __a43 -
                __a11 * __a34 * __a43 -
                __a13 * __a31 * __a44 -
                __a14 * __a33 * __a41;
                
    //[2, 3]
__inverse[6] =  __a11 * __a24 * __a43 +
                __a13 * __a21 * __a44 +
                __a14 * __a23 * __a41 -
                __a11 * __a23 * __a44 -
                __a13 * __a24 * __a41 -
                __a14 * __a21 * __a43;
                
    //[2, 4]
__inverse[7] =  __a11 * __a23 * __a34 +
                __a13 * __a24 * __a31 +
                __a14 * __a21 * __a33 -
                __a11 * __a24 * __a33 -
                __a13 * __a21 * __a34 -
                __a14 * __a23 * __a31;
                
    //[3, 1]
__inverse[8] =  __a21 * __a32 * __a44 +
                __a22 * __a34 * __a41 +
                __a24 * __a31 * __a42 -
                __a21 * __a34 * __a42 -
                __a22 * __a31 * __a44 -
                __a24 * __a32 * __a41;
                
    //[3, 2]
__inverse[9] =  __a11 * __a34 * __a42 +
                __a12 * __a31 * __a44 +
                __a14 * __a32 * __a41 -
                __a11 * __a32 * __a44 -
                __a12 * __a34 * __a41 -
                __a14 * __a31 * __a42;
                
    //[3, 3]
__inverse[10] = __a11 * __a22 * __a44 +
                __a12 * __a24 * __a41 +
                __a14 * __a21 * __a42 -
                __a11 * __a24 * __a42 -
                __a12 * __a21 * __a44 -
                __a14 * __a22 * __a41;
                
    //[3, 4]
__inverse[11] = __a11 * __a24 * __a32 +
                __a12 * __a21 * __a34 +
                __a14 * __a22 * __a31 -
                __a11 * __a22 * __a34 -
                __a12 * __a24 * __a31 -
                __a14 * __a21 * __a32;
                
    //[4, 1]
__inverse[12] = __a21 * __a33 * __a42 +
                __a22 * __a31 * __a43 +
                __a23 * __a32 * __a41 -
                __a21 * __a32 * __a43 -
                __a22 * __a33 * __a41 -
                __a23 * __a31 * __a42;
                
    //[4, 2]
__inverse[13] = __a11 * __a32 * __a43 +
                __a12 * __a33 * __a41 +
                __a13 * __a31 * __a42 -
                __a11 * __a33 * __a42 -
                __a12 * __a31 * __a43 -
                __a13 * __a32 * __a41;
                
    //[4, 3]
__inverse[14] = __a11 * __a23 * __a42 +
                __a12 * __a21 * __a43 +
                __a13 * __a22 * __a41 -
                __a11 * __a22 * __a43 -
                __a12 * __a23 * __a41 -
                __a13 * __a21 * __a42;
                
    //[4, 4]
__inverse[15] = __a11 * __a22 * __a33 +
                __a12 * __a23 * __a31 +
                __a13 * __a21 * __a32 -
                __a11 * __a23 * __a32 -
                __a12 * __a21 * __a33 -
                __a13 * __a22 * __a31;
                
// Multiply by determinant:
    // We set the matrix to all 0s if the determinant is 0.
if (__determinant != 0)
    __determinant = 1 / __determinant;
    
    
for (var i = 0; i < 16; ++i)
    __inverse[i] *= __determinant;
                
return __inverse;
