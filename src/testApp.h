#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "ball.h"
#include "button.h"
#include "ofxiPhoneExternalDisplay.h"

#include "ofxXmlSettings.h"
#include "ofxSVG.h"

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

    Button buttonMenu;
    Button buttonCredits;
    Button buttonInfo;
    Button buttonExternalDisplay;
    Button buttonStart;
    Button buttonPlusThresh;
    Button buttonMinusThresh;
    Button buttonOptions;
    Button buttonSwitch;
    Button buttonUIcol;
    
    ofxSVG svg1;
    ofxSVG svg2;
    ofxSVG svg3;
    ofxSVG svg4;
    ofxSVG svg5;
    ofxSVG svg6;
    ofxSVG svg7;
    ofxSVG svg8;
    
    ofColor colorUI;
    ofColor colorText;
    
    float touchRadiusX;
    float touchRadiusY;
    
    //GRABBER
    ofVideoGrabber grabber;
    ofTexture tex;
    
    //VIDEO PLAYER
//    ofiPhoneVideoPlayer video;
    
    //SOUND PLAYER
    ofSoundPlayer pong;
    ofSoundPlayer ping;
    
    bool whiteUI;
    int subMenu;
    int maxScore;
    int inc;
    float blink;
    float scale;
    
    void presentExternalDisplayPopup();
    void presentExternalDisplayNotFoundPopup();
    void presentMirroringFailedPopup();
    void popupDismissed();
    
    void externalDisplayConnected();
    void externalDisplayDisconnected();
    void externalDisplayChanged();
    
    ofTrueTypeFont TinyUnicode;
    
    ofxXmlSettings settings;
    
    
};


