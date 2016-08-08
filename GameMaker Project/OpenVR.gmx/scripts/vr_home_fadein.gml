///vr_home_fadein(seconds)
/*
    Fades from the GameMaker scene to the VR "home" scene in the specified
    number of seconds.
    
    Returns     -   undefined
 */
 
if (!global.vive_isrunning)
    return undefined;
    
external_call(global.vive_external_fadegridin, real(argument0));
return undefined;
