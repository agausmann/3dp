    // Axes correspond to the printer axes.

mm = 1;
$fs = 0.1;
epsilon = 0.01 * mm;

motor_screw_to_edge = 5.6 * mm;
motor_screw_clearance = 3.6 * mm;

motor_bracket_to_edge = 28 * mm;
motor_mount_thickness = 10 * mm;

motor_mount_lip_width = 2 * mm;
motor_mount_lip_height = 2 * mm;

motor_width = 42.2 * mm;
edge_to_shaft = motor_width / 2;
motor_shaft_clearance = 31 * mm;

motor_mount_total_width = motor_bracket_to_edge + motor_mount_lip_width;
motor_mount_total_thickness = motor_mount_thickness + motor_mount_lip_height;

motor_edge_to_lens = [ 0, -75, -10 ] * mm;
lens_to_base = [ 0, 0, -28 ] * mm;
// oops I should refactor this a bit
lens_to_base_x = -35 * mm;
mounting_screw_clearance = 6.2 * mm;

motor_to_camera_base = motor_edge_to_lens + lens_to_base;

camera_bracket_width = 20 * mm;
camera_bracket_thickness = 5 * mm;
camera_base_width = 45.3 * mm;
camera_lip = [ 6.2 * mm, camera_base_width, 7.5 * mm ];
brace_height = 35 * mm;
brace_length = 45 * mm;
brace_thickness = 10 * mm;

// Measurements for camera clearance
camera_total_width = 94 * mm;
camera_total_height = 43 * mm;
camera_total_depth = 25 * mm;
camera_overhang = 8 * mm;

module motor_mount()
{

    difference()
    {
        // Base shape
        cube([ motor_bracket_to_edge, motor_bracket_to_edge, motor_mount_thickness ]);

        // Cutout for motor shaft
        translate([ edge_to_shaft, edge_to_shaft, -epsilon ])
        {
            // Motor shaft clearance
            cylinder(h = motor_mount_thickness + 2 * epsilon, d = motor_shaft_clearance);

            // Additional cuts to make the cutout a rounded L-shape,
            // instead of a cut-off circle.
            translate([ -motor_shaft_clearance / 2, 0, 0 ])
                cube([ motor_shaft_clearance, motor_shaft_clearance / 2, motor_mount_thickness + 2 * epsilon ]);
            translate([ 0, -motor_shaft_clearance / 2, 0 ])
                cube([ motor_shaft_clearance / 2, motor_shaft_clearance, motor_mount_thickness + 2 * epsilon ]);
        }

        // Screw hole for mounting
        translate([ motor_screw_to_edge, motor_screw_to_edge, -epsilon ])
            cylinder(h = motor_mount_thickness + 2 * epsilon, d = motor_screw_clearance);
    }

    // Lip for alignment using edge of motor housing
    translate([ -motor_mount_lip_width, -motor_mount_lip_width, -motor_mount_lip_height ])
    {
        cube([ motor_mount_total_width, motor_mount_lip_width, motor_mount_total_thickness ]);
        cube([ motor_mount_lip_width, motor_mount_total_width, motor_mount_total_thickness ]);
    }
}

module brace()
{
    rotate([ 90, 0, -90 ]) linear_extrude(brace_thickness) polygon([
        [ brace_length, 0 ],
        [ 0, brace_height ],
        [ 0, brace_height - brace_thickness * sqrt(pow(brace_length, 2) + pow(brace_height, 2)) / brace_length ],
        [ brace_length - brace_thickness * sqrt(pow(brace_length, 2) + pow(brace_height, 2)) / brace_height, 0 ],
    ]);
}

module prusa_i3_x_camera()
{

    translate([ motor_mount_lip_width, motor_mount_thickness, 0 ]) rotate([ 90, 0, 0 ]) motor_mount();
    translate([ 0, 0, motor_to_camera_base[2] ])
    {
        cube([ camera_bracket_width, camera_bracket_thickness, abs(motor_to_camera_base[2]) ]);
        translate([ brace_thickness, 0, 0 ]) brace();
    }
    translate(motor_to_camera_base - [ 0, camera_base_width / 2, camera_bracket_thickness ])
    {
        difference()
        {
            cube([
                camera_bracket_width, abs(motor_to_camera_base[1]) + camera_base_width / 2 + camera_bracket_thickness,
                camera_bracket_thickness
            ]);
            translate([ camera_bracket_width / 2, camera_base_width / 2, -epsilon ])
                cylinder(d = mounting_screw_clearance, h = camera_bracket_thickness + 2 * epsilon);
        }
    }
}

module camera_model()
{
    translate(motor_to_camera_base +
              [ camera_bracket_width / 2 - lens_to_base_x - camera_total_depth, -camera_total_width / 2, 0 ])
        cube([ camera_total_depth, camera_total_width, camera_total_height ]);
}

prusa_i3_x_camera();
// camera_model();
