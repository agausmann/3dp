$fa = 1;
$fs = 1;

mm = 1;

magnet_dia = 10 * mm;
magnet_height = 3 * mm;

wall_width = 2 * mm;

fm_height = 2 * mm;
fm_width = 20 * mm;

module fridge_magnet()
{
    cylinder(h = fm_height, d = fm_width);
    translate([ 0, 0, fm_height ]) linear_extrude(magnet_height) difference()
    {
        offset(delta = wall_width) circle(d = magnet_dia);
        circle(d = magnet_dia);
    }
}

fridge_magnet();
