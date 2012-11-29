#include "button.h"


void setup(){

    
}

void Button::set(ofTrueTypeFont f, string s, int x, int y) {
    font = f;
    st = s;
    rx = x - font.stringWidth(st)*0.5f;
    ry = y - font.stringHeight(st)*0.5f;
    
    bbox = font.getStringBoundingBox(st, rx, ry);
    bbox.x-=13;
    bbox.y-=13;
    bbox.width+=26;
    bbox.height+=26;

}

void Button::draw(){
    font.drawString(st,(int)rx,(int)ry);
    //ofNoFill();
    //ofRect(bbox.x,bbox.y,bbox.width,bbox.height);
}

