$fn=50;

// size of the coverglass
coverslip_dims_x = 24;
coverslip_dims_y = 24;
coverslip_dims_z = 0.17;


coverslip_inner_brim_width = 2.5; // support space beneath coverslip edges
coverslip_outer_brim_width = 2.5; // support space beyond coverslip

// dimensions of the base 'slide' -- to fit into a standard holder
base_width = 75; // standard microscope slide = 75
base_depth = 25; // standard microscope slide = 25
base_thickness = 1.5;

// outer well properties - well within which the coverglass sits
well_thickness = 2;
well_height = 5;

// lid and main sample buffer well
lid_height = 10;
lid_gap = 1;    // gap between any side of the lid and the outer well on the slide part

total_sub_wells = 4;
inner_well_thickness = 1.5;
lid_plug_gap = 0.5;       // space between the plug wall and the well wall.
plug_gap_from_sample = 3; // space between bottom of the plug and the **bottom** of the coverslip

lid_seal_thickness = 1;

// magnetic wings
magnet_thickness = 3.2;
magnet_radius = 5.5;


show_coverslip = false; // adds a coverslip to the model -- set to false before you print!
show_cross_section = false; // adds a box to show a cross section -- set to false before you print!

// calculated dims etc

//centering
centre_x = base_width / 2;
centre_y = base_depth / 2;

// coverslip viewing hole
coverslip_hole_x = coverslip_dims_x - 2*coverslip_inner_brim_width;
coverslip_hole_y = coverslip_dims_y - 2*coverslip_inner_brim_width;

// outer well dims
well_width_x = coverslip_dims_x + coverslip_outer_brim_width + 2*well_thickness;
well_width_y = coverslip_dims_y + coverslip_outer_brim_width + 2*well_thickness;
well_hole_x = coverslip_dims_x + coverslip_outer_brim_width;
well_hole_y = coverslip_dims_y + coverslip_outer_brim_width;

lid_width_x = well_width_x - 2*well_thickness - lid_gap;
lid_width_y = well_width_y - 2*well_thickness - lid_gap;

lid_hole_x = coverslip_hole_x; //lid_width_x - 2*lid_thickness;
lid_hole_y = coverslip_hole_y; //lid_width_y - 2*lid_thickness;

lid_thickness_x = (lid_width_x - lid_hole_x)/2;
lid_thickness_y = (lid_width_y - lid_hole_y)/2;


lid_seal_groove_x = lid_hole_x + lid_thickness_x + lid_seal_thickness;
lid_seal_groove_y = lid_hole_y + lid_thickness_y + lid_seal_thickness;

wing_width_y = 3*magnet_radius;
wing_width_x = well_width_x + wing_width_y + wing_width_y;
        
// This module splits up the observation chamber into smaller wells
module lid_wells(num_wells=4,x_bounds=30, y_bounds=30, z_bounds=10,well_gap=3.5,gasket_width=2, outside_penetration) {
    
    // echo(floor(pow(num_wells,0.5)));
    
    num_wells_x = floor(pow(num_wells,0.5));
    num_wells_y = ceil(num_wells / num_wells_x);
    
    //echo(str("wells in x: ",num_wells_x));
    //echo(str("wells in y: ",num_wells_y));
    //echo(str("max x: ",x_bounds));
    //echo(str("max y: ",y_bounds));
    //echo(str("gap: ",well_gap));
    
    sub_well_x = (x_bounds - (num_wells_x-1)*well_gap)/num_wells_x;
    sub_well_y = (y_bounds - (num_wells_y-1)*well_gap)/num_wells_y;
    
    echo(str("well size: ",sub_well_x," mm by ", sub_well_y, " mm"));
    echo(str("well gap: ",well_gap, " mm"));    
    
    well_vol = sub_well_x * sub_well_y * z_bounds;
    echo(str("well area: ", (sub_well_x * sub_well_y)/100," cm2"));
    echo(str("max. volume (without lid): ",well_vol," ul per well"));
    
    if (num_wells > 1) {
    
        union() {
        for (ix = [1:num_wells_x]) {
            for (iy = [1:num_wells_y]) {
                    sub_well_offset_x = (ix-1)*(sub_well_x + well_gap);
                    sub_well_offset_y = (iy-1)*(sub_well_y + well_gap);
                
                    translate([sub_well_offset_x, sub_well_offset_y, -z_bounds])
                    cube([sub_well_x, sub_well_y, 3* z_bounds]);
                }
            }
        
        // gasket strips along x
        for (gx = [1:num_wells_x-1]) {
            gasket_offset_x = gx*(sub_well_x + well_gap) - 0.5*well_gap - 0.5*gasket_width;
            translate([gasket_offset_x, - (0.5*outside_penetration), z_bounds - 0.5*gasket_width])
            cube([gasket_width, y_bounds + outside_penetration, 2* z_bounds]);
            }
        
        // gasket strips along y
        for (gy = [1:num_wells_y - 1]) {
            gasket_offset_y = gy*(sub_well_y + well_gap) - 0.5*well_gap - 0.5*gasket_width;
            translate([-(0.5*outside_penetration), gasket_offset_y, z_bounds - 0.5*gasket_width])
            cube([x_bounds + outside_penetration, gasket_width, 2* z_bounds]);
        }
    }
    } else {
        translate([0, 0, -z_bounds]) cube([x_bounds, y_bounds, 3*z_bounds]);
    }
}

// This module generates a snug-fitting lid with plugs to reduce the buffer volume and limit oxygen ingress
module lid_plugs(num_wells=4,x_bounds=30, y_bounds=30, z_bounds=10,well_gap=3.5,gasket_width=2) {
    
    // echo(floor(pow(num_wells,0.5)));
    
    num_wells_x = floor(pow(num_wells,0.5));
    num_wells_y = ceil(num_wells / num_wells_x);
    
    //echo(str("wells in x: ",num_wells_x));
    //echo(str("wells in y: ",num_wells_y));
    //echo(str("max x: ",x_bounds));
    //echo(str("max y: ",y_bounds));
    //echo(str("gap: ",well_gap));
    
    sub_well_x = (x_bounds - (num_wells_x-1)*well_gap)/num_wells_x - lid_plug_gap;
    sub_well_y = (y_bounds - (num_wells_y-1)*well_gap)/num_wells_y - lid_plug_gap;
    
    //echo(str("well size x: ",sub_well_x));
    //echo(str("well size y: ",sub_well_y));
    //echo(str("well gap: ",well_gap));
    
    well_vol = floor((sub_well_x * sub_well_y * plug_gap_from_sample) + 3.141*z_bounds);
    echo(str("max. volume (with lid): ",well_vol," ul per well"));
    
    if (num_wells > 1) {
    
        difference() {
            union() {
                cube([x_bounds, y_bounds, plug_gap_from_sample]);
                
                for (ix = [1:num_wells_x]) {
                    for (iy = [1:num_wells_y]) {
                            sub_well_offset_x = (ix-1)*(sub_well_x + well_gap + lid_plug_gap) + 0.5*lid_plug_gap;
                            sub_well_offset_y = (iy-1)*(sub_well_y + well_gap + lid_plug_gap) + 0.5*lid_plug_gap;
                        
                            translate([sub_well_offset_x, sub_well_offset_y, 0])
                            cube([sub_well_x, sub_well_y, z_bounds]);
                        }
                    }
                }
            
            // Buffer escape tube ?
            for (cx = [1:num_wells_x]) {
                for (cy = [1:num_wells_y]) {
                        sub_well_offset_x = (cx-1)*(sub_well_x + well_gap + lid_plug_gap) + 0.5*lid_plug_gap + 0.5*sub_well_x;
                        sub_well_offset_y = (cy-1)*(sub_well_y + well_gap + lid_plug_gap) + 0.5*lid_plug_gap + 0.5*sub_well_y;
                    
                        translate([sub_well_offset_x, sub_well_offset_y, -2])
                         cylinder(h=z_bounds+4, r1=1,r2=1);
                    }
                }
                
            // gasket strips along x
            for (gx = [1:num_wells_x-1]) {
                gasket_offset_x = gx*(sub_well_x + well_gap) - 0.5*well_gap - 0.5*gasket_width + lid_plug_gap;
                translate([gasket_offset_x, 0, z_bounds - 0.5*gasket_width])
                cube([gasket_width, y_bounds, z_bounds]);
                }
            
            // gasket strips along y
            for (gy = [1:num_wells_y - 1]) {
                gasket_offset_y = gy*(sub_well_y + well_gap) - 0.5*well_gap - 0.5*gasket_width + lid_plug_gap;
                translate([0, gasket_offset_y, z_bounds - 0.5*gasket_width])
                cube([x_bounds, gasket_width, z_bounds]);
            }
        }
    } else {
        difference() {
            cube([x_bounds, y_bounds, z_bounds]);
            translate([0.5*x_bounds, 0.5*y_bounds, -2])
                cylinder(h=z_bounds+4, r1=1,r2=1);
        }
    }
}

// cross section differencer
difference() {
union() {

// -----------------------------------------------------------------------
// the main chamber
// -----------------------------------------------------------------------

color([0.95,0.35,0.75])
difference() {
    union() {
        
        // the slide base
        cube([base_width,base_depth,base_thickness]);
        
        // the outer well
        translate([centre_x - 0.5*well_width_x , centre_y - 0.5*well_width_y, 0])
            cube([well_width_x, well_width_y, well_height+base_thickness]);
            
        
        // magnetic wings
        translate([centre_x-wing_width_y-0.5*well_width_x,centre_y-(0.5*wing_width_y),0])
            difference() {
                cube([wing_width_x,wing_width_y,well_height+base_thickness]);
                translate([wing_width_x-0.5*wing_width_y,0.5*wing_width_y,well_height+base_thickness - magnet_thickness])
                    cylinder(h=magnet_thickness+1, r1=magnet_radius, r2=magnet_radius);
                translate([0.5*wing_width_y,0.5*wing_width_y,well_height+base_thickness - magnet_thickness])
                    cylinder(h=magnet_thickness+1, r1=magnet_radius, r2=magnet_radius);
            }
 
    }
    
    // main well hole
    translate([centre_x - 0.5*well_width_x + well_thickness, centre_y - 0.5*well_width_y + well_thickness, 0.5*base_thickness]) 
        cube([well_hole_x,well_hole_y,2*well_height]);
    
    // coverslip shallow hole
    translate([centre_x - 0.5*coverslip_dims_x-0.25, centre_y - 0.5*coverslip_dims_x-0.25, (0.5*base_thickness)- coverslip_dims_z])
         union() {
            cube([coverslip_dims_x+0.5,coverslip_dims_y+0.5,2*coverslip_dims_z]); // the dent for the slip
            translate([0,coverslip_dims_y-0.5,0])
               hull() {
                    cylinder(h=1,r1=1,r2=1);
                    translate([1,1,0]) cylinder(h=1,r1=1,r2=1);
                   translate([-1,0,0]) cube([2,2,1]);
                }
        }

    // coverslip viewing hole
    translate([centre_x - 0.5*coverslip_hole_x, centre_y - 0.5*coverslip_hole_y, -base_thickness])
        cube([coverslip_hole_x,coverslip_hole_y,3*base_thickness]);
        
//    // well hole bevel
//      // color([0.75,0.25,0.75, 0.500])
//       translate([0,0,(0.5*base_thickness)- coverslip_dims_z-0.5]) hull() {
//        translate([centre_x - 0.5*coverslip_hole_x, centre_y - 0.5*coverslip_hole_y, 0])
//           cube([coverslip_hole_x,coverslip_hole_y,0.5]);
//       translate([centre_x - 0.55*coverslip_hole_x, centre_y - 0.55*coverslip_hole_y, -1])
//           cube([1.1*coverslip_hole_x,1.1*coverslip_hole_y,0.5]);
//    }
    
    

}


// -----------------------------------------------------------------------
// a fake coverslip
// -----------------------------------------------------------------------
if (show_coverslip) {
     translate([centre_x - 0.5*coverslip_dims_x, centre_y - 0.5*coverslip_dims_x, (0.5*base_thickness)- coverslip_dims_z]) 
        color([0.75,0.75,0.75, 0.5])
        cube([coverslip_dims_x,coverslip_dims_y,coverslip_dims_z]);
}

// -----------------------------------------------------------------------
// the insert
// -----------------------------------------------------------------------

lid_z_offset = 0; // adjust for testing

// remove commenting here to show the insert assembled with the base
//    translate([centre_x*2,0, lid_height+base_thickness + 0.75]);
//    rotate([0,180,0]);

// commenting next line when showing the insert assembled with the base
translate([0,1.5*coverslip_dims_y,0])

color([0.95,0.75,0.25])
difference() {
    
    union() {
        
        
        // outer lid
        translate([centre_x - 0.5*lid_width_x , centre_y - 0.5*lid_width_y,lid_z_offset + 0.5*base_thickness + 0.5])
        cube([lid_width_x, lid_width_y, lid_height]);
    
        
        // magnetic wings
        translate([centre_x-wing_width_y-0.5*well_width_x,centre_y-(0.5*wing_width_y),0])
            difference() {
                hull() {
                    translate([0,-0.5*(lid_width_y-wing_width_y),0]) cube([wing_width_x,lid_width_y, 1]);
                    translate([0,0,lid_height - well_height-1]) cube([wing_width_x,wing_width_y, 1]);
                }
                translate([wing_width_x-0.5*wing_width_y, 0.5*wing_width_y, lid_height - well_height - magnet_thickness])
                    cylinder(h=magnet_thickness+1, r1=magnet_radius, r2=magnet_radius);
                translate([0.5*wing_width_y, 0.5*wing_width_y, lid_height - well_height - magnet_thickness])
                    cylinder(h=magnet_thickness+1, r1=magnet_radius, r2=magnet_radius);
            }
            
            
    }
    
    
    // lid well cutout
    translate([(centre_x - 0.5*lid_width_x) + lid_thickness_x,
               (centre_y - 0.5*lid_width_y) + lid_thickness_y,
                lid_z_offset])
        lid_wells(total_sub_wells,lid_hole_x, lid_hole_y, lid_height + 0.5*base_thickness + 0.5,inner_well_thickness,lid_seal_thickness,lid_thickness_x);


    // gasket channel
    translate([centre_x - 0.5*lid_hole_x - 0.5*lid_thickness_x - 0.5*lid_seal_thickness, 
               centre_y - 0.5*lid_hole_y - 0.5*lid_thickness_y - 0.5*lid_seal_thickness, 
               lid_height - 0.5 * lid_seal_thickness  + 0.5*base_thickness + 0.5])
        difference() {
            //outer gasket
            cube([lid_seal_groove_x,lid_seal_groove_y,2*lid_seal_thickness]);
            //inner gasket (void)
            translate([lid_seal_thickness, lid_seal_thickness, -1])
                cube([lid_seal_groove_x - 2*lid_seal_thickness, lid_seal_groove_y - 2*lid_seal_thickness, 25]);
        }


}


// -----------------------------------------------------------------------
// plugs - reduces exposure of sample buffer to atmosphere
// -----------------------------------------------------------------------

//// remove commenting here to show the insert assembled with the base
//translate([centre_x*2,0, lid_height+ 3* base_thickness + 1])
//rotate([0,180,0])

// commenting next line when showing the insert assembled with the base
translate([0,3*coverslip_dims_y,0])

color([0.15,0.85,0.75])
    // lid plugs
    translate([(centre_x - 0.5*lid_width_x) + lid_thickness_x,
               (centre_y - 0.5*lid_width_y) + lid_thickness_y,
                lid_z_offset])
        lid_plugs(total_sub_wells,lid_hole_x, lid_hole_y, lid_height + 0.5*base_thickness + 0.5,inner_well_thickness,lid_seal_thickness,lid_thickness_x);    



//close of cross section
}
if (show_cross_section) translate([-5,-37.5,-5]) color([1,0,0]) cube([100,50,50]); // cross section block
}
//close of cross section


// some useful information will be displayed in the console window

echo(str("Coverslip viewport = ", coverslip_hole_x, " by ", coverslip_hole_y,  " mm")) ;

outer_well_volume = (well_hole_x * well_hole_y * well_height)/pow(10,3);
echo(str("Outer well size = ", well_hole_x, " mm by ", well_hole_y, " mm by ", well_height, " mm (",outer_well_volume," ml total)")) ;

lid_volume = (lid_hole_x * lid_hole_y * lid_height)/pow(10,3);
echo(str("Inner well size = ", lid_hole_x, " mm by ", lid_hole_y,  " mm by ", lid_height ,"mm (",lid_volume," ml total)")) ;