///vr_get_controllercount()
/*
    Returns the number of detected controllers.
    
    Returns     -   number of detected controllers or 0 if error
 */
 
if (!global.vive_isrunning)
    return 0;
    
return external_call(global.vive_external_getcontrollercount);
