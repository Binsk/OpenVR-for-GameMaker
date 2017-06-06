///vr_hmd_set_forcedreprojection([ptr] handle, [bool] forced)
/*
    Toggles the option of forcing reprojection. This should be avoided
    at all costs, but if you absolutely CANNOT hit a solid 90fps then
    drop your framerate to 45fps and enable forced reprojection.
    
    If you are only occasionally dropping below 90 then you do not
    need this option as SteamVR  will automatically reproject as needed.
    
    Argument0:` [ptr] VR system handle
    Argument1:  [bool] if true reprojection will be forced
    Returns:    [undefined]
 */
if (!is_array(argument0) || is_undefined(argument0[0]))
    show_error("GMVR:   Invalid handle!", true);
    
external_call(global.__gmvr_external[GMVR_DLL.set_forcedreprojection], real(argument1));
