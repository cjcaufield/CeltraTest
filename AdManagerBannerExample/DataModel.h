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

// All the bundled unit IDs for testing
+ (NSArray<NSString *> *)allPossibleUnitIDs;

// Last componenet of the Unit ID only.
@property (nonatomic, readonly) NSString *prettyUnitID;

// Unit ID
@property (nonatomic, copy) NSString *unitID;

// Should the preloading hack be used
@property (nonatomic, assign) BOOL shouldPreload;

// Should the ad automatically be presented once it's done downloading (and preloading).
@property (nonatomic, assign) BOOL shouldAutoPresent;

@end
