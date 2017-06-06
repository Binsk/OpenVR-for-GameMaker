/**
    @author     Reuben Shea
    @date       05-28-17

    Details:
 **/
#ifndef VRSYSTEM_H
#define VRSYSTEM_H

enum VrDeviceClass {vrdc_none, vrdc_controller, vrdc_headset, vrdc_basestation};
enum VrEye {vre_left, vre_right};

    // This struct is mostly just to help organization and is
    // not actually needed in the long run.
struct VrControllerData_t
{
    double matrix[16] = {1., 0., 0., 0.,
                         0., 1., 0., 0.,
                         0., 0., 1., 0.,
                         0., 0., 0., 1.};

    bool    stateHasChanged = false,
            btnSystem_Pressed = false,
            btnApp_Pressed = false,
            btnGrip_Pressed = false,
            btnTouchpad_Pressed = false,
            btnTouchpad_Touched = false;

    float   axisXTouchpad_Value = 1.,
            axisYTouchpad_Value = 1.,
            axisTrigger_Value = 0.;



};

class VrSystem
{
    public:
        // FUNCTIONS:
            // General:
        VrSystem();
        ~VrSystem();
        bool    hasFatalError(){return errorIsFatal;}

            // Getter:
        void    vrLoadHmdMatrix(double* buffer); // Copy HMD matrix into provided buffer
        void    vrLoadProjectionMatrix(VrEye eye, double zNear, double zFar, double* buffer); // Copy projection matrix into provided buffer
        void    vrLoadViewMatrix(VrEye eye, double* buffer);
        uint8_t vrGetControllerCount();
        VrControllerData_t vrGetControllerData(uint8_t index);
        vr::EVRInitError        vrGetInitError(){return vrErrorInit;};
        vr::EVRCompositorError  vrGetCompositorError(){return vrErrorCompositor;};


            // Setter:
        void vrUpdateTextures(void* dataLeft, void* dataRight); // Push image data to textures
        void vrUpdateDisplay(); // Push new textures to HMD

    private:
        // VARIABLES:
            // General:
        bool                    errorIsFatal = false;
        uint8_t                 textureColorDefault[RENDER_WIDTH * RENDER_HEIGHT * 4];

            // OpenVR:
        vr::IVRSystem*          vrHmd = nullptr;
        vr::EVRInitError        vrErrorInit = vr::VRInitError_None;
        vr::EVRCompositorError  vrErrorCompositor = vr::VRCompositorError_None;
        vr::TrackedDevicePose_t vrDevicePoses[vr::k_unMaxTrackedDeviceCount];
        VrDeviceClass           vrDeviceClasses[vr::k_unMaxTrackedDeviceCount];
        std::queue<vr::VREvent_t>   vrEventQueue;
        double**                vrDeviceMatrices = nullptr;
        double*                 vrDeviceHmdMatrix = nullptr;
        uint32_t                vrDevicePacketNum[vr::k_unMaxTrackedDeviceCount];

            // SDL:
        SDL_Window*             sdlWindow = nullptr;
        SDL_GLContext           sdlContext = nullptr;

            // OpenGL / GLEW:
        GLuint                  textureLeftIndex,
                                textureRightIndex;

        // FUNCTIONS:
        void vrGenerateTextures();  // Create textures to render to
        void vrInitializeDevices();       // Initialize available VR devices
        void vrUpdatePoses();   // Update device IDs and matrices
        void vrUpdateEvents();  // Update controller events
};

VrSystem::VrSystem()
{
    // Initialize SDL system:
    if (SDL_Init(SDL_INIT_VIDEO) < 0)
    {
        errorIsFatal = true;
        pushError("Failed to initialize SDL!");
        return;
    }

    // Start the VR system:
    vrHmd = vr::VR_Init(&vrErrorInit, vr::VRApplication_Scene);
    if (vrErrorInit != vr::VRInitError_None)
    {
        errorIsFatal = true;
        pushError("Failed to initialize OpenVR!");
        return;
    }

    // Start the VR compositor:
    if (!vr::VRCompositor())
    {
        errorIsFatal = true;
        pushError("Failed to initialize VR compositor!");
        return;
    }

    // Create hidden window for OpenGL context:
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4);   // Max OpenGL version
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);   // Min OpenGL version
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 0);
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 0);
    sdlWindow = SDL_CreateWindow("OpenVR", 100, 100, 640, 360, SDL_WINDOW_HIDDEN | SDL_WINDOW_OPENGL);

    if (sdlWindow == nullptr)
    {
        errorIsFatal = true;
        pushError("Failed to create OpenGL context!");
        return;
    }

    // Create context:
    sdlContext = SDL_GL_CreateContext(sdlWindow);
    if (sdlContext == nullptr)
    {
        errorIsFatal = true;
        pushError("Failed to create OpenGL context!");
        return;
    }

    // Start GLEW for rendering:
    glewExperimental = GL_TRUE; // Required for OpenGL versions 3 and 4
    if (glewInit() != GLEW_OK)
    {
        errorIsFatal = true;
        pushError("Failed to initialize OpenGL!");
        return;
    }
    glGetError();   // Clear OpenGL errors

    vrInitializeDevices();
    vrUpdatePoses();
    vrGenerateTextures();
}

VrSystem::~VrSystem()
{
    // Destroy VR instance:
    if (vrHmd != nullptr)
        vr::VR_Shutdown();

    vrHmd = nullptr;

    // Destroy SDL window and textures:
    if (sdlContext != nullptr)
    {
        glDeleteTextures(1, &textureLeftIndex);
        glDeleteTextures(1, &textureRightIndex);
        sdlContext = nullptr;
    }

    if (sdlWindow != nullptr)
    {
        SDL_DestroyWindow(sdlWindow);
        SDL_Quit();
        sdlWindow = nullptr;
    }

    // Destroy device matrices:
    if (vrDeviceMatrices != nullptr)
    {
        for (uint32_t i = 0; i < vr::k_unMaxTrackedDeviceCount; ++i)
            delete vrDeviceMatrices[i];

        delete [] vrDeviceMatrices;
        vrDeviceMatrices = nullptr;
    }

    vr::VR_Shutdown();
}

void VrSystem::vrLoadHmdMatrix(double* buffer)
{
    // If we don't have the matrix, don't do anything
    if (vrDeviceHmdMatrix == nullptr)
    {
        //pushError("Failed to load HMD-view matrix!");
        return;
    }

    // Transfer matrix values:
    // GameMaker handles inverting the matrix
    GmMatrix matrix(vrDeviceHmdMatrix);
    matrix.writeToBuffer(buffer);
}

void VrSystem::vrLoadProjectionMatrix(VrEye eye, double zNear, double zFar, double* buffer)
{
    if (vrDeviceHmdMatrix == nullptr)
    {
        //pushError("Failed to load eye-projection matrix!");
        return;
    }

    // Create our projection matrix from scratch:
    vr::EVREye vrEye = (eye == vre_left) ? vr::Eye_Left : vr::Eye_Right;
    float   pfLeft, pfRight, pfTop, pfBottom;
    vrHmd -> GetProjectionRaw(vrEye, &pfLeft, &pfRight, &pfTop, &pfBottom);

    float idx = 1. / (pfRight - pfLeft);
    float idy = 1. / -(pfBottom - pfTop);    // Invert for OpenGL texture
    float idz = 1. / (zFar - zNear);
    float sx = pfRight + pfLeft;
    float sy = pfBottom + pfTop;

    buffer[0] = 2 * idx;    buffer[1] = 0;          buffer[2] = 0;              buffer[3] = 0;
    buffer[4] = 0;          buffer[5] = 2 * idy;    buffer[6] = 0;              buffer[7] = 0;
    buffer[8] = sx * idx;   buffer[9] = sy * idy;   buffer[10] = -zFar * idz;   buffer[11] = -1.;
    buffer[12] = 0;         buffer[13] = 0;         buffer[14] = -zFar * zNear * idz;   buffer[15] = 0;
}

void VrSystem::vrLoadViewMatrix(VrEye eye, double* buffer)
{
    if (vrDeviceHmdMatrix == nullptr)
    {
        //pushError("Failed to load eye-view matrix!");
        return;
    }

    auto hmdMatrix = vrHmd -> GetEyeToHeadTransform((eye == vre_left) ? vr::Eye_Left : vr::Eye_Right);
    GmMatrix matrix(hmdMatrix);
    matrix.writeToBuffer(buffer);
}

uint8_t VrSystem::vrGetControllerCount()
{
    uint8_t count = 0;
    for (uint8_t i = 0; i < vr::k_unMaxTrackedDeviceCount; ++i)
    {
        if (vrDeviceClasses[i] == vrdc_controller)
            ++count;
    }

    return count;
}

VrControllerData_t VrSystem::vrGetControllerData(uint8_t ind)
{
    VrControllerData_t controllerData;
    vr::VRControllerState_t controllerState;

    uint8_t indexCurrent = 0;
    uint8_t index = vr::k_unMaxTrackedDeviceCount;
        // Grab the appropriate index for our checks:
    for (uint8_t i = 0; i < vr::k_unMaxTrackedDeviceCount; ++i)
    {
        if (vrDeviceClasses[i] == vrdc_controller)
        {
            if (indexCurrent == ind)
            {
                index = i;
                break;
            }
            ++indexCurrent;
        }
    }

        // Invalid index:
    if (index == vr::k_unMaxTrackedDeviceCount)
    {
        pushError("Invalid controller index!");
        return controllerData;
    }

    // If there was an error, we don't update anything:
    if (!vrHmd -> GetControllerState(index, &controllerState, sizeof(vr::VRControllerState_t)))
    {
        pushError("Failed to retrieve controller data!");
        return controllerData;
    }

    // Fill with matrix data:
    GmMatrix matrix(vrDeviceMatrices[index]);
    matrix.writeToBuffer(controllerData.matrix);

    // Check if data has changed:
    if (controllerState.unPacketNum != vrDevicePacketNum[index])
    {
        vrDevicePacketNum[index] = controllerState.unPacketNum;
        controllerData.stateHasChanged = true;
    }

    // Record button data:
    controllerData.btnSystem_Pressed = (controllerState.ulButtonPressed & vr::ButtonMaskFromId(vr::k_EButton_System));
    controllerData.btnApp_Pressed = (controllerState.ulButtonPressed & vr::ButtonMaskFromId(vr::k_EButton_ApplicationMenu));
    controllerData.btnGrip_Pressed = (controllerState.ulButtonPressed & vr::ButtonMaskFromId(vr::k_EButton_Grip));
    controllerData.btnTouchpad_Pressed = (controllerState.ulButtonPressed & vr::ButtonMaskFromId(vr::k_EButton_Axis0));
    controllerData.btnTouchpad_Touched = (controllerState.ulButtonTouched & vr::ButtonMaskFromId(vr::k_EButton_Axis0));

    // Record axis data:
        // Touchpad:
    controllerData.axisXTouchpad_Value = controllerState.rAxis[0].x;
    controllerData.axisYTouchpad_Value = controllerState.rAxis[0].y;

        // Trigger:
    controllerData.axisTrigger_Value = controllerState.rAxis[1].x;

    return controllerData;
}

void VrSystem::vrGenerateTextures()
{
    // Initialize texture for left eye:
    glGenTextures(1, &textureLeftIndex);
    glBindTexture(GL_TEXTURE_2D, textureLeftIndex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_SRGB8_ALPHA8, RENDER_WIDTH, RENDER_HEIGHT, 0,
                 GL_RGBA, GL_UNSIGNED_BYTE, nullptr);

    // Initialize texture for right eye:
    glGenTextures(1, &textureRightIndex);
    glBindTexture(GL_TEXTURE_2D, textureRightIndex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_SRGB8_ALPHA8, RENDER_WIDTH, RENDER_HEIGHT, 0,
                 GL_RGBA, GL_UNSIGNED_BYTE, nullptr);

    // Initialize default rendering color:
    for (uint32_t i = 0; i < RENDER_WIDTH * RENDER_HEIGHT * 4; i += 4)
    {
        textureColorDefault[i] = 24;        // B
        textureColorDefault[i + 1] = 24;    // G
        textureColorDefault[i + 2] = 24;    // R
        textureColorDefault[i + 3] = 255;   // A
    }

    // Push our default color to each eye's texture:
    vrUpdateTextures(textureColorDefault, textureColorDefault);
    vrUpdateDisplay();
}

void VrSystem::vrInitializeDevices()
{
    // Allocate space for each device's matrix transform:
    if (vrDeviceMatrices == nullptr)
    {
        vrDeviceMatrices = new double*[vr::k_unMaxTrackedDeviceCount];
        for (uint32_t i = 0; i < vr::k_unMaxTrackedDeviceCount; ++i)
            vrDeviceMatrices[i] = new double[16];
    }

    // Mark all device slots as "empty"
    for (uint32_t i = 0; i < vr::k_unMaxTrackedDeviceCount; ++i)
        vrDeviceClasses[i] = vrdc_none;
}

void VrSystem::vrUpdateTextures(void* dataLeft, void* dataRight)
{
    // Push the pixel data onto our textures:
    glBindTexture(GL_TEXTURE_2D, textureLeftIndex);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, RENDER_WIDTH, RENDER_HEIGHT, GL_BGRA, GL_UNSIGNED_BYTE, dataLeft);

    glBindTexture(GL_TEXTURE_2D, textureRightIndex);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, RENDER_WIDTH, RENDER_HEIGHT, GL_BGRA, GL_UNSIGNED_BYTE, dataRight);
}

void VrSystem::vrUpdatePoses()
{
    vrDeviceHmdMatrix = nullptr;

    // Record device types and store transformation matrices:
    for (uint32_t i = 0; i < vr::k_unMaxTrackedDeviceCount; ++i)
    {
        if (vrDevicePoses[i].bPoseIsValid)
        {
            // Store matrix for this device:
            GmMatrix matrix(vrDevicePoses[i].mDeviceToAbsoluteTracking);
            matrix.writeToBuffer(vrDeviceMatrices[i]);

            // Determine the device type:
            switch (vrHmd -> GetTrackedDeviceClass(i))
            {
                case vr::TrackedDeviceClass_Controller:
                    vrDeviceClasses[i] = vrdc_controller; break;

                case vr::TrackedDeviceClass_HMD:
                    vrDeviceClasses[i] = vrdc_headset; break;

                case vr::TrackedDeviceClass_TrackingReference:
                    vrDeviceClasses[i] = vrdc_basestation; break;

                    // Any other kind of device we ignore:
                default:
                    vrDeviceClasses[i] = vrdc_none;
            }
        }
    }

    if (vrDevicePoses[vr::k_unTrackedDeviceIndex_Hmd].bPoseIsValid)
        vrDeviceHmdMatrix = vrDeviceMatrices[vr::k_unTrackedDeviceIndex_Hmd];
}

void VrSystem::vrUpdateEvents()
{
    // Empty the queue of all current events:
    while (!vrEventQueue.empty())
        vrEventQueue.pop();

    vr::VREvent_t event;
    while (vrHmd -> PollNextEvent(&event, sizeof(event)))
        vrEventQueue.push(event);
}

void VrSystem::vrUpdateDisplay()
{
    vrErrorCompositor = vr::VRCompositorError_None;

    glClearColor(0., 0., 0., 1.);
    glDisable(GL_MULTISAMPLE);

        // Push left-eye to display:
    vr::Texture_t textureLeft = {};
    textureLeft.eColorSpace = vr::ColorSpace_Gamma;
    textureLeft.eType = vr::TextureType_OpenGL;
    textureLeft.handle = (void*) textureLeftIndex;

    vrErrorCompositor = vr::VRCompositor() -> Submit(vr::Eye_Left, &textureLeft, NULL);
    if (vrErrorCompositor != vr::VRCompositorError_None)
        pushError("Failed to push texture to left eye!");

        // Push right-eye to display:
    vrErrorCompositor = vr::VRCompositorError_None;
    vr::Texture_t textureRight = {};
    textureRight.eColorSpace = vr::ColorSpace_Gamma;
    textureRight.eType = vr::TextureType_OpenGL;
    textureRight.handle = (void*) textureRightIndex;
    vrErrorCompositor = vr::VRCompositor() -> Submit(vr::Eye_Right, &textureRight, NULL);
    if (vrErrorCompositor != vr::VRCompositorError_None)
        pushError("Failed to push texture to right eye!");

    glFlush();

    // Read in new data from WaitGetPoses:
        // NOTE:    WaitGetPoses will freeze the game similar to vsync! This SHOULD be
        //          directly before render, but as it interfaces with GameMaker that is
        //          not a possibility!
    vr::VRCompositor() -> WaitGetPoses(vrDevicePoses, vr::k_unMaxTrackedDeviceCount, nullptr, 0);
    vrUpdatePoses();
}

#endif // VRSYSTEM_H
