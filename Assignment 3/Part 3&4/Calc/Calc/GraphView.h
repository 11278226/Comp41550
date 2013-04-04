//
//  GraphView.h
//  AxisDrawing
//
//  Created by CSI COMP41550 on 10/02/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExpressionPoints
@required
- (CGPoint) startPoint;
- (CGPoint) endPoint;
- (double) getScale;
- (CGPoint) getOrigin:(CGRect)rect;
@end

@interface GraphView : UIView

@property (assign) id <ExpressionPoints> delegate;


@end
