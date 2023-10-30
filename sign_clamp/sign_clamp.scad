$fa = 1;
$fs = 1;

mm = 1;
inch = 25.4 * mm;

pole_dia = 26 * mm;
min_thickness = 2 * mm;

// For M3
screw_dia = 3.3 * mm;
nut_dia = 6.01 * mm;
nut_height = 3 * mm;

sign_size = [5.1, 3.6] * inch;

total_thickness = pole_dia / 2 + min_thickness;
screw_x_pitch = pole_dia + 2 * min_thickness + screw_dia;
screw_y_pitch = sign_size[1] - 2 * min_thickness - nut_dia;

module sign_clamp()
{
    difference()
    {
        cube([sign_size[0], sign_size[1], total_thickness]);

        translate([sign_size[0] / 2, -0.1, total_thickness])
            rotate([-90, 0, 0])
                cylinder(d=pole_dia, h=sign_size[1] + 0.2);

        for (dx = [-0.5, 0.5])
        {
            for (dy = [-0.5, 0.5])
            {
                translate([sign_size[0] / 2 + dx * screw_x_pitch, sign_size[1] / 2 + dy * screw_y_pitch, -0.1])
                {
                    cylinder(d=screw_dia, h=total_thickness + 0.2);
                    linear_extrude(height=nut_height + 0.1)
                    polygon([
                        for (a = [0:5]) nut_dia / 2 * [cos(a * 60), sin(a * 60)]
                    ]);
                }
            }
        }
    }
}

sign_clamp();
