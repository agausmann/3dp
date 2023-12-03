$fs = 0.5;
$fa = 1;

mm = 1;

rod_dia = 21.5 * mm;
wall_thickness = 2 * mm;
main_height = 80 * mm;
key_dia = 3.5 * mm;

module tripod_bracket()
{
    difference()
    {
        linear_extrude(height = main_height) difference()
        {
            circle(d = rod_dia + 2 * wall_thickness);
            circle(d = rod_dia);
        }
        translate([ 0, rod_dia / 2 + wall_thickness + 0.1 * mm, 10 * mm ]) rotate([ 90, 0, 0 ])
            cylinder(d = key_dia, h = rod_dia * 2 + wall_thickness + 0.2 * mm);
    }

    difference()
    {
        for (z_rot = [ 0, 120, -120 ])
        {
            translate([ 0, 0, 20 * mm ]) rotate([ 30, 0, z_rot ]) linear_extrude(height = main_height) difference()
            {
                circle(d = rod_dia + 2 * wall_thickness);
                circle(d = rod_dia);
            }
        }

        linear_extrude(height = main_height) circle(d = rod_dia);
    }
}

tripod_bracket();
