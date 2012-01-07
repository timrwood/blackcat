//
//  AHScene.m
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//

#import "AHScene.h"
#import "AHButton.h"
#import "AHFileManager.h"


@implementation AHScene


#pragma mark -
#pragma mark init


- (id)init {
    self = [super init];
    if (self) {
        buttons = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark buttons


- (void)addButtonsFromJSONFile:(NSString *)filename {
    NSArray *json = [[AHFileManager manager] parseJSONFromResourceFileToArray:filename];
    for (NSObject *object in json) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            [self addButtonFromDictionary:(NSDictionary *)object];
        }
    }
}

- (void)addButtonFromDictionary:(NSDictionary *)dictionary {
    NSDictionary *deviceSpecific;
    if (YES) { // check for ipad/iphone
        id dict = [dictionary objectForKey:@"ipad"];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            deviceSpecific = (NSDictionary *) dict;
        } else {
            dlog(@"No ipad dictionary found for button");
        }
    } else {
        id dict = [dictionary objectForKey:@"iphone"];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            deviceSpecific = (NSDictionary *) dict;
        } else {
            dlog(@"No iphone dictionary found for button");
        }
    }
    if (deviceSpecific) {
        [self addButton:[[AHButton alloc] initFromDictionary:deviceSpecific]];
    } else {
        dlog(@"No dictionary found for button");
    }
}

- (void)addButton:(AHButton *)button {
    
}

- (void)removeButton:(AHButton *)button {
    
}

- (void)removeAllButtons {
    
}


#pragma mark -
#pragma mark update


- (void)update {
    
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    
}


@end
