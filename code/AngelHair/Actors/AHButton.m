//
//  AHButton.m
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHButton.h"


@implementation AHButton


#pragma mark -
#pragma mark init


- (id)initFromDictionary:(NSDictionary *)dictionary {
    int rx = [[dictionary objectForKey:@"rx"] intValue];
    int ry = [[dictionary objectForKey:@"ry"] intValue];
    int rw = [[dictionary objectForKey:@"rw"] intValue];
    int rh = [[dictionary objectForKey:@"rh"] intValue];
    int tx = [[dictionary objectForKey:@"tx"] intValue];
    int ty = [[dictionary objectForKey:@"ty"] intValue];
    int tw = [[dictionary objectForKey:@"tw"] intValue];
    int th = [[dictionary objectForKey:@"th"] intValue];
    
    NSString *_key = [[dictionary objectForKey:@"key"] stringValue];
    int _identifier = [[dictionary objectForKey:@"id"] intValue];
    
    return [self initFromRect:CGRectMake(rx, ry, rw, rh)
                   andTexRect:CGRectMake(tx, ty, tw, th) 
                    andTexKey:_key 
                        andId:_identifier];
}

- (id)initFromRect:(CGRect)_rect
        andTexRect:(CGRect)_tex
         andTexKey:(NSString *)_key
             andId:(int)_identifier {
    self = [super init];
    rect = _rect;
    identifier = _identifier;
    /*
    graphics = [[AHGraphicsRect alloc] initFromRect:_rect
                                     andTexRect:_tex
                                      andTexKey:_key];
     
    input = [[AHInputRect alloc] initFromRect:_rect
                                 withDelegate:self];
     */
    return self;
}


@end
