///matrix_tostring([gm_matrix] mat)
/*
    Converts a GameMaker 4x4 matrix to a readable string.
    
    Argument0   -   matrix to convert
    Returns     -   string
 */
// Determine if it is a proper matrix:
if (!is_array(argument0))
    show_error("MATRIX (argument0): Expected type [gm_matrix]!", true);
    
if (array_length_1d(argument0) != 16)
    show_error("MATRIX (argument0): Expected type [gm_matrix]!", true);
 
var __s1 = "", __s2 = "", __s3 = "", __s4 = "";
for (var i = 0; i < 4; ++i)
{
    // Calculate length of longest digit:
    var __d;
    for (var j = 0; j < 4; ++j)
        __d[j] = string(argument0[i + j * 4]);
    var __length = max(string_length(__d[0]),
                       string_length(__d[1]),
                       string_length(__d[2]),
                       string_length(__d[3]));
        
    // Add separating space if needed:
    if (i != 0)
    {
        __s1 += "  ";
        __s2 += "  ";
        __s3 += "  ";
        __s4 += "  ";
    }
    
    // Adjust digit lengths:
    for (var j = 0; j < 4; ++j)
    {
        if (string_length(__d[j]) < __length)
        {
            repeat (__length - string_length(__d[j]))
                __d[j] += " ";
        }
    }
    
    // Add final result to line of matrix:
    __s1 += __d[0];
    __s2 += __d[1];
    __s3 += __d[2];
    __s4 += __d[3];
    
}

return  "| "+__s1 + " |#" +
        "| "+__s2 + " |#" +
        "| "+__s3 + " |#" +
        "| "+__s4 + " |";
