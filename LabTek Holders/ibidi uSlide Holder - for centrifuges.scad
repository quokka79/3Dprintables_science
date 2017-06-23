$fn=100;

//


difference() {
  
    union() {
        
        // Main body with curved corners. Box Dims  = 81 x 81 x 6mm
        // floor plate
        hull() {
            translate([71,70,0]) cylinder(2,10,10); // far corner
            translate([10,10,0]) cylinder(2,10,10); // near corner
            translate([71,10,0]) cylinder(2,10,10); // far x corner
            translate([10,70,0]) cylinder(2,10,10); // far y corner
        }
        
        // outer wall
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
            
        // Slide Support wall 
        translate([20.5,0,2])
        difference() {
            hull() {
                translate([5,0,4]) cube([30,80,1]); // wall
                cube([40,80,1]); // wall
            }
            // finger holes
           difference() {
                translate([-5,40,1]) cylinder(10,15,20);
                translate([101,40,0]) cube([40,40,20], true);
            }
           difference() {
                translate([45,40,1]) cylinder(10,15,20);
                translate([101,40,0]) cube([40,40,20], true);
            }

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
    
    translate([28,1.75,2]) union() {
        // main well for uSlide - should match chamber size + some tolerance

         cube([26,76.5,12]);
         translate([0,10.25,-0.3]) cube([26,56,10]);

                         
        // viewing hole lattice
        translate([2.5,14.75,-5]) {
            // Left column
            translate([0,0,0]) cube([10,11,20]);
            translate([0,12,0]) cube([10,11,20]);
            translate([0,24,0]) cube([10,11,20]);
            translate([0,36,0]) cube([10,11,20]);
            //Right Column
            translate([11,36,0]) cube([10,11,20]);
            translate([11,24,0]) cube([10,11,20]);
            translate([11,12,0]) cube([10,11,20]);
            translate([11,0,0]) cube([10,11,20]);
        }
    }
       
    // finger grips
    translate([86,40,-5]) cylinder(15,15,15); //right
    translate([-5,40,-5]) cylinder(15,15,15);
    

};