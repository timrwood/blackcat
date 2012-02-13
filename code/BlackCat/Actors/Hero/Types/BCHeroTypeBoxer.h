//
//  BCHeroTypeBoxer.h
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "BCHeroType.h"
#import "AHLogicState.h"


@interface BCHeroTypeBoxer : BCHeroType <AHLogicDelegate> {
@private;
    AHLogicState *_dashState;
    
    GLKVector2 _targetPosition;
    
    float _timeStartedDash;
    
    float cameraPositionX;
    float xOffset;
}


#pragma mark -
#pragma mark dashing


- (BOOL)isDashing;
- (void)sendExplosionMessage:(int)type withRadius:(float)radius;
- (void)dashToPoint:(GLKVector2)point;


@end
