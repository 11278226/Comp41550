//
//  DOKGameWeekViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 09/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKGameWeekViewController.h"
#import "DOKAppDelegate.h"
#import "DOKMatchModel.h"
#import "DOKMatch.h"
#import <QuartzCore/QuartzCore.h>

@interface DOKGameWeekViewController () {
    NSNumber *gameWeek;
    NSNumber *showingGameWeek;
    NSString *myTeam;
    
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *playMatchesButton;
@property (nonatomic) NSMutableArray *matches;
@property (nonatomic) NSMutableArray *teams;
@property (nonatomic, retain) NSUserDefaults *defaults;
@end

@implementation DOKGameWeekViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self tableView:self.myTableView viewForHeaderInSection:0];
    [self.myTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    gameWeek = [self.defaults objectForKey:@"gameWeek"];
    showingGameWeek = gameWeek;
    [self reloadAll];
}

- (void)checkGameweek
{
    if ([showingGameWeek intValue] != [gameWeek intValue]) {//[showingGameWeek intValue] != [gameWeek intValue]) {
        self.playMatchesButton.hidden = YES;
    } else {
        self.playMatchesButton.hidden = NO;
    }
}

- (void)reloadAll
{
    self.matches = [NSMutableArray array];
    self.teams = [NSMutableArray array];
    
    
    myTeam = [self.defaults objectForKey:@"teamName"];
    NSFetchRequest *teamRequest = [NSFetchRequest fetchRequestWithEntityName:@"Teams"];
    NSError *error = nil;
    self.teams = [[[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:teamRequest error:&error] mutableCopy];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
    request.predicate = [NSPredicate predicateWithFormat:@"gameWeek = %d",[showingGameWeek intValue]];
    self.matches = [[[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    if ([self.matches count] == 0) {
        self.playMatchesButton.hidden = YES;
        showingGameWeek = [NSNumber numberWithInt:([showingGameWeek intValue] - 1)];
        request.predicate = [NSPredicate predicateWithFormat:@"gameWeek = %d",[showingGameWeek intValue]];
        self.matches = [[[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    }
    [self checkGameweek];
    NSError *saveError;
    if (![[[DOKAppDelegate sharedAppDelegate] managedObjectContext] save:&saveError]) {
        NSLog(@"Saving changes to book book two failed: %@", saveError);
    }
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matches count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Game Week Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DOKMatch *currMatch = [self.matches objectAtIndex:indexPath.row];
//    NSLog(@"%@",currMatch.homeTeam)
    
    ((UILabel *)[cell viewWithTag:1]).text = currMatch.homeTeam;
    ((UILabel *)[cell viewWithTag:2]).text = currMatch.awayTeam;
    ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%@",currMatch.homeGoals];
    ((UILabel *)[cell viewWithTag:4]).text = [NSString stringWithFormat:@"%@",currMatch.awayGoals];
    if ([currMatch.homeTeam isEqualToString:myTeam]) {
        ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor blueColor];
        ((UILabel *)[cell viewWithTag:2]).textColor = [UIColor darkTextColor];
    } else if ([currMatch.awayTeam isEqualToString:myTeam]) {
        ((UILabel *)[cell viewWithTag:2]).textColor = [UIColor blueColor];
        ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor darkTextColor];
    } else {
        ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor darkTextColor];
        ((UILabel *)[cell viewWithTag:2]).textColor = [UIColor darkTextColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGFloat width = CGRectGetWidth(tableView.bounds);
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,height)];
    container.layer.borderColor = [UIColor grayColor].CGColor;
    container.layer.borderWidth = 1.0f;
    CAGradientLayer *gradient = [self greyGradient];
    gradient.frame = container.bounds;
    [container.layer addSublayer:gradient];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/6,0,width*4/6,height)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font= [UIFont boldSystemFontOfSize:19.0f];
    headerLabel.shadowOffset = CGSizeMake(1, 1);
    headerLabel.textColor = [UIColor lightTextColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.shadowColor = [UIColor darkGrayColor];
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    headerLabel.text = title;
    
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [prevButton addTarget:self
               action:@selector(previousGameWeek:)
     forControlEvents:UIControlEventTouchDown];
    [prevButton setBackgroundImage:[UIImage imageNamed:@"nav-primary-arrow-left.jpg"] forState:UIControlStateNormal];
    [prevButton setBackgroundImage:[UIImage imageNamed:@"nav-primary-arrow-left.jpg"] forState:UIControlStateHighlighted];
    prevButton.frame = CGRectMake(10, 2, 26, 26);
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton addTarget:self
                   action:@selector(nextGameWeek:)
         forControlEvents:UIControlEventTouchDown];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"nav-primary-arrow-right.jpg"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"nav-primary-arrow-right.jpg"] forState:UIControlStateHighlighted];
    nextButton.frame = CGRectMake(width - 36, 2, 26, 26);
    
    [container addSubview:headerLabel];
    [container addSubview:prevButton];
    [container addSubview:nextButton];
    
    return container;
}

-(void)previousGameWeek:(id)sender
{
    if (!([showingGameWeek intValue] == 1)) {
        showingGameWeek = [NSNumber numberWithInt:([showingGameWeek intValue] - 1)];
        [self reloadAll];
    }
}

-(void)nextGameWeek:(id)sender
{
    int *nextWeekCheck = [showingGameWeek intValue] + 1;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
    request.predicate = [NSPredicate predicateWithFormat:@"gameWeek = %d",nextWeekCheck];
    NSError *error = nil;
    self.matches = [[[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    if (!([self.matches count] == 0)) {
        showingGameWeek = [NSNumber numberWithInt:([showingGameWeek intValue] + 1)];
        [self reloadAll];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Gameweek %d",[showingGameWeek intValue]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"Play Matches"]) {
            DOKMatchViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.myDelegate = self;
        detailViewController.matches = [NSMutableArray array];
        detailViewController.teams = [NSMutableArray array];
        detailViewController.teams = self.teams;
        detailViewController.matches = self.matches;
    }
}

- (void)secondViewControllerDismissed;
{
    [self.defaults setObject:[NSNumber numberWithInt:([gameWeek intValue] + 1)] forKey:@"gameWeek"];
    gameWeek = [NSNumber numberWithInt:([gameWeek intValue] + 1)];
    [self.defaults synchronize];
    [self reloadAll];
}

- (void)secondViewControllerDismissedWithoutPlaying
{
    [self reloadAll];
}

- (CAGradientLayer *) greyGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    
    UIColor *color1 = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5];
    UIColor *color2 = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:0.5];
    
    [gradient setColors:[NSArray arrayWithObjects:(id)color1.CGColor, (id)color2.CGColor, nil]];
    return gradient;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.myTableView reloadData];
}

@end
