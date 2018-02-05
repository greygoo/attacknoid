$fn=10;

// dimensions

// space between objects and wall
SPACING = 1;
WALL_THICKNESS = 2;
CASE_HEIGHT = 5;

// PLUGS
PLUG2_X = 7.6;
PLUG3_X = 10;
PLUG_Y = 5.75;
PLUG_Z = 7;
PLUGS_DISTANCE_Y = 3.85;
PLUGS_DISTANCE_X = 1;

// SERIAL CONNECTOR
SERIAL_X = 14.85;
SERIAL_Y = 8.5;
SERIAL_Z = 3.5;

// MAINBOARD
BOARD_X = 40;
BOARD_Y = 60;
BOARD_Z = 2;
CABLE_Z = 1;

// NOTOR DRIVER
MOTOR_DRIVER_X = 14.85;
MOTOR_DRIVER_Y = 17.25;
MOTOR_DRIVER_Z = 14;
MOTOR_DRIVER_DISTANCE_X = 2;
MOTOR_DRIVER_DISTANCE_Y = 9.5;

// ARDUINO
ARDUINO_MINI_X = 33;
ARDUINO_MINI_Y = 18;
ARDUINO_MINI_Z = 14.5;
ARDUINO_MINI_DISTANCE_X = 2;
ARDUINO_MINI_DISTANCE_Y = 33;



// derived dimensions
COVER_HEIGHT = 2 * SPACING
             + 2 * WALL_THICKNESS
             + max(PLUG_Z,
                   SERIAL_Z + ARDUINO_MINI_Z,
                   MOTOR_DRIVER_Z)
             - CASE_HEIGHT;

// locations
PLUGROW_1 = ([PLUGS_DISTANCE_X,
              PLUGS_DISTANCE_Y,
              BOARD_Z + CABLE_Z]);
              
PLUGROW_2 = ([PLUGS_DISTANCE_X,
              BOARD_Y - PLUGS_DISTANCE_Y - PLUG_Y,
              BOARD_Z + CABLE_Z]);
              
PLUGROW_3 = ([BOARD_X - PLUG_Y - PLUGS_DISTANCE_X,
              BOARD_Y - PLUGS_DISTANCE_Y,
              BOARD_Z + CABLE_Z]);
              
MOTOR_DRIVER_1 = ([MOTOR_DRIVER_DISTANCE_X,
                   MOTOR_DRIVER_DISTANCE_Y,
                   BOARD_Z + CABLE_Z]);
                   
MOTOR_DRIVER_2 = ([BOARD_X - MOTOR_DRIVER_X - MOTOR_DRIVER_DISTANCE_X,
                   MOTOR_DRIVER_DISTANCE_Y,
                   BOARD_Z + CABLE_Z]);
                   
ARDUINO_MINI = ([ARDUINO_MINI_DISTANCE_X, ARDUINO_MINI_DISTANCE_Y, BOARD_Z + CABLE_Z]);
                   
BOARD = ([0 ,0, CABLE_Z]);
CABLE = ([0, 0, 0]);

// objects

//COVER
difference(){
    difference(){
        minkowski(){
            driver_board();
            sphere(SPACING/2 + WALL_THICKNESS/2);
        }

        union(){
            minkowski(){
                driver_board();
                sphere(SPACING/2);
            }
            holes();
        }
    }

    translate([- (SPACING + WALL_THICKNESS),
               - (SPACING + WALL_THICKNESS),
               - (SPACING + WALL_THICKNESS)]){
        cube([BOARD_X + 2 * (SPACING + WALL_THICKNESS),
              BOARD_Y + 2 * (SPACING + WALL_THICKNESS),
              CASE_HEIGHT]);
    }
}

//CASE
*difference(){
    difference(){
        minkowski(){
            driver_board();
            sphere(SPACING/2 + WALL_THICKNESS/2);
        }
        
        minkowski(){
            driver_board();
            sphere(SPACING/2);
        }
    }
    
    translate([- (SPACING + WALL_THICKNESS),
           - (SPACING + WALL_THICKNESS),
           - (SPACING + WALL_THICKNESS) + CASE_HEIGHT]){
        cube([BOARD_X + 2 * (SPACING + WALL_THICKNESS),
              BOARD_Y + 2 * (SPACING + WALL_THICKNESS),
              COVER_HEIGHT]);
    }       
}

// modules
module driver_board(){
    union(){
        //CABLE
        translate(CABLE){
            translate([1,1,0]) cube([BOARD_X - 2, BOARD_Y - 2 , CABLE_Z]);
        }

        //BOARD
        translate(BOARD){
            cube([BOARD_X, BOARD_Y, BOARD_Z]);
        }

        // ARDUINO_MINI

        translate(ARDUINO_MINI){
            arduino_mini();
        }


        //MOTOR_DRIVER_1
        translate(MOTOR_DRIVER_1){
            motor_driver();
        }


        //MOTOR_DRIVER_2
        translate(MOTOR_DRIVER_2){
            motor_driver();
        }

        //PLUGROW_1
        translate(PLUGROW_1){
            plugrow1();
        }
        
        //PLUGROW_2
        translate(PLUGROW_2){
            plugrow2();
        }
        
        //PLUGROW_3
        translate(PLUGROW_3){
            plugrow3();
        }
    }
}

module plug2(){
    cube([PLUG2_X, PLUG_Y, PLUG_Z]);
}

module plug3(){
    cube([PLUG3_X, PLUG_Y, PLUG_Z]);
}

module plugrow1(){    
    for (i = [0:4]) {
        translate([i * PLUG2_X, 0, 0])plug2();
    }
    translate([- PLUG2_X, 0, 0])text("1");
}

module plugrow2(){
    for (i = [0:2]) {
        translate([i * PLUG3_X, 0, 0])plug3();
    }
    translate([- PLUG3_X, 0, 0])text("2");
}

module plugrow3(){
    rotate(270){
        plug3();
        translate([PLUG3_X, 0, 0])plug2();
    }
    translate([PLUG_Y, 0, 0])text("3");
}

module motor_driver(){
    cube([MOTOR_DRIVER_X, MOTOR_DRIVER_Y, MOTOR_DRIVER_Z]);
}

module arduino_mini(){
    cube([ARDUINO_MINI_X, ARDUINO_MINI_Y, ARDUINO_MINI_Z]);
}

module holes(){
    translate([0,0,PLUG_Z]){
        translate(PLUGROW_1){
            scale([1,1,2]) plugrow1();
        }
        
        translate(PLUGROW_2){
            scale([1,1,2]) plugrow2();
        }
        
        translate(PLUGROW_3){
            scale([1,1,2]) plugrow3();
        }
    }
}