$fa = 1;
$fs = 1;
mm = 1;
eps = 0.1 * mm;

battery_size = [ 43.5, 22.1, 97.0 ] * mm;

cup_height = 30 * mm;
cup_margin = 0.1 * mm;
wall_thickness = 2 * mm;

pipe_dia = 21.4 * mm;
key_dia = 3.5 * mm;

module cup()
{
    difference()
    {
        cube([
            battery_size.x + 2 * (cup_margin + wall_thickness),
            battery_size.y + 2 * (cup_margin + wall_thickness),
            cup_height + wall_thickness,
        ]);
        translate([ wall_thickness, wall_thickness, wall_thickness ]) cube([
            battery_size.x + 2 * cup_margin,
            battery_size.y + 2 * cup_margin,
            cup_height + eps,
        ]);
    }
}

module mount()
{
    difference()
    {
        hull()
        {
            cylinder(d = pipe_dia + 2 * wall_thickness, h = cup_height + wall_thickness);
            translate([ -0.5 * pipe_dia - wall_thickness, 0.5 * pipe_dia, 0 ]) cube([
                pipe_dia + 2 * wall_thickness,
                wall_thickness - eps,
                cup_height + wall_thickness,
            ]);
        }
        translate([ 0, 0, -eps ]) cylinder(d = pipe_dia, h = cup_height + wall_thickness + 2 * eps);

        translate([ 0.5 * pipe_dia + wall_thickness + 0.1 * mm, 0, wall_thickness + 0.5 * cup_height ])
            rotate([ 0, -90, 0 ]) cylinder(d = key_dia, h = pipe_dia * 2 + wall_thickness + 0.2 * mm);
    }
}

module battery_holder()
{
    cup();
    translate([ 0.5 * battery_size.x + wall_thickness, -0.5 * (pipe_dia), 0 ]) mount();
}

battery_holder();
