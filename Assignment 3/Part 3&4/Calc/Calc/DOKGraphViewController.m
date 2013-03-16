//
//  DOKGraphViewController.m
//  GraphCalc
//
//  Created by Diarmuid O'Keeffe on 11/03/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKGraphViewController.h"
#import "GraphView.h"
#import "DOKCalcModel.h"


#define MAX_SCALE = 5.0;
#define MIN_SCALE = 1.0;

@interface DOKGraphViewController ()
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
- (IBAction)zoomIn:(UIButton *)sender;
- (IBAction)zoomOut:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureOutlet;
@property (nonatomic) double previousScale;
- (IBAction)panGestureAction:(UIPanGestureRecognizer *)gesture;
- (IBAction)pinchGestureAction:(UIPinchGestureRecognizer *)gesture;
- (IBAction)doubleTapGestureAction:(UITapGestureRecognizer *)gesture;

@end

@implementation DOKGraphViewController

@synthesize scale = _scale;
@synthesize previousScale = _previousScale;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;
//@synthesize view = _view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if(_splitViewBarButtonItem != splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myOrigin = [userDefaults objectForKey:@"origin"];
    
    if (myOrigin)
        self.origin = CGPointFromString(myOrigin);
    
    if ([userDefaults doubleForKey:@"scale"])
        self.scale = [userDefaults doubleForKey:@"scale"];
    
    GraphView *myView = (GraphView *)self.view;
    myView.delegate = self;
    if (!self.scale) {
        self.scale = 1;
    }
//    if (_origin.x == 0.0 && _origin.y == 0.0) {
//        self.origin = CGPointMake(CGRectGetMidX(myView.bounds),CGRectGetMidY(myView.bounds));
//    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)zoomIn:(UIButton *)sender {
    if (self.scale < 5) {
        self.scale += 1;
        [self.view setNeedsDisplay];
    }
    
}

- (IBAction)zoomOut:(UIButton *)sender {
    if (self.scale > 1) {
        self.scale -= 1;
        [self.view setNeedsDisplay];
    }
    
}

- (BOOL)shouldAutorotate
{
    [self.view setNeedsDisplay];
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGPoint nilPoint = CGPointMake(0.0, 0.0);
    [self setOrigin:nilPoint];
    [self.view setNeedsDisplay];
    
}

- (IBAction)panGestureAction:(UIPanGestureRecognizer *)gesture {
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateRecognized)) {
        CGPoint translation = [gesture translationInView:self.view];
        [gesture setTranslation:CGPointZero inView:self.view];
        [self setNewOrigin:translation];

    }
}

- (IBAction)pinchGestureAction:(UIPinchGestureRecognizer *)gesture {
    if (self.scale == 0.0) {
        self.scale = self.previousScale = 1.0;
    } else {
        self.scale = self.previousScale;
    }
    double currScale = [gesture scale]*self.scale;
    
    if (currScale >= 1.0 &&  currScale <= 5.0) {
        self.scale = currScale;
        [self.view setNeedsDisplay];
        self.previousScale = currScale;
    }
    
}

- (IBAction)doubleTapGestureAction:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        CGPoint nilPoint = CGPointMake(0.0, 0.0);
        [self setOrigin:nilPoint];
        [self.view setNeedsDisplay];
    }
}

- (void)setNewOrigin:(CGPoint)translation
{
    
    CGPoint originalPoint = self.origin;//[(GraphView *)self.view origin];
    CGPoint newPoint = CGPointMake(originalPoint.x+translation.x, originalPoint.y+translation.y);
    [self setOrigin:newPoint];
    [self.view setNeedsDisplay];
}

-(CGPoint)startPoint {
    
    NSArray *objects = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f", - self.origin.x/self.scale], nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"x", nil];
    NSDictionary *myDictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    double ans1 = [DOKCalcModel evaluateExpression:self.expression usingVariableValues:myDictionary];
    CGPoint lineOrigin = CGPointMake(0.0,-ans1*self.scale+self.origin.y);
    return lineOrigin;
}
-(CGPoint)endPoint {
    NSArray *objects = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f", (-self.origin.x + self.view.bounds.size.width)/self.scale], nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"x", nil];
    NSDictionary *myDictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    double ans2 = [DOKCalcModel evaluateExpression:self.expression usingVariableValues:myDictionary];
    CGPoint lineEnd = CGPointMake(self.view.bounds.size.width - 0.0,-ans2*self.scale+self.origin.y);
    return lineEnd;
}

- (double) getScale {
    return self.scale;
}
- (CGPoint) getOrigin:(CGRect)rect {
    if (_origin.x == 0.0 && _origin.y == 0.0) {
        self.origin = CGPointMake(CGRectGetMidX(rect),CGRectGetMidY(rect));
    }
    return self.origin;
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myOrigin = NSStringFromCGPoint(self.origin);
    [userDefaults setObject:myOrigin forKey:@"origin"];
    [userDefaults setDouble:self.scale forKey:@"scale"];
    [userDefaults synchronize];
    NSLog(@"Data saved");
    
}

@end
