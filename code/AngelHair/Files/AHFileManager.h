//
//  AHFileManager.h
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHSubSystem.h"


@interface AHFileManager : NSObject <AHSubSystem> {
@private
    NSFileManager *fileManager;
}


#pragma mark -
#pragma mark singleton


+ (AHFileManager *)manager;


#pragma mark -
#pragma mark json


- (NSArray *)parseJSONFromResourceFileToArray:(NSString *)_filename;
- (NSArray *)parseJSONFromFileToArray:(NSString *)_filename;
- (NSDictionary *)parseJSONFromResourceFileToDictionary:(NSString *)_filename;
- (NSDictionary *)parseJSONFromFileToDictionary:(NSString *)_filename;


@end
