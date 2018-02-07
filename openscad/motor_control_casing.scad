// BOX
// FLAT BOTTOM
// ROUNDED CORNERS
// CALCULATED BASED ON SIZE OF CONTENT


$fn=10;

// dimensions
OBJECT = ([40, 60, 20]);

// parameters for the box
WALL = 2;
PADDING = 1;
LID_HEIGHT = 10;
RIM_HEIGHT = 2;
RIM_WIDTH = 1;
RIM_SPACING = 0.2;


// calculated dimensions

CORNER_SIZE = WALL/2;
WALL_SIZE = WALL/2;

INNER_BOX = ([OBJECT[0]+ 2 * PADDING,
              OBJECT[1]+ 2 * PADDING,
              OBJECT[2]+ 2 * PADDING]);
              
              
OUTER_BOX = ([OBJECT[0] + 2 * (PADDING + WALL_SIZE),
              OBJECT[1] + 2 * (PADDING + WALL_SIZE),
              OBJECT[2] + 2 * (PADDING + WALL_SIZE)]);

//box();
base();
//cover();
//outer_box();
//cutout_base();

module rim_base(){
    translate([0,0,OUTER_BOX[2] - LID_HEIGHT - RIM_HEIGHT])
    linear_extrude(RIM_HEIGHT){
        square([OBJECT[0] + 2 * (PADDING + RIM_WIDTH) + RIM_SPACING,
                OBJECT[1] + 2 * (PADDING + RIM_WIDTH) + RIM_SPACING],
                center = true);
    }
}

module rim_cover(){
        translate([0,0, OUTER_BOX[2] - LID_HEIGHT - RIM_HEIGHT]){
        difference(){
            linear_extrude(RIM_HEIGHT){
                square([INNER_BOX[0] + 2 * RIM_WIDTH - RIM_SPACING,
                        INNER_BOX[1] + 2 * RIM_WIDTH - RIM_SPACING],
                        center = true);
            }
            linear_extrude(RIM_HEIGHT){
                square([INNER_BOX[0],
                        INNER_BOX[1]],
                        center = true);                    
            }
            }
        }
}

module box(){
    difference(){
        outer_box();
        inner_box();
    }
}

module outer_box(){
    linear_extrude(OUTER_BOX[2]) {
        minkowski(){
            square([OUTER_BOX[0], 
                    OUTER_BOX[1]],
                    center = true);
            circle(CORNER_SIZE);
        }
    }
}

module inner_box(){
    translate([0,0, WALL_SIZE]){
        linear_extrude(INNER_BOX[2]) {
            square([INNER_BOX[0],
                    INNER_BOX[1]],
                    center = true);
        }
    }
}

module base(){
    difference(){
        difference(){
            box();
            translate([0,0,OUTER_BOX[2] - LID_HEIGHT]){
                resize([0,0, LID_HEIGHT]){
                    outer_box();
                }
            }
        }
        rim_base();
    }
}

module cover(){
    union(){
        difference(){
            box();
            resize([0,0, OUTER_BOX[2] - LID_HEIGHT]){
                outer_box();
            }
        }
    rim_cover();
    }
}