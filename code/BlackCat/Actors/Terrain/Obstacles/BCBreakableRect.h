//
//  BCBreakableRect.h
//  BlackCat
//
//  Created by Tim Wood on 2/8/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHGraphicsCube.h"
#import "AHActor.h"


@class AHPhysicsRect;


@interface BCBreakableRect : AHActor {
@private;
    AHPhysicsRect *_body;
    AHGraphicsCube *_skin;
    
    CGRect _texRect;
    CGRect _texRectTop;
    CGRect _texRectBot;
    CGSize _size;
    GLKVector2 _center;
    
    GLKVector2 _breakPoint;
    float _breakRadius;
    BOOL _hasBroken;
    
    BOOL _breakOnUp;
    BOOL _breakOnDown;
    BOOL _breakOnRight;
    
    NSString *_texKey;
    
    float _backDepth;
    float _frontDepth;
    
    float _restitution;
}


#pragma mark -
#pragma mark init


- (id)initWithRect:(CGRect)rect
        andTexRect:(CGRect)texRect
         andTexKey:(NSString *)texKey;
- (id)initWithCenter:(GLKVector2)center
         andSize:(CGSize)size
        andTexRect:(CGRect)texRect
         andTexKey:(NSString *)texKey;
- (void)setStartDepth:(float)front endDepth:(float)back;
- (void)setTopTex:(CGRect)topTex andBotTex:(CGRect)botTex;


#pragma mark -
#pragma mark tags


- (void)addTag:(int)tag;
- (void)setCategory:(int)category;
- (void)setRestitution:(float)restitution;


#pragma mark -
#pragma mark breaking


- (BOOL)isCloseEnoughToBreak;
- (void)breakAtPoint:(GLKVector2)point
          withRadius:(float)radius;
- (void)breakHorizontally;
- (void)breakVertically;


#pragma mark -
#pragma mark rebuild vertical


- (void)buildVerticalBreakableFromBottom:(float)bottom
                                   toTop:(float)top;
- (void)buildVerticalBrokenFromBottom:(float)bottom
                                toTop:(float)top;
- (void)buildVerticalBrokenWithLefts:(float *)lefts
                           andRights:(float *)rights
                            andCount:(int)count;


#pragma mark -
#pragma mark rebuild horizontal


- (void)buildHorizontalBreakableFromBottom:(float)bottom
                                   toTop:(float)top;
- (void)buildHorizontalBrokenFromBottom:(float)bottom
                                toTop:(float)top;
- (void)buildHorizontalBrokenWithLefts:(float *)lefts
                           andRights:(float *)rights
                            andCount:(int)count;

#pragma mark -
#pragma mark messages


- (void)enableBreakOnRight:(BOOL)willBreak;
- (void)enableBreakOnUp:(BOOL)willBreak;
- (void)enableBreakOnDown:(BOOL)willBreak;


@end