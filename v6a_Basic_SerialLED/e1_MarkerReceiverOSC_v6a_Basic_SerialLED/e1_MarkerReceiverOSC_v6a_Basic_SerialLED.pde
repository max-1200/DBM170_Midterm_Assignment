//*********************************************
// Example Code: ArUCo Fiducial Marker Detection in OpenCV Python and then send to Processing via OSC
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import org.ejml.simple.SimpleMatrix;
import oscP5.*;
import netP5.*;
import processing.net.*;
import processing.sound.*;

SoundFile file_wrench;
SoundFile file_use_wrench;
SoundFile file_find_tirepatchset;
SoundFile file_use_tirelever;

//Serial data
import processing.serial.*;
Serial port;

TagManager tm;
OscP5 oscP5;
boolean serialDebug = true;

int[] cornersID = {1, 3, 2, 0};
int[][] bundlesIDs = {{57}, {49}, {55}, {27}};
PVector[][] bundlesOffsets = { {new PVector(0, 0, 0)}, {new PVector(0, 0, 0)}, {new PVector(0, 0, 0)}, {new PVector(0, 0, 0)}};
int camWidth = 1280;
int camHeight = 720;

float touchThreshold = 0.025; //unit: m

float paperWidthOnScreen = 297.; //unit: mm
float markerWidth = 50; //unit: mm
float calibgridWidth = 199; //unit:mm
float calibgridHeight = 197; //unit:mm

PImage calibImg;

ArrayList<DataObject> DOlist = new ArrayList<DataObject>();

ArrayList<Tag> activeTagList = new ArrayList<Tag>(); //remove

void setup() {
  size(1280, 720);
  oscP5 = new OscP5(this, 9000);
  initTagManager();
  //Initialize the serial port
  for (int i = 0; i < Serial.list().length; i++) println("[", i, "]:", Serial.list()[i]);
  String portName = Serial.list()[Serial.list().length-1];//MAC: check the printed list
  //String portName = Serial.list()[9];//WINDOWS: check the printed list
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n'); // arduino ends each data packet with a carriage return
  port.clear();           // flush the Serial buffer

  file_wrench = new SoundFile(this, "find_wrench_set.wav");
  file_use_wrench = new SoundFile(this, "use_wrench_set.wav");
  file_find_tirepatchset = new SoundFile(this, "find_tire_patch_kit.wav");
  file_use_tirelever = new SoundFile(this, "use_tire_lever.wav");
}

void draw() {
  tm.update();
  background(200);
  tm.displayRaw();
  showInfo("Unit: cm", 0, height);

  activeTagList.clear();
  for (int tagIndex : tm.activeTags) {
    activeTagList.add(tm.tags[tagIndex]);
  }
  println("====");
  for (Tag t : activeTagList) {
    if (t.id != 0 ) println(t.id, nf(t.tx, 0, 2), nf(t.ty, 0, 2), nf(t.tz, 0, 2), nf(t.rx, 0, 2), nf(t.ry, 0, 2), nf(t.rz, 0, 2));
    //t.id = 0 is error-prone.
  }
  println("====");

  boolean id1 = false;
  boolean id2 = false;
  boolean id3 = false;
  boolean id6 = false;
  boolean id8 = false;

  for (int i = 0; i < activeTagList.size(); i++) {
    if (activeTagList.get(i).id == 1) {
      id1 = true;
    }
    
    if (activeTagList.get(i).id == 2) {
      id2 = true;
    }

    if (activeTagList.get(i).id == 3) { //patchkit top
      id3 = true;
    }
    
    if (activeTagList.get(i).id == 6) { //use tire lever
      id6 = true;
    }
    
    if (activeTagList.get(i).id == 8) { //wrench
      id8 = true;
    }
  }

  if (id2 && id8 && step1 == true) {
    port.write('a');
    file_wrench.play();
    step1 = false; //switch to chec off this part
  }

  if (id1 && step2 == true) {
    file_use_wrench.play();
    step2 = false;
    step3 = true;
  }

  if (id2 && id3 && id8 && step3 == true) {
    port.write('b');
    file_find_tirepatchset.play();
    step3 = false;
    step4 = true;
  }
  
  if (id6 && step4 == true) {
    //port.write('b');
    file_use_tirelever.play();
    step3 = false;
    step4 = false;
  }
}

void drawCalibImage() {
  pushStyle();
  imageMode(CENTER);
  image(calibImg, width/2, height/2, (float)calibImg.width*tag2screenRatio, (float)calibImg.height*tag2screenRatio);
  popStyle();
}

void drawCanvas() {
  pushStyle();
  noStroke();
  fill(255);
  rectMode(CENTER);
  rect(width/2, height/2, (float)calibImg.width*tag2screenRatio, (float)calibImg.height*tag2screenRatio);
  popStyle();
}

void showInfo(String s, int x, int y) {
  pushStyle();
  fill(52);
  textAlign(LEFT, BOTTOM);
  textSize(48);
  text(s, x, y);
  popStyle();
}
