//
//  FCMDeviceMotion.m
//  DummyMotion
//
//  Created by Nikola Markovic on 7/20/13.
//  Copyright (c) 2013 Nikola Markovic. All rights reserved.
//

#import "FCMDeviceMotion.h"
@implementation FCMDeviceMotion{
    CMAttitude* fakeAttitude;
}

-(id)init{
    if(self=[super init]){
        fakeAttitude= [[CMAttitude alloc] init];
    }
    return self;
}

-(CMAttitude*)attitude{
    return fakeAttitude;
}
@end
