//
//  Shader.fsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


uniform sampler2D textureBase;

varying highp vec2 texcoord_frag;
varying mediump vec3 norcoord_frag;
varying mediump vec3 lightPosition_frag;


void main(void) {
	lowp vec3 base = texture2D(textureBase, texcoord_frag).rgb;
    
	lowp float diffuse = max(dot(normalize(lightPosition_frag), norcoord_frag), 0.2);
    
	gl_FragColor = vec4(base * diffuse, 1.0);
}