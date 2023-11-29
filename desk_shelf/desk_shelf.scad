mm = 1;
cm = 10 * mm;

u = 25 * mm;

frame_height = 50 * cm;
frame_depth = 35 * cm;
frame_width = 155 * cm;

cubby_width = 40 * cm;

panel_thickness = 1 * cm;

module extrusion_base()
{
    // Very basic model representing T-slot extrusion.
    polygon([
        [ -0.5 * u, -0.5 * u ],

        [ -0.5 * u, -0.1 * u ], [ -0.2 * u, -0.1 * u ], [ -0.2 * u, 0.1 * u ],  [ -0.5 * u, 0.1 * u ],

        [ -0.5 * u, 0.5 * u ],

        [ -0.1 * u, 0.5 * u ],  [ -0.1 * u, 0.2 * u ],  [ 0.1 * u, 0.2 * u ],   [ 0.1 * u, 0.5 * u ],

        [ 0.5 * u, 0.5 * u ],

        [ 0.5 * u, 0.1 * u ],   [ 0.2 * u, 0.1 * u ],   [ 0.2 * u, -0.1 * u ],  [ 0.5 * u, -0.1 * u ],

        [ 0.5 * u, -0.5 * u ],

        [ 0.1 * u, -0.5 * u ],  [ 0.1 * u, -0.2 * u ],  [ -0.1 * u, -0.2 * u ], [ -0.1 * u, -0.5 * u ],
    ]);
}

module extrusion(l)
{
    linear_extrude(l) extrusion_base();
}

module side()
{
    extrusion(frame_height);
    translate([ 0, frame_depth - u, 0 ]) extrusion(frame_height);
    translate([ 0, 0.5 * u, 0.5 * u ]) rotate([ -90, 0, 0 ]) extrusion(frame_depth - 2 * u);
    translate([ 0, 0.5 * u, frame_height - 1.5 * u ]) rotate([ -90, 0, 0 ]) extrusion(frame_depth - 2 * u);
}

module cubby_shelf()
{
    translate([ u, -0.5 * u, -0.5 * u ]) rotate([ -90, 0, 0 ]) extrusion(frame_depth);
    translate([ cubby_width, -0.5 * u, -0.5 * u ]) rotate([ -90, 0, 0 ]) extrusion(frame_depth);

    translate([ 0.5 * u, -0.5 * u, 0 ]) cube([ cubby_width, frame_depth, panel_thickness ]);
}

module desk_shelf()
{
    side();
    translate([ frame_width - u, 0, 0 ]) side();
    translate([ cubby_width + u, 0, 0 ]) side();
    translate([ -0.5 * u, 1 * u, frame_height - 0.5 * u ]) rotate([ 0, 90, 0 ]) extrusion(frame_width);
    translate([ -0.5 * u, frame_depth - 2 * u, frame_height - 0.5 * u ]) rotate([ 0, 90, 0 ]) extrusion(frame_width);

    translate([-0.5 * u, -0.5 * u, frame_height ]) cube([frame_width, frame_depth, panel_thickness]);

    translate([ 0, 0, 16 * cm ]) cubby_shelf();
    translate([ 0, 0, 32 * cm ]) cubby_shelf();
}

desk_shelf();
