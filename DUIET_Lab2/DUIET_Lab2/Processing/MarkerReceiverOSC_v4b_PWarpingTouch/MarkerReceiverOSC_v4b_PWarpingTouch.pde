//*********************************************
// Example Code: ArUCo Fiducial Marker Detection in OpenCV Python and then send to Processing via OSC
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import org.ejml.simple.SimpleMatrix; //this is ecplained in the lecture, slides of the lab session week 2
import oscP5.*;
import netP5.*;
import processing.net.*;

TagManager tm;
OscP5 oscP5;
boolean serialDebug = true;

int[] cornersID = {1, 3, 2, 0};         //Detecting the corners 
int[][] bundlesIDs = {};
PVector[][] bundlesOffsets = {};
int camWidth = 1280;
int camHeight = 720;

float touchThreshold = 0.015; //unit: m

float paperWidthOnScreen = 297; //unit: mm
float markerWidth = 50; //unit: mm

PImage calibImg; 

void setup() {
  size(1280, 720);
  oscP5 = new OscP5(this, 9000);
  initTagManager();
  calibImg = loadImage("ArUco_Grid50.png");
  imageOffset.set((width - calibImg.width)/2 , (height - calibImg.height)/2);
}

void draw() {
  tm.update();
  if (!homographyMatrixCalculated) {
    background(100);
    tm.displayRaw();
    if (cornersDetected()) {
      calculateHomographyMatrix();
      registerPlanePoints();
      homographyMatrixCalculated = true;
    }
  } else {
    background(200);
    drawCanvas();
    tm.display2D(homography);
  }
}

void drawCalibImage(){
  pushStyle();
  imageMode(CENTER);
  image(calibImg,width/2,height/2);
  popStyle();
}

void drawCanvas(){
  pushStyle();
  noStroke();
  fill(255);
  rectMode(CENTER);
  rect(width/2,height/2,(float)calibImg.width*tag2screenRatio,(float)calibImg.height*tag2screenRatio);
  popStyle();
}

void showInfo(String s,int x, int y){
  pushStyle();
  fill(52);
  textAlign(LEFT, BOTTOM);
  textSize(48);
  text(s, x, y);
  popStyle();
}
