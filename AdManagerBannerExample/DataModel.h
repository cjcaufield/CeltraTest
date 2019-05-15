//
//  DataModel.h
//  AdManagerBannerExample
//
//  Created by Colin Caufield on 4/2/19.
//  Copyright © 2019 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

// Singleton
+ (instancetype)shared;

// All the bundled unit IDs for testing.
+ (NSArray<NSString *> *)allPossibleUnitIDs;

// Last componenet of the Unit ID only.
@property (nonatomic, readonly) NSString *prettyUnitID;

// Unit ID
@property (nonatomic, copy) NSString *unitID;

// Should the preloading hack be used.
@property (nonatomic, assign) BOOL shouldPreload;

// Place preloading views outside of the screen's bounds.
@property (nonatomic, assign) BOOL preloadOffscreen;

// Place preloading views in a parent view detached from the view hierarchy.
@property (nonatomic, assign) BOOL preloadInDetachedParentView;

// Hide banners after they've finished preloading.
@property (nonatomic, assign) BOOL hideAfterPreloading;

// Inject javascript to let the banner know when it's *actually* visible.
@property (nonatomic, assign) BOOL injectVisibilityJavascript;

// Should the ad automatically be presented once it's done downloading (and preloading).
@property (nonatomic, assign) BOOL shouldAutoPresent;

@end
