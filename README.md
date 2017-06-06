# OpenVR-for-GameMaker
*Read-Me is under works*  
**Summary:** 

This repository is intended to provide the software GameMaker: Studio with HTC Vive support. It uses the OpenVR system for interfacing
with the headset and the provided dll source to interface between OpenVR and GameMaker.

This entire project is compiled with MinGW / GCC and the included C++ project files are in the Code::Blocks format. This is with
the hopes of easing into possible multi-platform support down the road.


**Important Sections:**  
 *   binaries
 *   source


**source**  
The source folder contains both the C++ wrapper source files, along with the libraries it is dependent on, as well as a GameMaker
example that contains the interfacing scripts in order to use the wrapper DLL. The only files inside this folder that are 
*required* in order to get started with this system are the GameMaker script files which can be found in:
source -> GMS 1.4 -> VR Demo.gmx -> scripts

It is highly recommended, however, that you load the actual GameMaker demo file.


**binaries**  
The binaries folder contains the compiled C++ wrapper code required to run VR with GameMaker. Several other DLLs are required
by this DLL and can be found in the source folder with their respective licenses.
