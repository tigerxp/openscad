gapWidth = 1.9;
holdersLength = 10;
labelWidth = 20;
labelLength = 20;
thickness = 0.8;

module holder() {
    cube([labelWidth, thickness, holdersLength]);
}

// top part
cube([labelWidth, labelLength, thickness]);
translate([0, labelLength-thickness, thickness]) holder();
translate([0, labelLength-thickness*2-gapWidth, thickness]) holder();