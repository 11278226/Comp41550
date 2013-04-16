//
//  DOKTabBarViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 13/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKTabBarViewController.h"
#import "DOKSettingsViewController.h"

@interface DOKTabBarViewController ()

@end

@implementation DOKTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDelegate:(id)self];
//    self.tabBarController.delegate = self;
	// Do any additional setup after loading the view.
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[DOKSettingsViewController class]]) {
        DOKSettingsViewController *settingsViewController = (DOKSettingsViewController *)viewController;
        settingsViewController.myDelegate = self.futureDelegate;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
