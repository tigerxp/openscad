height = 4;
innerLength = 46;
innerWidth = 22.5;
walls = 1.2;

difference() {
    cube([innerWidth + walls*2, innerLength + walls*2, height], center=true);
    cube([innerWidth, innerLength, height], center=true);
}
