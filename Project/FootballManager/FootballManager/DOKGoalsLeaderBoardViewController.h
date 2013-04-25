//
//  DOKGoalsLeaderBoardViewController.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 20/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface DOKGoalsLeaderBoardViewController : CoreDataTableViewController

@property BOOL isAssists;
@property (nonatomic, assign) int league;

@end