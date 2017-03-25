$fn=100;

internal_width = 84;        // the width of just the comb, in mm (i.e. excluding the ears)

comb_thickness = 1.0;       // Thickness of each lane well (each comb 'tooth') in mm
comb_height = 12.0;         // Height of each comb tooth in mm (or the depth of each well in the gel)

sample_lanes = 6;           // the number of lanes on the comb. Their width will adjust to fit evenly across the comb.
lane_spacing_width = 2;     // the gap in mm between each lane segment.
fixed_ladder_lanes = true;  // add lanes at each end for ladder (fixed width).
                            // Set this to true if you have very wide lanes and don't want to waste ladder in them.
                            // Set this to false and you'll have just the sample lanes across the comb.
                            
body_height = 13.5;         // Height of the main 'body' part of the comb (the top section above the teeth)

module combs(number, spacing, ladderlane=false) {

    if (ladderlane) {
        
        ladder_width = 6.5; // in mm
        
        width = ((internal_width - (2 * ladder_width + 2 * spacing)) - ((number - 1) * spacing)) / number ;
        
        // Left ladder lane
        cube([ladder_width, comb_height + 1, comb_thickness]);
        
        // dispense the sample lanes
        for (i = [1:number]) {
            translate([(0 - width + ladder_width) + (i * (width + spacing)), 0, 0]) cube([width, comb_height + 1, comb_thickness]);
        }
        
        // Right ladder lane
        translate([(internal_width - ladder_width),0,0]) cube([ladder_width, comb_height + 1, comb_thickness]);
        
     
    } else {
        
        // dispense the sample lanes
        width = (internal_width - ((number - 1) * spacing)) / number;

        for (i = [1:number]) {
            translate([(0 - width - spacing) + (i * (width + spacing)), 0, 0]) cube([width, comb_height + 1, comb_thickness]);
        }
    }
}

module grab_bar(length, height, thickness) {
     
    dimple_size = height / 5;
    dimple_x_spacing = length / 8;
    dimple_y_spacing = height / 5;
       
    union() {
        
        // Grab-bar
        hull() {
            translate([0, 2, thickness]) cube([length, height - 4, 0.5]);  // Grab-bar top surface
            cube([length, height, 0.5]); // Grab-bar lower surface
        }

        // grab bar dimples
        for (i = [1:7]) {
            translate([(i * dimple_x_spacing), 2 * dimple_y_spacing, thickness - 0.15 * dimple_size]) scale([1, 1, 0.7]) sphere(r = dimple_size);
        }
        for (i = [1:6]) {
            translate([(i * dimple_x_spacing) + 0.5 * dimple_x_spacing, 3 * dimple_y_spacing, thickness-0.15 * dimple_size]) scale([1, 1, 0.7]) sphere(r = dimple_size);
        }
        
    }
}

// Make the main comb body
translate([0, comb_height, 0]) union() {
    cube([internal_width, body_height, comb_thickness]); // standard comb-plate dims 13.5 mm high
    translate([-2, (body_height - (0.75 * body_height)) / 2, 0]) grab_bar(internal_width+4, 0.75 * body_height, 5); // adds a grab-bar to reinforce the comb and make it easier to remove.
}

// add the tabs on each side. These fit into the cutouts (up to 3 mm thick) on the casting tray.
hull () {  // left ear
    translate([-8, comb_height, 0]) cube([8, body_height, comb_thickness]);
    translate([-8, comb_height, 2]) cube([6, body_height, 1]);
}
hull () { // right ear
    translate([internal_width, comb_height, 0]) cube([8, body_height, comb_thickness]);
    translate([internal_width + 2, comb_height, 2]) cube([6, body_height, 1]);
}

// add the combs - number of combs, their spacing, and an optional ladder-lane (e.g if you have super-wide lanes and wish to save on ladder!)
 combs(sample_lanes, lane_spacing_width, fixed_ladder_lanes);