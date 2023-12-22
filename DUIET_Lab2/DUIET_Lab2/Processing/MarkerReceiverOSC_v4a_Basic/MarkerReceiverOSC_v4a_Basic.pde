//*********************************************
// Example Code: ArUCo Fiducial Marker Detection in OpenCV Python and then send to Processing via OSC
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import org.ejml.simple.SimpleMatrix;
import oscP5.*;
import netP5.*;
import processing.net.*;

TagManager tm;
OscP5 oscP5;

int[] cornersID = {};
int[][] bundlesIDs = {};
PVector[][] bundlesOffsets = {};
int camWidth = 1280;                                  //Is this even relevant for the input? See notes
int camHeight = 720;

void setup() {
  size(800, 800);
  oscP5 = new OscP5(this, 9000);
  initTagManager();
}

void draw() {
  tm.update();
  background(200);
  tm.displayRaw();
  showInfo("Unit: cm",0,height);
}

void showInfo(String s,int x, int y){
  pushStyle();
  fill(52);
  textAlign(LEFT, BOTTOM);
  textSize(48);
  text(s, x, y);
  popStyle();
}
