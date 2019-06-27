#include "attacknoid.h"


// ir module 
#define ir A2
#define model 1080

// 1st drv8833
#define AIN_1 3
#define AIN_2 5
#define BIN_1 6
#define BIN_2 9

// 2nd drv8833
#define CIN_1 2
#define CIN_2 4
#define DIN_1 7
#define DIN_2 8

#define MAX_PWM_VOLTAGE 920

SharpIR SharpIR(ir, model);

char cmdChar;
boolean newData = false;


/*void recvOneChar();
void drive_forward(int speed);
void drive_backward(int speed);
void turn_right(int speed);
void turn_left(int speed);
void drive_stop();
void turret_up();
void turret_down();
void turret_shoot();*/


void setup() {
  Serial1.begin(9600);
  
  pinMode(BIN_1, OUTPUT);
  pinMode(BIN_2, OUTPUT);
  pinMode(AIN_1, OUTPUT);
  pinMode(AIN_2, OUTPUT);
  pinMode(CIN_1, OUTPUT);
  pinMode(CIN_2, OUTPUT);
  pinMode(DIN_1, OUTPUT);
  pinMode(DIN_2, OUTPUT);
}


void loop() {
  recvOneChar();
  evaluateCmd();

  int dis=SharpIR.distance();
  Serial1.print("Mean distance: ");
  Serial1.println(dis);

  if (dis < 20) {
    Serial.println("distance below 20cm, stopping");
    drive_stop();
    turn_right(MAX_PWM_VOLTAGE);
    delay(500);
    drive_forward(MAX_PWM_VOLTAGE);
  }
  delay(200);
}


void recvOneChar() {
  if (Serial1.available() > 0) {
    cmdChar = Serial1.read();
    newData = true;
  }
}


void evaluateCmd() {
  if (newData == true) {
    Serial1.print("got cmdChar: ");
    Serial1.println(cmdChar);

    int command = cmdChar;
    command -= 48;
    Serial1.print("got command: ");
    Serial1.println(command);

    switch ( command ) {
      case 0:
        drive_forward(MAX_PWM_VOLTAGE);
        Serial1.println("drive_forward");
        break;
      case 1:
        drive_backward(MAX_PWM_VOLTAGE);
        Serial1.println("drive_backward");
        break;
      case 2:
        turn_right(MAX_PWM_VOLTAGE);
        Serial1.println("turn_right");
        break;
      case 3:
        turn_left(MAX_PWM_VOLTAGE);
        Serial1.println("turn_left");
        break;
      case 4:
        drive_stop();
        Serial1.println("drive_stop");
        break;
      case 5:
        turret_up();
        Serial1.println("turret_up");
        break;
      case 6:
        turret_down();
        Serial1.println("turret_down");
        break;
      case 7:
        turret_shoot();
        Serial1.println("turret_shoot");
        break;
      case 8:
        turret_stop();
        break;
      default:
        Serial1.println("invalid command");
        break;
    }
    newData = false;
  } 
}


void drive_backward(int speed){
  digitalWrite(BIN_1, LOW);
  digitalWrite(AIN_1, LOW);
  analogWrite(BIN_2, LOW);
  analogWrite(AIN_2, speed);
}


void drive_forward(int speed){
  digitalWrite(BIN_2, LOW);
  digitalWrite(AIN_2, LOW);
  analogWrite(BIN_1, LOW);
  analogWrite(AIN_1, speed);
}


void turn_right(int speed){
  digitalWrite(BIN_1, LOW);
  digitalWrite(AIN_2, LOW);
  analogWrite(BIN_2, speed);
  analogWrite(AIN_1, LOW);
}


void turn_left(int speed){
  digitalWrite(BIN_2, LOW);
  digitalWrite(AIN_1, LOW);
  analogWrite(BIN_1, speed);
  analogWrite(AIN_2, LOW);
}


void drive_stop(){
  digitalWrite(BIN_2, LOW);
  digitalWrite(AIN_1, LOW);
  digitalWrite(BIN_1, LOW);
  digitalWrite(AIN_2, LOW);
}


void turret_up(){
  digitalWrite(CIN_1, LOW);
  digitalWrite(DIN_1, LOW);
  digitalWrite(CIN_2, LOW);
  digitalWrite(DIN_2, HIGH);
}


void turret_down(){
  digitalWrite(CIN_1, LOW);
  digitalWrite(DIN_2, LOW);
  digitalWrite(CIN_2, LOW);
  digitalWrite(DIN_1, HIGH);
}


void turret_shoot(){
  digitalWrite(CIN_1, HIGH);
  digitalWrite(DIN_2, LOW);
  digitalWrite(CIN_2, LOW);
  digitalWrite(DIN_1, LOW);
}


void turret_stop(){
  digitalWrite(CIN_1, LOW);
  digitalWrite(DIN_2, LOW);
  digitalWrite(CIN_2, LOW);
  digitalWrite(DIN_1, LOW);
}

