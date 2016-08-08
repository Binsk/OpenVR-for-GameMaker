/*

    This project provides rudamentary support for the HTC Vive virtual reality device.
    This project is labeled "Experimental" and thus will likely have bugs as well as
    severe lack of optimization.
    
    In order for the system to work, all DLLs should be added as included files.
    The required DLLs are as follows:
        glew32.dll      -> Open GL systems for texture support
        openvr_api.dll  -> Interfacing with SteamVR and the hardware
        SDL2.dll        -> Windowing to give Open GL functions context
        htcvive.dll     -> Wrapper to convert GameMaker calls
        pthread.dll     -> Multithreading (Currently disabled due to bugs)
    
    SteamVR Note:
        Re-projection MUST be disabled in SteamVR settings! This seems to cap
        the frame-rate to 45fps!
        
    Added This Update:
        - Function: vr_home_fadeout
        - Function: vr_home_fadein
        - Function: vr_color_fade
        - Function: vr_get_chaperonestate
        - Function: vr_update_events
        - Function: matrix_get_position
        - ENUM: VR_CHAPERONE_STATE
        - ENUM: VR_EVENT_TYPE
        - ENUM: VR_EVENT_DETAIL
 */
