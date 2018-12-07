//  Copyright (c) 2014 Google. All rights reserved.

#import <UIKit/UIKit.h>

@class DFPBannerView;

@interface ViewController : UIViewController <DFPBannerAdLoaderDelegate, GADUnifiedNativeAdLoaderDelegate>

@property(nonatomic, strong) GADAdLoader *loader;

@end
