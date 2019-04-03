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
@property (nonatomic, weak) IBOutlet UISwitch *autoPresentSwitch;

@end

@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show the status bar with a nice animation.
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //
    [self updateUI];
}

- (void)updateUI
{
    self.unitIDLabel.text = DataModel.shared.prettyUnitID;
    self.preloadSwitch.on = DataModel.shared.shouldPreload;
    self.autoPresentSwitch.on = DataModel.shared.shouldAutoPresent;
}

- (IBAction)preloadSwitchChanged:(UISwitch *)sender
{
    DataModel.shared.shouldPreload = sender.on;
}

- (IBAction)autoPresentSwitchChanged:(UISwitch *)sender
{
    DataModel.shared.shouldAutoPresent = sender.on;
}

@end
