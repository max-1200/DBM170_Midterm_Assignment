import netP5.*;
import oscP5.*;


//*********************************************
// Example Code: ArUCo Fiducial Marker Detection in OpenCV Python and then send to Processing via OSC
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import org.ejml.simple.SimpleMatrix;
import oscP5.*;
import netP5.*;
import processing.net.*;

//dependencies for processing opencv
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

//video function and capture function are probably from the processing video library 
Capture video;
OpenCV opencv;

TagManager tm;
OscP5 oscP5;

int[] cornersID = {};
int[][] bundlesIDs = {};
PVector[][] bundlesOffsets = {};

//This is relevant because the cornerpoint values imported are also scaled to this range of pixels on the screen 
int camWidth = 1280;                                
int camHeight = 720;

void setup() {
  size(1280, 720); //cannnot take variables 
  oscP5 = new OscP5(this, 9000);
  initTagManager();
  
  // A straight up copy from the example 
  //size(camWidth, camHeight); //camwidth does not work error, but now the screen is black
  //this function can only be called once, it was already called. Not the problem of the black screen
  video = new Capture(this, camWidth, camHeight);
  
  //this part is for the example of face detction, which is not really necessary for this purpose
  //opencv = new OpenCV(this, camWidth/2, camHeight/2);
  //opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
  //end 
  
}

void draw() {
  tm.update();
  background(200);
  tm.displayRaw();
  showInfo("Unit: cm",0,height);
  
  //also show the video image 
    image(video, 0, 0 );
}

void showInfo(String s,int x, int y){
  pushStyle();
  fill(52);
  textAlign(LEFT, BOTTOM);
  textSize(48);
  text(s, x, y);
  popStyle();
}
