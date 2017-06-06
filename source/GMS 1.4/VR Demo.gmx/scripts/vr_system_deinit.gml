///vr_system_deinit()
/*
    Deinitializiation script. This is only needed if you are calling
    game_restart() as all this is done automatically when the game ends.
 */
 
buffer_delete(global.__gmvr_bufferLeft);
buffer_delete(global.__gmvr_bufferRight);
