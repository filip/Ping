#include "testApp.h"
#define _USE_LIVE_VIDEO

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
    
    colorUI = (255,255,255);
    colorText = (0,0,0);
    ball.ballCol = (255,255,255); 
    
    inc=1;
    blink=ofGetElapsedTimef();
    
    maxScore = 1000;
    
    pong.loadSound("pong.wav");
    ping.loadSound("ping.wav");
    
    
    //if from VIDEO: resize.m4v is 480x320 pixels
        //video.loadMovie("resize.m4v");
        //video.play();
    //looping the video
        //video.setLoopState(OF_LOOP_NORMAL);
    
    //GRABBER
    
    if (ofGetWidth()>550){
        grabber.initGrabber(640, 480, OF_PIXELS_BGRA);
    }
    if (ofGetWidth()<500){
        grabber.initGrabber(480, 320, OF_PIXELS_BGRA);
    }
    
    tex.allocate(grabber.getWidth(), grabber.getHeight(), GL_RGB);
    
    //GRABBER END
    
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
    
    buttonMenu.set(TinyUnicode, "menu", 45, ofGetHeight()-50);
    buttonInfo.set(TinyUnicode, "info", ofGetWidth()/2,ofGetHeight()/6+20);
    buttonOptions.set(TinyUnicode, "options", ofGetWidth()/2,ofGetHeight()/6*2+20);
    buttonExternalDisplay.set(TinyUnicode,"external display", ofGetWidth()/2, ofGetHeight()/6*3+20);
    buttonCredits.set(TinyUnicode, "credits", ofGetWidth()/2, ofGetHeight()/6*4+20);
    buttonStart.set(TinyUnicode, "tap to start", ofGetWidth()/2, ofGetHeight()-60);
    buttonPlusThresh.set(TinyUnicode, "plus", ofGetWidth()/2+80,ofGetHeight()/6*2);
    buttonMinusThresh.set(TinyUnicode, "minus", ofGetWidth()/2-85,ofGetHeight()/6*2);
    buttonSwitch.set(TinyUnicode, "bounce from light px",ofGetWidth()/2,ofGetHeight()/6*3);
    buttonUIcol.set(TinyUnicode, "black UI",ofGetWidth()/2,ofGetHeight()/6*4);
    
}

//--------------------------------------------------------------
void testApp::update(){
    
    // if(!video.isLoaded()) {
    // return;
    // }
    
    //video.update(); //video
    grabber.update(); //grabber
    
    if(whiteUI){
        colorUI = (255,255,255);
        colorText = (0,0,0);
        ball.ballCol = (255,255,255); 
    }else{
        colorUI = (0,0,0);
        colorText = (255,255,255);
        ball.ballCol = (0,0,0); 
    }
    
    if(subMenu==5){
        
//        ball.pixels = video.getPixels();   // video here     
//        ball.videoW = video.getWidth();
//        ball.videoH = video.getHeight();
        
        ball.pixels = grabber.getPixels(); //grabber here
        ball.videoW = grabber.getWidth();
        ball.videoH = grabber.getHeight();
        
        float t = ball.bounce;
        float z = ball.counter;
        ball.update();
        if ( z < ball.counter){
            pong.play();            
        }
        if (t < ball.bounce){
            ping.play();
        }
    
        ball.xpos = ball.xpos + ball.xspeed;
        ball.ypos = ball.ypos + ball.yspeed;       
        
    }        
    
}





//--------------------------------------------------------------
void testApp::draw(){
    
    ofSetColor(255);
    grabber.draw(0, 0); //grabber
    //video.getTexture()->draw(0, 0); //video
    
    ofFill();
    ofEnableAlphaBlending();
    ofSetColor(colorUI,180);
    ofRect(20, 20, ofGetWidth()-40, 10);
    ofRect(20, ofGetHeight()-30, ofGetWidth()-40, 10);
    
    //menu
    
    switch ( subMenu ) {
            
        case 0 :
            
            ofSetColor(colorUI,180);
            ofRect(20,30,440,260);
            ofSetColor(colorText, 200);
            buttonMenu.draw();
            buttonOptions.draw();
            buttonInfo.draw();
            buttonExternalDisplay.draw();
            buttonCredits.draw();
                    
            ofNoFill();
            
            break;
            
        case 1 : 
            ofSetColor(colorUI,180);
            ofRect(20,30,440,260);
            ofSetColor(colorText, 200);
            buttonMenu.draw();
            TinyUnicode.drawString("info", (int) buttonInfo.rx,ofGetHeight()/5);
            TinyUnicode.drawString("PING! Augmented Pixel is a seventies style \nvideogame, that adds a layer of digital information \nand oldschool aesthetics to a video signal: A classic \nrectangular video game ball moves across a video \nimage. Whenever the ball hits something dark, \nit bounces off. The game itself has no rules and \nno goal. Like GTA, it provides a free environment \nin which anything is possible. And like Sony’s \nEyetoy, it uses a video camera as game controller.", 30, ofGetHeight()/5+40);
            break;
            
        case 2 : 
            ofSetColor(colorUI,180);
            ofRect(20,30,440,260);
            ofSetColor(0, 0, 0, 200);
            buttonMenu.draw();
            break;
            
        case 3 : 
            ofSetColor(colorUI,180);
            ofRect(20,30,440,260);
            ofSetColor(colorText, 200);
            buttonMenu.draw();
            TinyUnicode.drawString("credits", (int) buttonCredits.rx, ofGetHeight()/5);
            break;
            
        case 4 :            
            
            ofSetColor(colorUI,180);
            ofRect(20,30,440,260);
            ofSetColor(colorText, 200);
            
            TinyUnicode20.drawString("Hello!", ofGetWidth()/2-45,ofGetHeight()/5);
            TinyUnicode.drawString("PING! Augmented Pixel is a seventies style videogame, \nthat adds a layer of digital information and \noldschool aesthetics to a video signal: A classic \nrectangular video game ball moves across a video \nimage. Whenever the ball hits something dark, \nit bounces off. The game itself has no rules and \nno goal. Like GTA, it provides a free environment \nin which anything is possible. And like Sony’s Eyetoy, \nit uses a video camera as game controller.", 30, ofGetHeight()/5+40);
            
            
            if (ofGetElapsedTimef() - blink < 0.5f) {
                if (inc<0){
                    buttonStart.draw();
                }
                
            }
            else{
                inc=-inc;
                blink=ofGetElapsedTimef();
                
            }
            
            ofNoFill();
            //ofRect(ofGetWidth()/2-50, ofGetHeight()-80, 110, 30);
            
            break;
            
        case 6 :
            
            ofSetColor(colorUI,180);
            ofRect(20,30,440,260);
            ofSetColor(colorText, 200);
            TinyUnicode.drawString("bounce threshold", ofGetWidth()/2 - (int)(TinyUnicode.stringWidth("bounce threshold")*0.5f), ofGetHeight()/6*2- (int)(TinyUnicode.stringHeight("bounce threshold")*0.5f)-20); 
            TinyUnicode.drawString(ofToString(ball.threshold), ofGetWidth()/2 - (int)(TinyUnicode.stringWidth(ofToString(ball.threshold))*0.5f), ofGetHeight()/6*2-(int)(TinyUnicode.stringHeight(ofToString(ball.threshold))*0.5f));            
            buttonMenu.draw();
            buttonPlusThresh.draw();
            buttonMinusThresh.draw();
            buttonSwitch.draw();
            buttonUIcol.draw();
            
            break;
            
        default :
            
            buttonMenu.draw();
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
        buttonMenu.set(TinyUnicode, "back", 45, ofGetHeight()-50);
        if(buttonInfo.bbox.inside(touch.x, touch.y)){
            subMenu = 1; //info
            pong.play();            
        }
        
        if(buttonOptions.bbox.inside(touch.x, touch.y)){
            subMenu = 6; //sensitivity
            pong.play();            
        }
           
        if(buttonExternalDisplay.bbox.inside(touch.x, touch.y)){

            if(ofxiPhoneExternalDisplay::isExternalScreenConnected()){
                if(ofxiPhoneExternalDisplay::isMirroring()){
                    ofxiPhoneExternalDisplay::mirrorOff();
                    pong.play();
                } else {
                    if(!ofxiPhoneExternalDisplay::mirrorOn()){                        
                        presentMirroringFailedPopup();
                        ping.play();
                    }
                    
                }
            } else {
                presentMirroringFailedPopup();
                ping.play();
            }
        }
        
        
//        if(buttonExternalDisplayRect.inside(touch.x, touch.y)){
//            if(ofxiPhoneExternalDisplay::isExternalScreenConnected()){
//                presentExternalDisplayPopup();
//            } else {
//                presentExternalDisplayNotFoundPopup();
//            }
//        }
        
        if(buttonCredits.bbox.inside(touch.x, touch.y)){
            subMenu = 3; //credits
            pong.play();            
        }
        
    }
    
    if(buttonMenu.bbox.inside(touch.x, touch.y)){
        
        if (subMenu==0) {
            subMenu=5;
            buttonMenu.set(TinyUnicode, "menu", 45, ofGetHeight()-50);
            ping.play();            
        } else if (subMenu==5){
            subMenu=0;
            buttonMenu.set(TinyUnicode, "back", 45, ofGetHeight()-50);
            pong.play();            
        } else {
            subMenu=0;
            ping.play();            
        }
        
        
    }
    
    if(buttonStart.bbox.inside(touch.x, touch.y)){
        if (subMenu==4){
            subMenu=5;            
            pong.play();            
        }
    }
    
    if(subMenu==6){
        if(buttonPlusThresh.bbox.inside(touch.x, touch.y)){
            if(ball.threshold<0.9){
                ball.threshold+=0.1;;
                pong.play();
            }
        }
        
        if(buttonMinusThresh.bbox.inside(touch.x, touch.y)){
            if(ball.threshold>0.2){
                ball.threshold-=0.1;
                ping.play();
            }
        }
        if(buttonSwitch.bbox.inside(touch.x, touch.y)){
            if(ball.bounceDark){
                ball.bounceDark= false;
                buttonSwitch.st= "bounce from dark px";
                ball.threshold= 1-ball.threshold;
                ping.play();
            }
            else {
                ball.bounceDark= true;
                buttonSwitch.st= "bounce from light px";
                ball.threshold= 1-ball.threshold;
                pong.play();
            }
            
        }
        if(buttonUIcol.bbox.inside(touch.x, touch.y)){
            if(whiteUI){
                whiteUI= false;
                buttonUIcol.st= "white UI";
                ping.play();
            }
            else {
                whiteUI= true;
                buttonUIcol.st= "black UI";
                pong.play();
            }
            
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



