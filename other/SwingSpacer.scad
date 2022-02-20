$fn = 90;
d=19;
sq=8.7;
h=8;

difference() {
   cylinder(d=d, h=h, center=false);
    translate([-sq/2, -sq/2, 0])
    cube(sq);
}