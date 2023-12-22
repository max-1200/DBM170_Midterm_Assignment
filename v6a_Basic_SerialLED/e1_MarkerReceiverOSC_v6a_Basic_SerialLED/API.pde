//trigger your events here
int id1detect = 0;
int id2detect = 0;
int id3detect = 0;
int id4detect = 0;

boolean step1 = true;
boolean step2 = true;
boolean step3 = false;
boolean step4 = false;
boolean step5 = false;

void tagPresent3D(int id, float tx, float ty, float tz, float rx, float ry, float rz) {
  
    println("+ Tag:", id, "loc = (", tx, ",", ty, ",", tz, "), angle = (", degrees(rx),",",degrees(ry),",",degrees(rz),")");
    
    //if(id == 2 && step1 == true){  //step 1 of patching the tire, finding the wrench
    //  port.write('a');
    //  file_wrench.play();
    //  step1 = false; //switch to chec off this part 
    //}
    
    //if(id == 1 && step2 == true){ //using the wrench to remove the wheel
    //  //does not need a portwrite since this step does not need the toolboard
    //  file_use_wrench.play();
    //  step2 = false;
    //  step3 = true;
      
    //}
    
    //if(id == 2 && step3 == true){ //find the tirepatchtool
    //  port.write('b');
    //  file_find_tirepatchset.play();
    //  step3 = false;
    //}
    
    //if(id == 3  && step4 == true){
    //  file_use_tirelever.play();
    //  step4 = false;
    //  step5 = true;
    //}
    
    //if(id == 2 && step5 == true){ //only use this if there is time to think this true.
      
    //}
    
    
    
        //if(id == 1 && id1detect == 0){ // if a message comes in and it's id = 1 and the previous one it was not 1 detect that this is the first one (id1detect = 1)
        //  id1detect = id1detect + 1;    
        //}
        
        //if(id1detect >= 1  && id == 2){ // if the previous message id is 1 and the id now is 2, do the following
        //  port.write('a');
        //  file_wrench.play();
        //  id1detect = 0;
        //}
    
    //if(id == 1 && id == 2){ //board and wrench
    //  port.write('a');
    //  file_wrench.play();
    //}
    
    //if(id == 1){ //only wrench
    //  port.write('b');
    //}
    
    //if(id == 3 && id == 2){ //tire patch set and board
    //  port.write('c');
    //}
    
    //if(id == 3){ //tire patch set 
    //  port.write('d');
    //}
    
    //if(id == 4){ //tire levers
    //  port.write('e');
    //}
}

void tagAbsent3D(int id, float tx, float ty, float tz, float rx, float ry, float rz) {
    println("- Tag:", id, "loc = (", tx, ",", ty, ",", tz,"), angle = (", degrees(rx),",",degrees(ry),",",degrees(rz),")");
    //if(id == 1) port.write('b');
    //if(id == 2) port.write('d');
    //if(id == 3) port.write('f'); 
    //if(id == 4) port.write('h');
}

void tagUpdate3D(int id, float tx, float ty, float tz, float rx, float ry, float rz) {
  //if(serialDebug && !isCorner(id)) println("% Tag:", id, "loc = (", tx, ",", ty, ",", tz,"), angle = (", degrees(rx),",",degrees(ry),",",degrees(rz),")");
}

void tagPresent2D(int id, float x, float y, float z, float rz) {
  if (serialDebug && homographyMatrixCalculated && !isCorner(id)) {
    PVector t = img2screen(transformPoint(new PVector(x, y, z), homography));
    //println("+ Tag:", id, "loc = (", t.x, ",", t.y, "), angle = ", degrees(rz));
  }
}

void tagAbsent2D(int id, float x, float y, float z, float rz) {
  if (serialDebug && homographyMatrixCalculated && !isCorner(id)) {
    PVector t = img2screen(transformPoint(new PVector(x, y, z), homography));
    //println("- Tag:", id, "loc = (", t.x, ",", t.y, "), angle = ", degrees(rz));
  }
}

void tagUpdate2D(int id, float x, float y, float z, float rz) {
  if (serialDebug && homographyMatrixCalculated && !isCorner(id)) {
    PVector t = img2screen(transformPoint(new PVector(x, y, z), homography));
    float distance = distancePointToPlane(new PVector(x, y, z), planePoints);
    //println("% Tag:", id, "loc = (", t.x, ",", t.y, "), angle = ", degrees(rz),", d= ",distance);
  }
}

void bundlePresent2D(int id, float x, float y, float z, float rz) {
  if (serialDebug && homographyMatrixCalculated && !isCorner(id)) {
    PVector t = img2screen(transformPoint(new PVector(x, y, z), homography));
    println("+ Bundle:", id, "loc = (", t.x, ",", t.y, "), angle = ", degrees(rz));
  }
  if (homographyMatrixCalculated && !isCorner(id)) {
    PVector t = img2screen(transformPoint(new PVector(x, y, z), homography));
    for (DataObject obj : DOlist) {
      if (obj.checkHit(t.x, t.y, tm.BUNDLE_D/2)) {
        if (!obj.hasCtrlID(id)) {
          obj.addCtrlID(id, new PVector(t.x,t.y), rz);
        }
      }
    }
  }
}

void bundleAbsent2D(int id, float x, float y, float z, float rz) {
  if (serialDebug && homographyMatrixCalculated && !isCorner(id)) {
    PVector t = img2screen(transformPoint(new PVector(x, y, z), homography));
    println("- Bundle:", id, "loc = (", t.x, ",", t.y, "), angle = ", degrees(rz));
  }
  if (homographyMatrixCalculated && !isCorner(id)) {
    PVector t = img2screen(transformPoint(new PVector(x, y, z), homography));
    for (DataObject obj : DOlist) {
      if (obj.hasCtrlID(id)) {
        obj.removeCtrlID(id);
      }
    }
  }
}

void bundleUpdate2D(int id, float x, float y, float z, float rz) {
  if (serialDebug && homographyMatrixCalculated && !isCorner(id)) {
    PVector t = img2screen(transformPoint(new PVector(x, y, z), homography));
    //println("% Tag:", id, "loc = (", t.x, ",", t.y, "), angle = ", degrees(rz));
  }
  if (homographyMatrixCalculated && !isCorner(id)) {
    PVector t = img2screen(transformPoint(new PVector(x, y, z), homography));
    for (DataObject obj : DOlist) {
      if (obj.hasCtrlID(id)) {
        if (obj.getCtrlCounts()==1) {
          //obj.update(obj.val, t.x-obj.ref2D.x, t.y-obj.ref2D.x, rz-obj.ref_r);
        }
      }
    }
  }
}
