//
//  DOKMatchViewController.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 07/02/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondDelegate <NSObject>
-(void) secondViewControllerDismissed;
-(void) secondViewControllerDismissedWithoutPlaying;
@end

@interface DOKMatchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *matches;
@property (nonatomic, retain) NSMutableArray *teams;
@property (nonatomic, assign) id<SecondDelegate> myDelegate;
@property (nonatomic, retain) UITableView IBOutlet *myTableView;

@end
