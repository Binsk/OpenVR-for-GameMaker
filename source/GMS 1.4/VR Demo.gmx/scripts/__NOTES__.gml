/*
    GETTING THIS EXAMPLE TO RUN:
        Before you can run this example you must add a few DLLs to the included files.
        These were not included as part of the project in order to remove redundancy
        and maintenance.
        
            -   GMVive Wrapper.dll
            -   SDL2.dll
            -   openvr_api.dll
            -   glew32.dll
            
        All these files can be found in:
            source -> CPP -> GMVive Wrapper -> libraries -> [directory] -> lib32
            
        Make sure to read the included license files for each library before use.
 */

/*
    There are some oddities that have been addressed while writing this system.
    Here are some important things to keep in mind:
    
    1.  OpenGL is used to handle textures DLL-side before pushing them to
        the headset. OpenGL stores its textures flipped on the y-axis and
        so I have flipped the projection matrix for each eye to compensate.
        As a result, surfaces will appear upside-down in GameMaker when
        drawing in the window and will need to be flipped back.
    
    2.  MinGW with GCC was used to compile this DLL. There were some bugs in
        the OpenVR system that required a modified header file to work correctly.
        If you modify the DLL with VS then either the original or modified header
        will work fine. If you use the GCC compiler then you must use the modified
        version.
        
    3.  GameMaker provides no good way to pass texture data around. The only way
        to get texture data that can be read by a DLL is by copying it into a buffer
        and passing the buffer. Since we have two relatively large surfaces that must
        be coppied into a buffer every frame it is that much more difficult to keep
        the framerate at 90fps
 */
