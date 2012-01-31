//
//  Shader.vsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


attribute vec4 poscoord;

varying vec4 colorFragment;

uniform vec4 color;
uniform mat4 projection;
uniform mat4 modelview;


void main(void) {
    colorFragment = color;
    
    gl_Position = projection * modelview * poscoord;
}