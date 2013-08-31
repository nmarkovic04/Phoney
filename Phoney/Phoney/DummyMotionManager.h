//
//  DummyMotion.h
//  DummyMotion
//
//  Created by Nikola Markovic on 7/12/13.
//  Copyright (c) 2013 Nikola Markovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface DummyMotionManager : CMMotionManager

-(void)startReading;

@end
