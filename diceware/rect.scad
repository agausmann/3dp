include <diceware.scad>

module rect_base()
{
    scale([ die_width, die_width ]) polygon([ [ 0, 0 ], [ 3, 0 ], [ 3, 2 ], [ 0, 2 ] ]);
}

module rect_windows()
{
    for (x = [0:2])
    {
        for (y = [0:1])
        {
            translate(die_width * [ x, y ]) window();
        }
    }
}

module rect_bottom()
{
    diceware_bottom()
    {
        rect_base();
        rect_windows();
    }
}

module rect_top()
{
    diceware_top()
    {
        rect_base();
        rect_windows();
        translate([ 1.5 * die_width, -2 * wall_width - 0.1 * mm, wall_width + wall_height * 1.5 ]) rotate([ -90, 0, 0 ])
            cylinder(r = wall_height, h = 2 * die_width + 4 * wall_width + 0.2 * mm);
    }
}

rect_bottom();
translate([ 70, 0, 0 ]) rect_top();
