//
//  AHParticlePointRenderer.h
//  BlackCat
//
//  Created by Tim Wood on 2/22/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHParticleRenderer.h"


@interface AHParticlePointRenderer : AHParticleRenderer {
@private;
    GLKVector3 *_points;
    
    int _max;
}


@end
