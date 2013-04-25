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
#import "DOKMatchTabBarController.h"

@interface DOKGameWeekViewController () {
    NSNumber *gameWeek;
    NSNumber *showingGameWeek;
    NSString *myTeam;
    UINavigationItem *navigItem;
    UINavigationBar *naviBarObj;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *playMatchesButton;
@property (nonatomic) NSMutableArray *matches;
@property (nonatomic) NSMutableArray *leagueOneMatches;
@property (nonatomic) NSMutableArray *leagueTwoMatches;
@property (nonatomic) NSMutableArray *leagueThreeMatches;
@property (nonatomic) NSMutableArray *leagueFourMatches;
@property (nonatomic) NSMutableArray *teams;
@property (weak, nonatomic) IBOutlet UIButton *endSeasonButton;
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
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == 0 || orientation == UIInterfaceOrientationPortrait) {
        naviBarObj.frame = CGRectMake(0, 0, 320, 44);
    } else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        naviBarObj.frame = CGRectMake(0, 0, self.view.bounds.size.width, 32);
    }
    self.myTableView.frame =CGRectMake(0, naviBarObj.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - naviBarObj.bounds.size.height - 64);
    [self tableView:self.myTableView viewForHeaderInSection:0];
    [self.myTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:naviBarObj];
    naviBarObj.tintColor = [UIColor colorWithRed:21.0/255.0 green:112.0/255.0 blue:35.0/255.0 alpha:1.0];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    gameWeek = [self.defaults objectForKey:@"gameWeek"];
    showingGameWeek = gameWeek;
    
    navigItem = [[UINavigationItem alloc] initWithTitle:[NSString stringWithFormat:@"Gameweek %@",showingGameWeek]];
    naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
    
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
    self.leagueOneMatches = [NSMutableArray array];
    self.leagueTwoMatches = [NSMutableArray array];
    self.leagueThreeMatches = [NSMutableArray array];
    self.leagueFourMatches = [NSMutableArray array];
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
    navigItem.title = [NSString stringWithFormat:@"Gameweek %@",showingGameWeek];
    NSError *saveError;
    if (![[[DOKAppDelegate sharedAppDelegate] managedObjectContext] save:&saveError]) {
        NSLog(@"Saving changes to book book two failed: %@", saveError);
    }
    
    for (DOKMatch *thisMatch in self.matches) {
        switch ([thisMatch.league intValue]) {
            case 1:
                [self.leagueOneMatches addObject:thisMatch];
                break;
            case 2:
                [self.leagueTwoMatches addObject:thisMatch];
                break;
            case 3:
                [self.leagueThreeMatches addObject:thisMatch];
                break;
            case 4:
                [self.leagueFourMatches addObject:thisMatch];
                break;
            default:
                break;
        }
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
    switch (section) {
        case 0:
            return [self.leagueOneMatches count];
            break;
        case 1:
            return [self.leagueTwoMatches count];
            break;
        case 2:
            return [self.leagueThreeMatches count];
            break;
        case 3:
            return [self.leagueFourMatches count];
            break;
        default:
            break;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Game Week Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DOKMatch *currMatch;// = [self.matches objectAtIndex:indexPath.row];
    switch (indexPath.section) {
        case 0:
            currMatch = [self.leagueOneMatches objectAtIndex:indexPath.row];
            break;
        case 1:
            currMatch = [self.leagueTwoMatches objectAtIndex:indexPath.row];
            break;
        case 2:
            currMatch = [self.leagueThreeMatches objectAtIndex:indexPath.row];
            break;
        case 3:
            currMatch = [self.leagueFourMatches objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    ((UILabel *)[cell viewWithTag:1]).text = currMatch.homeTeam;
    ((UILabel *)[cell viewWithTag:2]).text = currMatch.awayTeam;
    ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%@",currMatch.homeGoals];
    ((UILabel *)[cell viewWithTag:4]).text = [NSString stringWithFormat:@"%@",currMatch.awayGoals];
    if ([currMatch.homeTeam isEqualToString:myTeam]) {
        ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:2]).textColor = [UIColor whiteColor];
    } else if ([currMatch.awayTeam isEqualToString:myTeam]) {
        ((UILabel *)[cell viewWithTag:2]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor whiteColor];
    } else {
        ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:2]).textColor = [UIColor whiteColor];
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
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.shadowColor = [UIColor darkGrayColor];
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    
    headerLabel.text = title;
    
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [prevButton addTarget:self
               action:@selector(previousGameWeek:)
     forControlEvents:UIControlEventTouchDown];
    [prevButton setBackgroundImage:[UIImage imageNamed:@"yellowarrowleft.png"] forState:UIControlStateNormal];
    [prevButton setBackgroundImage:[UIImage imageNamed:@"yellowarrowleft.png"] forState:UIControlStateHighlighted];
    prevButton.frame = CGRectMake(10, 5, 35, 35);
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton addTarget:self
                   action:@selector(nextGameWeek:)
         forControlEvents:UIControlEventTouchDown];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"yellowarrowright.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"yellowarrowright.png"] forState:UIControlStateHighlighted];
    nextButton.frame = CGRectMake(width - 45, 5, 35, 35);
    
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
    } else {
        self.endSeasonButton.hidden = NO;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"League 1"];
            break;
        case 1:
            return [NSString stringWithFormat:@"League 2"];
            break;
        case 2:
            return [NSString stringWithFormat:@"League 3"];
            break;
        case 3:
            return [NSString stringWithFormat:@"League 4"];
            break;
            
        default:
            break;
    }
    return [NSString stringWithFormat:@"Matches"];
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
    } else if ([[segue identifier] isEqualToString:@"PlayMatchesThroughTab"]) {
        DOKMatchTabBarController *detailViewController = [segue destinationViewController];
        
        detailViewController.exitMatchDelegate = self;
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
    
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(toInterfaceOrientation == 0 || toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        naviBarObj.frame = CGRectMake(0, 0, 320, 44);
    } else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        naviBarObj.frame = CGRectMake(0, 0, self.view.bounds.size.height+50, 32);
    }
    self.myTableView.frame =CGRectMake(0, naviBarObj.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - naviBarObj.bounds.size.height - 64);
    [self tableView:self.myTableView viewForHeaderInSection:0];
    [self.myTableView reloadData];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}



@end
