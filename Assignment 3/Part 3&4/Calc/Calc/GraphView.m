//
//  GraphView.m
//  AxisDrawing
//
//  Created by CSI COMP41550 on 10/02/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
//    [AxesDrawer drawAxesInRect:rect originAtPoint:[self.delegate getOrigin:rect] scale:[self.delegate getScale] lineOrigin:[self.delegate startPoint] lineEnd:[self.delegate endPoint]];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	UIGraphicsPushContext(context);
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:[self.delegate getOrigin:rect] scale:[self.delegate getScale] context:context];
    
    CGPoint lineOrigin = [self.delegate startPoint];
    CGPoint lineEnd = [self.delegate endPoint];

    CGContextMoveToPoint(context, lineOrigin.x, lineOrigin.y);
    CGContextAddLineToPoint(context, lineEnd.x, lineEnd.y);
    
    CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(context, red);
    
	CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}
@end
