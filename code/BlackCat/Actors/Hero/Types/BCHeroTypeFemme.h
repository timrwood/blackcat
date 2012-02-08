//
//  BCHeroTypeFemme.h
//  BlackCat
//
//  Created by Tim Wood on 2/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHLogicState.h"
#import "BCHeroType.h"


@interface BCHeroTypeFemme : BCHeroType <AHLogicDelegate> {
@private;
    float _timeStartedPhasewalk;
    AHLogicState *_phasewalkState;
    
    GLKVector2 _targetPosition;
}


@end
