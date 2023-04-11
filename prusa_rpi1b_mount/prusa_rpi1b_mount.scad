$fs = 0.1;
mm = 1;

board_position = [ 0, 0, 0 ] * mm;
board_size = [ 85, 56.1, 1.6 ] * mm;

board_underside = 4 * mm;

usba_position = [ 75.4, 24.5, 1.7 ] * mm;
usba_size = [ 17, 13.25, 15.25 ] * mm;
usba_face = [ 1, 0, 0 ];

eth_position = [ 65.5, 1.9, 1.65 ] * mm;
eth_size = [ 21.35, 16, 13.5 ] * mm;
eth_face = [ 1, 0, 0 ];

gpio_position = [ 0.65, 49.75, 1.6 ] * mm;
gpio_size = [ 33, 5, 8.8 ] * mm;

usbb_position = [ -1.95, 3.58, 1.6 ] * mm;
usbb_size = [ 7.1, 7.6, 3.0 ] * mm;
usbb_face = [ -1, 0, 0 ];

hdmi_position = [ 37, -1.8, 2.4 ] * mm;
hdmi_size = [ 15.1, 12.5, 5.6 ] * mm;
hdmi_face = [ 0, -1, 0 ];

composite_base_position = [ 41, 45, 1.6 ] * mm;
composite_base_size = [ 10.1, 9.9, 13 ] * mm;

composite_position = [ 46, 53.45, 9.5 ] * mm;
composite_dia = 9 * mm;
composite_depth = 9.5 * mm;

audio_base_position = [ 58.4, 44.75, 1.6 ] * mm;
audio_base_size = [ 12, 11.5, 10 ] * mm;

audio_position = [ 64.25, 56, 8 ] * mm;
audio_dia = 6.6 * mm;
audio_depth = 3.5 * mm;

sd_position = [ -17.5, 18, -3.5 ] * mm;
sd_size = [ 32, 24.5, 3.5 ] * mm;

mounting_holes = [
    [ 25.4, 17.875 ] * mm,
    [ 80, 43.6 ] * mm,
];
mounting_hole_dia = 2.75 * mm;
mounting_hole_outer_dia = 6 * mm;

case_margin = 0.5 * mm;
case_thickness = 1.5 * mm;
case_interior_position = [ -case_margin, -case_margin, -case_margin - board_underside ];
case_interior_size = [ board_size[0] + 2 * case_margin, board_size[1] + 2 * case_margin, 22 * mm + 2 * case_margin ];
case_position = case_interior_position - [ 1, 1, 1 ] * case_thickness;
case_size = case_interior_size + 2 * [ 1, 1, 1 ] * case_thickness;

standoff_width = 3 * mm;
standoff_height = case_thickness + case_margin + board_underside;
standoff_size = [ standoff_width, standoff_width, standoff_height ];

frame_width = 50.5 * mm;
frame_thickness = 6.3 * mm;
clip_thickness = 2 * mm;
clip_standoff_height = 5 * mm;
clip_lip = 1 * mm;
clip_offset = 5 * mm;
clip_width = 40 * mm;
clip_position =
    case_position + [ case_size[0] - clip_width, -clip_offset - clip_standoff_height + clip_thickness, clip_thickness ];
clip_mounting_hole_position = [ 30, 0, 15 ] * mm;
clip_mounting_hole_dia = 3 * mm;

side_led_width = 10 * mm;
side_led_height = 4 * mm;
side_led_position = case_position + [
    case_size[0] - case_thickness - case_margin - side_led_width - 2 * mm, case_size[1] - case_thickness - 1 * mm,
    case_size[2] / 2 -
    side_led_height
];
side_led_size = [ side_led_width, case_thickness + 2 * mm, side_led_height + 1 * mm ];

top_led_width = 10 * mm;
top_led_height = 4 * mm;
top_led_position = case_position + [
    case_size[0] - case_thickness - case_margin - top_led_width - 2 * mm,
    case_size[1] - case_thickness - case_margin - top_led_height - 2 * mm,
    case_size[2] - case_thickness - 1 * mm,
];
top_led_size = [ top_led_width, top_led_height, case_thickness + 2 * mm ];

module rpi1b(connector_tolerance = 0)
{
    sf1 = (1 + connector_tolerance);
    sf2 = connector_tolerance / 2;

    difference()
    {
        translate(board_position - [ 0, 0, board_size[2] * sf2 ]) scale([ 1, 1, sf1 ]) cube(board_size);

        for (h = mounting_holes)
        {
            translate([ h[0], h[1], board_position[2] - 1 ]) cylinder(d = mounting_hole_dia, h = board_size[2] + 2);
        }
    }
    translate(usba_position - usba_size * sf2) cube(usba_size * sf1);
    translate(eth_position - eth_size * sf2) cube(eth_size * sf1);
    translate(gpio_position) cube(gpio_size);
    translate(usbb_position - usbb_size * sf2) cube(usbb_size * sf1);
    translate(hdmi_position - hdmi_size * sf2) cube(hdmi_size * sf1);
    translate(composite_base_position) cube(composite_base_size);
    translate(composite_position) rotate([ -90, 0, 0 ]) cylinder(d = composite_dia * sf1, h = composite_depth);
    translate(audio_base_position) cube(audio_base_size);
    translate(audio_position) rotate([ -90, 0, 0 ]) cylinder(d = audio_dia * sf1, h = audio_depth);
    translate(sd_position - sd_size * sf2) cube(sd_size * sf1);
}

module shell()
{
    difference()
    {
        translate(case_position) cube(case_size);
        translate(case_interior_position) cube(case_interior_size);

        for (h = mounting_holes)
        {
            translate([ h[0], h[1], case_position[2] - 10 ]) cylinder(d = mounting_hole_dia, h = case_size[2] + 20);
        }
    }

    for (h = mounting_holes)
    {
        difference()
        {
            translate([ h[0], h[1], case_position[2] ]) cylinder(d = mounting_hole_outer_dia, h = case_size[2]);
            translate([ h[0], h[1], case_position[2] - 10 ]) cylinder(d = mounting_hole_dia, h = case_size[2] + 20);
        }
    }
}

module rpi_case()
{
    difference()
    {
        shell();
        rpi1b(connector_tolerance = 0.1);
    }

    translate(case_position) cube(standoff_size);
    translate(case_position + [ case_size[0] - standoff_width, 0, 0 ]) cube(standoff_size);
    translate(case_position + [ case_size[0] - standoff_width, case_size[1] - standoff_width, 0 ]) cube(standoff_size);
    translate(case_position + [ 0, case_size[1] - standoff_width, 0 ]) cube(standoff_size);
}

module usb_sd_cut()
{
    polygon([
        [
            case_position[2] + case_size[2] / 2 + 2 * mm,
            case_position[1] + 2 * mm,
        ],
        [
            case_position[2] + case_size[2] / 2,
            case_position[1] + 2 * mm,
        ],
        [
            usbb_position[2] + usbb_size[2],
            usbb_position[1] - 1 * mm,
        ],
        [
            usbb_position[2] + usbb_size[2],
            usbb_position[1],
        ],
        [
            usbb_position[2],
            usbb_position[1] + usbb_size[1],
        ],
        [
            usbb_position[2],
            usbb_position[1] + usbb_size[1] + 2 * mm,
        ],
        [
            sd_position[2] + sd_size[2],
            sd_position[1] - 2 * mm,
        ],
        [
            sd_position[2] + sd_size[2],
            sd_position[1],
        ],
        [
            sd_position[2] + sd_size[2],
            sd_position[1] + sd_size[1],
        ],
        [
            sd_position[2] + sd_size[2],
            sd_position[1] + sd_size[1] + 2 * mm,
        ],
        [
            case_position[2] + case_size[2] / 2,
            case_position[1] + case_size[1] - 2 * mm,
        ],
        [
            case_position[2] + case_size[2] / 2 + 2 * mm,
            case_position[1] + case_size[1] - 2 * mm,
        ],
    ]);
}

module composite_audio_add()
{
    polygon([[case_position [0] + case_size [0] * 0.4, case_position [2] + case_size [2] / 2 - 2 * mm],
             [case_position [0] + case_size [0] * 0.4, case_position [2] + case_size [2] / 2],
             [composite_position [0] - composite_dia / 2 - 2 * mm, composite_position [2]],
             [composite_position [0] + composite_dia / 2 + 4 * mm, composite_position [2]],
             [audio_position [0] - audio_dia / 2 - 4 * mm, audio_position [2]],
             [audio_position [0] + audio_dia / 2 + 2 * mm, audio_position [2]],
             [case_position [0] + case_size [0] * 0.85, case_position [2] + case_size [2] / 2],
             [case_position [0] + case_size [0] * 0.85, case_position [2] + case_size [2] / 2 - 2 * mm],
    ]);
}

module bottom_half_bbox()
{
    difference()
    {
        translate([ -10, -10, -10 ] + case_position)
            cube([ case_size[0] + 20, case_size[1] + 20, 10 + case_size[2] / 2 ]);

        translate([ case_position[0] + 10, 0, 0 ]) rotate([ 0, -90, 0 ]) linear_extrude(20 * mm) usb_sd_cut();
        translate(case_interior_position + [ 1, 1, board_underside + case_margin + 0.5 ])
            cube(case_interior_size - [ 2, 2, board_underside ]);
    }
    translate([ 0, case_position[1] + case_size[1] + 10, 0 ]) rotate([ 90, 0, 0 ]) linear_extrude(20 * mm)
        composite_audio_add();
}

module bottom_half()
{
    intersection()
    {
        difference()
        {
            rpi_case();
            translate(side_led_position) cube(side_led_size);
        }
        bottom_half_bbox();
    }
}

module top_half()
{
    difference()
    {
        rpi_case();
        bottom_half_bbox();
        translate(top_led_position) cube(top_led_size);
    }
}

module clip_profile()
{
    polygon([
        [ 0, 0 ],
        [ frame_width, 0 ],
        [ frame_width, frame_thickness ],
        [ frame_width - clip_lip, frame_thickness ],
        [ frame_width - clip_lip, frame_thickness + clip_thickness ],
        [ frame_width + clip_thickness, frame_thickness + clip_thickness ],
        [ frame_width + clip_thickness, -clip_standoff_height ],
        [ -clip_thickness, -clip_standoff_height ],
        [ -clip_thickness, frame_thickness + clip_thickness ],
        [ clip_lip, frame_thickness + clip_thickness ],
        [ clip_lip, frame_thickness ],
        [ 0, frame_thickness ],
    ]);
}

module clip()
{
    // Plate that attaches to Pi case
    difference()
    {
        translate(case_position - [ 0, clip_offset, 0 ])
            cube([ case_size[0], case_size[1] + clip_offset, clip_thickness ]);

        for (h = mounting_holes)
        {
            translate([ h[0], h[1], case_position[2] - 10 ]) cylinder(d = mounting_hole_dia, h = case_size[2] + 20);
        }
    }

    translate(clip_position) difference()
    {
        rotate([ 180, -90, 0 ]) linear_extrude(clip_width) clip_profile();

        translate(clip_mounting_hole_position + [ 0, clip_standoff_height + 1, 0 ]) rotate([ 90, 0, 0 ])
            cylinder(d = clip_mounting_hole_dia, h = clip_standoff_height + 2);
    }
    translate(case_position + [ 0, clip_thickness - clip_offset, 0 ]) rotate([ 90, 0, 0 ])
        linear_extrude(clip_thickness) polygon([
            [ 0, clip_thickness ],
            [ case_size[0] - clip_width, clip_thickness ],
            [ case_size[0] - clip_width, frame_width + 2 * clip_thickness ],
        ]);
}

bottom_half();
rpi1b();

translate([ 0, -10, 0 ]) rotate([ 180, 0, 0 ])
{
    top_half();
    rpi1b();
}

translate([ 0, -100, 0 ]) rotate([ -90, 0, 0 ]) composite_audio_add();
translate([ -50, 0, 0 ]) rotate([ 0, -90, 0 ]) usb_sd_cut();
translate([ 0, 80, 0 ]) bottom_half_bbox();
translate([ 150, 0, 0 ]) clip();
translate([ 150, 80, 0 ]) rotate([ 180, -90, 0 ]) linear_extrude(clip_width) clip_profile();
