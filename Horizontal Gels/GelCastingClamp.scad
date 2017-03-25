
translate([0,0,5]) cube([100,20,20]); // end butt

 difference() {
cube([100,150,5]); // main stage

translate([10,0,3]) cube([5,150,5]); // rail
translate([85,0,3]) cube([5,150,5]); // rail
}




translate([0,120,50]) union() {
    cube([100,20,20]); // end butt
    translate([10,0,-2]) cube([5,20,5]); // rail
    translate([85,0,-2]) cube([5,20,5]); // rail
}

