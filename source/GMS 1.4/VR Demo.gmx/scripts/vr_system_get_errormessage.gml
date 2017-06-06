///vr_system_get_errormessage()
/*
    Returns the next error message in the queue of errors and then removes
    the error from the queue.
    
    If no error exists then an empty string is returned.
    This function is global and NOT limited to a specific VR system.
    
    Returns:    [string] next error message
 */
 
return external_call(global.__gmvr_external[GMVR_DLL.system_errormessage]);
