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
    
    buttonMenu.set(TinyUnicode, "menu", 60, ofGetHeight()-50);
    buttonInfo.set(TinyUnicode, "info", ofGetWidth()/2,ofGetHeight()/6+20);
    buttonOptions.set(TinyUnicode, "options", ofGetWidth()/2,ofGetHeight()/6*2+20);
    buttonExternalDisplay.set(TinyUnicode,"external display", ofGetWidth()/2, ofGetHeight()/6*3+20);
    buttonCredits.set(TinyUnicode, "credits", ofGetWidth()/2, ofGetHeight()/6*4+20);
    buttonStart.set(TinyUnicode, "next", ofGetWidth()-60, ofGetHeight()-50);
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
    svg1.load("Ping_12.svg");
    svg2.load("Ping_11.svg");
    svg3.load("Ping_10.svg");
    svg4.load("Ping_9.svg");
    svg5.load("Ping_13.svg");
    svg6.load("Ping_14.svg");
    svg7.load("Ping_15.svg");
    svg8.load("Ping_16.svg");
}

//--------------------------------------------------------------
void testApp::update(){
    
//    video.update(); //video
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
            if (ofGetElapsedTimef() - blink < 0.5f) {
                if (inc<0){
                    buttonStart.draw();
                }
            }
            else{
                inc=-inc;
                blink=ofGetElapsedTimef();                
            }
            TinyUnicode.drawString("       This is PING! Augmented Pixel. \nIt is a tribute to Pong games that utilises \nthe camera feed of your device to interact \nwith a pixel ball. Whenever the ball hits \n      something dark it bounces off.", ofGetWidth()/2-170, ofGetHeight()/2-20);            
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
            TinyUnicode.drawString("PING! made by Andrey Yelbayev, \npublished by CreativeApplication.Net, \ninspired by Niklas Roy", ofGetWidth()/2-180, ofGetHeight()/2-10);
            break;            
        case 4 :
            buttonMenu.set(TinyUnicode, "back", 60, ofGetHeight()-50);
            ofSetColor(colorUI,180);
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(colorText, 200); 
            TinyUnicode.drawString("Hello", (int) ofGetWidth()/2-25,ofGetHeight()/5+40); 
            TinyUnicode.drawString("       This is PING! Augmented Pixel. \nIt is a tribute to Pong games that utilises \nthe camera feed of your device to interact \nwith a pixel ball. Whenever the ball hits \n       something dark it bounces off.", ofGetWidth()/2-170, ofGetHeight()/2-20);
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
        case 7:
            ofSetColor(colorUI,180);
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(colorText, 200);
            buttonMenu.draw();
            if (ofGetElapsedTimef() - blink < 0.5f) {
                if (inc<0){
                    buttonStart.draw();
                }
            }
            else{
                inc=-inc;
                blink=ofGetElapsedTimef();                
            }
            ofPushMatrix();
            ofTranslate(ofGetWidth()/2,ofGetHeight()/2-30);    
            scale = 0.6*ofGetHeight()/svg1.getHeight();
            ofScale(scale, scale);
            ofTranslate(-svg1.getWidth()/2,-svg1.getHeight()/2);    
            if (whiteUI){
            svg1.draw();
            } else {
            svg5.draw();
            }
            ofPopMatrix();
            TinyUnicode.drawString("You may point your camera at bright monochrome\n       surface and use a finger to play", ofGetWidth()/2- 180, ofGetHeight() - 90);         
            break;
        case 8:
            ofSetColor(colorUI,180);
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(colorText, 200);
            buttonMenu.draw();
            if (ofGetElapsedTimef() - blink < 0.5f) {
                if (inc<0){
                    buttonStart.draw();
                }
            }
            else{
                inc=-inc;
                blink=ofGetElapsedTimef();                
            }
            ofPushMatrix();
            ofTranslate(ofGetWidth()/2,ofGetHeight()/2-30);    
            scale = 0.6*ofGetHeight()/svg2.getHeight();
            ofScale(scale, scale);
            ofTranslate(-svg2.getWidth()/2,-svg2.getHeight()/2);    
            if (whiteUI){
                svg2.draw();
            } else {
                svg6.draw();
            }
            ofPopMatrix();
            TinyUnicode.drawString("or inspect your surroundings to see how\n      the ball will bounce around.", ofGetWidth()/2- 160,ofGetHeight() - 90); 
            break;
        case 9:
            ofSetColor(colorUI,180);
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(colorText, 200);
            buttonMenu.draw();
            if (ofGetElapsedTimef() - blink < 0.5f) {
                if (inc<0){
                    buttonStart.draw();
                }
            }
            else{
                inc=-inc;
                blink=ofGetElapsedTimef();                
            }
            ofPushMatrix();
            ofTranslate(ofGetWidth()/2,ofGetHeight()/2-30);    
            scale = 0.6*ofGetHeight()/svg3.getHeight();
            ofScale(scale, scale);
            ofTranslate(-svg3.getWidth()/2,-svg3.getHeight()/2);    
            if (whiteUI){
                svg3.draw();
            } else {
                svg7.draw();
            }
            ofPopMatrix();
            TinyUnicode.drawString("You may plug your device to external monitor,", ofGetWidth()/2 - 180,ofGetHeight() - 90); 
            break;
        case 10:
            ofSetColor(colorUI,180);
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(colorText, 200);
            buttonMenu.draw();
            if (ofGetElapsedTimef() - blink < 0.5f) {
                if (inc<0){
                    buttonStart.draw();
                }
            }
            else{
                inc=-inc;
                blink=ofGetElapsedTimef();                
            }
            ofPushMatrix();
            ofTranslate(ofGetWidth()/2,ofGetHeight()/2-30);    
            scale = 0.6*ofGetHeight()/svg4.getHeight();
            ofScale(scale, scale);
            ofTranslate(-svg4.getWidth()/2,-svg4.getHeight()/2);    
            if (whiteUI){
                svg4.draw();
            } else {
                svg8.draw();
            }
            ofPopMatrix();
            TinyUnicode.drawString("or use a projector to bring gaming experience\n              to the next level.", ofGetWidth()/2- 180, ofGetHeight() - 90); 
            break;
        case 11:
            ofSetColor(colorUI,180);
            ofRect(20,30,ofGetWidth()-40,ofGetHeight()-60);
            ofSetColor(colorText, 200);
            buttonMenu.draw();
            if (ofGetElapsedTimef() - blink < 0.5f) {
                if (inc<0){
                    buttonStart.draw();
                }
            }
            else{
                inc=-inc;
                blink=ofGetElapsedTimef();                
            }
            
            TinyUnicode.drawString("Anything is possible in the PING environment.\nSo, be creative and find your own way to play \n           the PING! Augmented Pixel!", ofGetWidth()/2- 180,ofGetHeight()/2 - 20); 
            break;            
        default :
            TinyUnicode.drawString("score " + ofToString(ball.counter), 41, 60);
            buttonMenu.draw();
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
    ping.stop();
    
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
        buttonMenu.set(TinyUnicode, "back", 60, ofGetHeight()-50);
        if(buttonInfo.bbox.inside(touch.x, touch.y)){
            buttonStart.set(TinyUnicode, "next", ofGetWidth()-60, ofGetHeight()-50);
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
            settings.setValue("settings:xpos", ball.xpos);
            settings.setValue("settings:ypos", ball.ypos);
            settings.setValue("settings:speedx", ball.xspeed);
            settings.setValue("settings:speedy", ball.yspeed);
            settings.setValue("settings:colorUI", whiteUI);
            settings.setValue("settings:threshhold", ball.threshold);
            settings.setValue("settings:bounceDark", ball.bounceDark);
            settings.setValue("settings:firstLaunch", 5);   
            settings.saveFile("settings.xml");
            buttonMenu.set(TinyUnicode, "menu", 60, ofGetHeight()-50);
            ping.play();            
        } else if (subMenu==5){
            subMenu=0;
            buttonMenu.set(TinyUnicode, "back", 60, ofGetHeight()-50);
            pong.play();            
        } else if (subMenu>7 && subMenu<12) {
            subMenu--;
            ping.play(); 
        } else if (subMenu==7){
            subMenu=1;
            ping.play(); 
        } else {
            subMenu=0;
            ping.play();            
        }
    }    
    if(buttonStart.bbox.inside(touch.x, touch.y)){
        if (subMenu==4){
            subMenu=7;
            pong.play();
        }
        else if (subMenu==1){
            subMenu=7;
            pong.play(); 
        }
        else if (subMenu>6 && subMenu<10){
            subMenu++;
            pong.play(); 
        }
        else if (subMenu==10){
            buttonStart.set(TinyUnicode, "done", ofGetWidth()-60, ofGetHeight()-50);            
            subMenu=11;
            pong.play(); 
        }
        else if (subMenu==11){
            buttonMenu.set(TinyUnicode, "menu", 60, ofGetHeight()-50);
            settings.setValue("settings:xpos", ball.xpos);
            settings.setValue("settings:ypos", ball.ypos);
            settings.setValue("settings:speedx", ball.xspeed);
            settings.setValue("settings:speedy", ball.yspeed);
            settings.setValue("settings:colorUI", whiteUI);
            settings.setValue("settings:threshhold", ball.threshold);
            settings.setValue("settings:bounceDark", ball.bounceDark);
            settings.setValue("settings:firstLaunch", 5);   
            settings.saveFile("settings.xml");
            pong.play(); 
            subMenu=5;
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



