mm = 1;
width = 80 * mm;
depth = 20 * mm;
height = 60 * mm;
tilt = 20;
min_thickness = 2 * mm;
base_height = 5 * mm;

module profile()
{
    polygon([
        [depth * cos(tilt) + min_thickness, -base_height],
        [depth * cos(tilt) + min_thickness, depth * sin(tilt)],
        [depth * cos(tilt) + min_thickness, depth * sin(tilt) + min_thickness],
        [depth * cos(tilt), depth * sin(tilt) + min_thickness],
        [depth * cos(tilt), depth * sin(tilt)],
        [0, 0],
        height * [-sin(tilt), cos(tilt)],
        [-height * sin(tilt) - min_thickness, height * cos(tilt)],
        [-height * sin(tilt) - min_thickness, -base_height],
    ]);
}

module phone_stand()
{
    linear_extrude(width) profile();
}

phone_stand();
