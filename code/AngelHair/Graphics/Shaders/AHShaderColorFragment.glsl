//
//  Shader.fsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


varying lowp vec4 colorFragment;


void main(void) {
    gl_FragColor = colorFragment;
}
