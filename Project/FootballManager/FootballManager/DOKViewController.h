//
//  DOKViewController.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 18/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOKNewCareerViewController.h"
#import "DOKSettingsViewController.h"

@interface DOKViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, QuitDelegate>

@property (nonatomic) UITableView *mainScreenTableView;

@end
