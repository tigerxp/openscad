//  Case lenght
length = 60.0; // [30:0.1:150]
// Case width
width  = 60.0; // [30:0.1:150]
// Case Height
height = 6.0; // [2:0.1:50]
// Corner radius
corner_radius = 5; // [1:0.1:12]
// Walls thinkness (extrusion width)
walls = 0.6; // [0.4,0.6,0.8,1.0]
// Thinkness of the top part (num layers*layer height)
top = 0.4; // [0.4,0.6,0.8,1.0]
// Clearance from the walls
clearance=0.1; // [0.05,0.1,0.12,0.15,0.2]

use <lib/round_cube.scad>

roundCornersCube(
    width + walls*2 + clearance*2, 
    length + walls*2 + clearance*2, 
    height + top + clearance, 
    corner_radius + clearance
);
