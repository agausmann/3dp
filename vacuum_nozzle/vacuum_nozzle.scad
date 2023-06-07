$fn = 100;
mm = 1;
e = 2.71828;
eps = 0.1 * mm;

attachment_outer_dia = 34.5 * mm;
attachment_height = 35 * mm;
wall_width = 2 * mm;

taper_height = 120 * mm;
nozzle_width = 15 * mm;
nozzle_angle = 45;

attachment_inner_dia = attachment_outer_dia - 2 * wall_width;
total_height = attachment_height + taper_height;

taper_steps = 20;

function taper_point(x, y) = [
    x * taper_height, y *(nozzle_width / 2 + (attachment_outer_dia - nozzle_width) / 2 * (e ^ -(6 * x)))
];

module taper_profile()
{
    taper_points = [
        for (i = [0:taper_steps]) taper_point(i / taper_steps, 1),
        for (i = [0:taper_steps]) taper_point((taper_steps - i) / taper_steps, -1),
    ];
    echo(taper_points);
    polygon(taper_points);
}

module nozzle()
{
    difference()
    {
        intersection()
        {
            translate([ attachment_outer_dia / 2, 0, 0 ]) rotate([ 0, -90, 0 ]) linear_extrude(attachment_outer_dia)
                taper_profile();
            cylinder(d = attachment_outer_dia, h = taper_height);
        }
        intersection()
        {
            translate([ attachment_inner_dia / 2, 0, 0 ]) rotate([ 0, -90, 0 ]) linear_extrude(attachment_inner_dia)
                offset(r = -wall_width)
            {
                taper_profile();
                translate([ -wall_width - eps, -attachment_outer_dia / 2 ])
                    square([ wall_width + 2 * eps, attachment_outer_dia ]);
                translate([ taper_height - eps, -nozzle_width / 2 ]) square([ wall_width + 2 * eps, nozzle_width ]);
            }
            cylinder(d = attachment_inner_dia, h = taper_height);
        }

        translate([ -attachment_outer_dia / 2, 0, taper_height ]) hull()
        {
            translate([ wall_width, -attachment_outer_dia / 2, 0 ])
                cube([ wall_width, attachment_outer_dia, taper_height ]);
            translate([
                attachment_outer_dia, -attachment_outer_dia / 2,
                -(attachment_outer_dia - wall_width) * tan(nozzle_angle)
            ]) cube([ wall_width, attachment_outer_dia, taper_height ]);
        }
    }
}

module vacuum_nozzle()
{
    linear_extrude(attachment_height) difference()
    {
        circle(d = attachment_outer_dia);
        circle(d = attachment_inner_dia);
    }
    translate([ 0, 0, attachment_height ]) nozzle();
}

vacuum_nozzle();
