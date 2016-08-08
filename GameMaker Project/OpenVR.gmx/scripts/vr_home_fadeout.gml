///vr_home_fadeout(seconds)
/*
    Fades from the "home area" back to the GameMaker scene in the specified
    number of seconds
    
    Returns     -   undefined
 */
 
if (!global.vive_isrunning)
    return undefined;
    
external_call(global.vive_external_fadegridout, real(argument0));
return undefined;
