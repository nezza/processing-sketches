/* Small sketch for prototyping how a video looks on an LED matrix
 * with different resolutions. */
import processing.opengl.*;
import controlP5.*;

import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

int table_x = 16;
int table_y = 8;
int box_size = 8;
color[][] colors;
PeasyCam camera;

int STATE_GUI=0;
int STATE_VIDEO=1;
int state =STATE_GUI;

ControlP5 controlP5;

import processing.video.*;
Movie myMovie;
void load_movie() {
  myMovie = new Movie(this, "movie2.mov");
  myMovie.loop();
}

void calculate_colors() {
  int steps_x = myMovie.width/table_x;
  int steps_y = myMovie.height/table_y;
  if ((steps_x==0) || (steps_y==0)) return;
  for (int i=0; i < table_x; i++) {
    for (int j=0; j < table_y; j++) {
      float rtot=0;
      float gtot=0;
      float btot=0;
      for (int k=0; k < steps_x; k++) {
        for (int l=0; l < steps_y; l++) {
          //int pixelcolor = myMovie.pixels[((j*steps_y)+l)*myMovie.width + ((i*steps_x)+k)];
          color pixelcolor = myMovie.get((i*steps_x)+k, (j*steps_y)+l);
          float r = red(pixelcolor);
          float g = green(pixelcolor);
          float b = blue(pixelcolor);
          rtot += r;
          gtot += g;
          btot += b;
        }
      }
      int index = steps_x*steps_y;
      colors[i][j] = color(rtot/index, gtot/index, btot/index);
    }
  }
}
void setup() {
  size(800, 600, OPENGL);
  noStroke();
  fill(255, 255, 255);
  //load_movie();
  setup_gui();
}
void setup_gui() {
  controlP5 = new ControlP5(this);
  Controller mySlider = controlP5.addSlider("table_x_setup", 0, 128, table_x, 20, 100, 20, 250);
  mySlider.valueLabel().setFont(ControlP5.grixel).adjust();
  mySlider.captionLabel().setFont(ControlP5.grixel).adjust();
  mySlider.valueLabel().style().margin(-20, 0, 0, 0);
  mySlider = controlP5.addSlider("table_y_setup", 0, 128, table_y, 100, 100, 20, 250);
  mySlider.valueLabel().setFont(ControlP5.grixel).adjust();
  mySlider.captionLabel().setFont(ControlP5.grixel).adjust();
  mySlider.valueLabel().style().margin(-20, 0, 0, 0);
  controlP5.addButton("start_video", 255, 200,100,80,19);
}
void draw_gui() {
  controlP5.draw();
}
void table_x_setup(int x) {
  table_x = x;
}
void table_y_setup(int y) {
  table_y =y;
}
void start_video() {
  camera = new PeasyCam(this, table_x*box_size/2, table_y*box_size/2, 0, 50);
  colors = new color[table_x][table_y];
  load_movie();
  state=STATE_VIDEO;
}
void draw() {
  if (state==STATE_GUI) {
    background(0);
    draw_gui();
  } 
  else {
    if (myMovie.available()) {
      myMovie.read();
      calculate_colors();
    }
    background(40);
    pushMatrix();
    for (int i=0; i < table_x; i++) {
      for (int j=0; j < table_y; j++) {
        fill(colors[i][j]);
        box(box_size);
        translate(0, box_size, 0);
      }
      translate(box_size, table_y*box_size*-1, 0);
    }
    popMatrix();
    camera.beginHUD();
    image(myMovie, 0, 0, myMovie.width/2, myMovie.height/2);
    camera.endHUD();
  }
}

