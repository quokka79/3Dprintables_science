    union() {
        // main well for LabTek - should match chamber size + tolerance
        color("red",1 ) cube([25,56,12]);
        // annoying tab
        color("red",1 ) translate([5,56,0]) cube([15,7,8]);   
        
        //lid
        translate([0,0,7.5]) union() {
            color("orange",1 ) cube([26,56,5]);
            color("orange",1 ) translate([12,15.5,5]) cube([2,23,6]);
            color("orange",1 ) translate([5,56,0]) cube([15,7,4]);  
        }
        
         
        
        // viewing hole lattice
        translate([2,2,-5]) {
            translate([0,37.5,0]) cube([9,10.5,10]);
            translate([0,25,0]) cube([9,10.5,10]);
            translate([0,12.5,0]) cube([9,10.5,10]);
            translate([0,0,0]) cube([9,10.5,10]);
            
            translate([11,37.5,0]) cube([9,10.5,10]);
            translate([11,25,0]) cube([9,10.5,10]);
            translate([11,12.5,0]) cube([9,10.5,10]);
            translate([11,0,0]) cube([9,10.5,10]);
        }
    }
    
    
    
    
           
        
        
        
        

        
