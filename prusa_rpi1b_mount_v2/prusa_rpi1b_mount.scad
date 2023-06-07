$fs = 0.1;
mm = 1;

///////////////////////////////////////
// Measurements from the CanaKit case.

// Larger diameter of the keyhole opening.
keyhole_real_dia = 6.5 * mm;

// Smaller diameter of the keyhole opening
keyhole_inner_dia = 3.5 * mm;

// Distance between the keyhole and
// the SD card / HDMI edges.
keyhole_start_position = [ 29.5, 35.5, 0 ];

// Spacing between the two keyholes.
keyhole_pitch = [ 36, 0, 0 ] * mm;

keyhole_positions = [for (i = [0:1]) keyhole_start_position + i * keyhole_pitch];

// How far the keyhole goes into the case.
keyhole_depth = 3.8 * mm;

// How much (depth) clearance there is for the head of the mountpoint.
keyhole_head_height = 2 * mm;

// Adjusted dimensions (adding some slack) for the printed heads.
keyhole_dia = keyhole_real_dia - 1 * mm;

///////////////////////////////////////
// 30x30 extrusion dimensions

extrusion_width = 30 * mm;
extrusion_slot_opening_width = 8 * mm;
extrusion_slot_depth = 9 * mm;
extrusion_slot_lip_thickness = 2 * mm;
extrusion_slot_inner_width = 16 * mm;
extrusion_diagonal_thickness = 2.54 * mm;

// How far in (on each edge: bottom/side) the diagonal starts on the inside of
// the slot.
//
// Put another way: Imagine if you extend the bottom and side of the slot to
// meet at a single point at a right angle. The diagonal edge of the slot then
// makes a 45-45-90 triangle with those two edges, and this is the side length
// of those edges of the triangle (except the diagonal).
//
// Datasheets that I've seen specify the diagonal parts in terms of its
// thickness, so I had to do some geometry to come up with a formula for this.
// extrusion_slot_diagonal_inset = extrusion_slot_inner_width / 2 - (extrusion_width / 2 - extrusion_slot_depth) +
//                                extrusion_diagonal_thickness / 2 * sqrt(2);
extrusion_slot_diagonal_inset = 4 * mm;

///////////////////////////////////////
// Part parameters

// Width of the structural elements.
bracket_width = 10 * mm;

// Thickness of the structural elements.
bracket_thickness = 5 * mm;

// How much clearance should there be between the bracket edge and the Pi?
bracket_offset = 5 * mm;

module keyhole()
{
    // Stem, using a convex hull to create a ramp on the bottom side.
    // This will reduce the overhang of the keyhole head to an acceptable level.
    hull()
    {
        cylinder(d = keyhole_inner_dia, h = keyhole_depth + bracket_thickness);
        translate([ (keyhole_dia - keyhole_inner_dia) / 2, 0, 0 ])
            cylinder(d = keyhole_inner_dia, h = keyhole_depth + bracket_thickness);
        translate([ (keyhole_dia - keyhole_inner_dia + keyhole_depth) / 2, 0, 0 ])
            cylinder(d = keyhole_inner_dia, h = bracket_thickness);
    }

    // Head
    translate([ 0, 0, keyhole_depth + bracket_thickness - keyhole_head_height ]) hull()
    {
        cylinder(d = keyhole_dia, h = keyhole_head_height);
    }
}

module extrusion_profile()
{
    polygon([
        [ -extrusion_width / 2, -extrusion_width / 2 ],
        [ -extrusion_width / 2, extrusion_width / 2 ],
        [ -extrusion_slot_opening_width / 2, extrusion_width / 2 ],
        [ -extrusion_slot_opening_width / 2, extrusion_width / 2 - extrusion_slot_lip_thickness ],
        [ -extrusion_slot_inner_width / 2, extrusion_width / 2 - extrusion_slot_lip_thickness ],
        [ -extrusion_slot_inner_width / 2, extrusion_width / 2 - extrusion_slot_depth + extrusion_slot_diagonal_inset ],
        [ -extrusion_slot_inner_width / 2 + extrusion_slot_diagonal_inset, extrusion_width / 2 - extrusion_slot_depth ],
        [ extrusion_slot_inner_width / 2 - extrusion_slot_diagonal_inset, extrusion_width / 2 - extrusion_slot_depth ],
        [ extrusion_slot_inner_width / 2, extrusion_width / 2 - extrusion_slot_depth + extrusion_slot_diagonal_inset ],
        [ extrusion_slot_inner_width / 2, extrusion_width / 2 - extrusion_slot_lip_thickness ],
        [ extrusion_slot_opening_width / 2, extrusion_width / 2 - extrusion_slot_lip_thickness ],
        [ extrusion_slot_opening_width / 2, extrusion_width / 2 ],
        [ extrusion_width / 2, extrusion_width / 2 ],
        [ extrusion_width / 2, -extrusion_width / 2 ],
    ]);
}

module bracket_profile()
{
    polygon([
        [ 0, -bracket_offset - bracket_thickness ],
        [ 0, keyhole_start_position[1] + bracket_width / 2 ],
        [ -bracket_thickness, keyhole_start_position[1] + bracket_width / 2 ],
        [ -bracket_thickness, 0 ],
        [ -bracket_thickness - bracket_offset, -bracket_offset ],
        [ -extrusion_width - bracket_thickness, -bracket_offset ],
        [
            -extrusion_width - bracket_thickness,
            -bracket_offset - bracket_thickness - (extrusion_width - extrusion_slot_opening_width) / 2
        ],
        [
            -extrusion_width - bracket_thickness,
            -bracket_offset - bracket_thickness - (extrusion_width + extrusion_slot_opening_width) / 2
        ],
        [
            -extrusion_width + extrusion_slot_lip_thickness,
            -bracket_offset - bracket_thickness - (extrusion_width + extrusion_slot_opening_width) / 2
        ],
        [
            -extrusion_width + extrusion_slot_lip_thickness,
            -bracket_offset - bracket_thickness - (extrusion_width + extrusion_slot_inner_width) / 2
        ],
        [
            -extrusion_width + extrusion_slot_depth - extrusion_slot_diagonal_inset,
            -bracket_offset - bracket_thickness - (extrusion_width + extrusion_slot_inner_width) / 2
        ],
        [
            -extrusion_width + extrusion_slot_depth - extrusion_slot_diagonal_inset + 2 * mm,
            -bracket_offset - bracket_thickness - (extrusion_width + extrusion_slot_inner_width) / 2 + 2 *
            mm
        ],
        [
            -extrusion_width + extrusion_slot_depth - extrusion_slot_diagonal_inset + 2 * mm,
            -bracket_offset - bracket_thickness - extrusion_width / 2 - 2 *
            mm
        ],
        [
            -extrusion_width, -bracket_offset - bracket_thickness - (extrusion_width - extrusion_slot_opening_width) / 2
        ],
        [ -extrusion_width, -bracket_offset - bracket_thickness ],
    ]);
}

module prusa_rpi1b_mount()
{
    rotate([ 0, 90, 0 ]) linear_extrude(height = keyhole_pitch[0] + bracket_width) bracket_profile();
    translate([ bracket_width / 2, keyhole_start_position[1], 0 ]) keyhole();
    translate([ bracket_width / 2 + keyhole_pitch[0], keyhole_start_position[1], 0 ]) keyhole();
}

prusa_rpi1b_mount();

translate([ -2, -bracket_offset - bracket_thickness - extrusion_width / 2, extrusion_width / 2 ]) rotate([ 90, 0, 90 ])
    extrusion_profile();
