///drop_interactive(controller id)
/*
    Marks an interactive object as "dropped".
    
    This is specific to this example. It is not part of the overal system.
 */
 
with (interactiveObj)
{
    if (_selected == argument0)
        _selected = 0;
}
