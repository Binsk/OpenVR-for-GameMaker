///vr_pull_event()
/*
    Pulls the next event stored in the system. If there is no event or there
    was an error, undefined will be returned. Otherwise an array of the following format is
    returned:
    
        0   -   [enum: VR_EVENT_TYPE]
        1   -   [enum: VR_EVENT_DETAIL]
        2   -   seconds since event was recieved
        3   -   data
        
    Section 3 (data) changes depending on what is in section 0.
    If section 0 is sub-type controller_button_* then data will contain
    the controller index.
 */
 
if (!global.vive_isrunning)
    return undefined;

var __buffer = buffer_create(4 * 8, buffer_fixed, 8);
external_call(global.vive_external_pullevent, buffer_get_address(__buffer));
var __array = 0;
__array[3] = 0; // Allocate space
buffer_seek(__buffer, buffer_seek_start, 0);

for (var i = 0; i < 4; ++i)
    __array[i] = buffer_read(__buffer, buffer_f64);
    
buffer_delete(__buffer);

// Check if there was an error:
if (__array[0] == -1)
    return undefined;
    
var __returnArray = 0;
__returnArray[3] = 0; // Allocate space

__returnArray[0] = __array[0];
__returnArray[1] = __array[3];
__returnArray[2] = __array[2];
__returnArray[3] = __array[1];

return __returnArray;
