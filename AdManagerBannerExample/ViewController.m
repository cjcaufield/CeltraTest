//  Copyright (c) 2014 Google. All rights reserved.

@import GoogleMobileAds;

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    
    [self sendDFPRequest];
}

- (void)sendDFPRequest
{
    NSLog(@"sendDFPRequest");
    
    NSString *unitID =
        //@"/21709104563/testing/display_300_250";
        //@"/21709104563/testing/display_300_600";
        //@"/21709104563/testing/static_fsa";
        //@"/21709104563/testing/cinemaloop_horizontal";
        //@"/21709104563/testing/cinemaloop_vertical";
        //@"/21709104563/testing/celtra/celtra1";
        //@"/21709104563/testing/celtra/celtra2";
        @"/21709104563/testing/celtra/celtra3";
        //@"/21709104563/testing/celtra/celtra4";
        //@"/21709104563/testing/celtra/celtra5";
        //@"/21709104563/testing/celtra/celtra6";
    
    NSArray *adTypes = @[kGADAdLoaderAdTypeDFPBanner, kGADAdLoaderAdTypeUnifiedNative];
    
    DFPRequest *request = [DFPRequest request];
    request.testDevices = @[kGADSimulatorID];
    
    self.loader = [[GADAdLoader alloc] initWithAdUnitID:unitID rootViewController:self adTypes:adTypes options:nil];
    self.loader.delegate = self;
    [self.loader loadRequest:request];
}

- (NSArray<NSValue *> *)validBannerSizesForAdLoader:(GADAdLoader *)adLoader
{
    NSLog(@"validBannerSizesForAdLoader:");
    
    return @[
        NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(300, 600))),
        NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(300, 250))),
        NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(1, 1)))
    ];
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveDFPBannerView:(DFPBannerView *)bannerView
{
    NSLog(@"adLoader:didReceiveDFPBannerView:");
    
    [self.view addSubview:bannerView];
    
    // If the banner is 1x1 it should be expanded to fullscreen.
    BOOL wantsFullscreen = CGSizeEqualToSize(bannerView.frame.size, CGSizeMake(1.0, 1.0));
    if (wantsFullscreen) {
        // Fullscreen frame
        CGRect fullscreenFrame = self.view.bounds;
        
        // Safe area insets
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if ([mainWindow respondsToSelector:@selector(safeAreaInsets)]) {
            fullscreenFrame = UIEdgeInsetsInsetRect(fullscreenFrame, mainWindow.safeAreaInsets);
        }
        
        [bannerView resize:GADAdSizeFromCGSize(fullscreenFrame.size)];
        bannerView.frame = fullscreenFrame;
    }
    else {
        bannerView.center = self.view.center;
    }
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd
{
    NSLog(@"adLoader:didReceiveUnifiedNativeAd:");
    
    // Empty because we're only testing banners.
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"adLoader:didFailToReceiveAdWithError: %@", error);
}

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader
{
    NSLog(@"adLoaderDidFinishLoading:");
}

@end
