# OpenVR-for-GameMaker
*Read-Me is under works*  
**Summary:** 

This repository is intended to provide the software GameMaker: Studio with HTC Vive support. It uses the OpenVR system for interfacing with the headset and the provided dll source to interface between OpenVR and GameMaker.

This entire project is compiled with MinGW / GCC and the included C++ project files are in the Code::Blocks format. This is with
the hopes of easing into possible multi-platform support down the road.

**Getting Things Running:**     

In order to get a working project going you need several files:
*   GameMaker script files from the example project
*   GMVive Wrapper.dll
*   SDL2.dll
*   openvrapi.dll
*   glew.dll

You can find the GameMaker script files inside the example GameMaker project located in *source -> GMS 1.4 -> OpenVR Demo*.
The GMVive Wrapper.dll is located in the binaries folder.
All remaining DLLs are located in their respective library folders in *source -> CPP -> GMVive Wrapper -> libraries

While my GameMaker scripts and the GMVive Wrapper.dll and source is covered by the MIT license the other libraries each come with their own licenses and have been included.

NOTE: The GameMaker example project *does not* include the necessary DLLs to run. If you wish to run the example make sure you add all the listed DLLs to the project as included files before attempting to run it.

**Important Sections:**  
 *   binaries
 *   source


**source**  
Contains the GameMaker and C++ source wrapper files / projects as well as the necessary 3rd party libraries and their licenses. 


**binaries**  
Contains compiled binaries of the C++ wrapper DLL for those who do not have the necessary C++ tools and compiler installed.
