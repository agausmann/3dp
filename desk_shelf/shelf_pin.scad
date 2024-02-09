$fs = 0.5;
$fa = 1;
mm = 1;
inch = 25.4 * mm;

back_thickness = 5 * mm;
bracket_thickness = 2 * mm;
bracket_depth = 0.5 * inch;
bracket_width = 0.6 * inch;
bracket_height = 1 * inch;
pin_dia = 5.8 * mm; // 6mm hole
pin_height = 0.125 * inch;

hole_dia = 0.27 * inch;

module shelf_pin()
{
    difference()
    {
        cube([ bracket_width, bracket_depth, bracket_height ]);
        translate([ bracket_width / 2, -0.1, bracket_height / 2 ]) rotate([ -90, 0, 0 ])
            cylinder(d = hole_dia, h = back_thickness + 0.2);

        translate([
            bracket_thickness,
            back_thickness,
            bracket_thickness,
        ])
            cube([
                bracket_width - 2 * bracket_thickness,
                bracket_depth,
                bracket_height - 2 * bracket_thickness,
            ]);
    }

    translate([ bracket_width / 2, bracket_depth / 2, bracket_height ]) cylinder(d = pin_dia, h = pin_height);
}

shelf_pin();
