/** Small applet for controlling an RGB-LED which is connected to
 *  an Arduino. Just use Example->Firmata->StandardFirmata as
 *  Arduino sketch. */
import controlP5.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
ControlP5 cp5;

/* Port configuration. */
int led_r = 9;
int led_g = 15;
int led_b1 = 12;
int led_b2 = 5;

void setup() {
  size(180,290);
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  cp5 = new ControlP5(this);
  cp5.addSlider("R", 0, 255, 0, 20, 20, 20, 250);
  cp5.addSlider("G", 0, 255, 0, 60, 20, 20, 250);
  cp5.addSlider("B1", 0, 255, 0, 100, 20, 20, 250);
  cp5.addSlider("B2", 0, 255, 0, 140, 20, 20, 250);
}

void R(int r) {
  arduino.analogWrite(led_r, r);
}
void G(int r) {
  arduino.analogWrite(led_g, r);
}
void B1(int r) {
  arduino.analogWrite(led_b1, r);
}
void B2(int r) {
  arduino.analogWrite(led_b2, r);
}


void draw() {
  background(0);
}

