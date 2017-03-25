$fn = 50;

tube_diameter = 11; // internal diameter of the rack holes. Use 50 ml = 29 mm, 15 ml = 17 mm, 1.5 ml = 11 mm
tube_well_height = 25;
tube_conical_height = 20;
tube_conical_min = 5;

number = 3;
tube_spacing_factor = 0.3; // gap between tube positions

wall_thickness = 1;

tube_radius = tube_diameter / 2;

rotating_angle = 0; // tilt the tube this angle away from vertical

// calcs for things
z_diff = sin(rotating_angle) * (tube_radius + 2);

tube_gap_width = (tube_spacing_factor * (tube_diameter + wall_thickness + wall_thickness));
tube_spacing = tube_gap_width + tube_diameter + wall_thickness + wall_thickness;

plate_width = tube_spacing * number;
plate_depth = tube_spacing;
plate_thickness = 4;

//use <Antaris_ST_CF.otf>

module maketube() {
difference() {
    
    // tube surround
    translate([0,z_diff,z_diff]) rotate([rotating_angle,0,0]) difference() {
        cylinder(tube_well_height,tube_radius + wall_thickness,tube_radius + wall_thickness); // outer wall
        translate([0,0,tube_conical_height]) cylinder(tube_well_height,tube_radius,tube_radius);    // inner wall
        cylinder(tube_conical_height,tube_conical_min / 2,tube_radius);
    }        

    if (z_diff == 0) {

        // viewing holes
        translate([-tube_radius/3,-plate_depth,plate_thickness]) cube([tube_diameter/3,plate_depth*2,tube_well_height - plate_thickness - (tube_well_height - tube_conical_height)]);
        translate([-plate_depth,-tube_radius/3,plate_thickness]) cube([plate_depth*2,tube_diameter/3,tube_well_height - plate_thickness - (tube_well_height - tube_conical_height)]);
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
        
        for (i = [1:number]) {
           // translate([(i * ((tube_radius + wall_thickness)*2) + (tube_radius + wall_thickness)*2),0,0]) maketube();;
          translate([0.5 * tube_spacing + ((tube_spacing * i) - tube_spacing),plate_depth/2,0]) maketube();;
        }

    
        // foot plate
        hull() {
            translate([0,0,0]) cube([plate_width, plate_depth,1]);   // base
            translate([0.5* (tube_spacing_factor * (tube_diameter + wall_thickness + wall_thickness)),(plate_depth/2)-(tube_radius + wall_thickness),plate_thickness-1]) cube([plate_width - tube_gap_width,  (tube_radius + wall_thickness) * 2, 1]);  // top
        }
    }
    
    if (z_diff == 0) {
        for (i = [1:number]) {
           translate([0.5 * tube_spacing + ((tube_spacing * i) - tube_spacing), plate_depth/2,0]) cylinder(tube_conical_height,tube_conical_min / 2,tube_radius);;
        }
    }
    
}
   

