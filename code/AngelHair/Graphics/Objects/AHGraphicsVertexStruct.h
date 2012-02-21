//
//  AHGraphicsVertexStruct.h
//  BlackCat
//
//  Created by Tim Wood on 2/21/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#ifndef BlackCat_AHGraphicsVertexStruct_h
#define BlackCat_AHGraphicsVertexStruct_h


typedef struct _AHVertex {
	GLKVector3 position;
	GLKVector3 normal;
	GLKVector3 tangent;
    GLKVector2 texture;
} AHVertex;


#endif
