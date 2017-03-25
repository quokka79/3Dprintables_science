$fn=100;

//


difference() {
  
    union() {
        
        // Main body with curved corners
        // floor plate
        hull() {
            translate([71,70,0]) cylinder(2,10,10); // far corner
            translate([10,10,0]) cylinder(2,10,10); // near corner
            translate([71,10,0]) cylinder(2,10,10); // far x corner
            translate([10,70,0]) cylinder(2,10,10); // far y corner
        }
        

        difference(){
            hull() {
                translate([71,70,1]) cylinder(6,10,10); // far corner
                translate([10,10,1]) cylinder(6,10,10); // near corner
                translate([71,10,1]) cylinder(6,10,10); // far x corner
                translate([10,70,1]) cylinder(6,10,10); // far y corner
            }
            hull() {
                translate([71,70,1]) cylinder(12,7,10); // far corner
                translate([10,10,1]) cylinder(12,7,10); // near corner
                translate([71,10,1]) cylinder(12,7,10); // far x corner
                translate([10,70,1]) cylinder(12,7,10); // far y corner
            }
        }     
            
        // LabTekII Support wall 
        translate([20.5,3,2])
        hull() {
            translate([5,5,4]) cube([30,61,1]); // wall
            cube([40,71,1]); // wall
        }
    
        // side grip-walls
        difference() {
            translate([86,40,2]) cylinder(5,20,18);
            translate([101,40,0]) cube([40,40,20], true);
        }

        difference() {
            translate([-5,40,2]) cylinder(5,20,18);
            translate([-20,40,0]) cube([40,40,20], true);
        }
    }
    
    //labtek imprinter - 25 x 63
    
    translate([28,11,2]) union() {
        // main well for LabTek - should match chamber size + tolerance
        cube([25,56,12]);
        // annoying tab
        translate([5,55,0]) cube([15,10,8]);   
                
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
    }
       
    // finger grips
    translate([86,40,-5]) cylinder(15,15,15); //right
    translate([-5,40,-5]) cylinder(15,15,15);
    

};