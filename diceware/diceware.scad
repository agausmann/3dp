mm = 1;

die_width = 16.2 * mm;
wall_width = 2 * mm;
wall_height = 0.8 * die_width;
window_border = 2 * mm;

module clamshell()
{
    linear_extrude(wall_width) difference()
    {
        offset(delta = wall_width) children(0);
        if ($children > 1)
        {
            children(1);
        }
    }

    translate([ 0, 0, wall_width ]) linear_extrude(wall_height) difference()
    {
        offset(delta = wall_width) children(0);
        children(0);
    }
}

module window()
{
    offset(delta = -window_border) scale(die_width) polygon([ [ 0, 0 ], [ 1, 0 ], [ 1, 1 ], [ 0, 1 ] ]);
}

module diceware_bottom()
{
    clamshell()
    {
        // Base
        children(0);
        // Base Cutouts
        children(1);
    }
}

module diceware_top()
{
    difference()
    {
        clamshell()
        {
            // Base
            offset(delta = wall_width) children(0);

            // Base Cutouts
            children(1);
        }
        // Wall Cutouts
        children(2);
    }
}
