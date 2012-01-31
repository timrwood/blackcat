//
//  AHButton.h
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"
#import "AHGraphicsRect.h"
#import "AHInputComponent.h"


@class AHScene;


@interface AHButton : AHActor <AHInputDelegate> {
@private
    int _identifier;
    AHGraphicsRect *_graphics;
    AHInputComponent *_input;
    AHScene *_scene;
}


#pragma mark -
#pragma mark init


- (id)initFromRectDictionary:(NSDictionary *)rDict
            andTexDictionary:(NSDictionary *)tDict;
- (id)initFromRect:(CGRect)_rect
        andTexRect:(CGRect)_tex
         andTexKey:(NSString *)_key
             andId:(int)_identifier;


#pragma mark -
#pragma mark scene


- (void)setScene:(AHScene *)scene;


#pragma mark -
#pragma mark identifier


- (int)identifier;


@end
