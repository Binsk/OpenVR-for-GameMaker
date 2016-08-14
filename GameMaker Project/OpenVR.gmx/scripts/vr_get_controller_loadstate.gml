///vr_get_controller_loadstate()
/*
    Returns the current "load state" of the controller model data.
    By default, the system starts loading the 3D mesh data for the controller model
    once it first detects it. This will return that state.
 */
 
if (!global.vive_isrunning)
    return VR_CONTROLLER_LOADSTATE.idle;

return external_call(global.vive_external_getcontrollerloadstate);
