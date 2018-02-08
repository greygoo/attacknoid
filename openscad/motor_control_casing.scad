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
//base();
cover();
//outer_box();
//cutout_base();


module openings(){
    //motor plugs
    translate([- OBJECT[0]/2,
               - OBJECT[1]/2 - (PADDING + WALL),
               PADDING + WALL_SIZE + 3]){
        cube([OBJECT[0],
              5.75 + PADDING + WALL,
              OBJECT[2] + PADDING + WALL_SIZE - 3]);
    }

    //sensor plugs
    translate([- OBJECT[0]/2,
               OBJECT[1]/2 - (5.75),
               PADDING + WALL_SIZE + 3]){
        cube([30,
              5.75 + PADDING + WALL,
              OBJECT[2] + PADDING + WALL_SIZE - 3]);
    }

    //power and serial plugs
    translate([OBJECT[0]/2 + PADDING + WALL,
               OBJECT[1]/2 + PADDING + WALL - 17.6,
               PADDING + WALL_SIZE + 3]){
        rotate([0,0,90]){
            cube([17.6,
                  5.75 + PADDING + WALL,
                  OBJECT[2] + PADDING + WALL_SIZE - 3]);
        }
    }
    
    //arduino serial pins
    translate([ - (OBJECT[0]/2 + PADDING + WALL),
               - OBJECT[1]/2 + 33,
               OBJECT[2] + PADDING + WALL_SIZE]){
        cube([8,18,PADDING + WALL_SIZE]);
    }
}



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
    openings();
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
        openings();
    }
}

module cover(){
    difference(){
        union(){
            difference(){
                box();
                resize([0,0, OUTER_BOX[2] - LID_HEIGHT]){
                    outer_box();
                }
            }
        rim_cover();
        }
        openings();
    }
}


