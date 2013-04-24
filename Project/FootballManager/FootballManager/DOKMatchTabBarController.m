//
//  DOKMatchTabBarController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 17/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKMatchTabBarController.h"
#import "DOKMatchViewController.h"

@interface DOKMatchTabBarController ()

@end

@implementation DOKMatchTabBarController

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
    
	// Do any additional setup after loading the view.
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[DOKMatchViewController class]]) {
        DOKMatchViewController *matchViewController = (DOKMatchViewController *)viewController;
        matchViewController.myDelegate = self.exitMatchDelegate;
        matchViewController.matches = [NSMutableArray array];
        matchViewController.teams = [NSMutableArray array];
        matchViewController.matches = self.matches;
        matchViewController.teams = self.teams;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
