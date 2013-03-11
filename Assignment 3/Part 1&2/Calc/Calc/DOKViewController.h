//
//  DOKViewController.h
//  Calc
//
//  Created by Diarmuid O'Keeffe on 26/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOKCalcModel.h"

@interface DOKViewController : UIViewController

@property (nonatomic,weak) IBOutlet UILabel *calcDisplay;
@property (nonatomic,strong) IBOutlet DOKCalcModel *calcModel;
@property (nonatomic) BOOL isInTheMiddleOfTypingSomething;
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;

@end
