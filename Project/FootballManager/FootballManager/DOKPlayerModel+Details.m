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

- (NSNumber *)overall {
    int overall = [self.offensivePositioning intValue] + [self.defensivePositioning intValue] +[self.strength intValue] +[self.stamina intValue] +[self.tackling intValue] +[self.speed intValue] +[self.goalkeeping intValue] +[self.shooting intValue] +[self.passing intValue] +[self.dribbling intValue] +[self.composure intValue];
    return [NSNumber numberWithInt:overall];
}

+ (NSMutableArray *)preferredPosition:(DOKPlayerModel *)player {
    int goalie;
    int def;
    int mid;
    int fwd;
    goalie = ([[player goalkeeping] intValue] + [[player passing] intValue]/2)*(10/4);
    def = ([[player defensivePositioning] intValue] + [[player tackling] intValue] + [[player passing] intValue]/2 + [[player strength] intValue])*(10/7);
    mid = ([[player passing] intValue] + [[player strength] intValue] + [[player dribbling] intValue]/2 + [[player speed] intValue]/2)*(10/6);
    fwd = ([[player shooting] intValue] + [[player offensivePositioning] intValue]/2 + [[player strength] intValue] + [[player dribbling] intValue]/2 + [[player passing] intValue]/2)*(10/7);
    NSArray *result = [NSArray arrayWithObjects:[NSNumber numberWithInt:goalie],[NSNumber numberWithInt:def],[NSNumber numberWithInt:mid],[NSNumber numberWithInt:fwd], nil];
    
    NSMutableArray *answer = [NSMutableArray array];
    
    NSArray *sorted = [result sortedArrayUsingSelector:@selector(compare:)];
    bool fwdChosen = NO;
    bool midChosen = NO;
    bool defChosen = NO;
    
    for (NSNumber *thisNumber in sorted) {
        if ([thisNumber intValue]==fwd && !fwdChosen) {
            [answer insertObject:@"FWD" atIndex:0];
            fwdChosen = YES;
        } else if ([thisNumber intValue]==mid && !midChosen) {
            [answer insertObject:@"MID" atIndex:0];
            midChosen = YES;
        } else if ([thisNumber intValue]==def && !defChosen) {
            [answer insertObject:@"DEF" atIndex:0];
            defChosen = YES;
        } else if ([thisNumber intValue]==goalie) {
            [answer insertObject:@"GK" atIndex:0];
        }
    }
    

    
    
    return answer;
}



@end
