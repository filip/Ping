#include "testApp.h"
//#define _USE_LIVE_VIDEO

#import "MyViewController.h"
#import "AlertViewDelegate.h"

MyViewController * viewController = nil;
AlertViewDelegate * alertViewDelegate = nil;

//--------------------------------------------------------------
void testApp::setup(){	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//If you want a landscape oreintation 
	iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
    
    ofTrueTypeFont::setGlobalDpi(72);
    
	TinyUnicode.loadFont("Commodore_Pixelized.ttf", 10, false);
    
    TinyUnicode20.loadFont("Commodore_Pixelized.ttf", 20, false);
    
    ofBackground(200,200,200);
    
    ofSetLogLevel(OF_LOG_VERBOSE);

    
    touchRadiusX = 40;
    touchRadiusY = 40;
    
    
    victory = false;
    inc=1;
    blink=ofGetElapsedTimef();
    
    maxScore = 1000;
    
    pong.loadSound("pong.wav");
   
   
    //resize.m4v is 480x320 pixels
    video.loadMovie("resize.m4v");
	video.play();
    //looping the video
    video.setLoopState(OF_LOOP_NORMAL);
   
    ball.setup();
    
    if( settings.loadFile(ofxiPhoneGetDocumentsDirectory() + "settings.xml") ){
		
	}else if(settings.loadFile("settings.xml") ){
		
	}
    
    ball.counter= settings.getValue("settings:score",0);
    ball.xpos = settings.getValue("settings:xpos",ofGetWidth()/2);
    ball.ypos = settings.getValue("settings:ypos", ofGetHeight()/2);
    ball.xspeed = settings.getValue("settings:speedx", 2);
    ball.yspeed = settings.getValue("settings:speedy", 2);
    subMenu = settings.getValue("settings:firstLaunch",5);
    
    //menu buttons
    
    buttonMenuRect.width = 50;
    buttonMenuRect.height = 30;
    buttonMenuRect.x = 20;
    buttonMenuRect.y = ofGetHeight()-70;
    
    buttonInfoRect.width = 55;
    buttonInfoRect.height = 30;
    buttonInfoRect.x = ofGetWidth()/2-30;
    buttonInfoRect.y = ofGetHeight()/5;
    
    buttonExternalDisplayRect.width = 150;
    buttonExternalDisplayRect.height = 30;
    buttonExternalDisplayRect.x = ofGetWidth()/2-75;
    buttonExternalDisplayRect.y = ofGetHeight()/5*2;
    
    buttonCreditsRect.width = 75;
    buttonCreditsRect.height = 30;
    buttonCreditsRect.x = ofGetWidth()/2-40;
    buttonCreditsRect.y = ofGetHeight()/5*3;
    
    buttonStartRect.width = 110;
    buttonStartRect.height = 30;
    buttonStartRect.x = ofGetWidth()/2-50;
    buttonStartRect.y = ofGetHeight()-80;
    
}

//--------------------------------------------------------------
void testApp::update(){
    
    if(!video.isLoaded()) {
        return;
    }
    video.update();    
   
    //borders    
    if (ball.xpos > ofGetWidth()-20) {
        ball.xpos = 20;
    }
    else if (ball.xpos < 20){
        ball.xpos = ofGetWidth()-20;
    }
    
    //bars at bottom and top
    if (ball.ypos < 30){ 
        ball.ypos = 30;
        ball.yspeed = ball.yspeed * (-1);
        pong.play();        
    }
    
    if (ball.ypos > ofGetHeight()-40){
        ball.ypos = ofGetHeight()-40;
        ball.yspeed = ball.yspeed * (-1);        
        pong.play();
    }
    
    
    if(subMenu==5){
        
        ball.pixels = video.getPixels();        
        ball.videoW = video.getWidth();
        ball.videoH = video.getHeight();
        
        ball.update();
        
        
        if (!victory){
            ball.xpos = ball.xpos + ball.xspeed;
            ball.ypos = ball.ypos + ball.yspeed;   
        }
        
    }        

}





//--------------------------------------------------------------
void testApp::draw(){
    
    ofSetColor(255);
    video.getTexture()->draw(0, 0);

    ofFill();
    ofEnableAlphaBlending();
    ofSetColor(255, 255, 255, 180);
    ofRect(20, 20, ofGetWidth()-40, 10);
    ofRect(20, ofGetHeight()-30, ofGetWidth()-40, 10);
    
//    if (ball.counter >= maxScore){
//        victory=true;
//        TinyUnicode.drawString("Victory!", ofGetWidth()/2-30, ofGetHeight()/2-10);
//        TinyUnicode.drawString("double tap to restart", ofGetWidth()/2-80, ofGetHeight()/2+10);
//    }
//    else{
//        victory=false;
//    }
    
   
    
    
    //menu

    switch ( subMenu ) {
            
        case 0 :
            
            ofSetColor(255, 255, 255, 180);
            ofRect(20,30,440,260);
            ofSetColor(150, 0, 0, 200);
            TinyUnicode.drawString("back", 30, ofGetHeight()-50);
            
            TinyUnicode.drawString("info", ofGetWidth()/2-20,ofGetHeight()/5+20);
            TinyUnicode.drawString("external display", ofGetWidth()/2-65, ofGetHeight()/5*2+20);
            TinyUnicode.drawString("credits", ofGetWidth()/2-30, ofGetHeight()/5*3+20);
            
            ofNoFill();
            
            //ofRect(ofGetWidth()/2-30,ofGetHeight()/5,55,30);
            //ofRect(ofGetWidth()/2-75, ofGetHeight()/5*2,150,30);
            //ofRect(ofGetWidth()/2-40, ofGetHeight()/5*3,75,30); 
            
            break;
            
        case 1 : 
            ofSetColor(255, 255, 255, 180);
            ofRect(20,30,440,260);
            ofSetColor(150, 0, 0, 200);
            TinyUnicode.drawString("back", 30, ofGetHeight()-50);
            TinyUnicode.drawString("info", ofGetWidth()/2-20,ofGetHeight()/5);
            TinyUnicode.drawString("PING! Augmented Pixel is a seventies style \nvideogame, that adds a layer of digital information \nand oldschool aesthetics to a video signal: A classic \nrectangular video game ball moves across a video \nimage. Whenever the ball hits something dark, \nit bounces off. The game itself has no rules and \nno goal. Like GTA, it provides a free environment \nin which anything is possible. And like Sony’s \nEyetoy, it uses a video camera as game controller.", 30, ofGetHeight()/5+40);
            break;
            
        case 2 : 
            ofSetColor(255, 255, 255, 180);
            ofRect(20,30,440,260);
            ofSetColor(150, 0, 0, 200);
            TinyUnicode.drawString("back", 30, ofGetHeight()-50);
            TinyUnicode.drawString("fullscreen", ofGetWidth()/2-40, ofGetHeight()/5);
            break;
            
        case 3 : 
            ofSetColor(255, 255, 255, 180);
            ofRect(20,30,440,260);
            ofSetColor(150, 0, 0, 200);
            TinyUnicode.drawString("back", 30, ofGetHeight()-50);
            TinyUnicode.drawString("credits", ofGetWidth()/2-30, ofGetHeight()/5);
            break;
            
        case 4 :            
            
            ofSetColor(255, 255, 255, 180);
            ofRect(20,30,440,260);
            ofSetColor(150, 0, 0, 200);

            TinyUnicode20.drawString("Hello!", ofGetWidth()/2-45,ofGetHeight()/5);
            TinyUnicode.drawString("PING! Augmented Pixel is a seventies style videogame, \nthat adds a layer of digital information and \noldschool aesthetics to a video signal: A classic \nrectangular video game ball moves across a video \nimage. Whenever the ball hits something dark, \nit bounces off. The game itself has no rules and \nno goal. Like GTA, it provides a free environment \nin which anything is possible. And like Sony’s Eyetoy, \nit uses a video camera as game controller.", 30, ofGetHeight()/5+40);
            
            
            if (ofGetElapsedTimef() - blink < 0.5f) {
                if (inc<0){
                    TinyUnicode.drawString("tap to start", ofGetWidth()/2-45, ofGetHeight()-60);
                }

            }
            else{
            inc=-inc;
            blink=ofGetElapsedTimef();
            
            }
            
            ofNoFill();
            //ofRect(ofGetWidth()/2-50, ofGetHeight()-80, 110, 30);
            
            break;
            
        default :
            
            TinyUnicode.drawString("menu", 30, ofGetHeight()-50);
            TinyUnicode.drawString("score " + ofToString(ball.counter), 30, 60);
            ball.draw();
            
            
            ofNoFill();
            //ofRect(20,ofGetHeight()-70,50,30);
            

            break;
            
    }
    
    
}

//--------------------------------------------------------------
void testApp::exit(){
    
    settings.setValue("settings:score", ball.counter);
    settings.setValue("settings:xpos", ball.xpos);
    settings.setValue("settings:ypos", ball.ypos);
    settings.setValue("settings:speedx", ball.xspeed);
    settings.setValue("settings:speedy", ball.yspeed);
    settings.setValue("settings:firstLaunch", 5);
    settings.saveFile("settings.xml");
    pong.stop();
    
}

void testApp::presentExternalDisplayPopup(){
    
    alertViewDelegate = [[[AlertViewDelegate alloc] init] retain];
    
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"External Display" 
                                                      message:@"Select a External Display Mode" 
                                                     delegate:alertViewDelegate 
                                            cancelButtonTitle:@"Cancel" 
                                            otherButtonTitles:nil] retain];
    
    vector<ofxiPhoneExternalDisplayMode> displayModes;
    displayModes = ofxiPhoneExternalDisplay::getExternalDisplayModes();
    
    [alert addButtonWithTitle:@"Preferred Mode"];
    
    for(int i = 0; i < displayModes.size(); i++){
        string buttonText = ofToString(displayModes[i].width) + " x " + ofToString(displayModes[i].height);
        [alert addButtonWithTitle:ofxStringToNSString(buttonText)];
    }
    
    [alert show];
    [alert release];
}

//--------------------------------------------------------------
void testApp::presentExternalDisplayNotFoundPopup(){
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"External Display" 
                                                      message:@"External Display not found.\nConnect to an external display using a VGA adapter or AirPlay."
                                                     delegate:nil 
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil] retain];
    [alert show];
    [alert release];
}

void testApp::presentMirroringFailedPopup(){
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Mirroring Failed" 
                                                      message:@"Either you are not connected to an external display or your device does not support mirroring."
                                                     delegate:nil 
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil] retain];
    [alert show];
    [alert release];
}

//--------------------------------------------------------------
void testApp::popupDismissed(){
    if(alertViewDelegate){
        [alertViewDelegate release];
        alertViewDelegate = nil;
    }
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){

    if(subMenu==0){
        if(buttonInfoRect.inside(touch.x, touch.y)){
            subMenu = 1; //info
        }
        
        if(buttonExternalDisplayRect.inside(touch.x, touch.y)){
            if(ofxiPhoneExternalDisplay::isExternalScreenConnected()){
                presentExternalDisplayPopup();
            } else {
                presentExternalDisplayNotFoundPopup();
            }
        }
        
        if(buttonCreditsRect.inside(touch.x, touch.y)){
            subMenu = 3; //credits
        }
        
    }
    
    if(buttonMenuRect.inside(touch.x, touch.y)){
        
        if (subMenu==0) {
            subMenu=5;
        } else {
            subMenu=0;    
        }
        
    }
    
    if(buttonStartRect.inside(touch.x, touch.y)){
        if (subMenu==4){
            subMenu=5;
        }
    }
    
    
    
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

    
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

    
    
    
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){
    
    if(subMenu==5){
        ball.xpos = ofGetWidth()/2;
        ball.ypos = ofGetHeight()/2;
        
        float s = ofRandom(-1,1);
        if (s>=0){
            ball.xspeed = 2;
        } else {
            ball.xspeed = -2;      
        }
        
        float a = ofRandom(-1,1);
        if (a>=0){
            ball.yspeed = 2;
        } else {
            ball.yspeed = -2;      
        }
        
        ball.counter = 0;
    }
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

//--------------------------------------------------------------
void testApp::externalDisplayConnected(){
    ofLogVerbose("external display connected.");
    presentExternalDisplayPopup();
}

//--------------------------------------------------------------
void testApp::externalDisplayDisconnected(){
    ofLogVerbose("external display disconnected.");
}

//--------------------------------------------------------------
void testApp::externalDisplayChanged(){
    ofLogVerbose("external display changed.");
    if(ofxiPhoneExternalDisplay::isDisplayingOnDeviceScreen()){
        if(viewController){
            [viewController.view removeFromSuperview];
            [viewController release];
            viewController = nil;
        }
    } else if(ofxiPhoneExternalDisplay::isDisplayingOnExternalScreen()) {
        if(!viewController){
            viewController = [[[MyViewController alloc] init] retain];
            [ofxiPhoneGetAppDelegate().window addSubview:viewController.view];  // add to device window.
        }
    }
}



