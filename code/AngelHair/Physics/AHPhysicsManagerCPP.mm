//
//  AHPhysicsManagerCPP.mm
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHPhysicsManagerCPP.h"


@implementation AHPhysicsManagerCPP


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark world


- (b2World *)world {
    return _world;
}


#pragma mark -
#pragma mark setup


- (void)setup {
    _world = new b2World(b2Vec2(0.0f, -10.0f));
    
    // debug draw
    _debugDraw = new AHDebugDraw();
    _debugDraw->SetFlags(AHDebugDraw::e_shapeBit + AHDebugDraw::e_jointBit + AHDebugDraw::e_centerOfMassBit);
    _world->SetDebugDraw(_debugDraw);
}


#pragma mark -
#pragma mark update


- (void)update {
    _world->Step(1.0f / 30.0f, 10, 10);
}


#pragma mark -
#pragma mark draw


- (void)drawDebug {
    dlog(@"draw debug");
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glLoadIdentity();
    
    _world->DrawDebugData();
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    
}



@end
