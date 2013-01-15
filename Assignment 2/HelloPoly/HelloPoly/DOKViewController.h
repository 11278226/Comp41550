//
//  DOKViewController.h
//  HelloPoly
//
//  Created by Diarmuid O'Keeffe on 15/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonShape.h"

@interface DOKViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) PolygonShape *polygonModel;

@end
