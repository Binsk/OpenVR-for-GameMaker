///vr_update_textures()
/*
    Pushes any graphical changes from GameMaker into the OpenGL system.
    This does NOT update the display!
    
    Returns     -   undefined
 */
 
if (!global.vive_isrunning)
    return undefined;
    
// Make sure surfaces exist:
if (!surface_exists(global.vive_lsurface))
{
    global.vive_lsurface = surface_create(global.vive_displayw, global.vive_displayh);
    surface_set_target(global.vive_lsurface);
    draw_clear(c_dkgray);
    surface_reset_target();
}   

if (!surface_exists(global.vive_rsurface))
{
    global.vive_rsurface = surface_create(global.vive_displayw, global.vive_displayh);
    surface_set_target(global.vive_rsurface);
    draw_clear(c_dkgray);
    surface_reset_target();
}    

// Copy pixel data to the buffers:
    // Seek just in case
buffer_seek(global.vive_lbuffer, buffer_seek_start, 0);
buffer_seek(global.vive_rbuffer, buffer_seek_start, 0);
buffer_get_surface(global.vive_lbuffer, global.vive_lsurface, 0, 0, 0);
buffer_get_surface(global.vive_rbuffer, global.vive_rsurface, 0, 0, 0);

external_call(global.vive_external_updatehmdtex, 
              buffer_get_address(global.vive_lbuffer), 
              buffer_get_address(global.vive_rbuffer))
