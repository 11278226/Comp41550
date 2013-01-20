//
//  DOKViewController.m
//  HelloPoly
//
//  Created by Diarmuid O'Keeffe on 20/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKViewController.h"
#import "DOKPolygonView.h"


#define MAXLENGTH 2

@interface DOKViewController () {
    UILabel *polygonType;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic) CGFloat netRotation;
-(IBAction) handleRotateGesture:(UIGestureRecognizer *) sender;
@property (weak, nonatomic) IBOutlet UIView *previewBorderColorView;
@property (weak, nonatomic) IBOutlet UILabel *borderBlueNumber;
@property (weak, nonatomic) IBOutlet UILabel *borderGreenNumber;
@property (weak, nonatomic) IBOutlet UILabel *borderRedNumber;
- (IBAction)borderBlueColor:(UISlider *)sender;
- (IBAction)borderGreenColor:(UISlider *)sender;
- (IBAction)borderRedColor:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UISlider *borderBlueSlider;
@property (weak, nonatomic) IBOutlet UISlider *borderGreenSlider;
@property (weak, nonatomic) IBOutlet UISlider *borderRedSlider;
@property (weak, nonatomic) IBOutlet UISlider *fillGreenSlider;
@property (weak, nonatomic) IBOutlet UISlider *fillBlueSlider;
@property (weak, nonatomic) IBOutlet UISlider *fillRedSlider;
@property (weak, nonatomic) IBOutlet UIView *previewColorView;
@property (weak, nonatomic) IBOutlet UILabel *fillBlueNumber;
@property (weak, nonatomic) IBOutlet UILabel *fillGreenNumber;
@property (weak, nonatomic) IBOutlet UILabel *fillRedNumber;
- (IBAction)increase:(id)sender;
- (IBAction)decrease:(id)sender;
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

- (void)didReceiveMemoryWarning
{
    
    [self setNumberOfSidesLabel:nil];
    [self setPolygonModel:nil];
    [self setMyScrollView:nil];
    [self setPreviewBorderColorView:nil];
    [self setPreviewColorView:nil];
    [self setBorderBlueNumber:nil];
    [self setBorderGreenNumber:nil];
    [self setBorderRedNumber:nil];
    [self setBorderBlueSlider:nil];
    [self setBorderGreenSlider:nil];
    [self setBorderRedSlider:nil];
    [self setFillBlueNumber:nil];
    [self setFillGreenNumber:nil];
    [self setFillRedNumber:nil];
    [self setFillBlueSlider:nil];
    [self setFillGreenSlider:nil];
    [self setFillRedSlider:nil];
    [self setAView:nil];
    [self setNumOfSides:nil];
    [self setPolygonStepperControl:nil];
    [super didReceiveMemoryWarning];
    
    
    
    // Dispose of any resources that can be recreated.
}

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
    UIColor *myBorderColor = [UIColor colorWithRed:[self.borderRedNumber.text floatValue]/256 green:[self.borderGreenNumber.text floatValue]/256 blue:[self.borderBlueNumber.text floatValue]/256 alpha:1];
    self.previewBorderColorView.backgroundColor = myBorderColor;
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
    self.myScrollView.hidden = NO;
}

- (IBAction)changeNumberOfSides:(UIStepper *)sender {
    double value = [sender value];
    [self.polygonModel setNumberOfSides:value];
    [self updateUI];
}

- (IBAction)increase:(id)sender {
    [self.polygonModel setNumberOfSides:self.polygonModel.numberOfSides + 1];
    [self updateUI];
}

- (IBAction)decrease:(id)sender {
    [self.polygonModel setNumberOfSides:self.polygonModel.numberOfSides - 1];
    [self updateUI];
}

//---handle rotate gesture---
-(IBAction) handleRotateGesture:(UIGestureRecognizer *) sender {
    CGFloat rotation = [(UIRotationGestureRecognizer *) sender rotation];
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotation + self.netRotation);
    sender.view.transform = transform;
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.netRotation += rotation;
    }
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
    
    polygonType = [[UILabel alloc] initWithFrame:CGRectMake(20, self.aView.bounds.size.height/2 - 40, self.aView.bounds.size.width-40, 30)];
    [polygonType setBackgroundColor:[UIColor clearColor]];
    polygonType.textAlignment = NSTextAlignmentCenter;
    [self.aView addSubview:polygonType];
    [self updateUI];
    
    
    [self.myScrollView setContentSize:CGSizeMake(320, 426)];
    CGFloat red, green, blue, alpha;
    [self.polygonModel.insideColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    self.fillRedNumber.text = [NSString stringWithFormat:@"%.0f",red*256];
    self.fillGreenNumber.text = [NSString stringWithFormat:@"%.0f",green*256];
    self.fillBlueNumber.text = [NSString stringWithFormat:@"%.0f",blue*256];
    self.fillRedSlider.value = red*256;
    self.fillGreenSlider.value = green*256;
    self.fillBlueSlider.value = blue*256;
    
    //[self updatePreviewColorView];
    
    CGFloat redBorder, greenBorder, blueBorder, alphaBorder;
    [self.polygonModel.borderColor getRed:&redBorder green:&greenBorder blue:&blueBorder alpha:&alphaBorder];
    
    self.borderRedNumber.text = [NSString stringWithFormat:@"%.0f",redBorder*256];
    self.borderGreenNumber.text = [NSString stringWithFormat:@"%.0f",greenBorder*256];
    self.borderBlueNumber.text = [NSString stringWithFormat:@"%.0f",blueBorder*256];
    self.borderRedSlider.value = redBorder*256;
    self.borderGreenSlider.value = greenBorder*256;
    self.borderBlueSlider.value = blueBorder*256;
    
    [self updatePreviewColorView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (void)updateUI
{
    self.title = [self.polygonModel name];
    polygonType.text = [self.polygonModel name];
    //self.numberOfSidesLabel.text = [self.polygonModel name];
    self.aView.numberOfSides = self.polygonModel.numberOfSides;
    self.aView.insideColor = self.polygonModel.insideColor;
    self.aView.borderColor = self.polygonModel.borderColor;
    self.polygonStepperControl.value = self.polygonModel.numberOfSides;
    self.numOfSides.text = [NSString stringWithFormat:@"%d",self.polygonModel.numberOfSides];
    [self.aView setNeedsDisplay];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d",self.polygonModel.numberOfSides] forKey:@"numberOfSides"];
    NSData *insideColorData = [NSKeyedArchiver archivedDataWithRootObject:self.polygonModel.insideColor];
    NSData *borderColorData = [NSKeyedArchiver archivedDataWithRootObject:self.polygonModel.borderColor];
    [defaults setObject:insideColorData forKey:@"insideColor"];
    [defaults setObject:borderColorData forKey:@"borderColor"];
    
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

- (IBAction)cancelColorChange:(UIButton *)sender {
    self.myScrollView.hidden = YES;
}

- (IBAction)saveColorChange:(UIButton *)sender {
    UIColor *myColor = [UIColor colorWithRed:[self.fillRedNumber.text floatValue]/256 green:[self.fillGreenNumber.text floatValue]/256 blue:[self.fillBlueNumber.text floatValue]/256 alpha:1];
    self.polygonModel.insideColor = myColor;
    UIColor *myBorderColor = [UIColor colorWithRed:[self.borderRedNumber.text floatValue]/256 green:[self.borderGreenNumber.text floatValue]/256 blue:[self.borderBlueNumber.text floatValue]/256 alpha:1];
    self.polygonModel.borderColor = myBorderColor;
    [self updateUI];
    self.myScrollView.hidden = YES;
}

- (IBAction)borderBlueColor:(UISlider *)sender {
    self.borderBlueNumber.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updatePreviewColorView];
}

- (IBAction)borderGreenColor:(UISlider *)sender {
    self.borderGreenNumber.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updatePreviewColorView];
}

- (IBAction)borderRedColor:(UISlider *)sender {
    self.borderRedNumber.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updatePreviewColorView];
}
@end

