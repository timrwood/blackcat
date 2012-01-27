//
//  Shader.vsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


attribute vec4 position;
attribute vec2 texcoord;

varying lowp vec2 texture_coordinate;

uniform mat4 projection;
uniform mat4 modelview;


void main(void) {
    texture_coordinate = texcoord;
    
    gl_Position = projection * modelview * position;
}