//
//  ball.cpp
//  ping
//
//  Created by Filip Visnjic on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "ball.h"

void Ball::setup(){
    
    xpos = ofGetWidth()/2;
    ypos = ofGetHeight()/2;
    counter=0; //1000000000
    bounce =0;
    
    
    
    if (ofGetWidth()==1024){
        speed = 4;       
    }
    else { speed = 2;
    }
    
    float s = ofRandom(-1,1);
    if (s>=0){
        xspeed = speed;
    } else {
        xspeed = -speed;
    }
    
    float a = ofRandom(-1,1);
    if (a>=0){
        yspeed = speed;
    } else {
        yspeed = -speed;      
    }
    
    
    //mysize must be an even number (4,6,8,10,12...)
    mysize = 10;
    pixels = new unsigned char [videoH*videoW*3];
    
    t=0.5f;
    threshold=0.5;
    
    timer=ofGetElapsedTimef();
    
    
    
}

void Ball::update(){
    
    //borders    
    if (xpos > ofGetWidth()-30) {
        xpos = 20;
    }
    else if (xpos < 20){
        xpos = ofGetWidth()-30;
    }
    
    //bars at bottom and top
    if (ypos < 30){ 
        ypos = 30;
        yspeed = yspeed * (-1);
        if (ofGetElapsedTimef()-timer > t) {
            bounce++;
            timer=ofGetElapsedTimef();
        }
    }
    
    if (ypos > ofGetHeight()-40){
        ypos = ofGetHeight()-40;
        yspeed = yspeed * (-1);
        if (ofGetElapsedTimef()-timer > t) {
            bounce++;
            timer=ofGetElapsedTimef();
        }
    }
    
    
    for (int i = 5; i < videoW; i+=10){
        for (int j = 5; j < videoH; j+=10){
            
            if (xpos >= i - (1.5*mysize) && xpos <= i + (1.5*mysize) && ypos >= j - (1.5*mysize) && ypos <= j + (1.5*mysize)){
                
                
                
                int cubes[9];
                int inc = 0;
                
                //checking surrounding pxls ball.mysize
                for (int q=-1; q<2; q++){
                    for (int p=-1; p<2; p++){
                        
                        //this is as formula to translate colours into grayscale                
                        //unsigned char r = pixels[((11*(j * 480 + i)*3)+16*((j * 480 + i)*3+1)+5*((j * 480 + i)*3+2))/32];
                        
                        // using the blue channel to manage pixels                            
                        unsigned char f = pixels[((j+p) * videoW + (i+q))*3+2];                
                        float val2 = 1 - ((float)f / 255.0f);
                        
                        if (val2 > threshold && bounceDark){                                
                            cubes[inc]=1;
                        }
                        else if (val2 < threshold && !bounceDark){
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
                    
                    xspeed = speed;
                    yspeed = 0;
                    
                    if (ofGetElapsedTimef()-timer > t) {
                        counter++;
                        timer=ofGetElapsedTimef();
                        
                    }
                    
                }
                
                //move left                        
                else if ((cubes[6]==1 && cubes[7]==1 && cubes[8] == 1) && (cubes[0]==0 && cubes[1]==0 && cubes[2] == 0)) {
                    
                    xspeed = -speed;
                    yspeed = 0;
                    
                    if (ofGetElapsedTimef()-timer > t) {
                        counter++;
                        timer=ofGetElapsedTimef();
                        
                    }
                }
                
                //move up
                else if ((cubes[2]==1 && cubes[5]==1 && cubes[8] == 1) && (cubes[0]==0 && cubes[3]==0 && cubes[6] == 0)) {                            
                    
                    xspeed = 0;
                    yspeed = -speed;
                    
                    if (ofGetElapsedTimef()-timer > t) {
                        counter++;
                        timer=ofGetElapsedTimef();
                        
                    }
                    
                }
                
                //move down
                else if ((cubes[0]==1 && cubes[3]==1 && cubes[6] == 1) && (cubes[2]==0 && cubes[5]==0 && cubes[8] == 0)){                        
                    
                    xspeed = 0;
                    yspeed = speed;
                    
                    if (ofGetElapsedTimef()-timer > t) {
                        counter++;
                        timer=ofGetElapsedTimef();
                        
                    }
                    
                }
                
                //move right+down
                else if ((cubes[0]==1 && cubes[2]==0 && cubes[6]==0 && cubes[8]==0) || (cubes[0]==1 && cubes[2]==1 && cubes[6]==1 && cubes[8]==0)) {                            
                    
                    xspeed = speed;
                    yspeed = speed;
                    
                    if (ofGetElapsedTimef()-timer > t) {
                        counter++;
                        timer=ofGetElapsedTimef();
                        
                    }
                    
                }
                
                //move left+down
                else if ((cubes[6]==1 && cubes[0]==0 && cubes[8]==0 && cubes[2]==0) || (cubes[6]==1 && cubes[0]==1 && cubes[8]==1 && cubes[2]==0)) {                            
                    
                    xspeed = -speed;
                    yspeed = speed;
                    
                    if (ofGetElapsedTimef()-timer > t) {
                        counter++;
                        timer=ofGetElapsedTimef();
                        
                    }
                    
                }
                
                //move right+up
                else if ((cubes[2]==1 && cubes[0]==0 && cubes[8]==0 && cubes[6]==0) || (cubes[2]==1 && cubes[0]==1 && cubes[8]==1 && cubes[6]==0)) {                            
                    
                    xspeed = speed;
                    yspeed = -speed;                            
                    
                    if (ofGetElapsedTimef()-timer > t) {
                        counter++;
                        timer=ofGetElapsedTimef();
                        
                    }
                    
                }
                
                //move left+up
                else if ((cubes[8]==1 && cubes[2]==0 && cubes[6]==0 && cubes[0]==0) || (cubes[8]==1 && cubes[2]==1 && cubes[6]==1 && cubes[0]==0)) {                            
                    
                    xspeed = -speed;
                    yspeed = -speed;                            
                    
                    if (ofGetElapsedTimef()-timer > t) {
                        counter++;
                        timer=ofGetElapsedTimef();
                        
                    }
                    
                }                                                            
            }                
        }                              
    }
    
}

void Ball::draw(){
    
    ofFill();
    ofSetColor(ballCol,200);
    ofRect(xpos, ypos, mysize, mysize);
    
}

