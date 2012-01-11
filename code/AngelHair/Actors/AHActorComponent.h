//
//  AHComponent.h
//  BlackCat
//
//  Created by Tim Wood on 12/30/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//

@protocol AHActorComponent <NSObject>


- (void)setup;
- (void)cleanupAfterRemoval;


@end
