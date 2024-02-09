mm = 1;
inch = 25.4 * mm;

length = 200 * mm;
slot_width = 10 * mm;
slot_pitch = 20 * mm;

thickness = 2 * mm;
total_width = 1 * inch;
total_height = 1 * inch;

module tslot_insert()
{
    polygon(points = [
        [-thickness, 3],
        [-thickness, -3],
        [0, -3],
        [6, 2],
        [6, 4],
        [4, 6],
        [2, 6],
        [2, 3],
    ], convexity = 2);
}


module cable_raceway()
{
    cube([length, total_width, thickness]);
    cube([length, thickness, 0.5 * inch + 3 * mm]);

    for (i=[0:(length / slot_pitch) - 1])
    {
        translate([i * slot_pitch, total_width - thickness, 0]) cube([slot_pitch - slot_width, thickness, total_height - slot_width / 2]);
    }

    translate([length, 0, 0.5 * inch])
    rotate([90, 0, -90])
    linear_extrude(length) tslot_insert();
}

cable_raceway();
// translate([0, -50]) tslot_insert();
