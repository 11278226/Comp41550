//
//  DOKViewController.m
//  Calc
//
//  Created by Diarmuid O'Keeffe on 26/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GraphView.h"
#import "DOKGraphViewController.h"
#import "SplitViewBarButtonItemPresenter.h"


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
- (IBAction)setAndShowGraph:(UIButton *)sender;

@end

@implementation DOKViewController

@synthesize propertyList = _propertyList;
@synthesize calcModel = _calcModel;
@synthesize calcDisplay = _calcDisplay;
@synthesize isInTheMiddleOfTypingSomething = _isInTheMiddleOfTypingSomething;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (DOKGraphViewController *)splitViewPolygonViewController {
    id pvc = [self.splitViewController.viewControllers lastObject];
    if(![pvc isKindOfClass:[DOKGraphViewController class]]) pvc =  nil;
    return pvc;
}

- (IBAction)setAndShowGraph:(UIButton *)sender {
    DOKGraphViewController *polygonVC = [self splitViewPolygonViewController];
    if(polygonVC) {
        GraphView *graphView = (GraphView *)polygonVC.view;
        polygonVC.expression = (NSMutableArray *)self.calcModel.expression;
        
        [graphView setNeedsDisplay];
    }
}

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
//    NSLog(@"%@",[DOKCalcModel descriptionOfExpression:[self.calcModel expressionForPropertyList:self.propertyList]]);
    
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
            NSArray *keys = [[NSArray alloc] initWithObjects:@"a",@"b",@"x", nil];
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
    UIAlertView *variableValuesAlertView = [[UIAlertView alloc] initWithTitle:@"Variables" message:@"\n  \n  \n " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    UILabel *aLabelField = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 45.0, 100.0, 25.0)];
    aLabelField.text= [NSString stringWithFormat:@"a:"];
    aLabelField.backgroundColor = [UIColor clearColor];
    aLabelField.textColor = [UIColor whiteColor];
    [variableValuesAlertView addSubview:aLabelField];
    
    UITextField *aTextField = [[UITextField alloc] initWithFrame:CGRectMake(125.0, 45.0, 140.0, 25.0)];
    if (self.calcModel.a != 0) {
        aTextField.text= [NSString stringWithFormat:@"%.2f", self.calcModel.a];
    }
    aTextField.backgroundColor = [UIColor whiteColor];
    aTextField.tag = 100;
    [variableValuesAlertView addSubview:aTextField];
    
    
    UILabel *bLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 75.0, 145.0, 25.0)];
    
    bLabel.text=[NSString stringWithFormat:@"b:"];
    bLabel.backgroundColor = [UIColor clearColor];
    bLabel.textColor = [UIColor whiteColor];
    [variableValuesAlertView addSubview:bLabel];

    UITextField *bTextField = [[UITextField alloc] initWithFrame:CGRectMake(125.0, 75.0, 140.0, 25.0)];
    if (self.calcModel.a != 0) {
        bTextField.text= [NSString stringWithFormat:@"%.2f", self.calcModel.b];
    }
    bTextField.backgroundColor = [UIColor whiteColor];
    bTextField.tag = 200;
    [variableValuesAlertView addSubview:bTextField];
    
    UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 105.0, 145.0, 25.0)];
    xLabel.text=[NSString stringWithFormat:@"c:"];
    xLabel.backgroundColor = [UIColor clearColor];
    xLabel.textColor = [UIColor whiteColor];
    [variableValuesAlertView addSubview:xLabel];
    
    UITextField *xTextField = [[UITextField alloc] initWithFrame:CGRectMake(125.0, 105.0, 140.0, 25.0)];
    if (self.calcModel.a != 0) {
        xTextField.text= [NSString stringWithFormat:@"%.2f", self.calcModel.x];
    }
    xTextField.backgroundColor = [UIColor whiteColor];
    xTextField.tag = 300;
    [variableValuesAlertView addSubview:xTextField];

    
    [variableValuesAlertView show];
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

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"makeGraph"]) {
        
        // Get destination view
        DOKGraphViewController *vc = [segue destinationViewController];
        [vc setExpression:self.calcModel.expression];
    }
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Variables"]) {
        UITextField *aTextField = (UITextField*)[alertView viewWithTag:100];
        UITextField *bTextField = (UITextField*)[alertView viewWithTag:200];
        UITextField *xTextField = (UITextField*)[alertView viewWithTag:300];
        [self.calcModel setVariableAsOperand:@"a" value:aTextField.text];
        [self.calcModel setVariableAsOperand:@"b" value:bTextField.text];
        [self.calcModel setVariableAsOperand:@"x" value:xTextField.text];
    }
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if(![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) detailVC = nil;
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    
    return [self splitViewBarButtonPresenter]?UIInterfaceOrientationIsPortrait(orientation):NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // tell the detail view to take button away
    [self splitViewBarButtonPresenter].splitViewBarButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    DOKGraphViewController *detailVC = [self.splitViewController.viewControllers lastObject];
    [detailVC.view setNeedsDisplay];
    return YES;
}



@end
