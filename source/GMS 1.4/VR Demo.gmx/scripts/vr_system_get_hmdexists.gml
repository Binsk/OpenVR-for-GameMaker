///vr_system_get_hmdexists()
/*
    Returns if the system can detect a headset. This function
    can be called without initializing the whole system and is
    quite fast.
    
    Returns:    whether or not the headset exists
 */
 
return external_call(global.__gmvr_external[GMVR_DLL.system_hmdexists]);
