#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "ball.h"
#include "ofxiPhoneExternalDisplay.h"

#include "ofxXmlSettings.h"

#define NUM_PTS 800

class testApp : public ofxiPhoneApp, public ofxiPhoneExternalDisplay {
    
	
public:
    void setup();
    void update();
    void draw();
    void exit();    
	
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    Ball ball;
    
    float touchRadiusX;
    float touchRadiusY;
    
    //ofVideoGrabber grabber;
    //ofTexture tex;
    //unsigned char * pix;
    //ofPixels graypix;
    
    ofSoundPlayer  pong;    
    ofiPhoneVideoPlayer video;
    
    ofRectangle buttonMenuRect;
    ofRectangle buttonCreditsRect;
    ofRectangle buttonInfoRect;
    ofRectangle buttonExternalDisplayRect;
    ofRectangle buttonStartRect;
    
    bool victory;
    int subMenu;
    int maxScore;
    int inc;
    float blink;
    
    void presentExternalDisplayPopup();
    void presentExternalDisplayNotFoundPopup();
    void presentMirroringFailedPopup();
    void popupDismissed();
    
    void externalDisplayConnected();
    void externalDisplayDisconnected();
    void externalDisplayChanged();
    
    ofTrueTypeFont TinyUnicode;
    ofTrueTypeFont TinyUnicode20;
    
    ofxXmlSettings settings;
    
    
};


