//
//  AHContactListener.h
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Infinite Beta. All rights reserved.
//


#include "Box2D.h"


class AHContactListener : public b2ContactListener {
public:
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    void BeginContact(b2Contact* contact);
    void EndContact(b2Contact* contact);
};
