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
    _world = new b2World(b2Vec2(0.0f, 10.0f));
    
    // debug draw
    _debugDraw = new AHDebugDraw();
    _world->SetDebugDraw(_debugDraw);
}


#pragma mark -
#pragma mark update


- (void)update {
    
}


#pragma mark -
#pragma mark draw


- (void)drawDebug {
    _world->DrawDebugData();
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    
}



@end
