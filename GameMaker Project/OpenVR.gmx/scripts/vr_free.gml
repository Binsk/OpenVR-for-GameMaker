///vr_free()
/*
    Stops the VR system and frees all associated resources as well as resets all 
    default variables.
    
    Returns     -   undefined
 */
 
external_call(global.vive_external_shutdown);

// Destroy render surfaces;
if (!is_undefined(global.vive_lsurface) && surface_exists(global.vive_lsurface))
    surface_free(global.vive_lsurface);
    
if (!is_undefined(global.vive_rsurface) && surface_exists(global.vive_rsurface))
    surface_free(global.vive_rsurface);
    
// Destroy any existing buffers:
if (!is_undefined(global.vive_lbuffer))
    buffer_delete(global.vive_lbuffer);
    
if (!is_undefined(global.vive_rbuffer))
    buffer_delete(global.vive_rbuffer);
    
vr_init(); // Resets all the variables
