$fs = 1;
$fa = 2;

mm = 1;
inch = 25.4 * mm;

mast_dia = 42.5 * mm;
leg_dia = 30 * mm;
wall_thickness = 3 * mm;
main_height = 100 * mm;
key_dia = 0.25 * inch;

module qfh_tripod_bracket()
{
    difference()
    {
        linear_extrude(height = main_height) difference()
        {
            circle(d = mast_dia + 2 * wall_thickness);
            circle(d = mast_dia);
        }
        translate([ 0, mast_dia / 2 + wall_thickness + 0.1 * mm, 10 * mm ]) rotate([ 90, 0, 0 ])
            cylinder(d = key_dia, h = mast_dia + 2 * wall_thickness + 0.2 * mm);
    }

    difference()
    {
        for (z_rot = [ 0, 120, -120 ])
        {
            translate([ 0, 0, 20 * mm ]) rotate([ 30, 0, z_rot ]) difference()
            {
                linear_extrude(height = main_height) difference()
                {
                    circle(d = leg_dia + 2 * wall_thickness);
                    circle(d = leg_dia);
                }
                translate([ -leg_dia / 2 - wall_thickness - 0.1 * mm, 0, main_height - 10 * mm ]) rotate([ 0, 90, 0 ])
                    cylinder(d = key_dia, h = leg_dia + 2 * wall_thickness + 0.2 * mm);
            }
        }

        linear_extrude(height = main_height) circle(d = mast_dia);
    }
}

qfh_tripod_bracket();
