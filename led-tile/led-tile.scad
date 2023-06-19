$fa = 1;
$fs = 1;

mm = 1;
m = 1000 * mm;

unit_side = 100 * mm;

joint_radius = 5 * mm;
joint_height = 5 * mm;
wall_width = 2 * mm;

leds_per_meter = 30;
unit_led_length = m / leds_per_meter;

// For a regular n-gon with given side length, compute the distance from the
// center of the n-gon to each vertex.
function vertex_radius(n, side_length) = side_length / (2 * sin(180 / n));

// For a regular n-gon with given side length, compute the distance from the
// center of the n-gon to the midpoint of each side.
function side_radius(n, side_length) = side_length / (2 * tan(180 / n));

module regular_poly(n, side_length)
{
    r = vertex_radius(n, side_length);
    polygon([for (i = [0:n - 1]) r * [ cos(360 * (i + 0.5) / n), sin(360 * (i + 0.5) / n) ]]);
}

module sector(r, a1, a2)
{
    inter_angles = [for (i = [ 0, 0.25, 0.5, 0.75, 1 ]) a1 * i + a2 * (1 - i)];

    intersection()
    {
        circle(r = r);
        polygon([
            [ 0, 0 ],
            for (a = inter_angles) 2 * r * [ cos(a), sin(a) ],
        ]);
    }
}

module led_profile(led_width, led_angle)
{
    min_width = 2 * mm;
    height = led_width * sin(led_angle);
    width = led_width * cos(led_angle);
    outer_width = max(min_width, width);

    polygon([
        [ 0, 0 ],
        [ width, height ],
        [ outer_width, height ],
        [ outer_width, 0 ],
    ]);
}

module led_shelf(led_length, led_width, led_angle)
{
    translate([ 0, led_length / 2, 0 ]) rotate([ 90, 0, 0 ]) linear_extrude(led_length)
        led_profile(led_width, led_angle);
}

module led_tile(n, side_length, front_thickness = 2 * mm, border_width = 8 * mm, num_leds = 2, led_width = 12 * mm,
                led_angle = 60, led_inset = 2 * mm, corner_radius = 20 * mm)
{
    interior_angle = (1 - 2 / n) * 180;

    linear_extrude(front_thickness) difference()
    {
        regular_poly(n, side_length);
        offset(delta = -border_width) regular_poly(n, side_length);
    }

    for (i = [0:n - 1])
    {
        side_angle = 360 * i / n;
        vertex_angle = 360 * (i + 0.5) / n;
        outer_vertex_r = vertex_radius(n, side_length);
        inner_side_r = side_radius(n, side_length) - border_width + led_inset;

        rotate([ 0, 0, side_angle ]) translate([ inner_side_r, 0, front_thickness ])
            led_shelf(num_leds * unit_led_length, led_width, led_angle);

        rotate([ 0, 0, vertex_angle ]) translate([ outer_vertex_r, 0, 0 ])
        {
            linear_extrude(front_thickness) sector(corner_radius, 180 - interior_angle / 2, 180 + interior_angle / 2);
            translate([ 0, 0, front_thickness ]) linear_extrude(joint_height)
                sector(joint_radius, 180 - interior_angle / 2, 180 + interior_angle / 2);
        }
    }
}

module joint_connector()
{
    difference()
    {
        cylinder(h = wall_width + joint_height, r = wall_width + joint_radius);
        translate([ 0, 0, wall_width ]) cylinder(h = joint_height + 0.1, r = joint_radius);
    }
}

module tritri_print()
{
    led_tile(n = 3, side_length = 2 * unit_side, num_leds = 5);
    led_tile(n = 3, side_length = unit_side, num_leds = 2);

    joint_connector();
}

module hexsq_print()
{
    led_tile(n = 6, side_length = unit_side, num_leds = 2);
    led_tile(n = 4, side_length = unit_side, num_leds = 2);
    joint_connector();
}
