//
//  Shader.fsh
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


uniform sampler2D textureBase;
uniform sampler2D textureNormal;

varying mediump vec3 lightVec;
varying mediump vec3 eyeVec;
varying highp vec2 texcoord_frag;

uniform lowp float invRadius;


void main(void) {
	lowp vec3 lVec = normalize(lightVec);
    
	lowp vec3 vVec = normalize(eyeVec);
	
	lowp vec3 base = texture2D(textureBase, texcoord_frag).rgb;
	
	lowp vec3 bump = normalize(texture2D(textureNormal, texcoord_frag).xyz * 2.0 - 1.0);
    
	lowp float diffuse = max(dot(lVec, bump), 0.4);
    
	lowp float specular = 0.8 * clamp(dot(reflect(-lVec, bump), vVec), 0.0, 1.0);
	
	gl_FragColor = vec4((base * diffuse) + specular, 1.0);
}













