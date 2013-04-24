//
//  DOKPlayerModel+Details.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 15/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKPlayerModel.h"

@interface DOKPlayerModel (Details)
+ (int)overallForPlayer:(DOKPlayerModel *)player;
- (NSNumber *)overall;
+ (NSString *)preferredPosition:(DOKPlayerModel *)player;
@end
