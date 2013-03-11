//
//  DOKViewController.m
//  Calc
//
//  Created by Diarmuid O'Keeffe on 26/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DOKViewController ()
@property (weak, nonatomic) IBOutlet UILabel *borderLabel;
@property (nonatomic) id propertyList;
- (IBAction)setVariableAsOperand:(UIButton *)sender;
- (IBAction)evaluateExpressionUsingVariableValues:(UIButton *)sender;
- (IBAction)setVariableValues:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *variablesView;
@property (weak, nonatomic) IBOutlet UITextField *variableX;
@property (weak, nonatomic) IBOutlet UITextField *variableA;
@property (weak, nonatomic) IBOutlet UITextField *variableB;
- (IBAction)saveVariableValues:(UIButton *)sender;
- (IBAction)showExpression:(UIButton *)sender;
- (IBAction)storeExpression:(UIButton *)sender;

@end

@implementation DOKViewController

@synthesize propertyList = _propertyList;
@synthesize calcModel = _calcModel;
@synthesize calcDisplay = _calcDisplay;
@synthesize isInTheMiddleOfTypingSomething = _isInTheMiddleOfTypingSomething;

- (IBAction)piPressed:(UIButton *)sender
{
    [self.calcDisplay setText:[NSString stringWithFormat:@"%f", M_PI]];
    self.calcModel.operand = [self.calcDisplay.text doubleValue];
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    
    if(self.isInTheMiddleOfTypingSomething) {
        NSRange range = [self.calcDisplay.text rangeOfString:@"."];
        if(!([digit isEqualToString:@"."] && range.length > 0))
            self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
            [self.calcModel digitPressed:self.calcDisplay.text inMiddleOfDigit:self.isInTheMiddleOfTypingSomething];
        }
    else {
        [self.calcDisplay setText:digit];
        [self.calcModel digitPressed:self.calcDisplay.text inMiddleOfDigit:self.isInTheMiddleOfTypingSomething];
        self.isInTheMiddleOfTypingSomething = YES;
    }
}
- (IBAction)operationPressed:(UIButton *)sender
{
    if(self.isInTheMiddleOfTypingSomething) {
        self.calcModel.operand = [self.calcDisplay.text doubleValue];
        self.isInTheMiddleOfTypingSomething = NO;
    }
    NSString *operation = [[sender titleLabel] text];
    if ([operation isEqualToString:@"="] && self.calcModel.operand == 0 && [self.calcModel.waitingOperation isEqualToString:@"/"]) {
        [self.calcDisplay setText:@"ERR DIV 0"];
    } else if ([operation isEqualToString:@"sqrt"] && self.calcModel.operand < 0) {
        [self.calcDisplay setText:@"ERR SQRT NEG"];
    } else {
        double result = [[self calcModel] performOperation:operation];
        [self.calcDisplay setText:[NSString stringWithFormat:@"%g", result]];
        if (![operation isEqualToString:@"C"]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.calcModel.expression];
            [array addObject:operation];
            //self.propertyList = [self.calcModel propertyListForExpression:array];
        }
    }
    NSLog(@"%@",[DOKCalcModel descriptionOfExpression:[self.calcModel expressionForPropertyList:self.propertyList]]);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *expressionPlistDirectory = [documentsDirectory stringByAppendingPathComponent:@"expression"];
    [self setPropertyList:(id)expressionPlistDirectory];
    self.borderLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.borderLabel.layer.borderWidth = 2.0;
    self.borderLabel.layer.cornerRadius = 10.0;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.variableA resignFirstResponder];
    [self.variableB resignFirstResponder];
    [self.variableX resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setVariableAsOperand:(UIButton *)sender {
    [self.calcModel setVariableAsOperand:sender.titleLabel.text];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.calcModel.expression];
    [array addObject:sender.titleLabel.text];
    //self.propertyList = [self.calcModel propertyListForExpression:array];
}

- (IBAction)evaluateExpressionUsingVariableValues:(UIButton *)sender {
    if ([sender tag] == 1) {
        if (self.calcModel.variableValues != nil) {
            self.calcModel.operand = [DOKCalcModel evaluateExpression:self.calcModel.expression usingVariableValues:self.calcModel.variableValues];
            [self.calcDisplay setText:[NSString stringWithFormat:@"%f", self.calcModel.operand]];
        } else {
            NSArray *objects = [[NSArray alloc] initWithObjects:@"2",@"4",@"6", nil];
            NSArray *keys = [[NSArray alloc] initWithObjects:@"x",@"a",@"b", nil];
            NSDictionary *myDictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            self.calcModel.operand = [DOKCalcModel evaluateExpression:self.calcModel.expression usingVariableValues:myDictionary];
            [self.calcDisplay setText:[NSString stringWithFormat:@"%f", self.calcModel.operand]];
        }
    } else {
        if (self.calcModel.variableValues != nil) {
            self.calcModel.operand = [DOKCalcModel evaluateExpression:[self.calcModel expressionForPropertyList:self.propertyList] usingVariableValues:self.calcModel.variableValues];
            [self.calcDisplay setText:[NSString stringWithFormat:@"%f", self.calcModel.operand]];
        } else {
            NSArray *objects = [[NSArray alloc] initWithObjects:@"2",@"4",@"6", nil];
            NSArray *keys = [[NSArray alloc] initWithObjects:@"a",@"b",@"x", nil];
            NSDictionary *myDictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            self.calcModel.operand = [DOKCalcModel evaluateExpression:[self.calcModel expressionForPropertyList:self.propertyList] usingVariableValues:myDictionary];
            [self.calcDisplay setText:[NSString stringWithFormat:@"%f", self.calcModel.operand]];
        }
    }
    
}

- (IBAction)setVariableValues:(UIButton *)sender {
    self.variablesView.hidden = NO;
}

- (IBAction)saveVariableValues:(UIButton *)sender {
    [self.calcModel setVariableAsOperand:@"a" value:self.variableA.text];
    [self.calcModel setVariableAsOperand:@"b" value:self.variableB.text];
    [self.calcModel setVariableAsOperand:@"x" value:self.variableX.text];
    [self.variableA resignFirstResponder];
    [self.variableB resignFirstResponder];
    [self.variableX resignFirstResponder];
    self.variablesView.hidden = YES;
}

- (IBAction)showExpression:(UIButton *)sender {
//    NSString *expressionString = [NSString stringWithFormat:@"Local: %@ ... Stored: %@", [DOKCalcModel descriptionOfExpression:self.calcModel.expression], [DOKCalcModel descriptionOfExpression:[self.calcModel expressionForPropertyList:self.propertyList]]];
    UIAlertView *expressionAlertView = [[UIAlertView alloc] initWithTitle:@"Expressions" message:@"\n  \n  \n " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    UILabel *userNameTextField = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    userNameTextField.text= [NSString stringWithFormat:@"Local: %@",[DOKCalcModel descriptionOfExpression:self.calcModel.expression] ];
    userNameTextField.backgroundColor = [UIColor clearColor];
    userNameTextField.textColor = [UIColor whiteColor];
    [expressionAlertView addSubview:userNameTextField];
    
    
    UILabel *passwordTextField = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 75.0, 245.0, 25.0)];
    passwordTextField.text=[NSString stringWithFormat:@"Stored: %@",[DOKCalcModel descriptionOfExpression:[self.calcModel expressionForPropertyList:self.propertyList]]];
    passwordTextField.backgroundColor = [UIColor clearColor];
    passwordTextField.textColor = [UIColor whiteColor];
    [expressionAlertView addSubview:passwordTextField];
//    expressionAlertView.frame= CGRectMake(5, 100, 320, 300);
    
    [expressionAlertView show];
    
}

- (IBAction)storeExpression:(UIButton *)sender {
    self.propertyList = [self.calcModel propertyListForExpression:self.calcModel.expression];
}
@end
