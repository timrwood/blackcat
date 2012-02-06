//
//  BCBuildingStepped010.h
//  BlackCat
//
//  Created by Tim Wood on 2/2/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "BCBuildingType.h"


@class AHGraphicsRect;
@class AHPhysicsRect;


@interface BCBuildingThreeStepped : BCBuildingType {
@private;
    AHPhysicsRect *_step1;
    AHPhysicsRect *_step2;
    AHPhysicsRect *_step3;
    
    AHGraphicsRect *_skin1;
    AHGraphicsRect *_skin2;
    AHGraphicsRect *_skin3;
    
    BOOL _step1to2isUp;
    BOOL _step2to3isUp;
}


#pragma mark -
#pragma mark steps


- (void)setStep1to2Up:(BOOL)isUp;
- (void)setStep2to3Up:(BOOL)isUp;


@end
