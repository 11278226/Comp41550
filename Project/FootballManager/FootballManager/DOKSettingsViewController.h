//
//  DOKSettingsViewController.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 13/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuitDelegate <NSObject>
-(void) popToRootView;
@end

@interface DOKSettingsViewController : UITableViewController

@property (nonatomic, assign) id<QuitDelegate>    myDelegate;

@end
