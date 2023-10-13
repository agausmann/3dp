mm = 1;
cm = 10 * mm;
m = 1000 * mm;
TAU = 2 * PI;

cable_dia = 4 * mm;
cable_length = 2 * m;
bend_dia = 40 * mm;

wall_thickness = 2 * mm;

helix_twist = cable_length / (bend_dia * PI);
helix_twist_degrees = helix_twist * 360;
helix_pitch = cable_dia + wall_thickness;
helix_height = helix_twist * helix_pitch;
helix_outer_dia = bend_dia + 2 * cable_dia;

steps_per_revolution = 72;
steps_per_pitch = 32;

module thread()
{
    layers = ceil(steps_per_pitch * helix_twist);
    points = concat(
        [
            for (i_t = [0:steps_per_revolution])
            let(
                angle = 360 * i_t / steps_per_revolution
            )
            [cos(angle), sin(angle), 0]
        ],
        [
            for (i_z = [0:layers]) each
            let(
                height = helix_pitch * i_z / steps_per_pitch
            )
            [
                for (i_t = [0:steps_per_revolution])
                let(
                    angle = 360 * i_t / steps_per_revolution,
                    r = 3 + sin(360 * (i_z / steps_per_pitch) + angle)
                )
                [r * cos(angle), r * sin(angle), height]
            ]
        ],
        [
            for (i_t = [0:steps_per_revolution])
            let(
                angle = 360 * i_t / steps_per_revolution
            )
            [cos(angle), sin(angle), layers / steps_per_pitch * helix_pitch]
        ]
    );

    faces = concat(
        [
            for (i_z = [1:layers + 2]) each
            [
                for (i_t = [1:steps_per_revolution])
                [
                    (i_z - 1) * (steps_per_revolution + 1) + (i_t - 1),
                    (i_z - 1) * (steps_per_revolution + 1) + i_t,
                    i_z * (steps_per_revolution + 1) + i_t,
                    i_z * (steps_per_revolution + 1) + (i_t - 1),
                ]
            ]
        ],
        [
            for (i_t = [1:steps_per_revolution])
            [
                0 * (steps_per_revolution + 1) + (i_t - 1),
                0 * (steps_per_revolution + 1) + i_t,
                (layers + 2) * (steps_per_revolution + 1) + i_t,
                (layers + 2) * (steps_per_revolution + 1) + (i_t - 1),
            ]
        ]
    );
    polyhedron(points, faces, ceil(helix_twist));
}

thread();
