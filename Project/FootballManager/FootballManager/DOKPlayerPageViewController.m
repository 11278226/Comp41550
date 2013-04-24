//
//  DOKMatchPageViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 14/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKPlayerPageViewController.h"
#import "DOKPlayerDetailViewController.h"

@interface DOKPlayerPageViewController ()

@property (nonatomic, retain) UIPageViewController *myPageViewController;
@property (nonatomic, retain) UIPageControl *pageControl;
@property NSInteger currentIndex;

@end

@implementation DOKPlayerPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.pageControl removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.pageControl.frame = CGRectMake(0, self.parentViewController.view.bounds.size.height - 30, self.parentViewController.view.bounds.size.width, 30);
    [self.parentViewController.view addSubview:self.pageControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageControl.numberOfPages = [self.playerArray count];
    self.pageControl = [[UIPageControl alloc] init];
    
    self.pageControl.frame = CGRectMake(0, self.parentViewController.view.bounds.size.height - 30, self.parentViewController.view.bounds.size.width, 30);
    
    self.currentIndex = [self.playerArray indexOfObject:self.player];
    
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.pageIndicatorTintColor = [UIColor greenColor];
    [self.pageControl setNumberOfPages:[self.playerArray count]];
    [self.parentViewController.view addSubview:self.pageControl];
    
    self.myPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{ UIPageViewControllerOptionInterPageSpacingKey : @20.f }];
    self.view.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:112.0/255.0 blue:35.0/255.0 alpha:1.0];
    
    [self setupPageViewController];
}

- (void)setupPageViewController;
{
    
    
    //Step 2:
    //Assign the delegate and datasource as self.
    self.myPageViewController.delegate = self;
    self.myPageViewController.dataSource = self;
    
    
    //Step 3:
    //Set the initial view controllers.
    DOKPlayerDetailViewController *contentViewController = [[DOKPlayerDetailViewController alloc] init];
    
    contentViewController.player = self.player;
    NSArray *viewControllers = [NSArray arrayWithObject:contentViewController];
    [self.myPageViewController setViewControllers:viewControllers
                                        direction:UIPageViewControllerNavigationDirectionForward
                                         animated:NO
                                       completion:nil];
    contentViewController = nil;
    //Step 4:
    //ViewController containment steps
    //Add the pageViewController as the childViewController
    [self addChildViewController:self.myPageViewController];
    
    //Add the view of the pageViewController to the current view
    [self.view addSubview:self.myPageViewController.view];
    
    //Call didMoveToParentViewController: of the childViewController, the UIPageViewController instance in our case.
    [self.myPageViewController didMoveToParentViewController:self];
    
    //Step 5:
    // set the pageViewController's frame as an inset rect.
    CGRect pageViewRect = self.view.bounds;
    pageViewRect = CGRectInset(pageViewRect, 0.0, 0.0);
    self.myPageViewController.view.frame = pageViewRect;
    
    //Step 6:
    //Assign the gestureRecognizers property of our pageViewController to our view's gestureRecognizers property.
    self.view.gestureRecognizers = self.myPageViewController.gestureRecognizers;
    self.pageControl.currentPage = self.currentIndex;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.currentIndex = [self.playerArray indexOfObject:[(DOKPlayerDetailViewController *)viewController player]];
    if(self.currentIndex == 0)
    {
        return nil;
    }
    DOKPlayerDetailViewController *contentViewController = [[DOKPlayerDetailViewController alloc] init];
    contentViewController.player = [self.playerArray objectAtIndex:self.currentIndex - 1];
    return contentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    self.currentIndex = [self.playerArray indexOfObject:[(DOKPlayerDetailViewController *)viewController player]];
    if(self.currentIndex == [self.playerArray count]-1)
    {
        return nil;
    }
    DOKPlayerDetailViewController *contentViewController = [[DOKPlayerDetailViewController alloc] init];
    contentViewController.player = [self.playerArray objectAtIndex:self.currentIndex + 1];
    return contentViewController;
}

#pragma mark - UIPageViewControllerDelegate Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    //Set the array with only 1 view controller
    UIViewController *currentViewController = [self.myPageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [self.myPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    //Important- Set the doubleSided property to NO.
    self.myPageViewController.doubleSided = NO;
    //Return the spine location
    return UIPageViewControllerSpineLocationMin;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed){
        for (int i = 0; i < [self.playerArray count]; i++) {
            DOKPlayerModel *myContent = [self.playerArray objectAtIndex:i];
            if([myContent isEqual:[(DOKPlayerDetailViewController *)[pageViewController.viewControllers objectAtIndex:0] player]])
            {
                self.pageControl.currentPage = i;
            }
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.pageControl removeFromSuperview];
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.pageControl.frame = CGRectMake(0, self.parentViewController.view.bounds.size.width-80, self.parentViewController.view.bounds.size.height+70, 30);
    } else {
        self.pageControl.frame = CGRectMake(0, self.parentViewController.view.bounds.size.width-80, self.parentViewController.view.bounds.size.height+70, 30);
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.parentViewController.view addSubview:self.pageControl];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
