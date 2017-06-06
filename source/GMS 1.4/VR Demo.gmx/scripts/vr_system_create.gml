///vr_system_create()
/*
    Creates a new VR system and returns its handle.
    This system is responsible for processing any input
    and tracking of the vr headset and controllers.
    
    Returns:    [ptr]   VR system handle or [undefined] if error
 */
    
//
var __handle = external_call(global.__gmvr_external[GMVR_DLL.system_create]);

if (__handle == 0)
    return undefined;
    
var __handlewrapper = 0;
__handlewrapper[0] = ptr(__handle);

if (room_speed < 90)
    show_debug_message("GMVR WARNING:   Room speed is set too low!");

return __handlewrapper;
