///vr_sees_hmd()
/*
    Returns whether or not the system can see the HMD.
    This can be called without initializing the whole system
    and is a fast call.
 */
 
return external_call(global.vive_external_hmdexists);
