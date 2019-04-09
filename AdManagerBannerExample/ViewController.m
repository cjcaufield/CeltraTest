//  Copyright (c) 2014 Google. All rights reserved.

@import GoogleMobileAds;

#import "ViewController.h"
#import "SettingsViewController.h"
#import "DataModel.h"

@interface ViewController () <DFPBannerAdLoaderDelegate, GADUnifiedNativeAdLoaderDelegate, GADAppEventDelegate>

// Ads
@property (nonatomic, strong) GADAdLoader *loader;
@property (nonatomic, strong) DFPBannerView *bannerView;
@property (nonatomic, assign) BOOL bannerWantsFullscreen;
@property (nonatomic, assign) BOOL bannerHasBeenPreloaded;

// Debug UI
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UILabel *activityLabel;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *actionBarButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *resetBarButton;

@end

@implementation ViewController

#pragma mark - UI

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reset];
    
    self.view.backgroundColor = [UIColor blackColor]; // [UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Don't show the status bar.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)updateUI
{
    // Update spinner
    [self updateSpinner];
    
    // Update the toolbar
    [self updateToolbar];
}

- (void)updateSpinner
{
    // No Ad
    if ([self canFetchAd]) {
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
        self.activityLabel.text = @"No Ad";
    }
    // Fetching
    if ([self isFetchingAd]) {
        self.spinner.hidden = NO;
        [self.spinner startAnimating];
        self.activityLabel.text = @"Fetching";
    }
    // Preloading
    else if ([self isPreloadingAd]) {
        self.spinner.hidden = NO;
        [self.spinner startAnimating];
        self.activityLabel.text = @"Preloading";
    }
    // Ready
    else if ([self canPresentBanner]) {
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
        self.activityLabel.text = @"Ready";
    }
}

- (void)updateToolbar
{
    // Reset button
    self.resetBarButton.enabled = [self canReset];
    
    // Fetch button
    if ([self canFetchAd]) {
        self.actionBarButton.title = @"Fetch";
        self.actionBarButton.enabled = YES;
    }
    // Present button
    else if ([self canPresentBanner]) {
        self.actionBarButton.title = @"Present";
        self.actionBarButton.enabled = YES;
    }
    // None
    else {
        self.actionBarButton.enabled = NO;
    }
}

- (IBAction)resetTapped:(UIBarButtonItem *)sender
{
    [self reset];
}

- (IBAction)actionTapped:(UIBarButtonItem *)sender
{
    // Fetch
    if ([self canFetchAd]) {
        [self tryFetchAd];
    }
    // Present
    else if ([self canPresentBanner]) {
        [self layoutBannerView];
    }
    
    // Update the UI.
    [self updateUI];
}

#pragma mark - Flow

- (void)reset
{
    // Destroy the loader
    self.loader = nil;
    
    // Remove the banner
    [self removeBannerView];
    
    // Reset flags
    self.bannerWantsFullscreen = NO;
    self.bannerHasBeenPreloaded = NO;
    
    // Update the UI
    [self updateUI];
}

- (void)tryFetchAd
{
    if (![self canFetchAd]) {
        return;
    }
    
    NSLog(@"Fetching ad");
    
    // Unit ID.
    NSString *unitID = DataModel.shared.unitID;
    
    // Banner and native types (unified request).
    NSArray *adTypes = @[kGADAdLoaderAdTypeDFPBanner, kGADAdLoaderAdTypeUnifiedNative];
    
    // Create the request.
    DFPRequest *request = [DFPRequest request];
    request.testDevices = @[kGADSimulatorID];
    
    // Create the loader.
    self.loader = [[GADAdLoader alloc] initWithAdUnitID:unitID rootViewController:self adTypes:adTypes options:nil];
    self.loader.delegate = self;
    
    // Load the request.
    [self.loader loadRequest:request];
}

- (void)preloadingDidFinish
{
    // Update flag
    self.bannerHasBeenPreloaded = YES;
    
    // Auto-present?
    if (DataModel.shared.shouldAutoPresent) {
        // Layout
        [self layoutBannerView];
    }
    
    // Update the UI
    [self updateUI];
}

#pragma mark - Google Delegate Methods

- (NSArray<NSValue *> *)validBannerSizesForAdLoader:(GADAdLoader *)adLoader
{
    NSLog(@"validBannerSizesForAdLoader:");
    
    return @[
        NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(300, 600))),
        NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(300, 250))),
        NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(1, 1))) // Fullscreen
    ];
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveDFPBannerView:(DFPBannerView *)bannerView
{
    NSLog(@"adLoader:didReceiveDFPBannerView:");
    
    // Abandon the banner if the fetch has been cancelled.
    if (!self.loader) {
        return;
    }
    
    // Grab the banner.
    self.bannerView = bannerView;
    
    // If the banner is 1x1 it's fullscreen.
    // This is a convention suggested by Google.
    self.bannerWantsFullscreen = CGSizeEqualToSize(self.bannerView.frame.size, CGSizeMake(1.0, 1.0));
    
    // Register as the banner's event delegate.
    self.bannerView.appEventDelegate = self;
    
    // Update the UI.
    [self updateUI];
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd
{
    NSLog(@"adLoader:didReceiveUnifiedNativeAd:");
    
    // Do nothing because we're only testing banners.
    
    // Update the UI.
    [self updateUI];
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error
{
    // Log the error
    NSLog(@"adLoader:didFailToReceiveAdWithError: %@", error);
    
    // Update the UI.
    [self updateUI];
}

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader
{
    NSLog(@"adLoaderDidFinishLoading:");
    
    // Abort if the fetch was cancelled or no banner arrived.
    if (!self.loader || !self.bannerView) {
        [self reset];
        return;
    }
    
    // Get rid of the loader.
    self.loader = nil;
    
    // Resize
    // IMPORTANT: Do this as early as possible.  Banners won't load properly when they're 1x1.
    [self resizeBannerView];
    
    // PRELOADING HACK
    // Banners won't preload unless they're attached to a window.
    if (DataModel.shared.shouldPreload) {
        // Logging
        NSLog(@"Using preloading hack.");
        NSLog(@"Adding banner to main window.");
        
        // Add the banner to the main window so it can preload.
        [self.mainWindow addSubview:self.bannerView];
        [self.mainWindow sendSubviewToBack:self.bannerView];
        
        // Optionally move the banner outside of the screen frame.
        if (DataModel.shared.preloadOffscreen) {
            CGRect offscreenBannerFrame = self.bannerView.frame;
            offscreenBannerFrame.origin.x += UIScreen.mainScreen.bounds.size.width;
            self.bannerView.frame = offscreenBannerFrame;
        }
        
        // Wait a specified amount of time for preloading to complete.
        NSTimeInterval kPreloadingTime = 5.0;
        [self performSelector:@selector(preloadingDidFinish) withObject:nil afterDelay:kPreloadingTime];
    }
    // NO PRELOADING HACK
    // Show banner immediately after it's received.
    else {
        // Logging
        NSLog(@"Not using preloading hack.");
        
        // Skip preloading.
        [self preloadingDidFinish];
    }
    
    // Update the UI.
    [self updateUI];
}

- (void)adView:(GADBannerView *)banner didReceiveAppEvent:(NSString *)name withInfo:(nullable NSString *)info
{
    NSLog(@"adView:didReceiveAppEvent:%@ withInfo:%@", name, info);
    
    // Nothing yet.
}

#pragma mark - Layout

- (UIWindow *)mainWindow
{
    return [[[UIApplication sharedApplication] delegate] window];
}

- (CGRect)fullscreenFrame
{
    // Fullscreen frame
    CGRect fullscreenFrame = self.view.bounds;
    
    // Safe area insets
    if (@available(iOS 11.0, *)) {
        fullscreenFrame = UIEdgeInsetsInsetRect(fullscreenFrame, self.mainWindow.safeAreaInsets);
    }
    
    // Bottom toolbar
    if (self.toolbar) {
        const CGFloat kBottomToolbarHeight = 44.0;
        fullscreenFrame.size.height -= kBottomToolbarHeight;
    }
    
    return fullscreenFrame;
}

- (void)resizeBannerView
{
    NSLog(@"resizeBannerView");
    
    // Fullscreen size if the ad wants it.
    if (self.bannerWantsFullscreen) {
        // Google resize method
        NSLog(@"Expanding banner to fullscreen frame");
        [self.bannerView resize:GADAdSizeFromCGSize(self.fullscreenFrame.size)];
        
        //
        self.bannerView.frame = self.fullscreenFrame;
    }
}

- (void)layoutBannerView
{
    NSLog(@"layoutBannerView");
    
    // Add the banner as a subview if necessary.
    if (![self hasBannerSubview]) {
        NSLog(@"Adding banner view as subview");
        [self.view addSubview:self.bannerView];
    }
    
    // Fullscreen banners take up most of the screen.
    if (self.bannerWantsFullscreen) {
        NSLog(@"Expanding banner to fullscreen frame");
        self.bannerView.frame = self.fullscreenFrame;
    }
    // Non-fullscreen banners are centered, but not resized.
    else {
        NSLog(@"Centering banner");
        self.bannerView.center = self.view.center;
    }
    
    // The GMA SDK seems to think ads are visibile when they're not.
    // To work around this, inject javascript to tell the banner that it's *actually* visible.
    if (DataModel.shared.injectVisibilityJavascript) {
        [self setBannerVisibilityJavascriptFlag:YES];
    }
    
    // Update the UI.
    [self updateUI];
}

- (void)removeBannerView
{
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}

- (BOOL)hasBannerSubview
{
    return [self.view.subviews containsObject:self.bannerView];
}

- (void)setBannerVisibilityJavascriptFlag:(BOOL)visible
{
    UIWebView *webView = [self topmostUIWebView:self.bannerView];
    NSString *javascriptString = [self bannerVisibilityJavascriptString:visible];
    [webView stringByEvaluatingJavaScriptFromString:javascriptString];
}

- (UIWebView *)topmostUIWebView:(UIView *)rootView
{
    // Be safe.
    if (rootView == nil) {
        return nil;
    }
    
    // This is a breadth first search, so maintain a queue of views to check.
    NSArray<UIView *> *views = @[rootView];
    
    // Subviews to check on the next iteration.
    NSMutableArray<UIView *> *subviews = [NSMutableArray array];
    
    // While there are still views to check.
    while (views.count > 0) {
        // Iterate over them.
        for (UIView *view in views) {
            // If the view is a UIWebView, return it.
            if ([view isKindOfClass:[UIWebView class]]) {
                return (UIWebView *)view;
            }
            // Otherwise, enqueue the view's subviews.
            else {
                [subviews addObjectsFromArray:view.subviews];
            }
        }
        
        // Set up the next iteration.
        views = subviews;
        subviews = [NSMutableArray array];
    }
    
    // Nothing found.
    return nil;
}

- (NSString *)bannerVisibilityJavascriptString:(BOOL)visible
{
    NSString *param = visible ? @"true" : @"false";
    
    NSString *javascriptString = [NSString stringWithFormat:@" \
        if (typeof flipboardVisibilityFlag !== 'undefined') {  \
            flipboardVisibilityFlag = %@;                      \
        }", param];
    
    return javascriptString;
}

#pragma mark - State

- (BOOL)canReset
{
    return self.loader != nil || self.bannerView != nil;
}

- (BOOL)canFetchAd
{
    return self.loader == nil && self.bannerView == nil;
}

- (BOOL)isFetchingAd
{
    return self.loader != nil && self.bannerView == nil;
}

- (BOOL)isPreloadingAd
{
    // If the banner is still attached to the window and it hasn't finished preloading.
    return [self.mainWindow.subviews containsObject:self.bannerView] && !self.bannerHasBeenPreloaded;
}

- (BOOL)canPresentBanner
{
    return self.bannerView != nil && ![self hasBannerSubview] && ![self isPreloadingAd] && !DataModel.shared.shouldAutoPresent;
}

@end
