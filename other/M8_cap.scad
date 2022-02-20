$fn = 90;
d = 19;
h1 = 8;
h2 = 20;
wall = 2;

difference() {
    difference() {
        union() {
            cylinder(d=d, h=h1+2);
            translate([0,0,h1+2]) {
                cylinder(d1=d, d2=8.2+wall*2, wall*2);
                cylinder(d=8.2+wall*2, h2-wall);
            }
        }
        cylinder(d=15, h=h1, $fn=6); // nut hole
        cylinder(d=8.1, h=h1+h2-wall); // bolt hole
    }
    // cube([10, 10, 40]);
}
