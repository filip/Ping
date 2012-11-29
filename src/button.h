#ifndef _BUTTON_H
#define _BUTTON_H

#include "ofMain.h"
#include "ofxiPhone.h"


class Button{
	
public: 
    
    void set(ofTrueTypeFont f, string s, int x, int y);
	void update();
	void draw();
    
    ofTrueTypeFont font;
    
    ofRectangle bbox;
    
    string st;
    float rx;
    float ry;
    
private:
  
};


#endif
