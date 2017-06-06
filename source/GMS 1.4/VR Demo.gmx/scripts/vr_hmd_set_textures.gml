///vr_hmd_set_textures([ptr] handle, [surface] left, [surface] right)
/*
    Pushes two surfaces to the DLL which are converted to textures and pushed
    to the HMD display.
    
    This function also performs the update for device positions and orientation.
    
    Argument0:  [ptr] VR system handle
    Argument1:  [surface] id of left-eye surface
    Argument2:  [surface0 id of right-eye surface
    Returns:    [undefined]
 */
 
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
    
if (!surface_exists(argument1) || !surface_exists(argument2))
    show_error("GMVR:   Invalid surfaces!", true);
    
if (surface_get_width(argument1) != GMVR_RESOLUTION.width ||
    surface_get_width(argument2) != GMVR_RESOLUTION.width ||
    surface_get_height(argument1) != GMVR_RESOLUTION.height ||
    surface_get_height(argument2) != GMVR_RESOLUTION.height)
    show_error("GMVR:   Invalid surface dimensions!", true);
    
    // Copy surface data into readable buffer:
buffer_seek(global.__gmvr_bufferLeft, buffer_seek_start, 0);
buffer_seek(global.__gmvr_bufferRight, buffer_seek_start, 0);
buffer_get_surface(global.__gmvr_bufferLeft, argument1, 0, 0, 0);
buffer_get_surface(global.__gmvr_bufferRight, argument2, 0, 0, 0);

// Push data to display:
external_call(global.__gmvr_external[GMVR_DLL.set_hmdtextures], argument0[0], 
              buffer_get_address(global.__gmvr_bufferLeft), 
              buffer_get_address(global.__gmvr_bufferRight));

return undefined;
