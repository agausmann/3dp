include <diceware.scad>

module u_base()
{
    scale([ die_width, die_width ])
        polygon([ [ 0, 0 ], [ 3, 0 ], [ 3, 2 ], [ 2, 2 ], [ 2, 1 ], [ 1, 1 ], [ 1, 2 ], [ 0, 2 ] ]);
}

module u_windows()
{
    for (x = [ [ 0, 1 ], [ 0, 0 ], [ 1, 0 ], [ 2, 0 ], [ 2, 1 ] ])
    {
        translate(die_width * x) window();
    }
}

module u_bottom()
{
    diceware_bottom()
    {
        u_base();
        u_windows();
    }
}

module u_top()
{
    diceware_top()
    {
        u_base();
        u_windows();
        translate([ 1.5 * die_width, -2 * wall_width - 0.1 * mm, wall_width + wall_height * 1.5 ]) rotate([ -90, 0, 0 ])
            cylinder(r = wall_height, h = 2 * die_width + 4 * wall_width + 0.2 * mm);
    }
}

u_bottom();
translate([ 70, 0, 0 ]) u_top();
