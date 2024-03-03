$fa = 10;
$fs = 0.1;

/* [Basic] */

// Spool external diameter
spool_dia = 55;

// Spool external width
spool_width = 20;

// Number of spools
spool_count = 6;

/* [Advanced] */

// Minimum thickness of divider walls and floor.
wall_thickness = 2;

// Size (diameter) of the wire hole.
wire_hole_dia = 5;

// Vertical position of the wire hole on the base wall.
wire_hole_offset = 10;

// Height of the base walls. Below this height, the divider width is ignored and the whole wall is filled in.
base_height = 20;

// Rounded corner where the divider walls meet the base walls.
cutout_radius = 5;

// Length of exterior divider walls.
external_divider_width = 5;

// Length of interior divider walls.
internal_divider_width = 10;

// Extra space around the given spool sizes
spool_tolerance = 1;

/* [Hidden] */

// Manually overwrite this if you want variable spool widths in a single part.
// For example:
// spool_widths = [50, 30];
spool_widths = [for (i = [1:spool_count]) spool_width];

// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks
function sum(v) = [for (p = v) 1] * v;
function cumsum(v) = [for (a = 0, b = v[0]; a < len(v); a = a + 1, b = b + v[a]) b];

module slot_mold(spool_width)
{
    translate([ wall_thickness, wall_thickness, wall_thickness ])
    {
        cube([
            spool_width + 2 * spool_tolerance,
            spool_dia + 2 * spool_tolerance,
            spool_dia + 2 * spool_tolerance + wall_thickness + 10,
        ]);

        divider_mold(spool_width + 2 * spool_tolerance, external_divider_width);

        translate([ 0, spool_dia + 2 * spool_tolerance + wall_thickness ])
            divider_mold(spool_width + 2 * spool_tolerance, external_divider_width);

        floor_mold(spool_width + 2 * spool_tolerance, external_divider_width);

        translate([ 0.5 * spool_width + spool_tolerance, 0, wire_hole_offset ]) rotate([ 90, 0, 0 ]) difference()
        {
            translate([0, 0, -0.1])
            cylinder(d = wire_hole_dia + 0.5 * wall_thickness, h = wall_thickness + 0.2);
            rotate_extrude() {
                translate([0.5 * wire_hole_dia + 0.25 * wall_thickness, 0.5 * wall_thickness])
                circle(d=wall_thickness);
            }
        }
    }
}

module divider_mold(total_width, divider_width, thickness = wall_thickness)
{
    rotate([ 90, 0, 0 ]) translate([ 0, 0, -0.1 ]) linear_extrude(height = thickness + 0.2) hull()
    {
        translate([ divider_width + cutout_radius, base_height + cutout_radius ]) circle(r = cutout_radius);
        translate([ total_width - divider_width - cutout_radius, base_height + cutout_radius ])
            circle(r = cutout_radius);
        translate([ divider_width, base_height + cutout_radius ])
            square([ total_width - 2 * divider_width, 2 * (wall_thickness + spool_tolerance) + spool_dia ]);
    }
}

module floor_mold(total_width, divider_width)
{
    total_height = spool_dia + 2 * spool_tolerance;
    translate([ 0, 0, -wall_thickness - 0.1 ]) linear_extrude(height = wall_thickness + 0.2) hull()
    {
        translate([ divider_width + cutout_radius, divider_width + cutout_radius ]) circle(r = cutout_radius);
        translate([ total_width - divider_width - cutout_radius, divider_width + cutout_radius ])
            circle(r = cutout_radius);

        translate([ divider_width + cutout_radius, total_height - divider_width - cutout_radius ])
            circle(r = cutout_radius);
        translate([ total_width - divider_width - cutout_radius, total_height - divider_width - cutout_radius ])
            circle(r = cutout_radius);
    }
}

module base_shape(total_size)
{
    // Subtract a copy of the base from the top of the base, to create the self-locating features.
    difference()
    {
        unstacked_base_shape(total_size);
        translate([-wall_thickness, 0, total_size.z - (wall_thickness - 0.5)])
            unstacked_base_shape(total_size + [2 * wall_thickness, 0, 0]);
    }
}

module unstacked_base_shape(total_size)
{
    minkowski() 
    {
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube(total_size - [2 * wall_thickness, 2 * wall_thickness, wall_thickness]);
        chamfer_corner();
    }
}

module chamfer_corner()
{
    rotate([180, 0, 0])
    linear_extrude(height = wall_thickness, scale=0) circle(r=wall_thickness);
}

module stackable_wire_holder_v2()
{
    offsets = cumsum(spool_widths);
    total_width =
        sum(spool_widths) + wall_thickness * (len(spool_widths) + 1) + 2 * spool_tolerance * len(spool_widths);

    total_size = [
        total_width,
        2 * (wall_thickness + spool_tolerance) + spool_dia,
        2 * (wall_thickness + spool_tolerance) + spool_dia,
    ];

    echo(offsets);

    difference()
    {
        base_shape(total_size);
        for (i = [0:len(spool_widths) - 1])
        {
            translate([
                offsets[i] + i * (wall_thickness + 2 * spool_tolerance) - spool_widths[i],
                0,
                0,
            ])
            {
                slot_mold(spool_widths[i]);
            }
        }

        translate([ 0, wall_thickness, wall_thickness ]) rotate([ 0, 0, 90 ])
            divider_mold(spool_dia + 2 * spool_tolerance, internal_divider_width, total_width);
    }
}

stackable_wire_holder_v2();

// translate([ 0, -100, 0 ]) slot_mold(20);
