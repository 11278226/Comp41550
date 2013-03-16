//
//  DOKGraphViewController.h
//  GraphCalc
//
//  Created by Diarmuid O'Keeffe on 11/03/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"
#import "GraphView.h"

@interface DOKGraphViewController : UIViewController <SplitViewBarButtonItemPresenter, UIGestureRecognizerDelegate, ExpressionPoints>

@property (nonatomic, strong) NSMutableArray* expression;
@property (nonatomic) GraphView *graphView;
@property (nonatomic) double scale;
@property (nonatomic) CGPoint origin;
@end
