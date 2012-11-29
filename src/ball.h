//
//  ball.h
//  ping
//
//  Created by Filip Visnjic on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef _BALL_H
#define _BALL_H

#include "ofMain.h"
#include "ofxiPhone.h"


class Ball{
	
public: 
    
    void setup();
	void update();
	void draw();
    
    float xpos;
    float ypos;
    float xspeed;
    float yspeed;
    float mysize;
    
    unsigned char * pixels;
    int videoW;
    int videoH;
    int speed;
    bool bounceDark;
    float t;
    float counter;
    float bounce;
    float timer;
    float threshold;
    ofColor ballCol;
    
private:
  
};


#endif
