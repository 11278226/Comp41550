//
//  PolygonShape.m
//  HelloPoly
//
//  Created by Diarmuid O'Keeffe on 15/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "PolygonShape.h"

@implementation PolygonShape

- (id)init
{
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int x;
        if((x = [[defaults objectForKey:@"numberOfSides"] integerValue])) {
            self.numberOfSides = x;
        } else {
        self.numberOfSides = 3;
        }
    }
    return self;
}

- (NSString *)name {
    NSArray *names  = [NSArray arrayWithObjects:@"Triangle",
                        @"Square",
                        @"Pentagon",
                        @"Hexagon",
                        @"Heptagon",
                        @"Octagon",
                        @"Nonagon",
                        @"Decagon",
                        @"Undecagon",
                        @"Dodecagon",
                        nil];
    
    return [names objectAtIndex:self.numberOfSides - 3];
}

- (void)setNumberOfSides:(int)sides {
    if ((sides > 12) || (sides <3)) return;
    _numberOfSides = sides;
}

@end
