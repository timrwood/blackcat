//
//  AHContactListener.mm
//  BlackCat
//
//  Created by Tim Wood on 1/9/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHPhysicsBody.h"
#import "AHContactListener.h"


void AHContactListener::BeginContact(b2Contact *contact) {
	AHPhysicsBody *contact1 = (__bridge AHPhysicsBody *)contact->GetFixtureA()->GetBody()->GetUserData();
	AHPhysicsBody *contact2 = (__bridge AHPhysicsBody *)contact->GetFixtureB()->GetBody()->GetUserData();
	if (contact1 && 
        contact2 &&
        [contact1 collidedWith:contact2] &&
        [contact2 collidedWith:contact1] &&
        [contact1 collidedWithButDidNotCall:contact2]){
        // contact was good, enable it
    } else {
        // contact was canceled, disable it
        contact->SetEnabled(NO);
    }
}

void AHContactListener::EndContact(b2Contact *contact) {
	AHPhysicsBody *contact1 = (__bridge AHPhysicsBody *)contact->GetFixtureA()->GetBody()->GetUserData();
	AHPhysicsBody *contact2 = (__bridge AHPhysicsBody *)contact->GetFixtureB()->GetBody()->GetUserData();
	if (contact1 && contact2) {
        [contact1 uncollidedWith:contact2];
        [contact2 uncollidedWith:contact1];
        [contact1 uncollidedWithButDidNotCall:contact2];
	}
}