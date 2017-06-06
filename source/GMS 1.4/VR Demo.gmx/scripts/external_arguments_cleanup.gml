///external_arguments_cleanup(buffer)
/* 
    Wipes all the arguments from memory and destroys the
    buffer. This can be done immediately after passing the
    data into the DLL, assuming it is single threaded.
    
    Argument0:  [buffer]    id of the buffer to destroy
    Returns:    [undefined]
 */
 
buffer_delete(argument0);
return undefined;
