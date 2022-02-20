// Box to a 18650 battery in a holder plus usb charger
// 
// R J Tidey 21 NOV 2017
//

//Set up basic dimesnsions
i_width = 22.5;
i_length = 101.0;
i_height = 22.0;

wall = 2.5;

//extra width for mounting stuff
e_width = 0.0;

//slot for charging point; set socket_A to 0 to allow only micro USB access
socket_A = 1;
socket_height1 = 7.5;
socket_width1 = 14.0;
socket_length = 19.0;
socket_height2 = 4.8;
socket_width2 = 8.5;
//narrow wall around micro socket
socket_wall = 1.5;
socket_shoulder = 2.3;

width = i_width + 2 * wall + e_width;
length = i_length + 2 * wall;
height = i_height + wall;

//ensure that the edge roundness is greater than the wall thickness
edge_roundness = 4;
tolerance = 0.3;

$fn = 20;

inner_box_dimensions = [length,width,height];

module mainBox()
{
    difference ()
    {
        hull()
        {
            addOutterCorners(0,0);
            addOutterCorners(1,0);
            addOutterCorners(0,1);
            addOutterCorners(1,1);
        }
        
        translate([0,0,wall])
        hull()
        {
            addInnerCorners(0,0);
            addInnerCorners(1,0);
            addInnerCorners(0,1);
            addInnerCorners(1,1);
        }

        translate([0,0,inner_box_dimensions[2]+0.1])
        hull()
        {
            addLidCorners(0,0);
            addLidCorners(1,0);
            addLidCorners(0,1);
            addLidCorners(1,1);
        }

        translate([inner_box_dimensions[0]-wall,0,inner_box_dimensions[2]+0.1])
        cube([wall,inner_box_dimensions[1],wall]);
    }
}

module mainLid()
{
    translate([0,inner_box_dimensions[1]+2,0])
    difference ()
    {
        hull()
        {
            Lid(0,0);
            Lid(1,0);
            Lid(0,1);
            Lid(1,1);
        }
    }
}



module addOutterCorners(x = 0, y = 0)
{
	translate([(inner_box_dimensions[0] - edge_roundness*2 + 0.1)*x,(inner_box_dimensions[1] - edge_roundness*2 +0.1)*y,0] + [edge_roundness,edge_roundness,0])

	cylinder(inner_box_dimensions[2]+wall,edge_roundness,edge_roundness);
}

module addInnerCorners(x = 0, y = 0)
{
	translate([(inner_box_dimensions[0] - edge_roundness*2 + 0.1)*x,(inner_box_dimensions[1] - edge_roundness*2 +0.1)*y,0] + [edge_roundness,edge_roundness,0])

	cylinder(inner_box_dimensions[2],edge_roundness-wall,edge_roundness-wall);
}

module addLidCorners(x = 0, y = 0)
{
	translate([(inner_box_dimensions[0] - edge_roundness*2 - 0.1 +wall)*x,(inner_box_dimensions[1] - edge_roundness*2 +0.1)*y,0] + [edge_roundness,edge_roundness,0])

	cylinder(wall,edge_roundness-wall+1.5,edge_roundness-wall+0.5);
}

module Lid(x = 0, y = 0)
{
	translate([(inner_box_dimensions[0] - edge_roundness*2 - 0.1 +wall-2)*x,(inner_box_dimensions[1] - edge_roundness*2 +0.1)*y,0] + [edge_roundness,edge_roundness,0])

	cylinder(wall,edge_roundness-wall+1.5-tolerance,edge_roundness-wall+0.5-tolerance);
}


//make main box with holes
difference () {
   
    union() {
        mainBox();
        translate([i_length-socket_length, wall, wall-0.1]) {
            cube([socket_length+0.1, i_width,i_height-socket_height1-socket_height2]);
        }
        if(e_width>0) {
            translate([wall-0.1, wall+i_width-0.02, wall-0.1]) {
                cube([i_length+0.2, wall,i_height-socket_height1-socket_height2]);
            }
        }   
    }
    if(socket_A) {
        translate([length - wall - 0.5, (i_width + 2*wall - socket_width1)*.5, wall+i_height-socket_height1])
            cube([wall+1, socket_width1, socket_height1+1]);
    }
    translate([length - wall - 0.5, (i_width + 2*wall - socket_width2)*.5, wall+i_height-socket_height1-socket_height2])
        cube([wall+1, socket_width2, socket_height2]);
    translate([length-wall+socket_wall, (i_width+2*wall - socket_width2)*.5-socket_shoulder, wall+i_height-socket_height1-socket_height2-socket_shoulder])
        cube([wall+1, socket_width2+2*socket_shoulder, socket_height2+2*socket_shoulder]);
}


mainLid();