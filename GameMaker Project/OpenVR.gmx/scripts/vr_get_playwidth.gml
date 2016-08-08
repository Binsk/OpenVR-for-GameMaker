///vr_get_playwidth()
/*
    Returns the playpace width in METERS for the user.
    NOTE: The SteamVR system must be fully initialized or you will get incorrect results.
    
    Returns     -   width of playspace in meters (or 0 if error)
 */
 
if (!global.vive_isrunning)
    return 0;
    
return external_call(global.vive_external_getplaywidth);
