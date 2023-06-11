include <diceware.scad>

module zigzag_base()
{
    scale([ die_width, die_width ]) polygon([
        [ 0, 0 ],
        [ 1, 0 ],
        [ 1, 1 ],
        [ 2, 1 ],
        [ 2, 2 ],
        [ 3, 2 ],
        [ 3, 3 ],
        [ 1, 3 ],
        [ 1, 2 ],
        [ 0, 2 ],
    ]);
}

module zigzag_windows()
{
    for (x = [ [ 0, 0 ], [ 0, 1 ], [ 1, 1 ], [ 1, 2 ], [ 2, 2 ] ])
    {
        translate(die_width * x) window();
    }
}

module zigzag_bottom()
{
    diceware_bottom()
    {
        zigzag_base();
        zigzag_windows();
    }
}

module zigzag_top()
{
    diceware_top()
    {
        zigzag_base();
        zigzag_windows();

        translate([ 1.5 * die_width, -2 * wall_width - 0.1 * mm, wall_width + wall_height * 1.5 ]) rotate([ -90, 0, 0 ])
            cylinder(r = wall_height, h = 3 * die_width + 4 * wall_width + 0.2 * mm);
    }
}

zigzag_bottom();
translate([ 60, 0, 0 ]) zigzag_top();
