tube_diameter = 30; // mm 50 ml = 30 mm, 15 ml = 16
tube_conical_height = 15;
tube_conical_min = 8;

tube_radius = tube_diameter / 2;

rotating_angle = 0; // tilt the tube this angle away from vertical

z_diff = sin(rotating_angle) * (tube_radius + 2);

difference() {
union() {
            // foot
    difference() {
            cylinder(5,tube_radius * 2,tube_radius + 2);
            translate([0,0,-2])cylinder(2,tube_radius * 2,tube_radius * 2);
            translate([0,0,z_diff]) rotate([rotating_angle,0,0]) cylinder(tube_conical_height,tube_conical_min / 2,tube_radius);

    }



    translate([0,z_diff,z_diff]) rotate([rotating_angle,0,0]) difference() {
        cylinder(30,tube_radius + 2,tube_radius + 2); // outer wall
        translate([0,0,tube_conical_height]) cylinder(40,tube_radius,tube_radius);    // inner wall
        cylinder(tube_conical_height,tube_conical_min / 2,tube_radius);
    }
}

translate([-5,-25,5]) cube([10,50,15]);
            translate([-25,-5,5]) cube([50,10,15]);

}