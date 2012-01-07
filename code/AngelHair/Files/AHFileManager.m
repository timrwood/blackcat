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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:_filename];
    return [self parseJSONFromFileToArray:filename];
}

- (NSArray *)parseJSONFromFileToArray:(NSString *)_filename {
    NSError *error = nil;
    
    NSData *json = [fileManager contentsAtPath:_filename];
    id array = [[CJSONDeserializer deserializer] deserializeAsArray:json error:&error];
    
    if (error) {
        dlog(@"Error parsing JSON : %@", [error localizedDescription]);
    }
    
    if ([array isKindOfClass:[NSArray class]]) {
        dlog(@"JSON is not a NSArray");
    }
    
    return (NSArray *) array;
}

- (NSDictionary *)parseJSONFromResourceFileToDictionary:(NSString *)_filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:_filename];
    return [self parseJSONFromFileToDictionary:filename];
}

- (NSDictionary *)parseJSONFromFileToDictionary:(NSString *)_filename {
    NSError *error = nil;
    
    NSData *json = [fileManager contentsAtPath:_filename];
    id dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:json error:&error];
    
    if (error) {
        dlog(@"Error parsing JSON : %@", [error localizedDescription]);
    }
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        dlog(@"JSON is not a NSDictionary");
    }
    
    return (NSDictionary *) dict;
}

@end
