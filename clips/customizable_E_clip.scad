//CUSTOMIZER VARIABLES
//	Width of the clip
width = 20.5;

//	Height of the clip
height = 50.5;

//	Thickness of the clip
thickness = 3.5; // [spinbox:1.0:0.1:10]

//	Width of the first gap on the clip
gap1 = 30.5; // [spinbox:0.1:0.1:30]

//	Width of the second gap on the clip
gap2 = 5.5; // [spinbox:0.1:0.1:30]
//CUSTOMIZER VARIABLES END

//E-CLIP
module zclip(w,h,t,d1,d2) {
    d1=d1+t/2;
	cube([t,h,w]);
	translate([t,h-t,0]) cube([d1+t,t,w]);
	translate([d1+t,0,0]) cube([t,h-t,w]);
	translate([d1+t+t,h-t,0]) cube([d2+t,t,w]);
	translate([d1+t+t+d2,0,0]) cube([t,h-t,w]);
    // Cylinders
    for (i = [0: t : h-t*2]){
        translate([t, i+t/2, 0])
            cylinder(h = w, d=t, $fn=16);
    }
}
zclip(width,height,thickness,gap1,gap2);
//Z-CLIP END