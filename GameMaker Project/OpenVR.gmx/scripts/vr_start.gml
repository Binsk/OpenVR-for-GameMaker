///vr_start(rwidth, rheight)
/*
    Starts up the VR system and creates all needed framebuffers and textures.
    
    Argument0   -   render-width of each eye
    Argument1   -   render-height of each eye
    Returns     -   error code
 */
if (global.vive_isrunning)
    return undefined;
 
argument0 = floor(argument0);
argument1 = floor(argument1);

// Boot the vive system: 
var __err = external_call(global.vive_external_bootup, max(1, argument0), max(1, argument1));
if (__err != VR_INIT_ERROR.none)
{
    global.vive_isrunning = false;
    return __err;
}

// Free up surfaces if already created:
if (!is_undefined(global.vive_lsurface) && surface_exists(global.vive_lsurface))
    surface_free(global.vive_lsurface);
    
if (!is_undefined(global.vive_rsurface) && surface_exists(global.vive_rsurface))
    surface_free(global.vive_rsurface);
    
global.vive_lsurface = surface_create(max(1, argument0), max(1, argument1));
global.vive_rsurface = surface_create(max(1, argument0), max(1, argument1));

global.vive_displayw = max(1, argument0);
global.vive_displayh = max(1, argument1);

// Destroy any existing buffers:
if (!is_undefined(global.vive_lbuffer))
    buffer_delete(global.vive_lbuffer);
    
if (!is_undefined(global.vive_rbuffer))
    buffer_delete(global.vive_rbuffer);
    
// Create buffers to hold all the pixel data:
    // Note, we assume type u8 for each channel
global.vive_lbuffer = buffer_create(global.vive_displayw * global.vive_displayh * 4, buffer_fast, 1);
global.vive_rbuffer = buffer_create(global.vive_displayw * global.vive_displayh * 4, buffer_fast, 1);

global.vive_isrunning = true;
return __err;
