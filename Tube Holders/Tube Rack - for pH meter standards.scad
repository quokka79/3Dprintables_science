tube_diameter = 30; // mm 50 ml = 30 mm, 15 ml = 16
tube_conical_height = 15;
tube_conical_min = 8;

tube_radius = tube_diameter / 2;

rotating_angle = 0; // tilt the tube this angle away from vertical

z_diff = sin(rotating_angle) * (tube_radius + 2);

use <Antaris_ST_CF.otf>

module maketube() {
difference() {
    
    // tube surround
    translate([0,z_diff,z_diff]) rotate([rotating_angle,0,0]) difference() {
        cylinder(30,tube_radius + 2,tube_radius + 2); // outer wall
        translate([0,0,tube_conical_height]) cylinder(40,tube_radius,tube_radius);    // inner wall
        cylinder(tube_conical_height,tube_conical_min / 2,tube_radius);
    }        

    if (z_diff == 0) {
    // viewing holes
        translate([-5,-25,5]) cube([10,50,15]);
        translate([-25,-5,5]) cube([50,10,15]);
    }
}
}


// Module definition.
// size=30 defines an optional parameter with a default value.
module LetterBlock(letter, size=10) {
            // convexity is needed for correct preview
            // since characters can be highly concave
            linear_extrude(height=size, convexity=4)
                text(letter, 
                     size=size,
                     font="Antaris\\_ST\\_CF:style=Regular",
                     halign="center",
                     valign="center");
}

difference() {        

    // tube holders
    union() {
        translate([tube_radius * 2 + 20,0,0]) maketube();
        translate([0,0,0]) maketube();
        translate([-tube_radius * 2 - 20,0,0]) maketube();
    
        hull() {
            translate([0,0,1]) cube([tube_radius * 12, (tube_radius + 2) * 4,2], true);
            translate([0,0,4]) cube([tube_radius * 9,  (tube_radius + 2) * 2, 2], true);
        }
    }
    
    if (z_diff == 0) {
        union() {
            translate([tube_radius * 2 + 20,0,z_diff]) rotate([rotating_angle,0,0]) cylinder(tube_conical_height,tube_conical_min / 2,tube_radius);
            translate([0,0,z_diff]) rotate([rotating_angle,0,0]) cylinder(tube_conical_height,tube_conical_min / 2,tube_radius);
            translate([-tube_radius * 2 - 20,0,z_diff]) rotate([rotating_angle,0,0]) cylinder(tube_conical_height,tube_conical_min / 2,tube_radius);
        }
    }
    
    // Module instantiation
    translate([-tube_radius * 2 - 20,-25,0]) LetterBlock("4");
    translate([0,-25,0]) LetterBlock("7");
    translate([tube_radius * 2 + 20,-25,0]) LetterBlock("10");
    
    translate([-tube_radius * 2 - 20,25,0]) rotate(180) LetterBlock("4");
    translate([0,25,0]) rotate(180) LetterBlock("7");
    translate([tube_radius * 2 + 20,25,0]) rotate(180) LetterBlock("10");
    
}
   

