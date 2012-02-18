//
//  BCDebugCameraMover.h
//  BlackCat
//
//  Created by Tim Wood on 2/17/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHInputComponent.h"
#import "AHActor.h"


@interface BCDebugCameraMover : AHActor <AHInputDelegate> {
@private;
    AHInputComponent *_input;
    
    GLKVector2 _moved;
}


@end
