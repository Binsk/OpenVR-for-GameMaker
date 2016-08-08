///vr_color_fade(seconds, color, alpha)
/*
    Fades to the specified color and alpha OVER the scene being rendered in the
    specified number of seconds.
    
    Returns     -   undefined
 */
 
if (!global.vive_isrunning)
    return undefined;
    
argument1 = real(argument1);
    
external_call(global.vive_external_fadecolor, real(argument0),
              clamp(color_get_red(argument1) / 255, 0., 1.), 
              clamp(color_get_green(argument1) / 255, 0., 1.),
              clamp(color_get_blue(argument1) / 255, 0., 1.),
              clamp(argument2, 0., 1.));
              
return undefined;
