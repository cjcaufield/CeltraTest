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
static NSString *kFLPreloadOffscreen = @"FLPreloadOffscreen";
static NSString *kFLPreloadInDetachedParentView = @"FLPreloadInDetachedParentView";
static NSString *kFLWaitForPreloadingCompletionEvent = @"FLWaitForPreloadingCompletionEvent";
static NSString *kFLHideAfterPreloading = @"FLHideAfterPreloading";
static NSString *kFLRemoveFromParentAfterPreloading = @"FLRemoveFromParentAfterPreloading";
static NSString *kFLInjectVisibilityJavascript = @"FLInjectVisibilityJavascript";
static NSString *kFLShouldAutoPresent = @"FLShouldAutoPresent";
static NSString *kFLManualImpressions = @"FLManualImpressions";

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
        self.unitID = [self defaultStringForKey:kFLUnitID fallback:@"/21709104563/testing/celtra/celtra18"];
        
        // Preload
        self.shouldPreload = [self defaultBoolForKey:kFLShouldPreload fallback:YES];
        
        // Preload offscreen
        // Doesn't seem to work, so leaving off by default.
        self.preloadOffscreen = [self defaultBoolForKey:kFLPreloadOffscreen fallback:NO];
        
        // Preload in detached parent view.
        self.preloadInDetachedParentView = [self defaultBoolForKey:kFLPreloadInDetachedParentView fallback:NO];
        
        // Wait for preloading completion event.
        self.waitForPreloadingCompletionEvent = [self defaultBoolForKey:kFLWaitForPreloadingCompletionEvent fallback:YES];
        
        // Hide after preloading
        self.hideAfterPreloading = [self defaultBoolForKey:kFLHideAfterPreloading fallback:NO];
        
        // Remove from hierarchy after preloading
        self.removeFromParentAfterPreloading = [self defaultBoolForKey:kFLRemoveFromParentAfterPreloading fallback:NO];
        
        // Inject visibility javascript
        self.injectVisibilityJavascript = [self defaultBoolForKey:kFLInjectVisibilityJavascript fallback:NO];
        
        // Auto-present
        self.shouldAutoPresent = [self defaultBoolForKey:kFLShouldAutoPresent fallback:YES];
        
        // Manual impressions
        self.manualImpressions = [self defaultBoolForKey:kFLManualImpressions fallback:NO];
    }
    return self;
}

- (NSString *)defaultStringForKey:(NSString *)key fallback:(NSString *)fallback
{
    NSString *defaultString = [self.defaults objectForKey:key];
    NSString *result = defaultString.length > 0 ? defaultString : fallback;
    return result;
}

- (BOOL)defaultBoolForKey:(NSString *)key fallback:(BOOL)fallback
{
    id object = [self.defaults objectForKey:key];
    BOOL result = object ? [self.defaults boolForKey:key] : fallback;
    return result;
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
         @"/21709104563/testing/celtra/celtra6",
         
         // Video ad *without* javascript hack
         @"/21709104563/testing/celtra/celtra18",
         
         // Video ad *with* javascript hack
         @"/21709104563/testing/celtra/celtra20"
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

- (void)setPreloadOffscreen:(BOOL)preloadOffscreen
{
    _preloadOffscreen = preloadOffscreen;
    [self.defaults setBool:preloadOffscreen forKey:kFLPreloadOffscreen];
}

- (void)setPreloadInDetachedParentView:(BOOL)detached
{
    _preloadInDetachedParentView = detached;
    [self.defaults setBool:detached forKey:kFLPreloadInDetachedParentView];
}

- (void)setWaitForPreloadingCompletionEvent:(BOOL)wait
{
    _waitForPreloadingCompletionEvent = wait;
    [self.defaults setBool:wait forKey:kFLWaitForPreloadingCompletionEvent];
}

- (void)setHideAfterPreloading:(BOOL)hide
{
    _hideAfterPreloading = hide;
    [self.defaults setBool:hide forKey:kFLHideAfterPreloading];
}

- (void)setRemoveFromParentAfterPreloading:(BOOL)remove
{
    _removeFromParentAfterPreloading = remove;
    [self.defaults setBool:remove forKey:kFLRemoveFromParentAfterPreloading];
}

- (void)setInjectVisibilityJavascript:(BOOL)inject
{
    _injectVisibilityJavascript = inject;
    [self.defaults setBool:inject forKey:kFLInjectVisibilityJavascript];
}

- (void)setShouldAutoPresent:(BOOL)shouldAutoPresent
{
    _shouldAutoPresent = shouldAutoPresent;
    [self.defaults setBool:shouldAutoPresent forKey:kFLShouldAutoPresent];
}

- (void)setManualImpressions:(BOOL)manualImpressions
{
    _manualImpressions = manualImpressions;
    [self.defaults setBool:manualImpressions forKey:kFLManualImpressions];
}

@end
