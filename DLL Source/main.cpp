//#include <openvr.h>  // Used for Vive functions
#include "openvr_mingw.h" // Work around for OpenVR Bug w/ MinGW
    // Work-around by: https://github.com/ValveSoftware/openvr/issues/133
#include <GL/glew.h> // Used for handling textures for each eye, no actual rendering
#include <unistd.h>
#include <SDL.h>     // Used for handling the invisible window
#include <queue>
/*
    GLEW Note: The only pre-compiled GLEW package for MinGW I could
    find was v1.10.0 (Newest is 1.13.0). It only provided .a libraries
    which are static, so I have to include this macro.

    P.s. I was too lazy to build 1.13.0 myself.
 */


#define GLEW_STATIC
#include "main.h"

// GameMaker Setup:
#define GMEX extern "C" __declspec (dllexport)

/// Global variables:
Vive* vive = nullptr;

/// ----------------------------- ///
/// --- Interfacing Functions --- ///
/// ----------------------------- ///

// Starts up SteamVR and initialized the required systems to render:
GMEX double systemInit(double rWidth, double rHeight)
{
    // Check if already initialized:
    if (vive != nullptr)
        return 8;

    // Initialize system:
    vr::EVRInitError _error;
    vive = new Vive(rWidth, rHeight);
    _error = vive -> getInitError();

    if (vive -> isFatalError())
    {
        delete vive;  // Clean-up system
        vive = nullptr;
        return (double) _error;
    }

    return _error; // Should always be 0

}

// Frees up the VR system and all generated data:
GMEX double systemFree()
{
    if (vive == nullptr)
        return 0;

    // Clean up the system:
    delete vive;
    vive = nullptr;
    return 0;
}

    // Fast check for headset without needing to init the whole system:
GMEX double headsetExists()
{
    return (double) vr::VR_IsHmdPresent();
}

    // Modify image for each eye:
GMEX double updateHMDTextures(void* lTexture, void* rTexture)
{
    if (vive == nullptr)
        return 0; // Error

    vive -> updateTextures(lTexture, rTexture);
    return 1;
}

    // Push images to the display:
GMEX double updateHMDDisplay()
{
    if (vive == nullptr)
        return 0; // Error

    vive -> updateDisplay();
    return 1;
}

GMEX double getHMDMatrix(double* matrix)
{
    if (vive == nullptr)
        return 0; // Error

    vive -> getHMDMatrix(matrix);
    return 1.;
}

GMEX double getEyePosMatrix(double* matrix, double leye)
{
    if (vive == nullptr)
        return 0; // Error

    vive -> getEyePosition((leye > 0) ? true : false, matrix);
    return 1.;
}

GMEX double getEyeProjMatrix(double* matrix, double leye, double znear, double zfar)
{
    if (vive == nullptr)
        return 0; // Error

    vive -> getEyeProjection((leye > 0) ? true : false, znear, zfar, matrix);
    return 1.;
}

GMEX double getControllerCount()
{
    if (vive == nullptr)
        return 0; // Error

    return vive -> getControllerCount();
}

GMEX double getControllerMatrix(double index, double* matrix)
{
    if (vive == nullptr)
        return 0.;

    vive -> getControllerPosition(index, matrix);
    return 0.;
}

GMEX double fadeGridIn(double seconds)
{
    if (vive == nullptr)
        return 0.;

    vive -> fadeGrid(seconds, true);

    return 1.;
}

GMEX double fadeGridOut(double seconds)
{
    if (vive == nullptr)
        return 0.;

    vive -> fadeGrid(seconds, false);

    return 1.;
}

GMEX double fadeColor(double seconds, double r, double g, double b, double a)
{
    if (vive == nullptr)
        return 0.;

    vive -> fadeColor(seconds, r, g, b, a);

    return 1.;
}

GMEX double getChaperoneState()
{
    if (vive == nullptr)
        return 200;

    return vive -> getChaperoneState();
}

GMEX double updateEvents()
{
    if (vive == nullptr)
        return 0.;

    return vive -> updateEvents(); // Returns number of events
}

GMEX double pullEvent(double* buffer)
{
    if (vive == nullptr)
    {
        buffer[0] = -1;
        return 0.;
    }

    vive -> getNextEventData(buffer);
    return 0.;
}

/// --------------------- ///
/// --- Simple Checks --- ///
/// --------------------- ///

// Returns with of play-space in meters:
GMEX double getPlayWidth(void)
{
    if (vive == nullptr)
        return 0; // Error

    float _width, _height;
    vr::VRChaperone() -> GetPlayAreaSize(&_width, &_height);
    return _width;
}

// Returns height of play-space in meters:
GMEX double getPlayHeight(void)
{
    if (vive == nullptr)
        return 0; // Error

    float _width, _height;
    vr::VRChaperone() -> GetPlayAreaSize(&_width, &_height);
    return _height;
}

/// --------------------- ///
/// --- System Checks --- ///
/// --------------------- ///


