$fs = 0.5;
$fa = 1;
mm = 1;
inch = 25.4 * mm;

back_thickness = 5 * mm;
clip_thickness = 2 * mm;
width = 10 * mm;
depth = 1 * inch;
height = 1 * inch;

opening_width = 0.2 * inch;

hole_dia = 0.27 * inch;

module cable_interior_base()
{
    translate([back_thickness, clip_thickness])
    square([
        depth - clip_thickness - back_thickness,
        height - 2 * clip_thickness,
    ]);
}

module cable_interior()
{
    offset(r = clip_thickness) offset(delta = -clip_thickness) cable_interior_base();
}

module cable_exterior()
{
    offset(r = 2 * clip_thickness) offset(delta = -clip_thickness) cable_interior_base();
}

module clip_profile()
{
    square([back_thickness, height]);
    square([back_thickness + 2 * clip_thickness, clip_thickness]);
    translate([0, height - clip_thickness])
        square([back_thickness + 2 * clip_thickness, clip_thickness]);
    difference() {
        cable_exterior();
        cable_interior();
    }
}

module shelf_pin()
{
    difference()
    {
        linear_extrude(height = width, convexity = 2) clip_profile();
        translate([ -0.1, height / 2, width / 2 ]) rotate([ 0, 90, 0 ])
            cylinder(d = hole_dia, h = back_thickness + 0.2);
        translate([depth - clip_thickness / 2, height/2, width/2]) rotate([45, 0, 0]) cube([clip_thickness + 0.2, opening_width, 3 * width], center=true);
    }
}

shelf_pin();
