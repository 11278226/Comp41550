//
//  DOKPlayerModel+Details.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 15/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKPlayerModel+Details.h"

@implementation DOKPlayerModel(Details)

+ (int)overallForPlayer:(DOKPlayerModel *)player {
    int overall;
    overall = [[player offensivePositioning] intValue] + [[player defensivePositioning] intValue] +[[player strength] intValue] +[[player stamina] intValue] +[[player tackling] intValue] +[[player speed] intValue] +[[player goalkeeping] intValue] +[[player shooting] intValue] +[[player passing] intValue] +[[player dribbling] intValue] +[[player composure] intValue];
    return overall;
}

+ (NSString *)preferredPosition:(DOKPlayerModel *)player {
    int goalie;
    int def;
    int mid;
    int fwd;
    goalie = ([[player goalkeeping] intValue] + [[player passing] intValue]/2)*(10/3);
    def = ([[player defensivePositioning] intValue] + [[player tackling] intValue] + [[player passing] intValue]/2 + [[player strength] intValue])*(10/7);
    mid = ([[player passing] intValue] + [[player strength] intValue] + [[player dribbling] intValue]/2 + [[player speed] intValue]/2)*(10/6);
    fwd = ([[player shooting] intValue] + [[player offensivePositioning] intValue]/2 + [[player strength] intValue] + [[player dribbling] intValue]/2 + [[player passing] intValue]/2)*(10/7);
    NSArray *result = [NSArray arrayWithObjects:[NSNumber numberWithInt:goalie],[NSNumber numberWithInt:def],[NSNumber numberWithInt:mid],[NSNumber numberWithInt:fwd], nil];
    
    NSInteger highestNumber = 0;
    NSInteger numberIndex;
    for (NSNumber *theNumber in result)
    {
        if ([theNumber integerValue] > highestNumber) {
            highestNumber = [theNumber integerValue];
            numberIndex = [result indexOfObject:theNumber];
        }
    }
    switch (numberIndex) {
        case 0:
            return @"GK";
            break;
        case 1:
            return @"DEF";
            break;
        case 2:
            return @"MID";
            break;
        case 3:
            return @"FWD";
            break;
        default:
            return nil;
            break;
    }
//    NSArray *sortedResult = [result sortedArrayUsingComparator:^(id firstObject, id secondObject) {
//        return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
//    }];
    
    
    return nil;
}

@end
