//
//  CMAttitude+Dummy.m
//  DummyMotion
//
//  Created by Nikola Markovic on 7/20/13.
//  Copyright (c) 2013 Nikola Markovic. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR)

#import "CMAttitude+Dummy.h"

/*
 * Class Name: RotationMatrixWrapper
 * Class Description: Represents a wrapper around the rotation matrix, since the CMAttitude matrix implementation is hidden.
 *                    We declare it inside the implementation scope since it should be internal and used only by the CMAttitude.
 */

@interface RotationMatrixWrapper : NSObject

+(CMRotationMatrix)rotationMatrix;
+(void)setRotationMatrix:(CMRotationMatrix)pMatrix;

@end

@implementation RotationMatrixWrapper

static CMRotationMatrix matrix;

+(CMRotationMatrix)rotationMatrix{
    return matrix;
}

+(CMRotationMatrix*)rotationMatrixPtr{
    return &matrix;
}

+(void)setRotationMatrix:(CMRotationMatrix)pMatrix{
    matrix= pMatrix;
}

@end


/* *** Attitude category *** */

@implementation CMAttitude (Dummy)

-(CMRotationMatrix)rotationMatrix{
    return [RotationMatrixWrapper rotationMatrix];
}

-(void)setRotationMatrix:(CMRotationMatrix)pRotationMatrix{
    [RotationMatrixWrapper setRotationMatrix:pRotationMatrix];
}

-(CMRotationMatrix*)rotationMatrixPtr{
    return [RotationMatrixWrapper rotationMatrixPtr];
}

-(double)roll{
    CMRotationMatrix* mat= [RotationMatrixWrapper rotationMatrixPtr];
    return atan2(mat->m31, mat->m32);
}

-(double)yaw{
    CMRotationMatrix* mat= [RotationMatrixWrapper rotationMatrixPtr];
    return acos(mat->m33);
}

-(double)pitch{
    CMRotationMatrix* mat= [RotationMatrixWrapper rotationMatrixPtr];

    return -atan2(mat->m13, mat->m23);
}

/* *** Helper methods for quaternion calculation *** */
float SIGN(float x) {return (x >= 0.0f) ? +1.0f : -1.0f;}
float NORM(float a, float b, float c, float d) {return sqrt(a * a + b * b + c * c + d * d);}

-(CMQuaternion)quaternion{
    // Needs to be tested
    CMRotationMatrix* mat= [RotationMatrixWrapper rotationMatrixPtr];
    
    double q0 = ( mat->m11 + mat->m22 + mat->m33 + 1.0f) / 4.0f;
    double q1 = ( mat->m11 - mat->m22 - mat->m33 + 1.0f) / 4.0f;
    double q2 = (-mat->m11 + mat->m22 - mat->m33 + 1.0f) / 4.0f;
    double q3 = (-mat->m11 - mat->m22 + mat->m33 + 1.0f) / 4.0f;
    if(q0 < 0.0f) q0 = 0.0f;
    if(q1 < 0.0f) q1 = 0.0f;
    if(q2 < 0.0f) q2 = 0.0f;
    if(q3 < 0.0f) q3 = 0.0f;
    q0 = sqrt(q0);
    q1 = sqrt(q1);
    q2 = sqrt(q2);
    q3 = sqrt(q3);
    if(q0 >= q1 && q0 >= q2 && q0 >= q3) {
        q0 *= +1.0f;
        q1 *= SIGN(mat->m32 - mat->m23);
        q2 *= SIGN(mat->m13 - mat->m31);
        q3 *= SIGN(mat->m21 - mat->m12);
    } else if(q1 >= q0 && q1 >= q2 && q1 >= q3) {
        q0 *= SIGN(mat->m32 - mat->m23);
        q1 *= +1.0f;
        q2 *= SIGN(mat->m21 + mat->m12);
        q3 *= SIGN(mat->m13 + mat->m31);
    } else if(q2 >= q0 && q2 >= q1 && q2 >= q3) {
        q0 *= SIGN(mat->m13 - mat->m31);
        q1 *= SIGN(mat->m21 + mat->m12);
        q2 *= +1.0f;
        q3 *= SIGN(mat->m32 + mat->m23);
    } else if(q3 >= q0 && q3 >= q1 && q3 >= q2) {
        q0 *= SIGN(mat->m21 - mat->m12);
        q1 *= SIGN(mat->m31 + mat->m13);
        q2 *= SIGN(mat->m32 + mat->m23);
        q3 *= +1.0f;
    } else {
        // log error
    }
    double r = NORM(q0, q1, q2, q3);
    q0 /= r;
    q1 /= r;
    q2 /= r;
    q3 /= r;
    
    CMQuaternion quaternion;
    quaternion.x= q0;
    quaternion.y= q1;
    quaternion.z= q2;
    quaternion.w= q3;
    
    return quaternion;
}

@end

#endif 

