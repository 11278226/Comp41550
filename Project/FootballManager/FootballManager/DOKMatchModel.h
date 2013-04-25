//
//  DOKMatchModel.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 08/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface DOKMatchModel : NSManagedObject

@property (nonatomic,retain) NSString *homeTeam;
@property (nonatomic,retain) NSString *awayTeam;
@property (nonatomic,retain) NSNumber *homeGoals;
@property (nonatomic,retain) NSNumber *awayGoals;
@property (nonatomic,retain) NSNumber *gameWeek;
@property (nonatomic,retain) NSNumber *league;

@end
