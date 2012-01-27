//
//  Shader.fsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


varying lowp vec2 texture_coordinate;

uniform sampler2D texture;


void main(void) {
    gl_FragColor = texture2D(texture, texture_coordinate);
}
