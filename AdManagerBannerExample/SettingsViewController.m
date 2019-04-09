//
//  SettingsViewController.m
//  AdManagerBannerExample
//
//  Created by Colin Caufield on 4/2/19.
//  Copyright © 2019 Google. All rights reserved.
//

#import "SettingsViewController.h"
#import "UnitIDViewController.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *unitIDLabel;
@property (nonatomic, weak) IBOutlet UISwitch *preloadSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *preloadOffscreenSwitch;
@property (nonatomic, weak) IBOutlet UITableViewCell *preloadOffscreenCell;
@property (nonatomic, weak) IBOutlet UISwitch *injectVisibilityJavascriptSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *autoPresentSwitch;

@end

@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show the status bar with a nice animation.
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Refresh the UI.
    [self updateUI];
}

- (void)updateUI
{
    // Set unit ID label text.
    self.unitIDLabel.text = DataModel.shared.prettyUnitID;
    
    // Set the switch states.
    self.preloadSwitch.on = DataModel.shared.shouldPreload;
    self.preloadOffscreenSwitch.on = DataModel.shared.preloadOffscreen;
    self.injectVisibilityJavascriptSwitch.on = DataModel.shared.injectVisibilityJavascript;
    self.autoPresentSwitch.on = DataModel.shared.shouldAutoPresent;
    
    // Only enable the preload offscreen cell if preloading is on.
    [self setPreloadOffscreenCellEnabled:DataModel.shared.shouldPreload];
}

- (void)setPreloadOffscreenCellEnabled:(BOOL)enabled
{
    self.preloadOffscreenCell.userInteractionEnabled = enabled;
    self.preloadOffscreenCell.contentView.alpha = enabled ? 1.0 : 0.5;
}

- (IBAction)preloadSwitchChanged:(UISwitch *)sender
{
    DataModel.shared.shouldPreload = sender.on;
    [self updateUI];
}

- (IBAction)preloadOffscreenChanged:(UISwitch *)sender
{
    DataModel.shared.preloadOffscreen = sender.on;
    [self updateUI];
}

- (IBAction)injectVisibilityJavascriptSwitchChanged:(UISwitch *)sender
{
    DataModel.shared.injectVisibilityJavascript = sender.on;
    [self updateUI];
}

- (IBAction)autoPresentSwitchChanged:(UISwitch *)sender
{
    DataModel.shared.shouldAutoPresent = sender.on;
    [self updateUI];
}

@end
