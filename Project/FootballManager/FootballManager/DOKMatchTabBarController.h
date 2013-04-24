//
//  DOKMatchTabBarController.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 17/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOKMatchTabBarController : UITabBarController

@property (nonatomic, retain) NSMutableArray *matches;
@property (nonatomic, retain) NSMutableArray *teams;
@property (nonatomic, assign) id exitMatchDelegate;

@end
