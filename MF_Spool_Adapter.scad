fn = 120;
d1 = 65;
h1 = 2;
d2 = 55;
h2 = 3.75;
d3 = 20;
d4 = 14;
h4 = 34;
d5 = 10;
tolerance = 0.1;


cut_w = 3;
module Side(cut=false) {
    difference() {
        union() {
            cylinder(d=d1, h=h1, center=false, $fn = fn);
            translate([0, 0, h1]) cylinder(d=d2, h=h2+cut_w, center=false, $fn = fn);
        }
        for (a=[0:90:270]) {
            rotate([0, 0, a]) {
                translate([0-cut_w/2, 0, h1+h2])  
                    cube([cut_w, d2/2, d2+1]);
            }
        }
        translate([0, 0, h1])
            cylinder(d=d3+tolerance, h = h2+cut_w+1, $fn = fn);
        if (cut == true) {
            cylinder(d=d5, h=h1, center=false, $fn = fn);
        }
    }
}

module Shaft() {
    difference() {
        union() {
            cylinder(d=d5, h=h1, $fn=fn);
            translate([0, 0, h1]) cylinder(d=d4, h=h4+h2*2, center=false, $fn = fn);
            translate([0, 0, h1+h4+h2*2]) cylinder(d=d5, h=h1, $fn=fn);
        }
        cylinder(d=4, h=10, $fn=fn);
        translate([0, 0, h1*3 + h2*2 +h4 - 10]) cylinder(d=4, h=10, $fn=fn);
    }
}

//Side(true);
//translate([0, 0, h1*2+h2*2+h4]) {
//   rotate([0, 180, 0]) Side(true);
//}
Shaft();
//translate([-1, 10, h1+h2]) {
//    color("Red") cube([2, 2, h4]);
//}
