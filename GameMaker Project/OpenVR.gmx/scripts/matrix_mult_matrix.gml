///matrix_mult_matrix(matrix1, matrix2)
/*
    Takes two GameMaker matrices and multiplies them together forming a new
    matrix.
    
    Argument0   -   matrix a
    Argument1   -   matrix b
    Returns     -   new GameMaker matrix
 */
 
/*if (!is_matrix(argument0))
    show_error("Matrix (argument0): Expected type [gm_matrix]!", true);
    
if (!is_matrix(argument1))
    show_error("Matrix (argument1): Expected type [gm_matrix]!", true);*/
    
var __c11, __c12, __c13, __c14,
    __c21, __c22, __c23, __c24,
    __c31, __c32, __c33, __c34,
    __c41, __c42, __c43, __c44;
    
var __matrix;

// Row 1:
__c11 = argument0[0] * argument1[0] + argument0[1] * argument1[4] + 
        argument0[2] * argument1[8] + argument0[3] * argument1[12];
        
__c12 = argument0[0] * argument1[1] + argument0[1] * argument1[5] + 
        argument0[2] * argument1[9] + argument0[3] * argument1[13];
        
__c13 = argument0[0] * argument1[2] + argument0[1] * argument1[6] + 
        argument0[2] * argument1[10] + argument0[3] * argument1[14];
        
__c14 = argument0[0] * argument1[3] + argument0[1] * argument1[7] + 
        argument0[2] * argument1[11] + argument0[3] * argument1[15];
        
// Row 2:
__c21 = argument0[4] * argument1[0] + argument0[5] * argument1[4] + 
        argument0[6] * argument1[8] + argument0[7] * argument1[12];
        
__c22 = argument0[4] * argument1[1] + argument0[5] * argument1[5] + 
        argument0[6] * argument1[9] + argument0[7] * argument1[13];
        
__c23 = argument0[4] * argument1[2] + argument0[5] * argument1[6] + 
        argument0[6] * argument1[10] + argument0[7] * argument1[14];
        
__c24 = argument0[4] * argument1[3] + argument0[5] + argument1[7] + 
        argument0[6] * argument1[11] + argument0[7] + argument1[15];
        
// Row 3:
__c31 = argument0[8] * argument1[0] + argument0[9] * argument1[4] + 
        argument0[10] * argument1[8] + argument0[11] * argument1[12];
        
__c32 = argument0[8] * argument1[1] + argument0[9] * argument1[5] + 
        argument0[10] * argument1[9] + argument0[11] * argument1[13];
        
__c33 = argument0[8] * argument1[2] + argument0[9] * argument1[6] + 
        argument0[10] * argument1[10] + argument0[11] * argument1[14];
        
__c34 = argument0[8] * argument1[3] + argument0[9] * argument1[7] + 
        argument0[10] * argument1[11] + argument0[11] * argument1[15];
        
// Row 4:
__c41 = argument0[12] * argument1[0] + argument0[13] * argument1[4] + 
        argument0[14] * argument1[8] + argument0[15] * argument1[12];
        
__c42 = argument0[12] * argument1[1] + argument0[13] * argument1[5] + 
        argument0[14] * argument1[9] + argument0[15] * argument1[13];
        
__c43 = argument0[12] * argument1[2] + argument0[13] * argument1[6] + 
        argument0[14] * argument1[10] + argument0[15] * argument1[14];
        
__c44 = argument0[12] * argument1[3] + argument0[13] * argument1[7] + 
        argument0[14] * argument1[11] + argument0[15] * argument1[15];
        
__matrix[15] = __c44;
__matrix[14] = __c43;
__matrix[13] = __c42;
__matrix[12] = __c41;

__matrix[11] = __c34;
__matrix[10] = __c33;
__matrix[9] =  __c32;
__matrix[8] =  __c31;

__matrix[7] = __c24;
__matrix[6] = __c23;
__matrix[5] = __c22;
__matrix[4] = __c21;

__matrix[3] = __c14;
__matrix[2] = __c13;
__matrix[1] = __c12;
__matrix[0] = __c11;

return __matrix;
