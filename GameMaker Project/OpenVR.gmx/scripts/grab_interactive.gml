///grab_interactive(controller id, position)
/*
    Marks an interactive object as "grabbed".
    
    This is specific to this example. It is not part of the overal system.
 */
 
with (interactiveObj)
{
    if (point_distance_3d(_x, _y, _z, argument1[0], argument1[1], argument1[2]) < _size)
        _selected = argument0;
}

return undefined;
