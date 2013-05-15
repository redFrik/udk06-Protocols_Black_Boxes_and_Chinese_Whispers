//first install oscP5 library
//http://www.sojamo.de/libraries/oscP5/
//put it in Documents/Processing/libraries

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress puredata;
int rrr, ggg, bbb, aaa;

void setup() {
  size(320, 240);
  rectMode(CENTER);
  noStroke();
  oscP5= new OscP5(this, 12000);  //receive port
  rrr= 255;
  ggg= 255;
  bbb= 255;
  aaa= 255;
  puredata= new NetAddress("127.0.0.1", 57120);  //ip pure-data
}
void draw() {
  background(0);
  fill(rrr, ggg, bbb, aaa);
  rect(mouseX, mouseY, 30, 30);
  sendOscFloat(mouseX, mouseY);
}
void oscEvent(OscIn oscIn) {                //osc in
  if(oscIn.checkAddrPattern("abc")) {
    if(oscIn.checkTypetag("iiii")) {
      rrr= oscIn.getInt(0);
      ggg= oscIn.getInt(1);
      bbb= oscIn.getInt(2);
      aaa= oscIn.getInt(3);
    }
  }
}
void sendOscFloat(float x, float y) {      //osc out
  OscMessage msg= new OscMessage("/mouse");
  msg.add(x);
  msg.add(y);
  oscP5.send(msg, puredata);
}

