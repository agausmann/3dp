include <diceware.scad>

module plus_base()
{
    scale([ die_width, die_width ]) polygon([
        [ 1, 1 ],
        [ 1, 0 ],
        [ 2, 0 ],
        [ 2, 1 ],
        [ 3, 1 ],
        [ 3, 2 ],
        [ 2, 2 ],
        [ 2, 3 ],
        [ 1, 3 ],
        [ 1, 2 ],
        [ 0, 2 ],
        [ 0, 1 ],
    ]);
}

module plus_windows()
{
    for (x = [ [ 1, 0 ], [ 0, 1 ], [ 1, 1 ], [ 1, 2 ], [ 2, 1 ] ])
    {
        translate(die_width * x) window();
    }
}

module plus_bottom()
{
    diceware_bottom()
    {
        plus_base();
        plus_windows();
    }
}

module plus_top()
{
    diceware_top()
    {
        plus_base();
        plus_windows();
        translate([ 1.5 * die_width, -2 * wall_width - 0.1 * mm, wall_width + wall_height * 1.5 ]) rotate([ -90, 0, 0 ])
            cylinder(r = wall_height, h = 3 * die_width + 4 * wall_width + 0.2 * mm);
    }
}

plus_bottom();
translate([ 70, 0, 0 ]) plus_top();
