$fa = 5;
$fs = 0.2;

module base()
{
    import("Wire organizer.stl", convexity = 8);
}

module walls()
{
    projection(cut = true) translate([ 0, 0, -40 ]) base();
}

module chamfer()
{

    translate([3, 3, 0]) minkowski() 
    {
        cube([159, 56, 65]);
        chamfer_corner();
    }
}

module chamfer_corner()
{
    translate([0, 0, 2]) rotate([180, 0, 0])
    linear_extrude(height = 2, scale=0) circle(r=2);
}

module stackable_wire_holder()
{
    intersection() 
    {
        difference()
        {
            union()
            {
                base();
                // Extend the walls to a total of 65mm
                translate([ 0, 0, 40 ]) linear_extrude(height = 25) walls();
            }

            translate([0, 0, 63.5]) chamfer();

        }
        chamfer();

    }
}

stackable_wire_holder();
