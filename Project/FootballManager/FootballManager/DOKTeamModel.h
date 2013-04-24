//
//  DOKTeamModel.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 01/02/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface DOKTeamModel : NSManagedObject

@property (nonatomic,retain) NSString *teamName;
@property (nonatomic,retain) NSNumber *leagueID;
@property (nonatomic,retain) NSNumber *wins;
@property (nonatomic,retain) NSNumber *draws;
@property (nonatomic,retain) NSNumber *losses;
@property (nonatomic,retain) NSNumber *points;
@property (nonatomic,retain) NSNumber *goalsFor;
@property (nonatomic,retain) NSNumber *goalsAgainst;

@end
