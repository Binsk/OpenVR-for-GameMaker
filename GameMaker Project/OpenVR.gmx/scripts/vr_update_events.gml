///vr_update_events()
/*
    Checks the system for any interactive events such as button presses.
    If this is called with events still in the system, THEY WILL BE ERASED!
    
    This returns the number of events stored in the system.
    
    Returns     -   number of events since last check
 */
 
if (!global.vive_isrunning)
    return 0;
              
return external_call(global.vive_external_updateevents);
