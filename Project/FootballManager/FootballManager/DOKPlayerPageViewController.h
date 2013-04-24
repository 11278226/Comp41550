//
//  DOKMatchPageViewController.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 14/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOKPlayerModel+Details.h"

@interface DOKPlayerPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, retain) NSMutableArray *playerArray;
@property (nonatomic, retain) DOKPlayerModel *player;

@end
