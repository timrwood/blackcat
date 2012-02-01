//
//  BCMainScene.h
//  BlackCat
//
//  Created by Tim Wood on 1/13/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#import "AHScene.h"


@class BCHeroRecorderActor;


@interface BCMainScene : AHScene {
@private;
    BCHeroRecorderActor *_recorderActor;
    NSData *_lastRecording;
}


@end
