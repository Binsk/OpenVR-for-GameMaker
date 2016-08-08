///vr_update_display()
/*
    Pushes any graphical changes in the OpenGL system to the HMD.
    
    Returns     -   undefined
 */
 
if (!global.vive_isrunning)
    return undefined;
    
external_call(global.vive_external_updatehmddisplay);
