//
//  DOKPlayerDetailViewController.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 02/02/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DOKPlayerModel;

@interface DOKPlayerDetailViewController : UITableViewController

@property (nonatomic, strong) IBOutlet DOKPlayerModel *player;

@end
