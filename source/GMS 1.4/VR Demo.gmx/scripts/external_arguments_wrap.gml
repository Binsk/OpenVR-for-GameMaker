///external_arguments_wrap(arg0, arg1, ...)
/*
    Wraps a series of arguments into a buffer to pass into
    our DLL. This removes the string / real argument count
    limit. Arguments must be of type real or string.
    Strings will be lists of const chars and reals will
    be float64s
    
    Argumentn:  Values to pass into buffer
    Returns:    buffer ID to pass to the DLL
 */

    // Calculate the size of the buffer:
var __byteAllocation = 0,
    __bufferSize = 0;    // In bytes
__byteAllocation[argument_count - 1] = 0; // Allocate array space
for (var i = 0; i < argument_count; ++i)
{
    if (is_real(argument[i]))
    {
        __byteAllocation[i] = 8;
        __bufferSize += 8;
    }
    
    if (is_string(argument[i]))
    {
        var __size = string_length(argument[i]) + 1;
        __byteAllocation[i] = __size;
        __bufferSize += __size;
    }
}

var __startOffset = argument_count + 1;
__bufferSize += __startOffset;
var __buffer = buffer_create(__bufferSize, buffer_fixed, 1);

// Buffer Format: argument_count, arg1 type, arg2 type, ..., data1, data2, ...
buffer_seek(__buffer, buffer_seek_start, 0);
buffer_write(__buffer, buffer_u8, argument_count);  // Write number of values stored

    // Write each value type (0 = real, 1 = string)
    // NOTE: I don't use booleans because buffers are byte aligned, not bit aligned
for (var i = 0; i < argument_count; ++i)
{
    buffer_seek(__buffer, buffer_seek_start, i + 1);
    if (is_real(argument[i]))
        buffer_write(__buffer, buffer_u8, 0);
    else
        buffer_write(__buffer, buffer_u8, 1);
}

// Write actual data:
var __extraOffset = 0;
for (var i = 0; i < argument_count; ++i)
{
    buffer_seek(__buffer, buffer_seek_start, __startOffset + __extraOffset);
    if (is_real(argument[i]))
        buffer_write(__buffer, buffer_f64, argument[i]);
    else
        buffer_write(__buffer, buffer_string, argument[i]);
        
    __extraOffset += __byteAllocation[i];
}

return __buffer;
