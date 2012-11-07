#include "testApp.h"
#define _USE_LIVE_VIDEO

//--------------------------------------------------------------
void testApp::setup(){	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//If you want a landscape oreintation 
	iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
    ofBackground(200,200,200);
    
    ball.setup();
    
    touchRadiusX = 40;
    touchRadiusY = 40;
    
    w = ofGetWidth();
    h = ofGetHeight();
    
    counter = 0;
    lives = 3;
    speed = 2;
    
    pong.loadSound("pong.wav");
    
    grabber.initGrabber(480, 360, OF_PIXELS_BGRA);
    tex.allocate(grabber.getWidth(), grabber.getHeight(), GL_RGB);
    pix = new unsigned char[ (int)( grabber.getWidth() * grabber.getHeight() * 3.0) ];
   
    //resize.m4v is 480x320 pixels
    //video.loadMovie("resize.m4v");
	//video.play();
    
    //looping the video
    //video.setLoopState(OF_LOOP_NORMAL);

}

//--------------------------------------------------------------
void testApp::update(){
//    if(!video.isLoaded()) {
//        return;
//    }
    
    //video.update();
    grabber.update();

    //  int wg = grabber.width;
    //	int hg = grabber.height;
    
    //loose
    
    if (ball.xpos+(ball.mysize/2) > w || ball.xpos-(ball.mysize/2) < 0) {
        ball.xpos = ofGetWidth()/2;
        
        counter = 0;
        
        lives = lives -1;
    }
    if (ball.ypos+(ball.mysize/2) > h || ball.ypos-(ball.mysize/2) < 0) {
        ball.ypos = ofGetHeight()/2;
        
        counter = 0;
        
        lives = lives -1;
        
    }
    
    //bars at bottom and top
    if (ball.xpos > 20 && ball.xpos < ofGetWidth()-40 && ball.ypos > 20 && ball.ypos < 30)
    { ball.yspeed = ball.yspeed * (-1); }
    
    if (ball.xpos > 20 && ball.xpos < ofGetWidth()-40 && ball.ypos > ofGetHeight()-40 && ball.ypos < ofGetHeight()-30)
    { ball.yspeed = ball.yspeed * (-1); }
    
    
    
    ball.xpos = ball.xpos + ball.xspeed;
    ball.ypos = ball.ypos + ball.yspeed;
    
    ball.update();
    
    for (int x = ball.xpos-(ball.mysize*1.5); x<ball.xpos+(ball.mysize*1.5); x+=ball.mysize){
        
        for (int y = ball.ypos-(ball.mysize*1.5); y<ball.ypos+(ball.mysize*1.5); y+=ball.mysize){
            
        
        }
            
    }
    
    tex.loadData(pix, grabber.getWidth(), grabber.getHeight(), GL_RGB);

}

//--------------------------------------------------------------
void testApp::draw(){
    
    ofSetColor(255);
    //video.getTexture()->draw(0, 0);
    grabber.draw(0, 0);
    //tex.draw(0, 0, tex.getWidth() / 4, tex.getHeight() / 4);
    
	//if(video.isLoaded()){
        
       unsigned char * pixels = grabber.getPixels();
        
        int videoW = grabber.getWidth();
        int videoH = grabber.getHeight();
        
		ofSetColor(54);
		for (int i = 5; i < videoW; i+=10){
			for (int j = 5; j < videoH; j+=10){
                
                //this is as formula to translate colours into grayscale                
                //unsigned char r = pixels[((11*(j * 480 + i)*3)+16*((j * 480 + i)*3+1)+5*((j * 480 + i)*3+2))/32];
                
                // using the blue channel to manage pixels
//                unsigned char r = pixels[(j * videoW + i)*3+2];                
//				float val = 1 - ((float)r / 255.0f);
//                if (val > 0.5){
//                    
//                    // circles for debugging
//                    ofCircle(i, j, 4 * val);
                    
                    if (ball.xpos >= i - (1.5*ball.mysize) && ball.xpos <= i + (1.5*ball.mysize) && ball.ypos >= j - (1.5*ball.mysize) && ball.ypos <= j + (1.5*ball.mysize)){
                        
                        
                        
                        int cubes[9];
                        int inc = 0;
                        
                        //checking surrounding pxls ball.mysize
                        for (int q=-1; q<2; q++){
                            for (int p=-1; p<2; p++){
                                
                                unsigned char f = pixels[((j+p) * videoW + (i+q))*3+2];                
                                float val2 = 1 - ((float)f / 255.0f);
                                if (val2 > 0.5){                                
                                    cubes[inc]=1;
                                }
                                else {
                                    cubes[inc]=0;
                                }
                                inc++;
                            }
                        }
                        
                        //move right
                        if ((cubes[0]==1 && cubes[1]==1 && cubes[2] == 1) && (cubes[6]==0 && cubes[7]==0 && cubes[8] == 0)) {
                        
                                ball.xspeed = speed;
                                ball.yspeed = 0;
                                
                        }
                        
                        //move left                        
                        else if ((cubes[6]==1 && cubes[7]==1 && cubes[8] == 1) && (cubes[0]==0 && cubes[1]==0 && cubes[2] == 0)) {
                                
                                ball.xspeed = -speed;
                                ball.yspeed = 0;
                                
                        }
                        
                        //move up
                        else if ((cubes[2]==1 && cubes[5]==1 && cubes[8] == 1) && (cubes[0]==0 && cubes[3]==0 && cubes[6] == 0)) {                            
                                
                                ball.xspeed = 0;
                                ball.yspeed = -speed;
                                
                        }
                        
                        //move down
                        else if ((cubes[0]==1 && cubes[3]==1 && cubes[6] == 1) && (cubes[2]==0 && cubes[5]==0 && cubes[8] == 0)){                        
                                
                                ball.xspeed = 0;
                                ball.yspeed = speed;
                                
                        }
                        
                        //move right+down
                        else if ((cubes[0]==1 && cubes[2]==0 && cubes[6]==0 && cubes[8]==0) || (cubes[0]==1 && cubes[2]==1 && cubes[6]==1 && cubes[8]==0)) {                            
                                
                                ball.xspeed = speed;
                                ball.yspeed = speed;
                                
                        }
                        
                        //move left+down
                        else if ((cubes[6]==1 && cubes[0]==0 && cubes[8]==0 && cubes[2]==0) || (cubes[6]==1 && cubes[0]==1 && cubes[8]==1 && cubes[2]==0)) {                            
                            
                            ball.xspeed = -speed;
                            ball.yspeed = speed;
                            
                        }
                        
                        //move right+up
                        else if ((cubes[2]==1 && cubes[0]==0 && cubes[8]==0 && cubes[6]==0) || (cubes[2]==1 && cubes[0]==1 && cubes[8]==1 && cubes[6]==0)) {                            
                            
                            ball.xspeed = speed;
                            ball.yspeed = -speed;
                            
                        }
                        
                        //move left+up
                        else if ((cubes[8]==1 && cubes[2]==0 && cubes[6]==0 && cubes[0]==0) || (cubes[8]==1 && cubes[2]==1 && cubes[6]==1 && cubes[0]==0)) {                            
                            
                            ball.xspeed = -speed;
                            ball.yspeed = -speed;
                            
                        }
                        
                        
                        counter = counter + 1;
                    }
                   
                    
                }
                
               
                
			//}
		}
    //}
    
    ball.draw();
    
    ofSetColor(255, 0, 0);
    ofNoFill();
    ofRect(mouseX-touchRadiusX/2, mouseY-touchRadiusY/2, touchRadiusX, touchRadiusY);
    
    ofFill();
    ofSetColor(255, 255, 255);
    ofRect(20, 20, ofGetWidth()-40, 10);
    ofRect(20, ofGetHeight()-30, ofGetWidth()-40, 10);
    
    
    ofDrawBitmapString("score " + ofToString(counter), 30, 60);
    ofDrawBitmapString("lives " + ofToString(lives), 30, 80);
    
    if (lives == 0 || lives < 0){
        ofDrawBitmapString("game over", ofGetWidth()/2-50, ofGetHeight()/2-10);
        counter = 0;
        lives = 0;
    }
    
	
}

//--------------------------------------------------------------
void testApp::exit(){
pong.stop();
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

    if (ball.xpos > touch.x - touchRadiusX/2 && ball.xpos < touch.x + touchRadiusX/2 &&
        ball.ypos > touch.y - touchRadiusY/2 && ball.ypos < touch.x + touchRadiusY/2){
        
        ball.xspeed = ball.xspeed * (-1);
        ball.yspeed = ball.yspeed * (1);
        
        counter = counter + 1;
        
        pong.play();
    }
    
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

    
    ball.xpos = ofRandom(0,400);
    ball.ypos = ofRandom(0,400);
    
    lives = 3;    
    
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

