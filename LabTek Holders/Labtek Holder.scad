$fn=100;

include_lattice = false; // a lattice can help with support but it is more annoying to move between wells with an immersion objective

difference() {
  
    // Main body
    union() {
       cube([25,75,1.5],true);                    
       translate([-15,0,3]) rotate([0,90,0]) scale([0.25, 1.5, 1]) cylinder(30,15,15);
       translate([0,0,2]) cube([30,65,6],true);
    }
    
    //cut out gaps at ends
    translate([0,0,3.5]) cube([15,75,5],true);

//    // bevelled base - can help for small working distance objectives but overhangs are more difficult to print
//    translate([0,0,-3]) hull() {
//        translate([0,0,0]) cube([50,85,1],true); // Bottom dims
//        translate([0,0,2]) cube([20,50,1],true); // Top dims
//    }
    
    // finger grips
    translate([29,0,0]) cylinder(15,15,15,true);
    translate([-29,0,0]) cylinder(15,15,15,true);
    translate([0,43,0]) cylinder(10,10,10,true); // end grip
    
    //labtek imprinter - 25 x 63
    
    color([0,1,0,0.5]) translate([-12.5,-29,-0.5]) union() {
        // main well for LabTek - should match chamber size + tolerance
        cube([25,56,12]);
        // annoying tab
        translate([5,55,0]) cube([15,10,8]);   
       
        if (include_lattice) {
        // viewing hole lattice
        translate([2.5,2,-5]) {
            translate([0,39,0]) cube([9,11,10]);
            translate([0,26,0]) cube([9,11,10]);
            translate([0,13,0]) cube([9,11,10]);
            translate([0,0,0]) cube([9,11,10]);
            
            translate([11,39,0]) cube([9,11,10]);
            translate([11,26,0]) cube([9,11,10]);
            translate([11,13,0]) cube([9,11,10]);
            translate([11,0,0]) cube([9,11,10]);
        }
    } else {
        translate([2.5,2,-5]) cube([20,50,10]);
        
        }
    }
}


