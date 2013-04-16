//
//  DOKManagerModel.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 19/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOKManagerModel : NSObject

@property (nonatomic) NSString *managerName;
@property int managerID;
@property NSString *teamName;
@property (nonatomic) NSString *wins;
@property (nonatomic) NSString *draws;
@property (nonatomic) NSString *losses;

@end
