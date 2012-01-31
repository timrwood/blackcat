//
//  Shader.fsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


varying lowp vec2 texcoordFragment;

uniform sampler2D textureBase;


void main(void) {
    gl_FragColor = texture2D(textureBase, texcoordFragment);
}
