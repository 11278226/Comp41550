//
//  DOKViewController.m
//  HelloPoly
//
//  Created by Diarmuid O'Keeffe on 15/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DOKPolygonView.h"

#define MAXLENGTH 2

@interface DOKViewController () {
    DOKPolygonView *aView;
}
- (IBAction)changeNumberOfSides:(UISegmentedControl *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSidesLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *polygonSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *polygonView;
@property (weak, nonatomic) IBOutlet UITextField *numOfSides;
@end

@implementation DOKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)changeNumberOfSides:(UISegmentedControl *)sender forEvent:(UIEvent *)event
{
    if(sender.selectedSegmentIndex == 0) {
        [self.polygonSegmentedControl setEnabled:YES forSegmentAtIndex:1];
        if (self.polygonModel.numberOfSides == 3) {
            [self.polygonSegmentedControl setEnabled:NO forSegmentAtIndex:0];
        }
        [self.polygonModel setNumberOfSides:self.polygonModel.numberOfSides - 1];
        self.numberOfSidesLabel.text = [self.polygonModel name];
        
    } else if(sender.selectedSegmentIndex =1) {
        [self.polygonSegmentedControl setEnabled:YES forSegmentAtIndex:0];
        if(self.polygonModel.numberOfSides == 12) {
            [self.polygonSegmentedControl setEnabled:NO forSegmentAtIndex:1];
        }
        [self.polygonModel setNumberOfSides:self.polygonModel.numberOfSides + 1];
        self.numberOfSidesLabel.text = [self.polygonModel name];
        
    }
    aView.numberOfSides = self.polygonModel.numberOfSides;
    self.numOfSides.text = [NSString stringWithFormat:@"%d", self.polygonModel.numberOfSides];
    [aView setNeedsDisplay];

}

- (PolygonShape *)polygonModel
{
    if(!_polygonModel) {
        _polygonModel = [[PolygonShape alloc] init];
    }
    return _polygonModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numberOfSidesLabel.text = [self.polygonModel name];    
    aView = [[DOKPolygonView alloc] initWithFrame:CGRectMake(20,140,280,364)];
    aView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:aView];
    aView.numberOfSides = self.polygonModel.numberOfSides;
    self.numOfSides.text = [NSString stringWithFormat:@"%d",self.polygonModel.numberOfSides];
    [aView setNeedsDisplay];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
   
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    int myInt = [[NSString stringWithFormat:@"%@%@",textField.text, string] integerValue];
    if (myInt > 12 || myInt == 2) {
        newLength = 20;
    }
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}

-(void)dismissKeyboard {
    if ([self.numOfSides.text integerValue] < 3) {
        self.numOfSides.text = @"3";
    }
    [self.polygonModel setNumberOfSides:[self.numOfSides.text integerValue]];
    self.numberOfSidesLabel.text = [self.polygonModel name];
    aView.numberOfSides = self.polygonModel.numberOfSides;
    [self.numOfSides resignFirstResponder];
    [aView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
