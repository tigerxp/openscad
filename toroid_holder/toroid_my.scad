$fn=60+0;   // +0 so it's ignored by customizer

// Select part
part = "mount"; // [mount:Mount,cap:Mount cap]
screw_hole_diameter = 3.7;
transformer_height = 50;
transformer_inner_diameter = 28;
mount_wall_thickness = 2;
pedestal_diameter = 65;
pedestal_height = 3;
number_of_spokes = 3; // [2:16]
cap_thickness = 3;
cap_diameter = 37;
nut_outer_diameter = 6.2;
nut_height = 3.1;

if(part=="mount") {
    toroid_transformer_holder(
        spokes=number_of_spokes,
        h=transformer_height,
        ow=mount_wall_thickness,
        od=transformer_inner_diameter,
        base_h=pedestal_height,
        base_d=pedestal_diameter,
        hole_d=screw_hole_diameter
    );
} else if (part=="cap") {
    toroid_cap(
        cd=cap_diameter,
        ch=cap_thickness,
        ow=mount_wall_thickness,
        od=transformer_inner_diameter,
        h=transformer_height,
        hd=screw_hole_diameter
    );
}

module toroid_cap(cd=37,ch=3,ow=2,od=28, h=50,hd=4) {
    difference() {
        union() {
            cylinder(d = cd, h=ch);
            translate([0, 0, ch])
                cylinder(d=od, h = h/2);
        }
        union() {
            cylinder(d= od-ow*2, h=h/2-nut_height-0.2);
            // nut hole
            translate([0,0,h/2-nut_height]) // bridge to print w/o support, to drill
                cylinder(d=nut_outer_diameter+0.2, h=nut_height, $fn=6);
            // bolt hole
            translate([0,0,h/2+0.2])
                cylinder(d = hd, h=22);
        }
    }
}

module toroid_transformer_holder(h = 37, od = 31, ow = 1.5, iw=3, hole_d=3, spokes=3, base_h=3, base_d=70 )
{
    spoke_deg = 360/spokes;
    difference() {
        union() {
            cylinder(d = hole_d+iw*2, h = h/2+base_h);
            difference() {
                cylinder(d = od, h = h/2+base_h);
                translate([0,0,-.5]) cylinder(d = od-ow*2, h = h+base_h+1);  // +1 to make it look nicer on preview
            }
            intersection() {
                for(a=[0:spokes-1])
                {
                    rotate([0,0,a*spoke_deg]) translate([0,od/4,(h/2+base_h)/2]) cube([ow*2,od/2,h/2+base_h], true);
                }
                cylinder(d = od, h = h+base_h);
            }
        }
        translate([0,0,-.5]) cylinder(d = hole_d, h = h+base_h+1);
    }
    difference() {
        cylinder(h = base_h, d = base_d);
        cylinder(h = base_h, d = od);
    }

}