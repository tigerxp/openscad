color("green") cube([20, 20, 0.6]);

translate([0,0,0.6]) {
    // circle
    translate([5,5,0])
        color("red") 
            cylinder(d=8,h=0.6, $fn=90);
    // triangle
    translate([5,15,0])
        rotate([0,0,30])
            color("red") 
                cylinder(d=8,h=0.6, $fn=3);
    // cube
    translate([15-4,1,0])
        color("red") 
            cube([8, 8, 0.6]);
    // hexagon
    translate([15,15,0])
        color("red") 
            cylinder(d=8,h=0.6, $fn=6);
}
