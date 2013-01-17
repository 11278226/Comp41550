//
//  DOKViewController.m
//  HelloPoly
//
//  Created by Diarmuid O'Keeffe on 15/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKViewController.h"
#import "DOKPolygonView.h"


#define MAXLENGTH 2

@interface DOKViewController () {
    
}
@property (weak, nonatomic) IBOutlet UISlider *fillGreenSlider;
@property (weak, nonatomic) IBOutlet UISlider *fillBlueSlider;
@property (weak, nonatomic) IBOutlet UISlider *fillRedSlider;
@property (weak, nonatomic) IBOutlet UIView *previewColorView;
@property (weak, nonatomic) IBOutlet UILabel *fillBlueNumber;
@property (weak, nonatomic) IBOutlet UILabel *fillGreenNumber;
@property (weak, nonatomic) IBOutlet UILabel *fillRedNumber;
@property (weak, nonatomic) IBOutlet UIView *colorView;
- (IBAction)fillRedColor:(UISlider *)sender;
- (IBAction)fillGreenColor:(UISlider *)sender;
- (IBAction)fillBlueColor:(UISlider *)sender;
- (IBAction)changeColorPress:(id)sender;
- (IBAction)changeNumberOfSides:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UIStepper *polygonStepperControl;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSidesLabel;
- (IBAction)cancelColorChange:(UIButton *)sender;
- (IBAction)saveColorChange:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet DOKPolygonView *aView;
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

- (IBAction)fillRedColor:(UISlider *)sender {
    self.fillRedNumber.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updatePreviewColorView];
}

-(void)updatePreviewColorView
{
    UIColor *myColor = [UIColor colorWithRed:[self.fillRedNumber.text floatValue]/256 green:[self.fillGreenNumber.text floatValue]/256 blue:[self.fillBlueNumber.text floatValue]/256 alpha:1];
    self.previewColorView.backgroundColor = myColor;
}

- (IBAction)fillGreenColor:(UISlider *)sender {
    self.fillGreenNumber.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updatePreviewColorView];
}

- (IBAction)fillBlueColor:(UISlider *)sender {
    self.fillBlueNumber.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updatePreviewColorView];
}

- (IBAction)changeColorPress:(id)sender {
    self.colorView.hidden = NO;
}

- (IBAction)changeNumberOfSides:(UIStepper *)sender {
    double value = [sender value];
    [self.polygonModel setNumberOfSides:value];
    [self updateUI];
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
    [self updateUI];
    
    
    CGFloat red, green, blue, alpha;
    [self.polygonModel.insideColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    self.fillRedNumber.text = [NSString stringWithFormat:@"%.0f",red*256];
    self.fillGreenNumber.text = [NSString stringWithFormat:@"%.0f",green*256];
    self.fillBlueNumber.text = [NSString stringWithFormat:@"%.0f",blue*256];
    self.fillRedSlider.value = red*256;
    self.fillGreenSlider.value = green*256;
    self.fillBlueSlider.value = blue*256;
    
    [self updatePreviewColorView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
   
}

- (void)updateUI
{
    self.numberOfSidesLabel.text = [self.polygonModel name];
    self.aView.numberOfSides = self.polygonModel.numberOfSides;
    self.aView.insideColor = self.polygonModel.insideColor;
    self.aView.borderColor = self.polygonModel.borderColor;
    self.polygonStepperControl.value = self.polygonModel.numberOfSides;
    self.numOfSides.text = [NSString stringWithFormat:@"%d",self.polygonModel.numberOfSides];
    [self.aView setNeedsDisplay];

}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL invalid = false;
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    int myInt = [[NSString stringWithFormat:@"%@%@",textField.text, string] integerValue];
    if (myInt > 12 || myInt == 2) {
        invalid = true;
    }
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return (newLength <= MAXLENGTH || returnKey) && !invalid;
}

-(void)dismissKeyboard {
    if ([self.numOfSides.text integerValue] < 3) {
        self.numOfSides.text = @"3";
    }
    [self.polygonModel setNumberOfSides:[self.numOfSides.text integerValue]];
    [self updateUI];
    [self.numOfSides resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelColorChange:(UIButton *)sender {
    self.colorView.hidden = YES;
}

- (IBAction)saveColorChange:(UIButton *)sender {
    UIColor *myColor = [UIColor colorWithRed:[self.fillRedNumber.text floatValue]/256 green:[self.fillGreenNumber.text floatValue]/256 blue:[self.fillBlueNumber.text floatValue]/256 alpha:1];
    self.polygonModel.insideColor = myColor;
    [self updateUI];
    self.colorView.hidden = YES;
}
@end
