/**
    @author     Reuben Shea
    @date       05-28-17

    Details:
        This project acts as a wrapper to help GameMaker: Studio
        communicate with the OpenVR system.

        This system uses 32bit libraries and the C++11 standard.
        This system was designed and tested using GCC 7.1.0 and
        MinGW 4.3.0

        NOTE:   To make openvr.h compatible with MinGW the python
                script openvr_tomingw.py was used. This script
                was not written by me.
 **/

/// -- EXTERNAL INCLUDES -- ///
#include <openvr_mingw.h>       // OpenVR / Vive interface
#include <glew.h>               // OpenGL required for context
#include <SDL.h>
#include <vector>
#include <queue>
#include <string>

/// -- GLOBAL VARIABLES -- ///
std::queue<const char*> ERROR_MESSAGES;

/// -- MACROS -- ///
#define GMX extern "C"  __declspec (dllexport)
#define GLEW_STATIC
#define ERROR_MAX   10
#define RENDER_WIDTH    1080
#define RENDER_HEIGHT   1200

void pushError(const char* error)
{
    ERROR_MESSAGES.push(error);
    while (ERROR_MESSAGES.size() > 10)
        ERROR_MESSAGES.pop();
}

/// -- LOCAL INCLUDES -- ///
#include "gmdata.h"
#include "vrsystem.h"   // VR controller system

/// -- HELPER FUNCTIONS -- ///
    // Unwrap the GameMaker buffer of arguments into
    // a list of GameMaker string / reals
std::vector <GmData> unwrapArguments(void* buffer)
{
    uint8_t argumentCount = ((uint8_t*) buffer)[0];
    std::vector<GmData> arguments;

    void* buffer_at = (void*) &(((uint8_t*) buffer)[argumentCount + 1]);

    for (uint8_t i = 0; i < argumentCount; ++i)
    {
        GmData_Type argumentType = (((uint8_t*) buffer)[i + 1] == 0) ?
                                   gmdt_real : gmdt_string;

        // Store real value in the list:
        if (argumentType == gmdt_real)
        {
            arguments.push_back(GmData(((double*) buffer_at)[0]));
            buffer_at = (void*) &(((double*) buffer_at)[1]);
            continue;
        }

        if (argumentType == gmdt_string)
        {
            std::string string = "";
            while (true)
            {
                char c = ((char*) buffer_at)[0];
                buffer_at = (void*) &(((char*) buffer_at)[1]);

                // Check if we are done with the string:
                if (c == 0)
                    break;

                string += c;
            }

            arguments.push_back(GmData(string.c_str()));
        }
    }

    return arguments;
}

/// -- SYSTEM FUNCTIONS -- ///
GMX double  gm_getHmdExists()
{
    return (double) vr::VR_IsHmdPresent();
}

    // Create a new VR system and return the handle
    // in a GameMaker readable format
GMX double  gm_systemCreate()
{
    VrSystem* handle = new VrSystem();

        // If there was a problem, return a bad handle:
    if (handle -> hasFatalError())
    {
        delete handle;
        handle = NULL;
    }

    return (double) ((uint32_t) handle);
}

    // Destroy the specified VR handle.
    // Making sure the pointer exists is handled by
    // GameMaker.
GMX void    gm_systemDestroy(VrSystem* handle)
{
    delete (VrSystem*) handle;
}

GMX void    gm_fadeToHome(double seconds)
{
    vr::VRCompositor() -> FadeGrid(seconds, true);
}

GMX void    gm_fadeFromHome(double seconds)
{
    vr::VRCompositor() -> FadeGrid(seconds, false);
}

/// -- GETTER FUNCTIONS -- ///

    // Returns the next human-readable error stored:
GMX const char* gm_getErrorMessage()
{
    if (ERROR_MESSAGES.empty())
        return "";

    const char* error = ERROR_MESSAGES.front();
    ERROR_MESSAGES.pop();

    return error;
}

GMX double      gm_getCompositorError(VrSystem* handle)
{
    return double(handle -> vrGetCompositorError());
}

GMX double      gm_getInitError(VrSystem* handle)
{
    return double(handle -> vrGetInitError());
}

GMX void    gm_loadHmdViewMatrix(VrSystem* handle, double* buffer)
{
    handle -> vrLoadHmdMatrix(buffer);
}

GMX void    gm_loadEyeProjectionMatrix(VrSystem* handle, double* buffer, void* arguments)
{
    // Argument count and data type checking is performed by GameMaker
    auto args = unwrapArguments(arguments);

    handle -> vrLoadProjectionMatrix((VrEye) args[0].getReal(), args[1].getReal(), args[2].getReal(), buffer);
}

GMX void    gm_loadEyeViewMatrix(VrSystem* handle, double* buffer, void* arguments)
{
    auto args = unwrapArguments(arguments);

    handle -> vrLoadViewMatrix((VrEye) args[0].getReal(), buffer);
}

GMX double  gm_getPlayspaceWidth()
{
    float width, height;
    vr::VRChaperone() -> GetPlayAreaSize(&width, &height);
    return width;
}

GMX double  gm_getPlayspaceHeight()
{
    float width, height;
    vr::VRChaperone() -> GetPlayAreaSize(&width, &height);
    return height;
}

GMX double  gm_getChaperoneState()
{
    return double(vr::VRChaperone() ->  GetCalibrationState());
}

GMX double  gm_getControllerCount(VrSystem* handle)
{
    return handle -> vrGetControllerCount();
}

GMX void  gm_getControllerData(VrSystem* handle, double index, double* buffer)
{
    VrControllerData_t data = handle -> vrGetControllerData(index);
    GmMatrix matrix(data.matrix);

        // Write all the double / float data first:
    matrix.writeToBuffer(buffer);
    buffer[16] = data.axisXTouchpad_Value;
    buffer[17] = data.axisYTouchpad_Value;
    buffer[18] = data.axisTrigger_Value;

        // Record bool values for GameMaker
    uint8_t* buffer_u8 = (uint8_t*) &(buffer[19]);
    buffer_u8[0] = data.stateHasChanged;
    buffer_u8[1] = data.btnSystem_Pressed;
    buffer_u8[2] = data.btnApp_Pressed;
    buffer_u8[3] = data.btnGrip_Pressed;
    buffer_u8[4] = data.btnTouchpad_Pressed;
    buffer_u8[5] = data.btnTouchpad_Touched;
}

/// -- SETTER FUNCTIONS -- ///
GMX void    gm_setHmdTextures(VrSystem* handle, void* textureLeft, void* textureRight)
{
    handle -> vrUpdateTextures(textureLeft, textureRight);  // Generate OpenGL textures
    handle -> vrUpdateDisplay();                            // Push textures to display
}

GMX void    gm_setForcedInterleavedReprojection(double enabled)
{
    if (enabled >= 0.5)
        vr::VRCompositor() -> ForceInterleavedReprojectionOn(true);
    else
        vr::VRCompositor() -> ForceInterleavedReprojectionOn(false);
}
