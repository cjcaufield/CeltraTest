//
//  DataModel.m
//  AdManagerBannerExample
//
//  Created by Colin Caufield on 4/2/19.
//  Copyright © 2019 Google. All rights reserved.
//

#import "DataModel.h"

static NSString *kFLUnitID = @"FLUnitID";
static NSString *kFLShouldPreload = @"FLShouldPreload";
static NSString *kFLShouldAutoPresent = @"FLShouldAutoPresent";

@implementation DataModel

+ (instancetype)shared
{
    static DataModel *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[DataModel alloc] init];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Unit ID
        self.unitID = [self.defaults objectForKey:kFLUnitID];
        if (self.unitID.length == 0) {
            self.unitID = @"/21709104563/testing/cinemaloop_horizontal";
        }
        
        // Should preload
        if ([self.defaults objectForKey:kFLShouldPreload]) {
            self.shouldPreload = [self.defaults boolForKey:kFLShouldPreload];
        } else {
            self.shouldPreload = YES;
        }
        
        // Should automatically present
        if ([self.defaults objectForKey:kFLShouldAutoPresent]) {
            self.shouldAutoPresent = [self.defaults boolForKey:kFLShouldAutoPresent];
        } else {
            self.shouldAutoPresent = YES;
        }
    }
    return self;
}

+ (NSArray<NSString *> *)allPossibleUnitIDs
{
    return @[
         // 300x250 banner
         @"/21709104563/testing/display_300_250",
         
         // 300x600 banner
         @"/21709104563/testing/display_300_600",
         
         // Simple fullscreen Celtra banner ad
         @"/21709104563/testing/static_fsa",
         
         // Fullscreen landscape Celtra video loop with tap to full video.
         @"/21709104563/testing/cinemaloop_horizontal",
         
         // Fullscreen portrait Celtra video loop with tap to full video.
         @"/21709104563/testing/cinemaloop_vertical",
         
         // Internal tests
         @"/21709104563/testing/celtra/celtra1",
         @"/21709104563/testing/celtra/celtra2",
         @"/21709104563/testing/celtra/celtra3",
         @"/21709104563/testing/celtra/celtra4",
         @"/21709104563/testing/celtra/celtra5",
         @"/21709104563/testing/celtra/celtra6"
    ];
}

- (NSUserDefaults *)defaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (NSString *)prettyUnitID
{
    return [self.unitID lastPathComponent];
}

- (void)setUnitID:(NSString *)unitID
{
    _unitID = unitID;
    [self.defaults setObject:unitID forKey:kFLUnitID];
}

- (void)setShouldPreload:(BOOL)shouldPreload
{
    _shouldPreload = shouldPreload;
    [self.defaults setBool:shouldPreload forKey:kFLShouldPreload];
}

- (void)setShouldAutoPresent:(BOOL)shouldAutoPresent
{
    _shouldAutoPresent = shouldAutoPresent;
    [self.defaults setBool:shouldAutoPresent forKey:kFLShouldAutoPresent];
}

@end
