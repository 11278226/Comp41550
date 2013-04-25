//
//  DOKMatchViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 07/02/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKMatchViewController.h"
#import "DOKTeamModel.h"
#import "DOKPlayerModel.h"
#import "DOKAppDelegate.h"
#import "DOKMatchModel.h"
#import "DOKMatch.h"
#import "DOKPlayer.h"
#import "Flurry.h"
#include <stdlib.h>


@interface DOKMatchViewController () {
}
@property (weak, nonatomic) IBOutlet UILabel *awayTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScore;
@property (weak, nonatomic) IBOutlet UILabel *awayScore;
@property (nonatomic, strong) NSString *myTeamName;
@property (nonatomic) int *pausedGamePlays;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property  BOOL matchesFinished;
@property  BOOL instantMatches;
@property  BOOL isNotFirstTimeViewLoaded;
@property  BOOL *pauseGame;
@property (strong, nonatomic) DOKMatch *savedMatch;
@property (strong, nonatomic) NSMutableArray *savedMatchDetails;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *possessionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *possessionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *homePossessionView;
@property (weak, nonatomic) IBOutlet UILabel *awayPossessionLabel;
@property (weak, nonatomic) IBOutlet UILabel *defTerritory;
@property (weak, nonatomic) IBOutlet UILabel *midTerritory;
@property (weak, nonatomic) IBOutlet UILabel *fwdTerritory;
@property (weak, nonatomic) IBOutlet UILabel *homeShotsLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayShotsLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTacklesLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayTacklesLabel;
@property (weak, nonatomic) IBOutlet UILabel *homePassesLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayPassesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *territoryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avgTerritoryView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) NSMutableArray *goalsAndAssists;
@property (strong, nonatomic) NSMutableArray *allGoalscorers;
@property (strong, nonatomic) NSMutableArray *allAssists;
- (IBAction)closeButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;



- (IBAction)playMatch:(UIButton *)sender;

@end

@implementation DOKMatchViewController

@synthesize myDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.playButton setTitle:@"Play" forState:UIControlStateHighlighted];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.myTeamName = [defaults objectForKey:@"teamName"];
    self.goalsAndAssists = [NSMutableArray array];
    
    self.allAssists = [NSMutableArray array];
    self.allGoalscorers = [NSMutableArray array];
    
    self.possessionImageView.backgroundColor = [UIColor redColor];
    self.homePossessionView.backgroundColor = [UIColor blueColor];
    
    [self.possessionImageView addSubview:self.homePossessionView];
    self.homePossessionView.frame = CGRectMake(0, 0, self.possessionImageView.bounds.size.width/2, self.possessionImageView.bounds.size.height);
    
    [self.territoryImageView addSubview:self.avgTerritoryView];
    self.avgTerritoryView.frame = CGRectMake(0, 0, self.territoryImageView.bounds.size.width/2, self.territoryImageView.bounds.size.height);
    
    self.instantMatches = [defaults boolForKey:@"Instant Matches"];
    self.savedMatchDetails = [NSMutableArray array];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.isNotFirstTimeViewLoaded) {
        DOKMatch *myMatch = [[DOKMatch alloc] init];
        for (DOKMatch *thisMatch in self.matches) {
            if ([self.myTeamName isEqualToString:thisMatch.homeTeam] || [self.myTeamName isEqualToString:thisMatch.awayTeam]) {
                myMatch = thisMatch;
            }
            else {
                
            }
        }
        
        self.navBar.topItem.title = [NSString stringWithFormat:@"%@ vs %@",myMatch.homeTeam,myMatch.awayTeam];
        self.homeTeamLabel.text = myMatch.homeTeam;
        self.awayTeamLabel.text = myMatch.awayTeam;
        self.isNotFirstTimeViewLoaded = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)setupGameForMatch:(DOKMatch *)currMatch {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Players"];
    request.predicate = [NSPredicate predicateWithFormat:@"teamName = %@",currMatch.homeTeam];
    
    NSError *error = nil;
    
    NSMutableArray *homeTeam = [[[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    request.predicate = [NSPredicate predicateWithFormat:@"teamName = %@",currMatch.awayTeam];
    NSMutableArray *awayTeam = [[[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    NSMutableArray *filteredHomeTeam = [NSMutableArray array];
    NSMutableArray *filteredAwayTeam = [NSMutableArray array];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *myTeam = [defaults objectForKey:@"myTeam"];
    if ([currMatch.homeTeam isEqualToString:self.myTeamName]) {
        NSMutableArray *myTeamArray = [NSMutableArray array];
        NSString *keeper = [myTeam objectForKey:@"playerOne"];
        [myTeamArray addObject:keeper];
        NSString *defenceOne = [myTeam objectForKey:@"playerTwo"];
        [myTeamArray addObject:defenceOne];
        NSString *defenceTwo = [myTeam objectForKey:@"playerThree"];
        [myTeamArray addObject:defenceTwo];
        NSString *wingOne = [myTeam objectForKey:@"playerFour"];
        [myTeamArray addObject:wingOne];
        NSString *mid = [myTeam objectForKey:@"playerFive"];
        [myTeamArray addObject:mid];
        NSString *wingTwo = [myTeam objectForKey:@"playerSix"];
        [myTeamArray addObject:wingTwo];
        NSString *striker = [myTeam objectForKey:@"playerSeven"];
        [myTeamArray addObject:striker];
        
        for (NSString *playerName in myTeamArray) {
            //        NSString *playerName = [myTeam objectForKey:playerPos];
            for (DOKPlayer *player in homeTeam) {
                if ([player.name isEqualToString:playerName]) {
                    [filteredHomeTeam addObject:player];
                }
            }
        }
    } else if ([currMatch.awayTeam isEqualToString:self.myTeamName]) {
        NSMutableArray *myTeamArray = [NSMutableArray array];
        NSString *keeper = [myTeam objectForKey:@"playerOne"];
        [myTeamArray addObject:keeper];
        NSString *defenceOne = [myTeam objectForKey:@"playerTwo"];
        [myTeamArray addObject:defenceOne];
        NSString *defenceTwo = [myTeam objectForKey:@"playerThree"];
        [myTeamArray addObject:defenceTwo];
        NSString *wingOne = [myTeam objectForKey:@"playerFour"];
        [myTeamArray addObject:wingOne];
        NSString *mid = [myTeam objectForKey:@"playerFive"];
        [myTeamArray addObject:mid];
        NSString *wingTwo = [myTeam objectForKey:@"playerSix"];
        [myTeamArray addObject:wingTwo];
        NSString *striker = [myTeam objectForKey:@"playerSeven"];
        [myTeamArray addObject:striker];
        
        for (NSString *playerName in myTeamArray) {
            //        NSString *playerName = [myTeam objectForKey:playerPos];
            for (DOKPlayer *player in awayTeam) {
                if ([player.name isEqualToString:playerName]) {
                    [filteredAwayTeam addObject:player];
                }
            }
        }
    }
    
    NSMutableDictionary *myHomeDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *myAwayDictionary = [[NSMutableDictionary
                                              alloc] init];
    for (int j = 0; j<7; j++) {
        DOKPlayer *myPlayer;
        DOKPlayer *awayPlayer;
        if ([currMatch.homeTeam isEqualToString:self.myTeamName]) {
            myPlayer = [filteredHomeTeam objectAtIndex:j];
            awayPlayer = [awayTeam objectAtIndex:j];
        } else if ([currMatch.awayTeam isEqualToString:self.myTeamName]) {
            myPlayer = [homeTeam objectAtIndex:j];
            awayPlayer = [filteredAwayTeam objectAtIndex:j];
        } else {
            myPlayer = [homeTeam objectAtIndex:j];
            awayPlayer = [awayTeam objectAtIndex:j];
        }
        NSString *thisTeamFormation;
        if ([self.myTeamName isEqualToString:currMatch.homeTeam]) {
            thisTeamFormation = [[NSUserDefaults standardUserDefaults] valueForKey:@"Formation"];
        } else {
            thisTeamFormation = @"2-3-1";
        }
        switch (j) {
            case 0:
                [myHomeDictionary setValue:myPlayer.goalkeeping forKey:@"goalie"];
                [myHomeDictionary setValue:myPlayer.passing forKey:@"passingGoalie"];
                break;
            case 1:
            {
                NSNumber *defPos = [myHomeDictionary valueForKey:@"defPos"];
                defPos = [NSNumber numberWithInt:[defPos intValue] + [myPlayer.defensivePositioning intValue]];
                [myHomeDictionary setValue:defPos forKey:@"defPos"];
                NSNumber *tackling = [myHomeDictionary valueForKey:@"tackling"];
                tackling = [NSNumber numberWithInt:[tackling intValue] + [myPlayer.tackling intValue]];
                [myHomeDictionary setValue:tackling forKey:@"tackling"];
                NSNumber *passing = [myHomeDictionary valueForKey:@"passingDef"];
                passing = [NSNumber numberWithInt:[passing intValue] + [myPlayer.passing intValue]];
                [myHomeDictionary setValue:passing forKey:@"passingDef"];
                NSNumber *strength = [myHomeDictionary valueForKey:@"strengthDef"];
                strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                [myHomeDictionary setValue:strength forKey:@"strengthDef"];
                break;
            }
            case 2:
            {
                if (![thisTeamFormation isEqualToString:@"1-2-3"] && ![thisTeamFormation isEqualToString:@"1-3-2"]) {
                    NSNumber *defPos = [myHomeDictionary valueForKey:@"defPos"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [myPlayer.defensivePositioning intValue]];
                    [myHomeDictionary setValue:defPos forKey:@"defPos"];
                    NSNumber *tackling = [myHomeDictionary valueForKey:@"tackling"];
                    tackling = [NSNumber numberWithInt:[tackling intValue] + [myPlayer.tackling intValue]];
                    [myHomeDictionary setValue:tackling forKey:@"tackling"];
                    NSNumber *passing = [myHomeDictionary valueForKey:@"passingDef"];
                    passing = [NSNumber numberWithInt:[passing intValue] + [myPlayer.passing intValue]];
                    [myHomeDictionary setValue:passing forKey:@"passingDef"];
                    NSNumber *strength = [myHomeDictionary valueForKey:@"strengthDef"];
                    strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                    [myHomeDictionary setValue:strength forKey:@"strengthDef"];
                } else {
                    NSNumber *passing = [myHomeDictionary valueForKey:@"passing"];
                    passing = [NSNumber numberWithInt:[passing intValue] + [myPlayer.passing intValue]];
                    [myHomeDictionary setValue:passing forKey:@"passing"];
                    NSNumber *strength = [myHomeDictionary valueForKey:@"strength"];
                    strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                    [myHomeDictionary setValue:strength forKey:@"strength"];
                    NSNumber *dribbling = [myHomeDictionary valueForKey:@"dribbling"];
                    dribbling = [NSNumber numberWithInt:[dribbling intValue] + [myPlayer.dribbling intValue]];
                    [myHomeDictionary setValue:dribbling forKey:@"dribbling"];
                    NSNumber *offPos = [myHomeDictionary valueForKey:@"offPosMid"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [myPlayer.offensivePositioning intValue]];
                    [myHomeDictionary setValue:offPos forKey:@"offPosMid"];
                    NSNumber *defPos = [myHomeDictionary valueForKey:@"defPosMid"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [myPlayer.defensivePositioning intValue]];
                    [myHomeDictionary setValue:defPos forKey:@"defPosMid"];
                    NSNumber *shooting = [myHomeDictionary valueForKey:@"shootingMid"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [myPlayer.shooting intValue]];
                    [myHomeDictionary setValue:shooting forKey:@"shootingMid"];
                }
                
                break;
            }
            case 3:
            {
                if (![thisTeamFormation isEqualToString:@"3-2-1"] && ![thisTeamFormation isEqualToString:@"3-3-0"] && ![thisTeamFormation isEqualToString:@"3-1-2"]) {
                    NSNumber *passing = [myHomeDictionary valueForKey:@"passing"];
                    passing = [NSNumber numberWithInt:[passing intValue] + [myPlayer.passing intValue]];
                    [myHomeDictionary setValue:passing forKey:@"passing"];
                    NSNumber *strength = [myHomeDictionary valueForKey:@"strength"];
                    strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                    [myHomeDictionary setValue:strength forKey:@"strength"];
                    NSNumber *dribbling = [myHomeDictionary valueForKey:@"dribbling"];
                    dribbling = [NSNumber numberWithInt:[dribbling intValue] + [myPlayer.dribbling intValue]];
                    [myHomeDictionary setValue:dribbling forKey:@"dribbling"];
                    NSNumber *offPos = [myHomeDictionary valueForKey:@"offPosMid"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [myPlayer.offensivePositioning intValue]];
                    [myHomeDictionary setValue:offPos forKey:@"offPosMid"];
                    NSNumber *defPos = [myHomeDictionary valueForKey:@"defPosMid"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [myPlayer.defensivePositioning intValue]];
                    [myHomeDictionary setValue:defPos forKey:@"defPosMid"];
                    NSNumber *shooting = [myHomeDictionary valueForKey:@"shootingMid"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [myPlayer.shooting intValue]];
                    [myHomeDictionary setValue:shooting forKey:@"shootingMid"];
                } else {
                    NSNumber *defPos = [myHomeDictionary valueForKey:@"defPos"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [myPlayer.defensivePositioning intValue]];
                    [myHomeDictionary setValue:defPos forKey:@"defPos"];
                    NSNumber *tackling = [myHomeDictionary valueForKey:@"tackling"];
                    tackling = [NSNumber numberWithInt:[tackling intValue] + [myPlayer.tackling intValue]];
                    [myHomeDictionary setValue:tackling forKey:@"tackling"];
                    NSNumber *passing = [myHomeDictionary valueForKey:@"passingDef"];
                    passing = [NSNumber numberWithInt:[passing intValue] + [myPlayer.passing intValue]];
                    [myHomeDictionary setValue:passing forKey:@"passingDef"];
                    NSNumber *strength = [myHomeDictionary valueForKey:@"strengthDef"];
                    strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                    [myHomeDictionary setValue:strength forKey:@"strengthDef"];
                }
                break;
            }
            case 4:
            {
                if (![thisTeamFormation isEqualToString:@"1-2-3"] && ![thisTeamFormation isEqualToString:@"2-1-3"]) {
                    NSNumber *passing = [myHomeDictionary valueForKey:@"passing"];
                    passing = [NSNumber numberWithInt:[passing intValue] + [myPlayer.passing intValue]];
                    [myHomeDictionary setValue:passing forKey:@"passing"];
                    NSNumber *strength = [myHomeDictionary valueForKey:@"strength"];
                    strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                    [myHomeDictionary setValue:strength forKey:@"strength"];
                    NSNumber *dribbling = [myHomeDictionary valueForKey:@"dribbling"];
                    dribbling = [NSNumber numberWithInt:[dribbling intValue] + [myPlayer.dribbling intValue]];
                    [myHomeDictionary setValue:dribbling forKey:@"dribbling"];
                    NSNumber *offPos = [myHomeDictionary valueForKey:@"offPosMid"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [myPlayer.offensivePositioning intValue]];
                    [myHomeDictionary setValue:offPos forKey:@"offPosMid"];
                    NSNumber *defPos = [myHomeDictionary valueForKey:@"defPosMid"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [myPlayer.defensivePositioning intValue]];
                    [myHomeDictionary setValue:defPos forKey:@"defPosMid"];
                    NSNumber *shooting = [myHomeDictionary valueForKey:@"shootingMid"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [myPlayer.shooting intValue]];
                    [myHomeDictionary setValue:shooting forKey:@"shootingMid"];
                } else {
                    NSNumber *shooting = [myHomeDictionary valueForKey:@"shooting"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [myPlayer.shooting intValue]];
                    [myHomeDictionary setValue:shooting forKey:@"shooting"];
                    NSNumber *offPos = [myHomeDictionary valueForKey:@"offPos"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [myPlayer.offensivePositioning intValue]];
                    [myHomeDictionary setValue:offPos forKey:@"offPos"];
                    NSNumber *dribbling = [myHomeDictionary valueForKey:@"dribblingFwd"];
                    dribbling = [NSNumber numberWithInt:[dribbling intValue] + [myPlayer.dribbling intValue]];
                    [myHomeDictionary setValue:dribbling forKey:@"dribblingFwd"];
                    NSNumber *strength = [myHomeDictionary valueForKey:@"strengthFwd"];
                    strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                    [myHomeDictionary setValue:strength forKey:@"strengthFwd"];
                }
                break;
            }
            case 5:
            {
                if (![thisTeamFormation isEqualToString:@"2-3-1"] && ![thisTeamFormation isEqualToString:@"3-2-1"] && ![thisTeamFormation isEqualToString:@"3-3-0"]) {
                    NSNumber *shooting = [myHomeDictionary valueForKey:@"shooting"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [myPlayer.shooting intValue]];
                    [myHomeDictionary setValue:shooting forKey:@"shooting"];
                    NSNumber *offPos = [myHomeDictionary valueForKey:@"offPos"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [myPlayer.offensivePositioning intValue]];
                    [myHomeDictionary setValue:offPos forKey:@"offPos"];
                    NSNumber *dribbling = [myHomeDictionary valueForKey:@"dribblingFwd"];
                    dribbling = [NSNumber numberWithInt:[dribbling intValue] + [myPlayer.dribbling intValue]];
                    [myHomeDictionary setValue:dribbling forKey:@"dribblingFwd"];
                    NSNumber *strength = [myHomeDictionary valueForKey:@"strengthFwd"];
                    strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                    [myHomeDictionary setValue:strength forKey:@"strengthFwd"];
                } else {
                    NSNumber *passing = [myHomeDictionary valueForKey:@"passing"];
                    passing = [NSNumber numberWithInt:[passing intValue] + [myPlayer.passing intValue]];
                    [myHomeDictionary setValue:passing forKey:@"passing"];
                    NSNumber *strength = [myHomeDictionary valueForKey:@"strength"];
                    strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                    [myHomeDictionary setValue:strength forKey:@"strength"];
                    NSNumber *dribbling = [myHomeDictionary valueForKey:@"dribbling"];
                    dribbling = [NSNumber numberWithInt:[dribbling intValue] + [myPlayer.dribbling intValue]];
                    [myHomeDictionary setValue:dribbling forKey:@"dribbling"];
                    NSNumber *offPos = [myHomeDictionary valueForKey:@"offPosMid"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [myPlayer.offensivePositioning intValue]];
                    [myHomeDictionary setValue:offPos forKey:@"offPosMid"];
                    NSNumber *defPos = [myHomeDictionary valueForKey:@"defPosMid"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [myPlayer.defensivePositioning intValue]];
                    [myHomeDictionary setValue:defPos forKey:@"defPosMid"];
                    NSNumber *shooting = [myHomeDictionary valueForKey:@"shootingMid"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [myPlayer.shooting intValue]];
                    [myHomeDictionary setValue:shooting forKey:@"shootingMid"];
                }
                break;
            }
            case 6:
            {
                if (![thisTeamFormation isEqualToString:@"3-3-0"]) {
                    NSNumber *shooting = [myHomeDictionary valueForKey:@"shooting"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [myPlayer.shooting intValue]];
                    [myHomeDictionary setValue:shooting forKey:@"shooting"];
                    NSNumber *offPos = [myHomeDictionary valueForKey:@"offPos"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [myPlayer.offensivePositioning intValue]];
                    [myHomeDictionary setValue:offPos forKey:@"offPos"];
                    NSNumber *dribbling = [myHomeDictionary valueForKey:@"dribblingFwd"];
                    dribbling = [NSNumber numberWithInt:[dribbling intValue] + [myPlayer.dribbling intValue]];
                    [myHomeDictionary setValue:dribbling forKey:@"dribblingFwd"];
                    NSNumber *strength = [myHomeDictionary valueForKey:@"strengthFwd"];
                    strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                    [myHomeDictionary setValue:strength forKey:@"strengthFwd"];
                } else {
                    NSNumber *passing = [myHomeDictionary valueForKey:@"passing"];
                    passing = [NSNumber numberWithInt:[passing intValue] + [myPlayer.passing intValue]];
                    [myHomeDictionary setValue:passing forKey:@"passing"];
                    NSNumber *strength = [myHomeDictionary valueForKey:@"strength"];
                    strength = [NSNumber numberWithInt:[strength intValue] + [myPlayer.strength intValue]];
                    [myHomeDictionary setValue:strength forKey:@"strength"];
                    NSNumber *dribbling = [myHomeDictionary valueForKey:@"dribbling"];
                    dribbling = [NSNumber numberWithInt:[dribbling intValue] + [myPlayer.dribbling intValue]];
                    [myHomeDictionary setValue:dribbling forKey:@"dribbling"];
                    NSNumber *offPos = [myHomeDictionary valueForKey:@"offPosMid"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [myPlayer.offensivePositioning intValue]];
                    [myHomeDictionary setValue:offPos forKey:@"offPosMid"];
                    NSNumber *defPos = [myHomeDictionary valueForKey:@"defPosMid"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [myPlayer.defensivePositioning intValue]];
                    [myHomeDictionary setValue:defPos forKey:@"defPosMid"];
                    NSNumber *shooting = [myHomeDictionary valueForKey:@"shootingMid"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [myPlayer.shooting intValue]];
                    [myHomeDictionary setValue:shooting forKey:@"shootingMid"];
                }
                break;
            }
            default:
                break;
        }
        if ([self.myTeamName isEqualToString:currMatch.awayTeam]) {
            thisTeamFormation = [[NSUserDefaults standardUserDefaults] valueForKey:@"Formation"];
        } else {
            thisTeamFormation = @"2-3-1";
        }
        switch (j) {
            case 0:
                [myAwayDictionary setValue:awayPlayer.goalkeeping forKey:@"goalie"];
                [myAwayDictionary setValue:awayPlayer.passing forKey:@"passingGoalie"];
                break;
            case 1:
            {
                NSNumber *defPosAway = [myAwayDictionary valueForKey:@"defPos"];
                defPosAway = [NSNumber numberWithInt:[defPosAway intValue] + [awayPlayer.defensivePositioning intValue]];
                [myAwayDictionary setValue:defPosAway forKey:@"defPos"];
                NSNumber *tacklingAway = [myAwayDictionary valueForKey:@"tackling"];
                tacklingAway = [NSNumber numberWithInt:[tacklingAway intValue] + [awayPlayer.tackling intValue]];
                [myAwayDictionary setValue:tacklingAway forKey:@"tackling"];
                NSNumber *passingAway = [myAwayDictionary valueForKey:@"passingDef"];
                passingAway = [NSNumber numberWithInt:[passingAway intValue] + [awayPlayer.passing intValue]];
                [myAwayDictionary setValue:passingAway forKey:@"passingDef"];
                NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strengthDef"];
                strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                [myAwayDictionary setValue:strengthAway forKey:@"strengthDef"];
                break;
            }
            case 2:
            {
                if (![thisTeamFormation isEqualToString:@"1-2-3"] && ![thisTeamFormation isEqualToString:@"1-3-2"]) {
                    NSNumber *defPosAway = [myAwayDictionary valueForKey:@"defPos"];
                    defPosAway = [NSNumber numberWithInt:[defPosAway intValue] + [awayPlayer.defensivePositioning intValue]];
                    [myAwayDictionary setValue:defPosAway forKey:@"defPos"];
                    NSNumber *tacklingAway = [myAwayDictionary valueForKey:@"tackling"];
                    tacklingAway = [NSNumber numberWithInt:[tacklingAway intValue] + [awayPlayer.tackling intValue]];
                    [myAwayDictionary setValue:tacklingAway forKey:@"tackling"];
                    NSNumber *passingAway = [myAwayDictionary valueForKey:@"passingDef"];
                    passingAway = [NSNumber numberWithInt:[passingAway intValue] + [awayPlayer.passing intValue]];
                    [myAwayDictionary setValue:passingAway forKey:@"passingDef"];
                    NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strengthDef"];
                    strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                    [myAwayDictionary setValue:strengthAway forKey:@"strengthDef"];
                } else {
                    NSNumber *passingAway = [myAwayDictionary valueForKey:@"passing"];
                    passingAway = [NSNumber numberWithInt:[passingAway intValue] + [awayPlayer.passing intValue]];
                    [myAwayDictionary setValue:passingAway forKey:@"passing"];
                    NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strength"];
                    strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                    [myAwayDictionary setValue:strengthAway forKey:@"strength"];
                    NSNumber *dribblingAway = [myAwayDictionary valueForKey:@"dribbling"];
                    dribblingAway = [NSNumber numberWithInt:[dribblingAway intValue] + [awayPlayer.dribbling intValue]];
                    [myAwayDictionary setValue:dribblingAway forKey:@"dribbling"];
                    NSNumber *offPos = [myAwayDictionary valueForKey:@"offPosMid"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [awayPlayer.offensivePositioning intValue]];
                    [myAwayDictionary setValue:offPos forKey:@"offPosMid"];
                    NSNumber *defPos = [myAwayDictionary valueForKey:@"defPosMid"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [awayPlayer.defensivePositioning intValue]];
                    [myAwayDictionary setValue:defPos forKey:@"defPosMid"];
                    NSNumber *shooting = [myAwayDictionary valueForKey:@"shootingMid"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [awayPlayer.shooting intValue]];
                    [myAwayDictionary setValue:shooting forKey:@"shootingMid"];
                }
                
                break;
            }
            case 3:
            {
                if (![thisTeamFormation isEqualToString:@"3-2-1"] && ![thisTeamFormation isEqualToString:@"3-3-0"] && ![thisTeamFormation isEqualToString:@"3-1-2"]) {
                    NSNumber *passingAway = [myAwayDictionary valueForKey:@"passing"];
                    passingAway = [NSNumber numberWithInt:[passingAway intValue] + [awayPlayer.passing intValue]];
                    [myAwayDictionary setValue:passingAway forKey:@"passing"];
                    NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strength"];
                    strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                    [myAwayDictionary setValue:strengthAway forKey:@"strength"];
                    NSNumber *dribblingAway = [myAwayDictionary valueForKey:@"dribbling"];
                    dribblingAway = [NSNumber numberWithInt:[dribblingAway intValue] + [awayPlayer.dribbling intValue]];
                    [myAwayDictionary setValue:dribblingAway forKey:@"dribbling"];
                    NSNumber *offPos = [myAwayDictionary valueForKey:@"offPosMid"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [awayPlayer.offensivePositioning intValue]];
                    [myAwayDictionary setValue:offPos forKey:@"offPosMid"];
                    NSNumber *defPos = [myAwayDictionary valueForKey:@"defPosMid"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [awayPlayer.defensivePositioning intValue]];
                    [myAwayDictionary setValue:defPos forKey:@"defPosMid"];
                    NSNumber *shooting = [myAwayDictionary valueForKey:@"shootingMid"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [awayPlayer.shooting intValue]];
                    [myAwayDictionary setValue:shooting forKey:@"shootingMid"];
                } else {
                    NSNumber *defPosAway = [myAwayDictionary valueForKey:@"defPos"];
                    defPosAway = [NSNumber numberWithInt:[defPosAway intValue] + [awayPlayer.defensivePositioning intValue]];
                    [myAwayDictionary setValue:defPosAway forKey:@"defPos"];
                    NSNumber *tacklingAway = [myAwayDictionary valueForKey:@"tackling"];
                    tacklingAway = [NSNumber numberWithInt:[tacklingAway intValue] + [awayPlayer.tackling intValue]];
                    [myAwayDictionary setValue:tacklingAway forKey:@"tackling"];
                    NSNumber *passingAway = [myAwayDictionary valueForKey:@"passingDef"];
                    passingAway = [NSNumber numberWithInt:[passingAway intValue] + [awayPlayer.passing intValue]];
                    [myAwayDictionary setValue:passingAway forKey:@"passingDef"];
                    NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strengthDef"];
                    strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                    [myAwayDictionary setValue:strengthAway forKey:@"strengthDef"];
                }
                break;
            }
            case 4:
            {
                if (![thisTeamFormation isEqualToString:@"1-2-3"] && ![thisTeamFormation isEqualToString:@"2-1-3"]) {
                    NSNumber *passingAway = [myAwayDictionary valueForKey:@"passing"];
                    passingAway = [NSNumber numberWithInt:[passingAway intValue] + [awayPlayer.passing intValue]];
                    [myAwayDictionary setValue:passingAway forKey:@"passing"];
                    NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strength"];
                    strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                    [myAwayDictionary setValue:strengthAway forKey:@"strength"];
                    NSNumber *dribblingAway = [myAwayDictionary valueForKey:@"dribbling"];
                    dribblingAway = [NSNumber numberWithInt:[dribblingAway intValue] + [awayPlayer.dribbling intValue]];
                    [myAwayDictionary setValue:dribblingAway forKey:@"dribbling"];
                    NSNumber *offPos = [myAwayDictionary valueForKey:@"offPosMid"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [awayPlayer.offensivePositioning intValue]];
                    [myAwayDictionary setValue:offPos forKey:@"offPosMid"];
                    NSNumber *defPos = [myAwayDictionary valueForKey:@"defPosMid"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [awayPlayer.defensivePositioning intValue]];
                    [myAwayDictionary setValue:defPos forKey:@"defPosMid"];
                    NSNumber *shooting = [myAwayDictionary valueForKey:@"shootingMid"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [awayPlayer.shooting intValue]];
                    [myAwayDictionary setValue:shooting forKey:@"shootingMid"];
                } else {
                    NSNumber *shootingAway = [myAwayDictionary valueForKey:@"shooting"];
                    shootingAway = [NSNumber numberWithInt:[shootingAway intValue] + [awayPlayer.shooting intValue]];
                    [myAwayDictionary setValue:shootingAway forKey:@"shooting"];
                    NSNumber *offPosAway = [myAwayDictionary valueForKey:@"offPos"];
                    offPosAway = [NSNumber numberWithInt:[offPosAway intValue] + [awayPlayer.offensivePositioning intValue]];
                    [myAwayDictionary setValue:offPosAway forKey:@"offPos"];
                    NSNumber *dribblingAway = [myAwayDictionary valueForKey:@"dribblingFwd"];
                    dribblingAway = [NSNumber numberWithInt:[dribblingAway intValue] + [awayPlayer.dribbling intValue]];
                    [myAwayDictionary setValue:dribblingAway forKey:@"dribblingFwd"];
                    NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strengthFwd"];
                    strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                    [myAwayDictionary setValue:strengthAway forKey:@"strengthFwd"];
                }
                break;
            }
            case 5:
            {
                if (![thisTeamFormation isEqualToString:@"2-3-1"] && ![thisTeamFormation isEqualToString:@"3-2-1"] && ![thisTeamFormation isEqualToString:@"3-3-0"]) {
                    NSNumber *shootingAway = [myAwayDictionary valueForKey:@"shooting"];
                    shootingAway = [NSNumber numberWithInt:[shootingAway intValue] + [awayPlayer.shooting intValue]];
                    [myAwayDictionary setValue:shootingAway forKey:@"shooting"];
                    NSNumber *offPosAway = [myAwayDictionary valueForKey:@"offPos"];
                    offPosAway = [NSNumber numberWithInt:[offPosAway intValue] + [awayPlayer.offensivePositioning intValue]];
                    [myAwayDictionary setValue:offPosAway forKey:@"offPos"];
                    NSNumber *dribblingAway = [myAwayDictionary valueForKey:@"dribblingFwd"];
                    dribblingAway = [NSNumber numberWithInt:[dribblingAway intValue] + [awayPlayer.dribbling intValue]];
                    [myAwayDictionary setValue:dribblingAway forKey:@"dribblingFwd"];
                    NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strengthFwd"];
                    strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                    [myAwayDictionary setValue:strengthAway forKey:@"strengthFwd"];
                } else {
                    NSNumber *passingAway = [myAwayDictionary valueForKey:@"passing"];
                    passingAway = [NSNumber numberWithInt:[passingAway intValue] + [awayPlayer.passing intValue]];
                    [myAwayDictionary setValue:passingAway forKey:@"passing"];
                    NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strength"];
                    strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                    [myAwayDictionary setValue:strengthAway forKey:@"strength"];
                    NSNumber *dribblingAway = [myAwayDictionary valueForKey:@"dribbling"];
                    dribblingAway = [NSNumber numberWithInt:[dribblingAway intValue] + [awayPlayer.dribbling intValue]];
                    [myAwayDictionary setValue:dribblingAway forKey:@"dribbling"];
                    NSNumber *offPos = [myAwayDictionary valueForKey:@"offPosMid"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [awayPlayer.offensivePositioning intValue]];
                    [myAwayDictionary setValue:offPos forKey:@"offPosMid"];
                    NSNumber *defPos = [myAwayDictionary valueForKey:@"defPosMid"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [awayPlayer.defensivePositioning intValue]];
                    [myAwayDictionary setValue:defPos forKey:@"defPosMid"];
                    NSNumber *shooting = [myAwayDictionary valueForKey:@"shootingMid"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [awayPlayer.shooting intValue]];
                    [myAwayDictionary setValue:shooting forKey:@"shootingMid"];
                }
                break;
            }
            case 6:
            {
                if (![thisTeamFormation isEqualToString:@"3-3-0"]) {
                    NSNumber *shootingAway = [myAwayDictionary valueForKey:@"shooting"];
                    shootingAway = [NSNumber numberWithInt:[shootingAway intValue] + [awayPlayer.shooting intValue]];
                    [myAwayDictionary setValue:shootingAway forKey:@"shooting"];
                    NSNumber *offPosAway = [myAwayDictionary valueForKey:@"offPos"];
                    offPosAway = [NSNumber numberWithInt:[offPosAway intValue] + [awayPlayer.offensivePositioning intValue]];
                    [myAwayDictionary setValue:offPosAway forKey:@"offPos"];
                    NSNumber *dribblingAway = [myAwayDictionary valueForKey:@"dribblingFwd"];
                    dribblingAway = [NSNumber numberWithInt:[dribblingAway intValue] + [awayPlayer.dribbling intValue]];
                    [myAwayDictionary setValue:dribblingAway forKey:@"dribblingFwd"];
                    NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strengthFwd"];
                    strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                    [myAwayDictionary setValue:strengthAway forKey:@"strengthFwd"];
                } else {
                    NSNumber *passingAway = [myAwayDictionary valueForKey:@"passing"];
                    passingAway = [NSNumber numberWithInt:[passingAway intValue] + [awayPlayer.passing intValue]];
                    [myAwayDictionary setValue:passingAway forKey:@"passing"];
                    NSNumber *strengthAway = [myAwayDictionary valueForKey:@"strength"];
                    strengthAway = [NSNumber numberWithInt:[strengthAway intValue] + [awayPlayer.strength intValue]];
                    [myAwayDictionary setValue:strengthAway forKey:@"strength"];
                    NSNumber *dribblingAway = [myAwayDictionary valueForKey:@"dribbling"];
                    dribblingAway = [NSNumber numberWithInt:[dribblingAway intValue] + [awayPlayer.dribbling intValue]];
                    [myAwayDictionary setValue:dribblingAway forKey:@"dribbling"];
                    NSNumber *offPos = [myAwayDictionary valueForKey:@"offPosMid"];
                    offPos = [NSNumber numberWithInt:[offPos intValue] + [awayPlayer.offensivePositioning intValue]];
                    [myAwayDictionary setValue:offPos forKey:@"offPosMid"];
                    NSNumber *defPos = [myAwayDictionary valueForKey:@"defPosMid"];
                    defPos = [NSNumber numberWithInt:[defPos intValue] + [awayPlayer.defensivePositioning intValue]];
                    [myAwayDictionary setValue:defPos forKey:@"defPosMid"];
                    NSNumber *shooting = [myAwayDictionary valueForKey:@"shootingMid"];
                    shooting = [NSNumber numberWithInt:[shooting intValue] + [awayPlayer.shooting intValue]];
                    [myAwayDictionary setValue:shooting forKey:@"shootingMid"];
                }
                break;
            }
            default:
                break;
        }
    }
    
    NSArray *combinedTeams = [NSArray arrayWithObjects:myHomeDictionary,myAwayDictionary, homeTeam, awayTeam, filteredHomeTeam, filteredAwayTeam, nil];
    return combinedTeams;
}

- (DOKMatch *)playThisMatch:(DOKMatch *)currMatch atPoint:(NSMutableArray *)myMatchDetails
{
    __block int homeGoals = 0;
    __block int awayGoals = 0;
    
    
    NSArray *homeAndAwayTeams = [self setupGameForMatch:currMatch];
    
    NSDictionary* myHomeDictionary = [homeAndAwayTeams objectAtIndex:0];
    NSDictionary* myAwayDictionary = [homeAndAwayTeams objectAtIndex:1];
    NSMutableArray *thisHomeTeam;// = [homeAndAwayTeams objectAtIndex:2];
    NSMutableArray *thisAwayTeam;// = [homeAndAwayTeams objectAtIndex:3];
    if ([currMatch.homeTeam isEqualToString:self.myTeamName]) {
        thisHomeTeam = [homeAndAwayTeams objectAtIndex:4];
        thisAwayTeam = [homeAndAwayTeams objectAtIndex:3];
    } else if ([currMatch.awayTeam isEqualToString:self.myTeamName]) {
        thisHomeTeam = [homeAndAwayTeams objectAtIndex:2];
        thisAwayTeam = [homeAndAwayTeams objectAtIndex:5];
    } else {
        thisHomeTeam = [homeAndAwayTeams objectAtIndex:2];
        thisAwayTeam = [homeAndAwayTeams objectAtIndex:3];
    }
    
    
    dispatch_queue_t whileQ = dispatch_queue_create("match_queue", 0);
    dispatch_async(whileQ, ^{
        int plays= [[myMatchDetails objectAtIndex:0] intValue];
        NSString *currTerritory;
        NSString *currTeam;
        NSString *homeTeamName = currMatch.homeTeam;
        NSString *awayTeamName = currMatch.awayTeam;
        int possession;
        int defTerritory;
        int midTerritory;
        int fwdTerritory;
        int homeShots;
        int awayShots;
        int homeTackles;
        int awayTackles;
        int homePasses;
        int awayPasses;
        if (plays != 0) {
            currTeam = [myMatchDetails objectAtIndex:1];
            currTerritory = [myMatchDetails objectAtIndex:2];
            possession = [[myMatchDetails objectAtIndex:3] intValue];
            defTerritory = [[myMatchDetails objectAtIndex:4] intValue];
            midTerritory = [[myMatchDetails objectAtIndex:5] intValue];
            fwdTerritory = [[myMatchDetails objectAtIndex:6] intValue];
            homeShots = [[myMatchDetails objectAtIndex:7] intValue];
            awayShots = [[myMatchDetails objectAtIndex:8] intValue];
            homeTackles = [[myMatchDetails objectAtIndex:9] intValue];
            awayTackles = [[myMatchDetails objectAtIndex:10] intValue];
            homePasses = [[myMatchDetails objectAtIndex:11] intValue];
            awayPasses = [[myMatchDetails objectAtIndex:12] intValue];
            homeGoals = [[myMatchDetails objectAtIndex:13] intValue];
            awayGoals = [[myMatchDetails objectAtIndex:14] intValue];
        } else {
            currTerritory = @"mid";
            currTeam = currMatch.homeTeam;
            possession = 0;
            defTerritory = 0;
            midTerritory = 1;
            fwdTerritory = 0;
            homeShots = 0;
            awayShots = 0;
            homeTackles = 0;
            awayTackles = 0;
            homePasses = 0;
            awayPasses = 0;
        }
        
        while (plays != 120 && !((self.pauseGame && ([currMatch.homeTeam isEqualToString:self.myTeamName] || [currMatch.awayTeam isEqualToString:self.myTeamName])))) {
            
            
            //        arc4random_uniform(100)+1;
            if ([currTerritory isEqualToString:@"mid"]) {
                if ([currTeam isEqualToString:homeTeamName]) {
                    int homeStrengthAndDribbling = ([[myHomeDictionary objectForKey:@"strength"] intValue] + [[myHomeDictionary objectForKey:@"dribbling"] intValue]);
                    int awayStrengthAndDribbling = ([[myAwayDictionary objectForKey:@"strength"] intValue] + [[myAwayDictionary objectForKey:@"dribbling"] intValue]);
                    int totalStrengthAndDribbling = homeStrengthAndDribbling + awayStrengthAndDribbling;
                    
                    if (!(arc4random_uniform(totalStrengthAndDribbling)+1 > homeStrengthAndDribbling)) {
                        int passNum = ([[myHomeDictionary objectForKey:@"passing"] intValue] + [[myHomeDictionary objectForKey:@"offPos"] intValue] - [[myAwayDictionary objectForKey:@"defPos"] intValue]);
                        if (arc4random_uniform(100)+1 < passNum) {
                            homePasses += 1;
                            currTerritory = @"fwd";
                        } else {
                            //misplaced pass
                            currTerritory = @"fwd";
                            currTeam = awayTeamName;
                        }
                    } else {
                        awayTackles += 1;
                        currTeam = awayTeamName;
                    }
                } else {
                    int awayStrengthAndDribbling = ([[myAwayDictionary objectForKey:@"strength"] intValue] + [[myAwayDictionary objectForKey:@"dribbling"] intValue]);
                    int homeStrengthAndDribbling = ([[myHomeDictionary objectForKey:@"strength"] intValue] + [[myHomeDictionary objectForKey:@"dribbling"] intValue]);
                    int totalStrengthAndDribbling = awayStrengthAndDribbling + homeStrengthAndDribbling;
                    
                    if (!(arc4random_uniform(totalStrengthAndDribbling)+1 > awayStrengthAndDribbling)) {
                        int passNum = ([[myAwayDictionary objectForKey:@"passing"] intValue] + [[myAwayDictionary objectForKey:@"offPos"] intValue] - [[myHomeDictionary objectForKey:@"defPos"] intValue]);
                        if (arc4random_uniform(100)+1 < passNum) {
                            awayPasses += 1;
                            currTerritory = @"def";
                        } else {
                            currTerritory = @"def";
                            currTeam = homeTeamName;
                        }
                    } else {
                        homeTackles += 1;
                        currTeam = homeTeamName;
                    }
                }
            } else if ([currTerritory isEqualToString:@"def"]) {
                if ([currTeam isEqualToString:homeTeamName]) {
                    if (arc4random_uniform(100)+1 < 5) {
                        currTeam = awayTeamName;
                        //                        continue;
                    } else {
                        bool longPass = false;
                        if (arc4random_uniform(100)+1 >= 80) {
                            longPass = true;
                        }
                        int passingDef = [[myHomeDictionary objectForKey:@"passingDef"] intValue];
                        
                        if (!longPass) {
                            if (passingDef > arc4random_uniform(10)+1) {
                                homePasses += 1;
                                currTerritory = @"mid";
                            } else {
                                currTerritory = @"mid";
                                currTeam = awayTeamName;
                            }
                        } else if(longPass) {
                            if (passingDef > arc4random_uniform(20)+1) {
                                homePasses += 1;
                                currTerritory = @"fwd";
                            } else {
                                currTerritory = @"fwd";
                                currTeam = awayTeamName;
                            }
                        }
                    }
                } else {
                    int awayStrengthAndDribbling = ([[myAwayDictionary objectForKey:@"strengthFwd"] intValue] + [[myAwayDictionary objectForKey:@"dribblingFwd"] intValue]);
                    int homeStrengthAndTackling = ([[myHomeDictionary objectForKey:@"strengthDef"] intValue] + [[myHomeDictionary objectForKey:@"tackling"] intValue]);
                    int totalStrengthAndDribblingAndTackling = awayStrengthAndDribbling + homeStrengthAndTackling;
                    bool dribble = false;
                    if (arc4random_uniform(100)+1 >= 75) {
                        dribble = true;
                    }
                    if (dribble) {
                        if ((arc4random_uniform(totalStrengthAndDribblingAndTackling)+1 < awayStrengthAndDribbling)) {
                            //shot
                            awayShots += 1;
                            int shot = ([[myAwayDictionary objectForKey:@"shooting"] intValue]);
                            int keeper = ([[myHomeDictionary objectForKey:@"goalkeeping"] intValue]);
                            if (arc4random_uniform(shot + keeper)+1 < shot) {
                                //goal
                                DOKPlayer *goalMaker = [self findAssistForTeam:currTeam withPassingValue:[[myAwayDictionary objectForKey:@"passing"] intValue] + [[myAwayDictionary objectForKey:@"passingFwd"] intValue] andPlayers:thisAwayTeam];
                                DOKPlayer *goalScorer = [self findScorerWithAssistFromPlayer:goalMaker forTeam:currTeam withScoringValue:[[myAwayDictionary objectForKey:@"shooting"] intValue] + [[myAwayDictionary objectForKey:@"offPos"] intValue] + [[myAwayDictionary objectForKey:@"shootingMid"] intValue] + [[myAwayDictionary objectForKey:@"offPosMid"] intValue] withPlayers:thisAwayTeam];
                                [self.allAssists addObject:goalMaker];
                                [self.allGoalscorers addObject:goalScorer];
                                if ([currMatch.homeTeam isEqualToString:self.myTeamName] || [currMatch.awayTeam isEqualToString:self.myTeamName]) {
                                    [self.goalsAndAssists addObject:goalMaker];
                                    [self.goalsAndAssists addObject:goalScorer];
                                }
                                
                                awayGoals += 1;
                                currTerritory = @"mid";
                                currTeam = homeTeamName;
                            } else {
                                //save
                                currTeam = homeTeamName;
                            }
                        } else {
                            homeTackles += 1;
                            currTeam = homeTeamName;
                        }
                    }
                    else {
                        awayShots += 1;
                        int shot = ([[myAwayDictionary objectForKey:@"shooting"] intValue]);
                        int defPos = ([[myHomeDictionary objectForKey:@"defPos"] intValue]);
                        int keeper = ([[myHomeDictionary objectForKey:@"goalkeeping"] intValue]);
                        if (arc4random_uniform(shot + keeper + defPos)+1 < shot) {
                            //goal
                            DOKPlayer *goalMaker = [self findAssistForTeam:currTeam withPassingValue:[[myAwayDictionary objectForKey:@"passing"] intValue] + [[myAwayDictionary objectForKey:@"passingFwd"] intValue] andPlayers:thisAwayTeam];
                            DOKPlayer *goalScorer = [self findScorerWithAssistFromPlayer:goalMaker forTeam:currTeam withScoringValue:[[myAwayDictionary objectForKey:@"shooting"] intValue] + [[myAwayDictionary objectForKey:@"offPos"] intValue] + [[myAwayDictionary objectForKey:@"shootingMid"] intValue] + [[myAwayDictionary objectForKey:@"offPosMid"] intValue] withPlayers:thisAwayTeam];
                            [self.allAssists addObject:goalMaker];
                            [self.allGoalscorers addObject:goalScorer];
                            if ([currMatch.homeTeam isEqualToString:self.myTeamName] || [currMatch.awayTeam isEqualToString:self.myTeamName]) {
                                [self.goalsAndAssists addObject:goalMaker];
                                [self.goalsAndAssists addObject:goalScorer];
                            }
                            awayGoals += 1;
                            currTerritory = @"mid";
                            currTeam = homeTeamName;
                        } else {
                            //save
                            currTeam = homeTeamName;
                        }
                    }
                }
            } else if ([currTerritory isEqualToString:@"fwd"]) {
                if ([currTeam isEqualToString:homeTeamName]) {
                    int homeStrengthAndDribbling = ([[myHomeDictionary objectForKey:@"strengthFwd"] intValue] + [[myHomeDictionary objectForKey:@"dribblingFwd"] intValue]);
                    int awayStrengthAndTackling = ([[myAwayDictionary objectForKey:@"strengthDef"] intValue] + [[myAwayDictionary objectForKey:@"tackling"] intValue]);
                    int totalStrengthAndDribblingAndTackling = homeStrengthAndDribbling + awayStrengthAndTackling;
                    bool dribble = false;
                    if (arc4random_uniform(100)+1 >= 75) {
                        dribble = true;
                    }
                    if (dribble) {
                        if ((arc4random_uniform(totalStrengthAndDribblingAndTackling)+1 < homeStrengthAndDribbling)) {
                            //shot
                            homeShots += 1;
                            int shot = ([[myHomeDictionary objectForKey:@"shooting"] intValue]);
                            int keeper = ([[myAwayDictionary objectForKey:@"goalkeeping"] intValue]);
                            if (arc4random_uniform(shot + keeper)+1 < shot) {
                                //goal
                                DOKPlayer *goalMaker = [self findAssistForTeam:currTeam withPassingValue:[[myHomeDictionary objectForKey:@"passing"] intValue] + [[myHomeDictionary objectForKey:@"passingFwd"] intValue] andPlayers:thisHomeTeam];
                                DOKPlayer *goalScorer = [self findScorerWithAssistFromPlayer:goalMaker forTeam:currTeam withScoringValue:[[myHomeDictionary objectForKey:@"shooting"] intValue] + [[myHomeDictionary objectForKey:@"offPos"] intValue] + [[myHomeDictionary objectForKey:@"shootingMid"] intValue] + [[myHomeDictionary objectForKey:@"offPosMid"] intValue] withPlayers:thisHomeTeam];
                                [self.allAssists addObject:goalMaker];
                                [self.allGoalscorers addObject:goalScorer];
                                if ([currMatch.homeTeam isEqualToString:self.myTeamName] || [currMatch.awayTeam isEqualToString:self.myTeamName]) {
                                    [self.goalsAndAssists addObject:goalMaker];
                                    [self.goalsAndAssists addObject:goalScorer];
                                }
                                homeGoals += 1;
                                currTerritory = @"mid";
                                currTeam = awayTeamName;
                            } else {
                                //save
                                currTeam = awayTeamName;
                            }
                        } else {
                            awayTackles += 1;
                            currTeam = awayTeamName;
                        }
                    }
                    else {
                        homeShots +=1;
                        int shot = ([[myHomeDictionary objectForKey:@"shooting"] intValue]);
                        int defPos = ([[myAwayDictionary objectForKey:@"defPos"] intValue]);
                        int keeper = ([[myAwayDictionary objectForKey:@"goalkeeping"] intValue]);
                        if (arc4random_uniform(shot + keeper + defPos)+1 < shot) {
                            //goal
                            DOKPlayer *goalMaker = [self findAssistForTeam:currTeam withPassingValue:[[myHomeDictionary objectForKey:@"passing"] intValue] + [[myHomeDictionary objectForKey:@"passingFwd"] intValue] andPlayers:thisHomeTeam];
                            DOKPlayer *goalScorer = [self findScorerWithAssistFromPlayer:goalMaker forTeam:currTeam withScoringValue:[[myHomeDictionary objectForKey:@"shooting"] intValue] + [[myHomeDictionary objectForKey:@"offPos"] intValue] + [[myHomeDictionary objectForKey:@"shootingMid"] intValue] + [[myHomeDictionary objectForKey:@"offPosMid"] intValue] withPlayers:thisHomeTeam];
                            [self.allAssists addObject:goalMaker];
                            [self.allGoalscorers addObject:goalScorer];
                            if ([currMatch.homeTeam isEqualToString:self.myTeamName] || [currMatch.awayTeam isEqualToString:self.myTeamName]) {
                                [self.goalsAndAssists addObject:goalMaker];
                                [self.goalsAndAssists addObject:goalScorer];
                            }
                            homeGoals += 1;
                            currTerritory = @"mid";
                            currTeam = awayTeamName;
                        } else {
                            //save
                            currTeam = awayTeamName;
                        }
                    }
                } else {
                    if (arc4random_uniform(100)+1 < 5) {
                        currTeam = homeTeamName;
                        //                        continue;
                    }
                    bool longPass = false;
                    if (arc4random_uniform(100)+1 >= 80) {
                        longPass = true;
                    } else {
                        int passingDef = [[myAwayDictionary objectForKey:@"passingDef"] intValue];
                        
                        if (!longPass) {
                            if (passingDef > arc4random_uniform(10)+1) {
                                awayPasses += 1;
                                currTerritory = @"mid";
                                //                            continue;
                            } else {
                                currTerritory = @"mid";
                                currTeam = homeTeamName;
                            }
                        } else if(longPass) {
                            if (passingDef > arc4random_uniform(20)+1) {
                                awayPasses += 1;
                                currTerritory = @"def";
                                //                            continue;
                            } else {
                                currTerritory = @"def";
                                currTeam = awayTeamName;
                            }
                        }
                    }
                }
            }
            if ([currTeam isEqualToString:homeTeamName]) {
                possession += 1;
            }
            if ([currTerritory isEqualToString:@"def"])
                defTerritory += 1;
            else if ([currTerritory isEqualToString:@"mid"])
                midTerritory += 1;
            else
                fwdTerritory += 1;
            
            
            plays += 1;
            if (plays%2==0 && !self.instantMatches) {
                sleep(1);
            }
            if ([currMatch.homeTeam isEqualToString:self.myTeamName] || [currMatch.awayTeam isEqualToString:self.myTeamName]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timeLabel.text = [NSString stringWithFormat:@"%d",plays/2];
                    self.awayScore.text = [NSString stringWithFormat:@"%d",awayGoals];
                    self.homeScore.text = [NSString stringWithFormat:@"%d",homeGoals];
                    self.possessionLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.0f%%",(float)100*possession/(plays+1)]];
                    self.awayPossessionLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.0f%%",(float)100*(plays+1-possession)/(plays+1)]];
                    self.homePossessionView.frame = CGRectMake(0, 0, self.possessionImageView.bounds.size.width*possession/(plays+1), self.possessionImageView.bounds.size.height);
                    self.defTerritory.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.0f%%",(float)100*(defTerritory)/(plays+1)]];
                    self.midTerritory.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.0f%%",(float)100*(midTerritory)/(plays+1)]];
                    self.fwdTerritory.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.0f%%",(float)100*(fwdTerritory)/(plays+1)]];
                    float terrFloat = ((float)(midTerritory)/(2*(plays+1)) + (float)(fwdTerritory)/(plays+1));
                    self.avgTerritoryView.frame = CGRectMake(0, 0, self.possessionImageView.bounds.size.width*terrFloat, self.possessionImageView.bounds.size.height);
                    [self.myTableView reloadData];
                    
                    self.homeShotsLabel.text = [NSString stringWithFormat:@"%d",homeShots];
                    self.awayShotsLabel.text = [NSString stringWithFormat:@"%d",awayShots];
                    self.homeTacklesLabel.text = [NSString stringWithFormat:@"%d",homeTackles];
                    self.awayTacklesLabel.text = [NSString stringWithFormat:@"%d",awayTackles];
                    self.homePassesLabel.text = [NSString stringWithFormat:@"%d",homePasses];
                    self.awayPassesLabel.text = [NSString stringWithFormat:@"%d",awayPasses];
                });
            }
            if (self.pauseGame && ([currMatch.homeTeam isEqualToString:self.myTeamName] || [currMatch.awayTeam isEqualToString:self.myTeamName])) {
                
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:plays] atIndex:0];
                [self.savedMatchDetails insertObject:currTeam atIndex:1];
                [self.savedMatchDetails insertObject:currTerritory atIndex:2];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:possession] atIndex:3];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:defTerritory] atIndex:4];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:midTerritory] atIndex:5];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:fwdTerritory] atIndex:6];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:homeShots] atIndex:7];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:awayShots] atIndex:8];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:homeTackles] atIndex:9];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:awayTackles] atIndex:10];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:homePasses] atIndex:11];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:awayPasses] atIndex:12];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:homeGoals] atIndex:13];
                [self.savedMatchDetails insertObject:[NSNumber numberWithInt:awayGoals] atIndex:14];
                
                self.pausedGamePlays = plays;
                self.savedMatch = currMatch;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.playButton setTitle:@"Continue" forState:UIControlStateNormal];
                    [self.playButton setTitle:@"Continue" forState:UIControlStateHighlighted];
                });
            }
        }
        currMatch.homeGoals = [NSNumber numberWithInt:homeGoals];
        currMatch.awayGoals = [NSNumber numberWithInt:awayGoals];
        
        if (([currMatch.homeTeam isEqualToString:self.myTeamName] || [currMatch.awayTeam isEqualToString:self.myTeamName]) && !self.pauseGame) {
            [self setMatchesDone];
        }
    });
    return currMatch;
}

- (DOKPlayer *) findAssistForTeam:(NSString *)team withPassingValue:(int)passing andPlayers:(NSMutableArray *)players {
    NSString *thisTeamFormation;
    int assistValue = arc4random_uniform(passing)+1;
    if ([self.myTeamName isEqualToString:team]) {
        thisTeamFormation = [[NSUserDefaults standardUserDefaults] valueForKey:@"Formation"];
    } else {
        thisTeamFormation = @"2-3-1";
    }
    DOKPlayer *goalMaker;
    if ([team isEqualToString:self.homeTeamLabel.text]) {
        for (int i = 3; i < 7; i++) {
            DOKPlayer *thisPlayer = [players objectAtIndex:i];
            if (assistValue > 0 && assistValue <= [thisPlayer.passing intValue]) {
                goalMaker = thisPlayer;
            }
            assistValue -= [thisPlayer.passing intValue];
        }
    } else {
        
        for (int i = 3; i < 7; i++) {
            DOKPlayer *thisPlayer = [players objectAtIndex:i];
            if (assistValue > 0 && assistValue <= [thisPlayer.passing intValue]) {
                goalMaker = thisPlayer;
            }
            assistValue -= [thisPlayer.passing intValue];
        }
        
    }
    return goalMaker;
}

- (DOKPlayer *) findScorerWithAssistFromPlayer:(DOKPlayer *)player forTeam:(NSString *)team withScoringValue:(int)scoring withPlayers:(NSMutableArray *)players{
    NSString *thisTeamFormation;
    scoring = scoring - [player.shooting intValue] - [player.offensivePositioning intValue];
    int shootValue = arc4random_uniform(scoring)+1;
    
    
    if ([self.myTeamName isEqualToString:team]) {
        thisTeamFormation = [[NSUserDefaults standardUserDefaults] valueForKey:@"Formation"];
    } else {
        thisTeamFormation = @"2-3-1";
    }
    DOKPlayer *goalScorer;
    if ([team isEqualToString:self.homeTeamLabel.text]) {
        for (int i = 3; i < 7; i++) {
            DOKPlayer *thisPlayer = [players objectAtIndex:i];
            if (![thisPlayer isEqual:player]) {
                
                if (shootValue > 0 && shootValue <= [thisPlayer.shooting intValue] + [thisPlayer.offensivePositioning intValue]) {
                    goalScorer = thisPlayer;
                }
                shootValue -= ([thisPlayer.shooting intValue] + [thisPlayer.offensivePositioning intValue]);
            }
        }
    } else {
        
        for (int i = 3; i < 7; i++) {
            DOKPlayer *thisPlayer = [players objectAtIndex:i];
            if (![thisPlayer isEqual:player]) {
                if (shootValue > 0 && shootValue <= [thisPlayer.shooting intValue]+ [thisPlayer.offensivePositioning intValue]) {
                    goalScorer = thisPlayer;
                }
                shootValue -= ([thisPlayer.shooting intValue] + [thisPlayer.offensivePositioning intValue]);
            }
        }
        
    }
    return goalScorer;
}

- (void) saveContext {
    NSError *theError = nil;
	[[[DOKAppDelegate sharedAppDelegate] managedObjectContext] save:&theError];
	
	if (theError) {
		NSLog(@"error saving context: %@", [theError localizedDescription]);
	}
}

- (void) setMatchesDone
{
    self.matchesFinished = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"name"];
    NSString *teamName = [defaults objectForKey:@"teamName"];
    NSDictionary *myFlurryDict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"Name", teamName, @"Team", nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.playButton setTitle:@"Done" forState:UIControlStateHighlighted];
    });
    [Flurry logEvent:@"Match Played" withParameters:myFlurryDict];
}

- (IBAction)closeButtonPressed:(UIButton *)sender {
    if([self.myDelegate respondsToSelector:@selector(secondViewControllerDismissedWithoutPlaying)]) {
        [self.myDelegate secondViewControllerDismissedWithoutPlaying];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)playMatch:(UIButton *)sender {
    self.closeButton.hidden = YES;
    if (!self.matchesFinished) {
        if ([self.playButton.titleLabel.text isEqualToString:@"Pause"]) {
            self.pauseGame = YES;
            
        } else if([self.playButton.titleLabel.text isEqualToString:@"Continue"]) {
            self.pauseGame = NO;
            [self playThisMatch:self.savedMatch atPoint:self.savedMatchDetails];
            [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
            [self.playButton setTitle:@"Pause" forState:UIControlStateHighlighted];
            
        } else {
            
            [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
            [self.playButton setTitle:@"Pause" forState:UIControlStateHighlighted];
            DOKMatch *myMatch = [[DOKMatch alloc] init];
            for (DOKMatch *currMatch in self.matches) {
                
                if ([currMatch.homeTeam isEqualToString:self.myTeamName] || [currMatch.awayTeam isEqualToString:self.myTeamName]) {
                    myMatch = currMatch;
                } else
                    [self playThisMatch:currMatch atPoint:0];
            }
            //            plays = 0;
            [self playThisMatch:myMatch atPoint:0];
        }
    } else {
        if([self.myDelegate respondsToSelector:@selector(secondViewControllerDismissed)])
        {
            for (DOKPlayerModel *myPlayer in self.allGoalscorers) {
                myPlayer.goals = [NSNumber numberWithInt:([myPlayer.goals intValue] + 1)];
            }
            for (DOKPlayerModel *myPlayer in self.allAssists) {
                myPlayer.assists = [NSNumber numberWithInt:([myPlayer.assists intValue] + 1)];
            }
            for (DOKMatch *currMatch in self.matches) {
                NSLog(@"%@:%@ -- %@:%@",currMatch.homeTeam,currMatch.homeGoals,currMatch.awayGoals,currMatch.awayTeam);
                for (DOKTeamModel *currTeam in self.teams) {
                    if ([currTeam.teamName isEqualToString:currMatch.homeTeam]) {
                        currTeam.goalsFor = [NSNumber numberWithInt:([currTeam.goalsFor intValue] + [currMatch.homeGoals intValue])];
                        currTeam.goalsAgainst = [NSNumber numberWithInt:([currTeam.goalsAgainst intValue] + [currMatch.awayGoals intValue])];
                        if ([currMatch.homeGoals intValue] > [currMatch.awayGoals intValue]) {
                            currTeam.wins = [NSNumber numberWithInt:([currTeam.wins intValue] + 1)];
                            currTeam.points = [NSNumber numberWithInt:([currTeam.points intValue] + 3)];
                        } else if([currMatch.homeGoals intValue] == [currMatch.awayGoals intValue]) {
                            currTeam.draws = [NSNumber numberWithInt:([currTeam.draws intValue] + 1)];
                            currTeam.points = [NSNumber numberWithInt:([currTeam.points intValue] + 1)];
                        } else {
                            currTeam.losses = [NSNumber numberWithInt:([currTeam.losses intValue] + 1)];
                        }
                    } else if ([currTeam.teamName isEqualToString:currMatch.awayTeam]) {
                        currTeam.goalsFor = [NSNumber numberWithInt:([currTeam.goalsFor intValue] + [currMatch.awayGoals intValue])];
                        currTeam.goalsAgainst = [NSNumber numberWithInt:([currTeam.goalsAgainst intValue] + [currMatch.homeGoals intValue])];
                        if ([currMatch.awayGoals intValue] > [currMatch.homeGoals intValue]) {
                            currTeam.points = [NSNumber numberWithInt:([currTeam.points intValue] + 3)];
                            currTeam.wins = [NSNumber numberWithInt:([currTeam.wins intValue] + 1)];
                        } else if([currMatch.awayGoals intValue] == [currMatch.homeGoals intValue]) {
                            currTeam.points = [NSNumber numberWithInt:([currTeam.points intValue] + 1)];
                            currTeam.draws = [NSNumber numberWithInt:([currTeam.draws intValue] + 1)];
                        } else {
                            currTeam.losses = [NSNumber numberWithInt:([currTeam.losses intValue] + 1)];
                        }
                    }
                }
            }
            [self.myDelegate secondViewControllerDismissed];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)myBackButtonPressed {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma TableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GoalsAndAssists";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger goalTag = 1;
    NSInteger assistTag = 2;
    
    NSString *goalScorer = [[self.goalsAndAssists objectAtIndex:(indexPath.row*2)] name];
    NSString *goalAssist = [[self.goalsAndAssists objectAtIndex:(indexPath.row*2 + 1)] name];
    
    ((UILabel *)[cell viewWithTag:goalTag]).text = goalScorer;
    ((UILabel *)[cell viewWithTag:assistTag]).text = goalAssist;

    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.goalsAndAssists count]/2;
}


@end
