//
//  AHButton.h
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHActor.h"
#import "AHGraphicsRect.h"


@interface AHButton : AHActor /* <AHInputComponent> */ {
@private
    CGRect rect;
    int identifier;
    AHGraphicsRect *graphics;
    // AHInputRect *input;
}


#pragma mark -
#pragma mark init


- (id)initFromDictionary:(NSDictionary *)dictionary;
- (id)initFromRect:(CGRect)_rect
        andTexRect:(CGRect)_tex
         andTexKey:(NSString *)_key
             andId:(int)_identifier;


@end
