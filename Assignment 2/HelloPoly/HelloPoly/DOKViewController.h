//
//  DOKViewController.h
//  HelloPoly
//
//  Created by Diarmuid O'Keeffe on 20/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonShape.h"


@interface DOKViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) PolygonShape *polygonModel;

@end

