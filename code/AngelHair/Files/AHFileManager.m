//
//  AHFileManager.m
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHFileManager.h"
#import "CJSONDeserializer.h"


static AHFileManager *_manager = nil;


@implementation AHFileManager


#pragma mark -
#pragma mark singleton


+ (AHFileManager *)manager {
	if (!_manager) {
        _manager = [[self alloc] init];
	}
    
	return _manager;
}


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        fileManager = [[NSFileManager alloc] init];
    }
    return self;
}



#pragma mark -
#pragma mark setup


- (void)setup {
    
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    
}


#pragma mark -
#pragma mark json


- (NSArray *)parseJSONFromResourceFileToArray:(NSString *)_filename {
    return [self parseJSONFromFileToArray:[self pathToResourceFile:_filename]];
}

- (NSArray *)parseJSONFromFileToArray:(NSString *)_filename {
    NSError *error = nil;
    
    NSData *json = [fileManager contentsAtPath:_filename];
    
    NSArray *array = [[CJSONDeserializer deserializer] deserializeAsArray:json error:&error];
    
    if (error) {
        dlog(@"Error parsing JSON : %@ : %@", _filename, [error localizedDescription]);
    }
    
    if (![array isKindOfClass:[NSArray class]]) {
        dlog(@"JSON is not a NSArray %@", _filename);
    }
    
    return (NSArray *) array;
}

- (NSDictionary *)parseJSONFromResourceFileToDictionary:(NSString *)_filename {
    return [self parseJSONFromFileToDictionary:[self pathToResourceFile:_filename]];
}

- (NSDictionary *)parseJSONFromFileToDictionary:(NSString *)_filename {
    NSError *error = nil;
    
    NSData *json = [fileManager contentsAtPath:_filename];
    NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:json error:&error];
    
    if (error) {
        dlog(@"Error parsing JSON : %@ : %@", _filename, [error localizedDescription]);
    }
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        dlog(@"JSON is not a NSDictionary %@", _filename);
    }
    
    return (NSDictionary *) dict;
}


#pragma mark -
#pragma mark file paths


- (NSString *)pathToResourceFile:(NSString *)file {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file];
}


@end
