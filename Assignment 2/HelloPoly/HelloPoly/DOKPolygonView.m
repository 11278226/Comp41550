//
//  DOKPolygonView.m
//  HelloPoly
//
//  Created by Diarmuid O'Keeffe on 15/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKPolygonView.h"

@implementation DOKPolygonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);
    [self.insideColor setFill];
    [self.borderColor setStroke];
    NSArray *theArray = [DOKPolygonView pointsForPolygonInRect:self.bounds numberOfSides:self.numberOfSides];
    for (NSValue *theValue in theArray) {
        CGPoint thePoint = [theValue CGPointValue];
        if ([theArray indexOfObject:theValue] == 0) {
             CGContextMoveToPoint(context, thePoint.x, thePoint.y);
        } else {
            CGContextAddLineToPoint(context, thePoint.x, thePoint.y);
        }
    }
    // Drawing code
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFillStroke);    
}

+ (NSArray *)pointsForPolygonInRect:(CGRect)rect numberOfSides:(int)numberOfSides {
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    float radius = 0.9 * center.x; NSMutableArray *result = [NSMutableArray array];
    float angle = (2.0 * M_PI) / numberOfSides;
    float exteriorAngle = M_PI - angle;
    float rotationDelta = angle - (0.5 * exteriorAngle);
    for (int currentAngle = 0; currentAngle < numberOfSides; currentAngle++) {
        float newAngle = (angle * currentAngle) - rotationDelta;
        float curX = cos(newAngle) * radius;
        float curY = sin(newAngle) * radius;
        [result addObject:[NSValue valueWithCGPoint:
                           CGPointMake(center.x+curX,center.y+curY)]];
    }
    return result;
}



@end
