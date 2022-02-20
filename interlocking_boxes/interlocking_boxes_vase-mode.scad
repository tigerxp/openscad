/* [Size] */
// Box unit size in mm. This defines the size of 1 'unit' for your box.
BoxUnits = 40;
// Box Width in units
BoxWidthUnits = 1;
BoxWidth = BoxWidthUnits * BoxUnits;
// Box Length in units
BoxLengthUnits = 4;
BoxLength = BoxLengthUnits * BoxUnits;
// Box Height in mm
BoxHeight = 40;
// Fit Factor. Greater factor = looser fit
FitFactor = 0.15; // [0:0.01:0.4]

/* [Dovetail] */
// Dovetail inside length in mm
DTInsideLength = 4; // [1:0.2:5]
// Dovetail angle in degrees
DTAngle = 45;
// Dovetail width in mm
DTWidth = 2; // [1:0.2:4]

/* [Hidden] */
// This helps calculate the length of the 'long' side of the dovetail
DTx = tan(DTAngle) * DTWidth;
// This polygon defines the dovetail shape
DTShape = [
    [ 0, 0 ],
    [ DTInsideLength / 2, 0 ],
    [ DTInsideLength / 2 + DTx, DTWidth ],
    [ -DTInsideLength / 2 - DTx, DTWidth ],
    [ -DTInsideLength / 2, 0 ]
];

difference()
{
    union()
    {
        // main box
        cube([ BoxLength, BoxWidth, BoxHeight ], center = false);

        // -- Male dovetails
        for (i = [1:BoxLengthUnits])
            translate(
                [ (i - 1) * BoxUnits + (BoxUnits / 2), BoxWidth, 0 ])
                union()
            {
                linear_extrude(height = BoxHeight, center = false) union()
                {
                    // this adds a slight offset to the male dovetail for a
                    // looser fit
                    translate([ -DTInsideLength / 2, 0, 0 ])
                        square([ DTInsideLength, DTWidth ]);
                    // main dovetail shape
                    translate([ 0, DTWidth * FitFactor * 2, 0 ])
                        polygon(DTShape);
                };
            }
        for (i = [1:BoxWidthUnits])
            translate([ BoxLength, (i - 1) * BoxUnits + (BoxUnits / 2), 0 ])
                rotate([ 0, 0, -90 ])
                    linear_extrude(height = BoxHeight, center = false) union()
            {
                // male dovetail offset
                translate([ -DTInsideLength / 2, 0, 0 ])
                    square([ DTInsideLength, DTWidth ]);
                // main dovetail shape
                translate([ 0, DTWidth * FitFactor * 2, 0 ]) polygon(DTShape);
            };
    }

    // --- Female dovetails
    for (i = [1:BoxLengthUnits])
        union()
        {
            translate([ (i - 1) * BoxUnits + (BoxUnits / 2), 0, 0 ])
                scale([ 1 + FitFactor, 1 + FitFactor, 1 ])
                    linear_extrude(height = BoxHeight, center = false)
                        polygon(DTShape);
        }
        for (i = [1:BoxWidthUnits])
            translate([ 0, (i - 1) * BoxUnits + (BoxUnits / 2), 0 ])
                rotate([ 0, 0, -90 ]) scale([ 1 + FitFactor, 1 + FitFactor, 1 ])
                    linear_extrude(height = BoxHeight, center = false)
                        polygon(DTShape);
} // difference