//
//  DummyMotion.m
//  DummyMotion
//
//  Created by Nikola Markovic on 7/12/13.
//  Copyright (c) 2013 Nikola Markovic. All rights reserved.
//

#import "DummyMotionManager.h"
#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>
#include <errno.h>
#import "CMAttitude+Dummy.h"
#import "FCMDeviceMotion.h"

#define PHONEY_KEY_FOR_PORT @"PhoneyPort"
#define PHONEY_DEFAULT_PORT 28000

@implementation DummyMotionManager{
    bool reading; // reading data flag
    CMDeviceMotion* fakeDeviceMotion; // fake device motion
    dispatch_queue_t dataQueue; // queue in which we read the incoming data
    int port;
}

-(id)init{
    if(self = [super init]){
        reading= NO;
        fakeDeviceMotion= [[FCMDeviceMotion alloc] init];
        
        // initialize the queue
        dataQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L);
        
        // read port from .plist file
        NSNumber* portNum= [[NSBundle mainBundle] objectForInfoDictionaryKey:PHONEY_KEY_FOR_PORT];
        if(!portNum){
            portNum= [NSNumber numberWithInt:PHONEY_DEFAULT_PORT];
        }
        
        port= portNum.intValue;
        
        // create the default identity matrix
        CMRotationMatrix matrix;
        double matrixData[9]= { 1, 0, 0,
                                0, 1, 0,
                                0, 0, 1};
        memcpy(&matrix, matrixData, 9 * sizeof(double));
        [fakeDeviceMotion.attitude setRotationMatrix:matrix];
    }
    return self;
}

-(void)startDeviceMotionUpdates{
    [self startReading];
}

-(void)stopDeviceMotionUpdates{
    [self stopReading];
}

-(void)startReading{
    if(!reading){
        reading= YES;
        dispatch_async(dataQueue,^{
            [self read];
        });
    }
}

-(void)stopReading{
    reading= NO;
}

-(CMDeviceMotion*)deviceMotion{
    return fakeDeviceMotion;
}

-(BOOL)isDeviceMotionAvailable{
    return YES;
}

-(void)read{
    int sockfd,n;
    struct sockaddr_in servaddr,cliaddr;
    socklen_t len;
    float transformationMatrix[16]; // 4x4 transformation matrix
    double rotationMatrix[9]= { 1, 0, 0, 0, 1, 0, 0, 0, 1}; // 3x3 rotation matrix
    sockfd=socket(AF_INET, SOCK_DGRAM, 0); // we want to receive datagrams

    bzero(&servaddr,sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr=htonl(INADDR_ANY);
    servaddr.sin_port=htons(port);
    if(bind(sockfd,(struct sockaddr *)&servaddr,sizeof(servaddr)) == 0){ // bind the socket file descriptor
       // successful
    }else{
        // Error binding socket
        printf("Error binding socket: %s",strerror(errno));
    }

    CMRotationMatrix mat;
    while(reading)
    {
        len = sizeof(cliaddr);
        
        n = recvfrom(sockfd, transformationMatrix, 1000, 0, (struct sockaddr *)&cliaddr, &len);
        int counter= 0;
        for(int i=0; i<16; i++){
            
            if( i==3 || i==7 || i>=11)
                continue;
            
            rotationMatrix[counter++]= transformationMatrix[i];
        }
        memcpy(&mat, rotationMatrix, 9*sizeof(double));
        [self.deviceMotion.attitude setRotationMatrix:mat];
    }

}


@end
