///matrix_get_identity()
/*
    Generates and returns the identity matrix.
    
    Returns:    GameMaker matrix
 */
 
var __mutateMatrix = 0;
__mutateMatrix[15] = 1;
__mutateMatrix[10] = 1;
__mutateMatrix[5]  = 1;
__mutateMatrix[0]  = 1;
return __mutateMatrix;
