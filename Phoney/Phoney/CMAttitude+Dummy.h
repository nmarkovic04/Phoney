//
//  CMAttitude+Dummy.h
//  DummyMotion
//
//  Created by Nikola Markovic on 7/20/13.
//  Copyright (c) 2013 Nikola Markovic. All rights reserved.
//

//#if (TARGET_IPHONE_SIMULATOR)

#import <CoreMotion/CoreMotion.h>

@interface CMAttitude (Dummy)
/**
 * Method Description: Rotation matrix is a read only parameter. This way we'll allow the user to set the matrix externally.
 * Parameters: rotationMatrix - Rotation matrix to be set
 */
-(void)setRotationMatrix:(CMRotationMatrix)rotationMatrix;

@end

