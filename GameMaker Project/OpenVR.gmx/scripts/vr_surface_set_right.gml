///vr_surface_set_right()
/*
    Sets the rendering target to the surface associated with the left eye.
    The surface target must be reset MANUALLY!
    
    Call this and draw your right-eye render surface before pushing data to the display.
 */
 
if (!global.vive_isrunning)
    return undefined;
    
// Make sure surfaces exist:
if (!surface_exists(global.vive_rsurface))
{
    global.vive_lsurface = surface_create(global.vive_displayw, global.vive_displayh);
}   

surface_set_target(global.vive_rsurface);
draw_clear(c_black);
    // Flip image for HMD
d3d_set_projection_ortho(0, global.vive_displayh, global.vive_displayw, -global.vive_displayh, 0);
