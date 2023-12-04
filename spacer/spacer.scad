$fa = 1;
$fs = 0.1;

mm = 1;

height = 10 * mm;
id = 4 * mm;
od = 6 * mm;

module spacer()
{
    linear_extrude(height) difference()
    {
        circle(d = od);
        circle(d = id);
    }
}

spacer();
