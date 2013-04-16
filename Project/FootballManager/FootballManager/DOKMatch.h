//
//  DOKMatch.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 11/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOKMatch : NSObject

@property (nonatomic,retain) NSString *homeTeam;
@property (nonatomic,retain) NSString *awayTeam;
@property (nonatomic,retain) NSNumber *homeGoals;
@property (nonatomic,retain) NSNumber *awayGoals;
@property (nonatomic,retain) NSNumber *gameWeek;

@end
