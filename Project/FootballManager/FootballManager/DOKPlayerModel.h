//
//  DOKPlayerModel.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 19/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface DOKPlayerModel : NSManagedObject

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *teamName;
@property (nonatomic,retain) NSNumber *offensivePositioning;
@property (nonatomic,retain) NSNumber *defensivePositioning;
@property (nonatomic,retain) NSNumber *strength;
@property (nonatomic,retain) NSNumber *shooting;
@property (nonatomic,retain) NSNumber *tackling;
@property (nonatomic,retain) NSNumber *goalkeeping;
@property (nonatomic,retain) NSNumber *passing;
@property (nonatomic,retain) NSNumber *dribbling;
@property (nonatomic,retain) NSNumber *speed;
@property (nonatomic,retain) NSNumber *stamina;
@property (nonatomic,retain) NSNumber *composure;
@property (nonatomic,retain) NSNumber *teamID;
//@property (nonatomic, retain) IBOutlet UIImageView *ratingImageView;

@end
