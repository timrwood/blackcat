//
//  AHScene.m
//  BlackCat
//
//  Created by Tim Wood on 1/6/12.
//  Copyright (c) 2012 Broken Pixel Studios. All rights reserved.
//


#import "AHTimeManager.h"
#import "AHActorManager.h"
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
    NSDictionary *texture;
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
    id tex = [dictionary objectForKey:@"tex"];
    if ([tex isKindOfClass:[NSDictionary class]]) {
        texture = (NSDictionary *) tex;
    } else {
        dlog(@"No texture dictionary found for button");
    }
    if (deviceSpecific && texture) {
        [self addButton:[[AHButton alloc] initFromRectDictionary:deviceSpecific andTexDictionary:texture]];
    } else {
        dlog(@"No dictionary found for button");
    }
}

- (void)addButton:(AHButton *)button {
    if (![buttons containsObject:button]) {
        [buttons addObject:button];
    }
    [[AHActorManager manager] add:button];
    [button setScene:self];
}

- (void)removeButton:(AHButton *)button {
    if ([buttons containsObject:button]) {
        [buttons removeObject:button];
    }
    [[AHActorManager manager] destroy:button];
}

- (void)removeAllButtons {
    while ([buttons count] > 0) {
        [self removeButton:(AHButton *) [buttons objectAtIndex:0]];
    }
}


#pragma mark -
#pragma mark setup


- (void)setup {
    [self resetSetup];
}

- (void)resetSetup {
    
}


#pragma mark -
#pragma mark update


- (void)update {
    
}

- (void)reset {
    [self resetTeardown];
    [[AHActorManager manager] destroyAll];
    [[AHActorManager manager] updateAfterEverything];
    [[AHTimeManager manager] reset];
    [self resetSetup];
}


#pragma mark -
#pragma mark teardown


- (void)teardown {
    [self resetTeardown];
}

- (void)resetTeardown {
    
}


#pragma mark -
#pragma mark button


- (void)buttonWasTapped:(AHButton *)button {
    
}


@end
