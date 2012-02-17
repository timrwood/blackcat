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
    float averageVelocityX;
    
    BOOL _needsToDash;
    int _needsToDashState;
}


#pragma mark -
#pragma mark dashing


- (BOOL)isDashing;
- (void)sendExplosionMessage:(int)type withRadius:(float)radius;
- (void)dashToPoint:(GLKVector2)point;


#pragma mark -
#pragma mark update


- (void)updateDashXOffset;
- (void)updateDashCheckTurnOn;
- (void)updateDashCheckTurnOff;


@end
