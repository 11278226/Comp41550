//
//  DOKFormationTableViewController.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 14/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOKPlayerModel+Details.h"

@protocol PickPlayerDelegate
- (void)pickPlayerViewControllerPlayerPicked:(DOKPlayerModel *)playerPicked playerRemoved:(DOKPlayerModel *)playerRemoved forTag:(int)tag;
@end

@interface DOKPickPlayerTableViewController : UITableViewController

@property (nonatomic, assign) id<PickPlayerDelegate> pickPlayerDelegate;
@property int *thisPlayerTag;
@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, retain) NSString *originalPlayer;
@property (nonatomic, retain) NSString *thisPlayer;

@end
