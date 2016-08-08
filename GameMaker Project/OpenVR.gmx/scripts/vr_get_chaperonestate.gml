///vr_get_chaperonestate()
/*
    Returns the state of the VR chaperone. The return type well be type
    [enum: VR_CHAPERONE_ERROR]
    
    If the VR system is not initialized then VR_CHAPERONE_ERROR.error will be returned.
    
    Returns     -   state of chaperone
 */
 
if (!global.vive_isrunning)
    return VR_CHAPERONE_STATE.error;
              
return external_call(global.vive_external_getchaperonestate);
