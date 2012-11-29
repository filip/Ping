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
    
    colorUI = (255);
    colorText = (0);
    ball.ballCol = (255);
    
    inc=1;
    blink=ofGetElapsedTimef();
    
    maxScore = 1000;
    
    pong.loadSound("pong.wav");
    ping.loadSound("ping.wav");
    
    
    //if from VIDEO: resize.m4v is 480x320 pixels
//    video.loadMovie("resize.m4v");
//    video.play();
//    //looping the video
//    video.setLoopState(OF_LOOP_NORMAL);
    
    //GRABBER
    
    if (ofGetWidth()==568){
        grabber.initGrabber(640, 480, OF_PIXELS_BGRA); //iPhone 5
    }
    if (ofGetWidth()==480){
        grabber.initGrabber(480, 320, OF_PIXELS_BGRA); //iPhone 4-
    }
    if (ofGetWidth()==1024){
        grabber.initGrabber(1024, 748, OF_PIXELS_BGRA); //iPad
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
    ball.xspeed = settings.getValue("settings:speedx", ball.speed);
    ball.yspeed = settings.getValue("settings:speedy", ball.speed);
    subMenu = settings.getValue("settings:firstLaunch",5);
    whiteUI = settings.getValue("settings:colorUI", 1);
    ball.bounceDark = settings.getValue("settings:bounceDark", 1);
    ball.threshold = settings.getValue("settings:threshhold",0.5);


    //menu buttons
    
    buttonMenu.set(TinyUnicode, "menu", 45, ofGetHeight()-50);
    buttonInfo.set(TinyUnicode, "info", ofGetWidth()/2,ofGetHeight()/6+20);
    buttonOptions.set(TinyUnicode, "options", ofGetWidth()/2,ofGetHeight()/6*2+20);
    buttonExternalDisplay.set(TinyUnicode,"external display", ofGetWidth()/2, ofGetHeight()/6*3+20);
    buttonCredits.set(TinyUnicode, "credits", ofGetWidth()/2, ofGetHeight()/6*4+20);
    buttonStart.set(TinyUnicode, "tap to start", ofGetWidth()/2, ofGetHeight()-60);
    buttonPlusThresh.set(TinyUnicode, "plus", ofGetWidth()/2+80,ofGetHeight()/6*2);
    buttonMinusThresh.set(TinyUnicode, "minus", ofGetWidth()/2-85,ofGetHeight()/6*2);
    buttonSwitch.set(TinyUnicode, "bounce from dark px",ofGetWidth()/2,ofGetHeight()/6*3);
    buttonUIcol.set(TinyUnicode, "white UI",ofGetWidth()/2,ofGetHeight()/6*4);
    if (!ball.bounceDark){
        buttonSwitch.st="bounce from light px";
    }
    if (!whiteUI){
        buttonUIcol.st = "black UI";
    }
    
}

//--------------------------------------------------------------
void testApp::update(){
    
    //video.update(); //video
    grabber.update(); //grabber
    
    if(whiteUI){
        colorUI = (255);
        colorText = (0);
        ball.ballCol = (255); 
    }else{
        colorUI = (0);
        colorText = (255);
        ball.ballCol = (0); 
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
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
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
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(colorText, 200);
            buttonMenu.draw();
            TinyUnicode.drawString("info", (int) buttonInfo.rx,ofGetHeight()/5);
            TinyUnicode.drawString("PING! Augmented Pixel is a seventies style \nvideogame, that adds a layer of digital information \nand oldschool aesthetics to a video signal: A classic \nrectangular video game ball moves across a video \nimage. \n \nWhenever the ball hits something dark, \nit bounces off. The game itself has no rules and \nno goal. Like GTA, it provides a free environment \nin which anything is possible. And like Sony’s \nEyetoy, it uses a video camera as game controller.", ofGetWidth()/2-210, ofGetHeight()/2-60);
            break;
            
        case 2 : 
            ofSetColor(colorUI,180);
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(0, 0, 0, 200);
            buttonMenu.draw();
            break;
            
        case 3 : 
            ofSetColor(colorUI,180);
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(colorText, 200);
            buttonMenu.draw();
            TinyUnicode.drawString("credits ", (int) buttonCredits.rx, ofGetHeight()/5);
            TinyUnicode.drawString("PING! by Andrey Yelbayev and Filip Visnjic, \ninspired by Niklas Roy", ofGetWidth()/2-190, ofGetHeight()/2);
            

            break;
            
        case 4 :            
            
            ofSetColor(colorUI,180);
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(colorText, 200);
            
            TinyUnicode20.drawString("Hello!", ofGetWidth()/2-45,ofGetHeight()/5);
            TinyUnicode.drawString("PING! Augmented Pixel is a seventies style videogame, \nthat adds a layer of digital information and \noldschool aesthetics to a video signal: A classic \nrectangular video game ball moves across a video \nimage. \n\nWhenever the ball hits something dark, \nit bounces off.", ofGetWidth()/2-210, ofGetHeight()/2-40);
            
            
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
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(colorText, 200);
            TinyUnicode.drawString("bounce threshold", ofGetWidth()/2 - (int)(TinyUnicode.stringWidth("bounce threshold")*0.5f), ofGetHeight()/6*2- (int)(TinyUnicode.stringHeight("bounce threshold")*0.5f)-30); 
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
    settings.setValue("settings:colorUI", whiteUI);
    settings.setValue("settings:threshhold", ball.threshold);
    settings.setValue("settings:bounceDark", ball.bounceDark);
    settings.setValue("settings:firstLaunch", 5);    
    settings.saveFile("settings.xml");
    
    pong.stop();
    
}

void testApp::presentExternalDisplayPopup(){
    
//    alertViewDelegate = [[[AlertViewDelegate alloc] init] retain];
//    
//    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"External Display" 
//                                                      message:@"Select a External Display Mode" 
//                                                     delegate:alertViewDelegate 
//                                            cancelButtonTitle:@"Cancel" 
//                                            otherButtonTitles:nil] retain];
//    
//    vector<ofxiPhoneExternalDisplayMode> displayModes;
//    displayModes = ofxiPhoneExternalDisplay::getExternalDisplayModes();
//    
//    [alert addButtonWithTitle:@"Preferred Mode"];
//    
//    for(int i = 0; i < displayModes.size(); i++){
//        string buttonText = ofToString(displayModes[i].width) + " x " + ofToString(displayModes[i].height);
//        [alert addButtonWithTitle:ofxStringToNSString(buttonText)];
//    }
//    
//    [alert show];
//    [alert release];
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
                ball.bounceDark= 0;
                buttonSwitch.st= "bounce from light px";
                ball.threshold= 1-ball.threshold;
                ping.play();
            }
            else {
                ball.bounceDark= 1;
                buttonSwitch.st= "bounce from dark px";
                ball.threshold= 1-ball.threshold;
                pong.play();
            }
            
        }
        if(buttonUIcol.bbox.inside(touch.x, touch.y)){
            if(whiteUI){
                whiteUI= 0;
                buttonUIcol.st= "black UI";
                ping.play();
            }
            else {
                whiteUI= 1;
                buttonUIcol.st= "white UI";
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
            ball.xspeed = ball.speed;
        } else {
            ball.xspeed = -ball.speed;      
        }
        
        float a = ofRandom(-1,1);
        if (a>=0){
            ball.yspeed = ball.speed;
        } else {
            ball.yspeed = -ball.speed;      
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



