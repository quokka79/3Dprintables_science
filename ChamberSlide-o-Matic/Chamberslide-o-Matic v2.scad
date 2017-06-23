$fn=100;

// size of the coverglass
coverslip_dims_x = 24;
coverslip_dims_y = 24;
coverslip_dims_z = 0.17; // glass thickness


coverslip_inner_brim_width = 2.5; //2.5; // support space beneath coverslip edges
coverslip_outer_brim_width = 2.5; //2.5; // support space beyond coverslip

// dimensions of the base 'slide' -- to fit into a standard holder
base_width = 55; // standard microscope slide = 75
base_depth = 25; // standard microscope slide = 25
base_thickness = 2;

// outer well properties - well within which the coverglass sits
base_well_thickness = 2.0;
base_well_height = 5;

// insert and main sample buffer well
insert_well_height = 5;
insert_gap_with_base = 0.3;    // gap between any side of the lid and the outer well on the slide part

num_insert_wells = 4;
insert_well_thickness = 1.0; // width of the internal walls of the chamber section

// plug-lid
plug_lid_gap_with_insert = 0.5;       // space between the plug wall and the well wall.
plug_gap_from_sample = 2; // space between bottom of the plug and the **bottom** of the coverslip

// gasket properties
gasket_width = 0.7; // width of the gasket channels or gasket ridges. This should be set to a multiple of your nozzle width!
gasket_depth = -0.8;   // positive value = depth of channel cut into insert base, to hold a fitted gasket.
                    //                  Set this to less than the actual thickness of your gasket 
                    //                  to allow some gasket to protrude.
                    // negative value = depth of a ridge protruding from insert base, e.g. to press
                    //                  into a flat gasket sheet.
                    // value of zero =  No ridges or channels flat insert base

gasket_mould_factor = 0.8; // sizing of the channels or ridges relative to the gasket_width value; tweak for best fitting of your actual gaskets.

// magnetic wings
magnet_thickness = 1.5;
magnet_radius = 2.5;

show_coverslip = false; // adds a coverslip to the model -- set to false before you print!
show_gasket = false; // adds a coverslip to the model -- set to false before you print!

// set these to true/false to show/hide the components, e.g. those you wish to print
show_main_chamber = false;
show_insert_chamber = false;
show_plug_lid = false;
show_gasket_mould = true;

show_cross_section_a = false; // adds a box to show a cross section through the long side of the base
show_cross_section_b = false; // adds a box to show a cross section through the short side of the base
show_cross_section_c = false; // adds a box to show a cross section through the gasket mould
cross_section_height_tweak = 1.8 + insert_gap_with_base; // adjust this to change the gap between the assembled components -- helps for display!

// calculated dims etc -- no need to edit anything here!

//centering
centre_x = base_width / 2;
centre_y = base_depth / 2;

// coverslip viewing hole
cslip_access_hole_x = coverslip_dims_x - 2*coverslip_inner_brim_width;
cslip_access_hole_y = coverslip_dims_y - 2*coverslip_inner_brim_width;

gasket_bounds_x = cslip_access_hole_x + coverslip_outer_brim_width;
gasket_bounds_y = cslip_access_hole_y + coverslip_outer_brim_width;

num_wells_x = floor(pow(num_insert_wells,0.5));
num_wells_y = ceil(num_insert_wells / (floor(pow(num_insert_wells,0.5))));

// base well dims
well_width_x = coverslip_dims_x + 2*coverslip_outer_brim_width + 2*base_well_thickness;
well_width_y = coverslip_dims_y + 2*coverslip_outer_brim_width + 2*base_well_thickness;
well_hole_x = coverslip_dims_x + 2*coverslip_outer_brim_width;
well_hole_y = coverslip_dims_y + 2*coverslip_outer_brim_width;

// insert main-well dims
lid_width_x = well_width_x - 2*base_well_thickness - 2*insert_gap_with_base;
lid_width_y = well_width_y - 2*base_well_thickness - 2*insert_gap_with_base;

lid_thickness_x = (lid_width_x - cslip_access_hole_x)/2;
lid_thickness_y = (lid_width_y - cslip_access_hole_y)/2;

wing_width_x = well_width_x + 6*magnet_radius;
wing_width_y = well_width_y + 6*magnet_radius;

// This module generates a gasket grid
module waffle_maker (strut_width=gasket_width, bounds_x=50, bounds_y=50, bounds_z=gasket_depth, n_struts_x=2, n_struts_y=2) {
        union() {
           
           // outer gasket
           difference() {
                  cube([bounds_x, bounds_y, 2*abs(bounds_z)]);
                    translate([strut_width, strut_width, min(0,bounds_z)-1]) {
                        cube([bounds_x - 2*strut_width,
                               bounds_y - 2*strut_width,
                               5*abs(bounds_z)]);
                    }
                }
            
            //inner gaskets                      
            per_x_offset = (bounds_x - strut_width)/n_struts_x;
            per_y_offset = (bounds_y - strut_width)/n_struts_y;
            
            // gasket strips along x
            for (gx = [1:n_struts_x - 1]) {
                translate([gx * per_x_offset, 0, 0])
                    cube([strut_width, bounds_x, 2*abs(bounds_z)]);
                }
            
            // gasket strips along y
            for (gy = [1:n_struts_y - 1]) {
                translate([ 0, gy * per_y_offset, 0])
                    cube([bounds_y, strut_width, 2*abs(bounds_z)]);
            }
        }
    }

// This module generates a gasket grid
module rod_maker (tube_radius=1, bounds_x=20, bounds_y=20, bounds_z=10, n_struts_x=2, n_struts_y=2) {

    //inner gaskets                      
    per_x_offset = (bounds_x - 2*tube_radius)/n_struts_x;
    per_y_offset = (bounds_y - 2*tube_radius)/n_struts_y;

    // gasket strips along x
    for (gx = [1:n_struts_x]) {
        for (gy = [1:n_struts_y]) {
            translate([(gx * per_x_offset) - 0.5*per_x_offset + tube_radius,
                       (gy * per_y_offset) - 0.5*per_y_offset + tube_radius,
                       0])
                cylinder(h=2*abs(bounds_z), r1=tube_radius,r2=tube_radius);
        }
    }
}

// cross section differencer
difference() {
union() {
// -----------------------------------------------------------------------
// the main chamber
// -----------------------------------------------------------------------
if (show_main_chamber) {

   // color([0.95,0.35,0.75])
    difference() {
        
        union() {
            // the end tabs to fit standard microscope stage things
            cube([base_width,base_depth, base_well_height + base_thickness]);

            // magnet base - original plan
            translate([centre_x - 3*magnet_radius - 0.5*well_width_x, centre_y - 0.5 * well_width_y, 0])
                cube([wing_width_x, well_width_y, base_well_height + base_thickness]);
            
//            // magnet base - square plan
//            translate([centre_x - 3*magnet_radius - 0.5*well_width_x, centre_y - 0.5 * wing_width_x, 0])
//                cube([wing_width_x, wing_width_x, base_well_height + base_thickness]);
            
        }
        
        translate([centre_x - 3*magnet_radius - 0.5*well_width_x, centre_y - 0.5 * well_width_y, 0]) {
        
            // magnets left
            translate([0.5*(wing_width_x - well_width_x) - magnet_radius, 0, base_well_height+base_thickness - magnet_thickness]) {
                translate([0,0.15*well_width_y,0]) cylinder(h=magnet_thickness+0.5, r1=magnet_radius, r2=magnet_radius);
                translate([0,0.85*well_width_y,0]) cylinder(h=magnet_thickness+0.5, r1=magnet_radius, r2=magnet_radius);
            }

            // magnets right
            translate([(wing_width_x - 0.5*(wing_width_x - well_width_x)) + magnet_radius, 0, base_well_height + base_thickness - magnet_thickness]) {
                translate([0,0.15*well_width_y,0]) cylinder(h=magnet_thickness+0.5, r1=magnet_radius, r2=magnet_radius);
                translate([0,0.85*well_width_y,0]) cylinder(h=magnet_thickness+0.5, r1=magnet_radius, r2=magnet_radius);
            }
        }
        

        
        // main well hole
        translate([centre_x - 0.5*well_width_x + base_well_thickness, centre_y - 0.5*well_width_y + base_well_thickness, base_thickness]) 
            cube([well_hole_x, well_hole_y, 2*base_well_height]);
        
        // coverslip shallow hole
        translate([centre_x - 0.5*coverslip_dims_x-0.5, centre_y - 0.5*coverslip_dims_x-0.5, 0.5*base_thickness])
             union() {
                cube([coverslip_dims_x+1,coverslip_dims_y+1, 2*base_well_height]); // the dent for the slip
                translate([0,coverslip_dims_y-0.5, -0.25*base_thickness])
                   hull() {
                        cylinder(h=10,r1=2,r2=2);
                        translate([1,1.5,0]) cylinder(h=10,r1=2,r2=2);
                        translate([-2,1.5,0]) cube([2,2,10]);
                    }
            }

        // coverslip viewing hole
        translate([centre_x - 0.5*cslip_access_hole_x, centre_y - 0.5*cslip_access_hole_y, -base_thickness])
           cube([cslip_access_hole_x,cslip_access_hole_y,3*base_thickness]);
    }
}



// -----------------------------------------------------------------------
// a fake coverslip
// -----------------------------------------------------------------------
if (show_coverslip) {
     translate([centre_x - 0.5*coverslip_dims_x, centre_y - 0.5*coverslip_dims_x, (0.5*base_thickness)- coverslip_dims_z]) 
        color([0.75,0.75,0.75, 0.35])
        cube([coverslip_dims_x,coverslip_dims_y,coverslip_dims_z]);
}

// -----------------------------------------------------------------------
// a fake gasket
// -----------------------------------------------------------------------
if (show_gasket) {
     translate([centre_x - 0.5*(cslip_access_hole_x + 2*gasket_width + (coverslip_inner_brim_width - gasket_width)) + 0.5*gasket_width, 
                centre_y - 0.5*(cslip_access_hole_y + 2*gasket_width + (coverslip_inner_brim_width - gasket_width)), 
                (0.5*base_thickness) + coverslip_dims_z]) 
        color([0.2,0.2,0.75, 0.5])
        scale([1,1,0.5]) waffle_maker(strut_width=0.8*gasket_width, bounds_x=gasket_bounds_x, bounds_y=gasket_bounds_y, bounds_z=gasket_depth, n_struts_x=num_wells_x, n_struts_y=num_wells_y);
;
}




// -----------------------------------------------------------------------
// the insert
// -----------------------------------------------------------------------
if (show_insert_chamber) {
// remove commenting here to show the insert assembled with the base
//        translate([centre_x*2, 0, insert_well_height + base_thickness + coverslip_dims_z + 1.75*cross_section_height_tweak])
//        rotate([0,180,0]) {
    
// commenting next line when showing the insert assembled with the base
    translate([0,1.5*coverslip_dims_y,0]) {
       // color([0.95,0.75,0.25,1.0])
        difference() {
            
            union() { // combines a box for the buffer/sample + magnet wings + (optional) raised ridges
                                
                // insert outer box
                outbox_z = insert_well_height - abs(min(1-0.25*gasket_depth,gasket_depth));
                translate([centre_x - 0.5*lid_width_x , centre_y - 0.5*lid_width_y, 0]) {
                    difference() {
                        translate([-0.5*(wing_width_x - lid_width_x), -1, 0]) cube([wing_width_x, lid_width_y+2, base_thickness + magnet_thickness]);
                        
                        translate([(lid_width_x - (cslip_access_hole_x + coverslip_outer_brim_width))/2,
                                   (lid_width_y - (cslip_access_hole_y + coverslip_outer_brim_width))/2,
                                    -outbox_z]) {
                            cube([cslip_access_hole_x + coverslip_outer_brim_width,
                                  cslip_access_hole_y + coverslip_outer_brim_width,
                                  2.5*outbox_z]);
                        }
                    }
                    
                // well walls
                    translate([((lid_width_x - (cslip_access_hole_x + coverslip_outer_brim_width)-2*gasket_width)/2),
                                (lid_width_y - (cslip_access_hole_y + coverslip_outer_brim_width)-2*gasket_width)/2,
                                 0])
                    color([0.95,0.75,0.25,1.0]) waffle_maker(strut_width=base_well_thickness,
                                                                bounds_x=gasket_bounds_x+2*gasket_width,
                                                                bounds_y=gasket_bounds_y+2*gasket_width,
                                                                bounds_z=outbox_z,
                                                                n_struts_x=num_wells_x,
                                                                n_struts_y=num_wells_y);
                    }
                    
                // magnetic base
//                translate([centre_x - 0.5*wing_width_x , centre_y - 0.5*lid_width_y, 0])
//                    cube([wing_width_x, lid_width_y, 2*magnet_thickness]);
    
                // gasket ridges
                if (gasket_depth < 0) {
                    //offset_extra = 1.5*abs(min(0,gasket_depth)); // declarative languages are super annoying.
                    z_offset = insert_well_height + min(0,gasket_depth) + base_thickness + magnet_thickness ;
                    translate([centre_x - 0.5*(cslip_access_hole_x + coverslip_inner_brim_width),
                               centre_y - 0.5*(cslip_access_hole_y + coverslip_inner_brim_width),
                               z_offset]) 
                       waffle_maker(strut_width=gasket_width, bounds_x=gasket_bounds_x, bounds_y=gasket_bounds_y, bounds_z=gasket_depth, n_struts_x=num_wells_x, n_struts_y=num_wells_y);;
                }
                
                //surround to fit main chamber
                    difference() {
                        translate([centre_x - 0.5*(well_hole_x - 2*plug_lid_gap_with_insert),
                                   centre_y - 0.5*(well_hole_y - 2*plug_lid_gap_with_insert),
                                   z_offset])
                            cube([well_hole_x - 2*plug_lid_gap_with_insert, well_hole_y - 2*plug_lid_gap_with_insert, 1.8*outbox_z]);
                        
//                        translate([(lid_width_x - (cslip_access_hole_x + coverslip_outer_brim_width))/2,
//                                   (lid_width_y - (cslip_access_hole_y + coverslip_outer_brim_width))/2,
//                                    -outbox_z]) {
                        translate([centre_x - 0.5*(cslip_access_hole_x + coverslip_outer_brim_width),
                                   centre_y - 0.5*(cslip_access_hole_y + coverslip_outer_brim_width),
                                   z_offset])            
                             cube([cslip_access_hole_x + coverslip_outer_brim_width,
                                  cslip_access_hole_y + coverslip_outer_brim_width,
                                  2.5*outbox_z]);
                      //  }
                    }

            }
        

                
            // Magnet spots    
            translate([centre_x - 3*magnet_radius - 0.5*well_width_x, centre_y - 0.5 * well_width_y, base_thickness]) {
                // magnets left
                translate([0.5*(wing_width_x - well_width_x) - magnet_radius, 0, 0]) {
                      translate([0,0.15*well_width_y,0]) cylinder(h=magnet_thickness+0.5, r1=magnet_radius, r2=magnet_radius);
                      translate([0,0.85*well_width_y,0]) cylinder(h=magnet_thickness+0.5, r1=magnet_radius, r2=magnet_radius);
                }
                // magnets right
                translate([(wing_width_x - 0.5*(wing_width_x - well_width_x)) + magnet_radius, 0, 0]) {
                     translate([0,0.15*well_width_y,0]) cylinder(h=magnet_thickness+0.5, r1=magnet_radius, r2=magnet_radius);
                     translate([0,0.85*well_width_y,0]) cylinder(h=magnet_thickness+0.5, r1=magnet_radius, r2=magnet_radius);
                }
            
            }
                

            // cutout to mate around coverslip 'well'
            translate([centre_x - 0.5*lid_width_x - insert_gap_with_base,
                       centre_y - 0.5*lid_width_y - insert_gap_with_base,
                       insert_well_height + base_thickness]) {
                difference() {
                    cube([well_hole_x, well_hole_y, base_thickness]);
                    translate([0.5*(well_hole_x - (coverslip_dims_x + 1)) + insert_gap_with_base, 
                              0.5*(well_hole_y - (coverslip_dims_y + 1)),
                              -base_thickness])
                        cube([coverslip_dims_x + 1 - 2*insert_gap_with_base, coverslip_dims_y + 1 - 2*insert_gap_with_base, 3*base_thickness]); 
                }
            }


    
        // gasket channel
        if (gasket_depth >= 0) {
            
            offset_extra = 2*abs(min(0,gasket_depth)); // declarative languages are super annoying.
            z_offset = (insert_well_height + 1.5*base_thickness) - gasket_depth - offset_extra;
            translate([centre_x - 0.5*(cslip_access_hole_x + coverslip_inner_brim_width),
                       centre_y - 0.5*(cslip_access_hole_y + coverslip_inner_brim_width),
                       z_offset])
                  waffle_maker(strut_width=gasket_width, bounds_x=gasket_bounds_x, bounds_y=gasket_bounds_y, bounds_z=4*gasket_depth, n_struts_x=num_wells_x, n_struts_y=num_wells_y);
        }
    }
}
}

// -----------------------------------------------------------------------
// plugs - reduces exposure of sample buffer to atmosphere
// -----------------------------------------------------------------------
if (show_plug_lid) {
    //// remove commenting here to show the insert assembled with the base
//    translate([centre_x*1.425,1.2, insert_well_height + 2.5* base_thickness + coverslip_dims_z + insert_gap_with_base + 1.8*cross_section_height_tweak])
//    rotate([0,180,0]) {

plug_height = insert_well_height + 3 - plug_gap_from_sample + abs(min(1-0.25*gasket_depth,gasket_depth)); //+ abs(min(0,gasket_depth)); // + 1.5* base_thickness + 3 - plug_gap_from_sample + abs(min(0,gasket_depth));
    // insert_well_height - abs(min(1-0.5*gasket_depth,gasket_depth));
    // commenting next line when showing the insert assembled with the base
    translate([0,3*coverslip_dims_y,0]) {
        color([0.15,0.85,0.75])
        difference() {
           union() {
                translate([gasket_width-2.5,gasket_width-2.5,0]) cube([gasket_bounds_x+5, gasket_bounds_x+5, 3]);
                translate([0.5,0.5,3]) cube([gasket_bounds_x+gasket_width-0.5, gasket_bounds_y+gasket_width-0.5, plug_height]);
            }

           translate([0,0,3])
            waffle_maker(strut_width=base_well_thickness + plug_lid_gap_with_insert,
                         bounds_x=(gasket_bounds_x + 2*gasket_width + plug_lid_gap_with_insert),
                         bounds_y=(gasket_bounds_y + 2*gasket_width + plug_lid_gap_with_insert),
                         bounds_z=plug_height,
                         n_struts_x=num_wells_x,
                         n_struts_y=num_wells_y);
        
            translate([0,0,-plug_height])
               rod_maker(bounds_x=(gasket_bounds_x + 2*gasket_width + plug_lid_gap_with_insert),
                         bounds_y=(gasket_bounds_y + 2*gasket_width + plug_lid_gap_with_insert),
                         bounds_z=3*plug_height,
                         n_struts_x=num_wells_x,
                         n_struts_y=num_wells_y);
        }
    }
}

// -----------------------------------------------------------------------
// Casting tray - make your own gaskets here in PDMS or 3% agarose!
// -----------------------------------------------------------------------


//close of cross section
}
if (show_cross_section_a) translate([-5,-33,-5]) color([1,0,0]) cube([100,50,50]); // cross section block
if (show_cross_section_b) translate([-18,-5,-5]) color([1,0,0]) cube([0.5*base_width,50,50]); // cross section block
}
//close of cross section


difference() {
if (show_gasket_mould) {
    
    tray_thickness = 3;
    
    wall_height = tray_thickness + abs(gasket_depth);


     // negative mould (for recasting in plaster or something
    rotate([180,0,0]) {
        translate([1.4*coverslip_dims_x,-4.5*coverslip_dims_y,-2*wall_height - tray_thickness]) {
            difference() {
             
     
                // outer mould
                translate([-2,-2,1]) difference() {
                    cube([well_width_x+8, well_width_y+8, 2*wall_height + tray_thickness - 1]);
                }
                     

                // imprint of the original mould
                union() {
        difference() { // make inverse casting mould
            union() {
                
                // base of the tray
                cube([well_width_x+4, well_width_y+4, 3]);
                
                translate([((well_width_x+4 - (cslip_access_hole_x + coverslip_outer_brim_width)-gasket_width)/2),
                        (well_width_y+4 - (cslip_access_hole_y + coverslip_outer_brim_width)-gasket_width)/2,
                        0])
                    cube([gasket_bounds_x+(gasket_width), gasket_bounds_y+(gasket_width), 3.8]);

                 // outer casting wall
                 difference() {
                    cube([well_width_x+4, well_width_y+4, 2*(3+abs(gasket_depth))]);
                    translate([2,2,-0.5*(3+abs(gasket_depth))]) cube([well_width_x, well_width_y, 4*(3+abs(gasket_depth))]);
                    //overflow tube
                    translate([0.5*(well_width_x),-2,abs(gasket_depth)+4]) cube([10,5,5]); //scale([1,1,0.3]) rotate([90,0,0]) cylinder(3,3,5);
                 }

             }
             
             // imprint of sample wells
             translate([((well_width_x+4 - (cslip_access_hole_x + coverslip_outer_brim_width)-2*gasket_width)/2),
                        (well_width_y+4 - (cslip_access_hole_y + coverslip_outer_brim_width)-2*gasket_width)/2,
                        2.5])
                waffle_maker(strut_width=base_well_thickness,
                             bounds_x=gasket_bounds_x+2*gasket_width,
                             bounds_y=gasket_bounds_y+2*gasket_width,
                             bounds_z=5,
                             n_struts_x=num_wells_x,
                             n_struts_y=num_wells_y);
                
                    


       
  
            if (gasket_depth > 0) {
                offset_extra = 3*abs(min(0,gasket_depth)); // declarative languages are super annoying.
                z_offset = (insert_well_height + 1.5*base_thickness) - gasket_depth - offset_extra;
                translate([0.5*((well_width_x+4) - gasket_bounds_x),
                           0.5*((well_width_y+4) - gasket_bounds_y),
                           2.5 - gasket_depth]) 
                    waffle_maker(strut_width=0.9*gasket_width,
                                 bounds_x=gasket_bounds_x,
                                 bounds_y=gasket_bounds_y,
                                 bounds_z=0.9*gasket_depth,
                                 n_struts_x=num_wells_x,
                                 n_struts_y=num_wells_y);
            }
        }
            // gasket ridges
            if (gasket_depth < 0) {
                offset_extra = 3*abs(min(0,gasket_depth)); // declarative languages are super annoying.
                z_offset = (insert_well_height + 1.5*base_thickness) - gasket_depth - offset_extra;
                translate([0.5*((well_width_x+4) - gasket_bounds_x),
                           0.5*((well_width_y+4) - gasket_bounds_y),
                           2.5 - gasket_width]) 
                    waffle_maker(strut_width=1.1*gasket_width,
                                 bounds_x=gasket_bounds_x,
                                 bounds_y=gasket_bounds_y,
                                 bounds_z=1.1*gasket_depth,
                                 n_struts_x=num_wells_x,
                                 n_struts_y=num_wells_y);
            }
        }

        }
    }
}


   
    
    // positive mould for direct casting in rubber
    translate([3.3*coverslip_dims_x, 3*coverslip_dims_y,0]) {
    union() {
        difference() { // make inverse casting mould
            union() {
                
                // base of the tray
                cube([well_width_x+4, well_width_y+4, 3]);
                
                translate([((well_width_x+4 - (cslip_access_hole_x + coverslip_outer_brim_width)-gasket_width)/2),
                        (well_width_y+4 - (cslip_access_hole_y + coverslip_outer_brim_width)-gasket_width)/2,
                        0])
                    cube([gasket_bounds_x+(gasket_width), gasket_bounds_y+(gasket_width), 3.8]);

                 // outer casting wall
                 difference() {
                    cube([well_width_x+4, well_width_y+4, 2*(3+abs(gasket_depth))]);
                    translate([2,2,-0.5*(3+abs(gasket_depth))]) cube([well_width_x, well_width_y, 4*(3+abs(gasket_depth))]);
                    //overflow tube
                    translate([0.5*(well_width_x),-2,abs(gasket_depth)+4]) cube([10,5,5]); //scale([1,1,0.3]) rotate([90,0,0]) cylinder(3,3,5);
                 }

             }
             
             // imprint of sample wells
             translate([((well_width_x+4 - (cslip_access_hole_x + coverslip_outer_brim_width)-2*gasket_width)/2),
                        (well_width_y+4 - (cslip_access_hole_y + coverslip_outer_brim_width)-2*gasket_width)/2,
                        2.5])
                waffle_maker(strut_width=base_well_thickness,
                             bounds_x=gasket_bounds_x+2*gasket_width,
                             bounds_y=gasket_bounds_y+2*gasket_width,
                             bounds_z=5,
                             n_struts_x=num_wells_x,
                             n_struts_y=num_wells_y);
                
                    


       
  
            if (gasket_depth > 0) {
                offset_extra = 3*abs(min(0,gasket_depth)); // declarative languages are super annoying.
                z_offset = (insert_well_height + 1.5*base_thickness) - gasket_depth - offset_extra;
                translate([0.5*((well_width_x+4) - gasket_bounds_x),
                           0.5*((well_width_y+4) - gasket_bounds_y),
                           2.5 - gasket_depth]) 
                    waffle_maker(strut_width=0.9*gasket_width,
                                 bounds_x=gasket_bounds_x,
                                 bounds_y=gasket_bounds_y,
                                 bounds_z=0.9*gasket_depth,
                                 n_struts_x=num_wells_x,
                                 n_struts_y=num_wells_y);
            }
        }
            // gasket ridges
            if (gasket_depth < 0) {
                offset_extra = 3*abs(min(0,gasket_depth)); // declarative languages are super annoying.
                z_offset = (insert_well_height + 1.5*base_thickness) - gasket_depth - offset_extra;
                translate([0.5*((well_width_x+4) - gasket_bounds_x),
                           0.5*((well_width_y+4) - gasket_bounds_y),
                           2.5 - gasket_width]) 
                    waffle_maker(strut_width=1.1*gasket_width,
                                 bounds_x=gasket_bounds_x,
                                 bounds_y=gasket_bounds_y,
                                 bounds_z=1.1*gasket_depth,
                                 n_struts_x=num_wells_x,
                                 n_struts_y=num_wells_y);
            }
            
//        // support rods for coverslip to get the spacing right
//           translate([0.5*((well_width_x+2) - gasket_bounds_x),
//                           0.5*((well_width_y+2) - gasket_bounds_y),
//                           2.85 - gasket_width])            
//            rod_maker(bounds_x=(gasket_bounds_x + 2*gasket_width + plug_lid_gap_with_insert),
//                         bounds_y=(gasket_bounds_y + 2*gasket_width + plug_lid_gap_with_insert),
//                         bounds_z=1.1*gasket_depth,
//                         n_struts_x=num_wells_x,
//                         n_struts_y=num_wells_y);
            
            }
    }
}

// if (show_cross_section_a) translate([-5,-38,-5]) color([0,0,1]) cube([100,50,50]); // cross section block
if (show_cross_section_c) translate([coverslip_dims_x,1.45*coverslip_dims_y,-5]) color([1,0,0]) cube([100,50,50]); // cross section block

}


// some useful information will be displayed in the console window

echo(str("Coverslip viewport = ", cslip_access_hole_x, " by ", cslip_access_hole_y,  " mm")) ;

outer_well_volume = (well_hole_x * well_hole_y * base_well_height)/pow(10,3);
echo(str("Outer well size = ", well_hole_x, " mm by ", well_hole_y, " mm by ", base_well_height, " mm (",outer_well_volume," ml total)")) ;

lid_volume = (cslip_access_hole_x * cslip_access_hole_y * insert_well_height)/pow(10,3);
echo(str("Inner well size = ", cslip_access_hole_x, " mm by ", cslip_access_hole_y,  " mm by ", insert_well_height ,"mm (",lid_volume," ml total)")) ;

echo(str("Wells x = ", num_wells_x, " Wells y = ", num_wells_y)) ;