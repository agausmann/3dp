include <diceware.scad>

module house_base()
{
    scale([ die_width, die_width ]) polygon([
        [ 0, 0 ],
        [ 3, 0 ],
        [ 3, 1 ],
        [ 2.5, 1 ],
        [ 2.5, 2 ],
        [ 0.5, 2 ],
        [ 0.5, 1 ],
        [ 0, 1 ],
    ]);
}

module house_windows()
{
    for (x = [ 0, 1, 2 ])
    {
        translate([ die_width * x, 0 ]) window();
    }
    for (x = [ 0, 1 ])
    {
        translate([ die_width * (x + 0.5), die_width ]) window();
    }
}

module house_bottom()
{
    diceware_bottom()
    {
        house_base();
        house_windows();
    }
}

module house_top()
{
    diceware_top()
    {
        house_base();
        house_windows();
        translate([ 1.5 * die_width, -2 * wall_width - 0.1 * mm, wall_width + wall_height * 1.5 ]) rotate([ -90, 0, 0 ])
            cylinder(r = wall_height, h = 2 * die_width + 4 * wall_width + 0.2 * mm);
    }
}

house_bottom();
translate([ 70, 0, 0 ]) house_top();
