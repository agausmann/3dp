include <diceware.scad>

module line_base()
{
    scale([ die_width, die_width ]) polygon([ [ 0, 0 ], [ 5, 0 ], [ 5, 1 ], [ 0, 1 ] ]);
}

module line_windows()
{
    for (x = [ 0, 1, 2, 3, 4 ])
    {
        translate([ die_width * x, 0 ]) window();
    }
}

module line_bottom()
{
    diceware_bottom()
    {
        line_base();
        line_windows();
    }
}

module line_top()
{
    diceware_top()
    {
        line_base();
        line_windows();
        translate([ 2.5 * die_width, -2 * wall_width - 0.1 * mm, wall_width + wall_height * 1.5 ]) rotate([ -90, 0, 0 ])
            cylinder(r = wall_height, h = die_width + 4 * wall_width + 0.2 * mm);
    }
}

line_bottom();
translate([ 100, 0, 0 ]) line_top();
