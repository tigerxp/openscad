height = 10; // Rise height
magnet_length=26.0; // Customize magnet length 
magnet_width=10.0; // Customize magnet width

$fn = 60; // Quality

module round_cube(l, w, h) {
    r = w/2;
    union() {
        cube([l-r*2, w, h]);
        translate([0, r, 0]) 
            cylinder(h=h, r=r, center=false);
        translate([l-r*2, r, 0]) 
            cylinder(h=h, r=r, center=false);
    }
}

//difference() {
//    round_cube(l=magnet_length+Walls*2, w=magnet_width + Walls*2, h=Height+Walls);
    translate([magnet_width/2, 0, 0])
        round_cube(l=magnet_length, w=magnet_width, h=height);
//}
    
