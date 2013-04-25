//
//  DOKEndSeasonViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 25/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKEndSeasonViewController.h"
#import "DOKTeamModel+LeagueTable.h"
#import "DOKAppDelegate.h"
#import "Flurry.h"
#import "DOKPlayerModel+Details.h"
#import "DOKMatch.h"

@interface DOKEndSeasonViewController ()
@property (nonatomic) NSMutableArray *teams;
@property (nonatomic) NSMutableArray *fetchedTeams;
@end

@implementation DOKEndSeasonViewController

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
    self.teams = [[NSMutableArray alloc] init];
    NSError *error;
    
    NSFetchRequest *fetchRequestImages = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityImages = [NSEntityDescription entityForName:@"Teams"
                                                    inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]];
    [fetchRequestImages setEntity:entityImages];
    self.fetchedTeams = [[[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:fetchRequestImages error:&error] mutableCopy];
    for (DOKTeamModel *info in self.fetchedTeams) {
        [self.teams addObject:info];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (true) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSNumber numberWithInt:1] forKey:@"gameWeek"];
        [defaults synchronize];
        NSMutableArray *leagueOneTeams = [NSMutableArray array];
        NSMutableArray *leagueTwoTeams = [NSMutableArray array];
        NSMutableArray *leagueThreeTeams = [NSMutableArray array];
        NSMutableArray *leagueFourTeams = [NSMutableArray array];
        [self removeAllMatches];
        [self resetTeams];
        [self resetPlayers];
        for (DOKTeamModel *currTeam in self.fetchedTeams) {
            switch ([currTeam.league intValue]) {
                case 1:
                    [leagueOneTeams addObject:currTeam];
                    break;
                case 2:
                    [leagueTwoTeams addObject:currTeam];
                    break;
                case 3:
                    [leagueThreeTeams addObject:currTeam];
                    break;
                case 4:
                    [leagueFourTeams addObject:currTeam];
                    break;
                default:
                    break;
            }
        }
        for (int i = 1; i < 5 ; i++) {
            switch (i) {
                case 1:
                    [self generateMatchesForTeams:leagueOneTeams inLeague:i];
                    break;
                case 2:
                    [self generateMatchesForTeams:leagueTwoTeams inLeague:i];
                    break;
                case 3:
                    [self generateMatchesForTeams:leagueThreeTeams inLeague:i];
                    break;
                case 4:
                    [self generateMatchesForTeams:leagueFourTeams inLeague:i];
                    break;
                default:
                    break;
            }
            
        }
        
//        NSDictionary *myFlurryDict = [NSDictionary dictionaryWithObjectsAndKeys:self.nameField.text, @"Name", self.teamNameField.text, @"Team", nil];
//        [Flurry logEvent:@"Started Career" withParameters:myFlurryDict];
        
    } else {
        UIAlertView *noDataEntered = [[UIAlertView alloc] initWithTitle:@"Empty Text Fields" message:@"Please enter text into the fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noDataEntered show];
        return NO;
    }
    
    return YES;
}

- (void) resetTeams {
    NSFetchRequest * allTeams = [[NSFetchRequest alloc] init];
    [allTeams setEntity:[NSEntityDescription entityForName:@"Teams" inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]]];
    //    [allTeams setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    allTeams.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"points"
                                                                                      ascending:NO
                                                                                       selector:nil],[NSSortDescriptor sortDescriptorWithKey:@"goalsFor"                                                          ascending:NO                                                        selector:nil], nil];
    NSError * error = nil;
    NSArray * team = [[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:allTeams error:&error];
    int leagueOneCount = 0;
    int leagueTwoCount = 0;
    int leagueThreeCount = 0;
    int leagueFourCount = 0;
    for (DOKTeamModel * thisTeam in team) {
        thisTeam.goalsFor = [NSNumber numberWithInt:0];
        thisTeam.goalsAgainst = [NSNumber numberWithInt:0];
        thisTeam.points = [NSNumber numberWithInt:0];
        thisTeam.wins = [NSNumber numberWithInt:0];
        thisTeam.draws = [NSNumber numberWithInt:0];
        thisTeam.losses = [NSNumber numberWithInt:0];
        if ([thisTeam.league intValue] == 1) {
            if (leagueOneCount == 7) {
                thisTeam.league = [NSNumber numberWithInt:2];
            }
            leagueOneCount +=1;
        } else if ([thisTeam.league intValue] == 2) {
            if (leagueTwoCount == 0) {
                thisTeam.league = [NSNumber numberWithInt:1];
            } else if (leagueTwoCount == 7) {
                thisTeam.league = [NSNumber numberWithInt:3];
            }
            leagueTwoCount +=1;
        } else if ([thisTeam.league intValue] == 3) {
            if (leagueThreeCount == 0) {
                thisTeam.league = [NSNumber numberWithInt:2];
            } else if (leagueThreeCount == 7) {
                thisTeam.league = [NSNumber numberWithInt:4];
            }
            leagueThreeCount +=1;
        } else if ([thisTeam.league intValue] == 4) {
            if (leagueFourCount == 0) {
                thisTeam.league = [NSNumber numberWithInt:3];
            } 
            leagueFourCount +=1;
        }
    }
    
    
    NSError *saveError = nil;
    if (![[[DOKAppDelegate sharedAppDelegate] managedObjectContext] save:&saveError]) {
        NSLog(@"Failed to remove all matches - error: %@", [error localizedDescription]);
    }
}

- (void) resetPlayers {
    NSFetchRequest * allTeams = [[NSFetchRequest alloc] init];
    [allTeams setEntity:[NSEntityDescription entityForName:@"Players" inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]]];
    //    [allTeams setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * team = [[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:allTeams error:&error];
    //error handling goes here
    for (DOKPlayerModel * thisTeam in team) {
        thisTeam.goals = [NSNumber numberWithInt:0];
        thisTeam.assists = [NSNumber numberWithInt:0];
    }
    NSError *saveError = nil;
    if (![[[DOKAppDelegate sharedAppDelegate] managedObjectContext] save:&saveError]) {
        NSLog(@"Failed to remove all matches - error: %@", [error localizedDescription]);
    }
}

- (void) removeAllMatches {
    NSFetchRequest * allMatches = [[NSFetchRequest alloc] init];
    [allMatches setEntity:[NSEntityDescription entityForName:@"Match" inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]]];
    [allMatches setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * mtch = [[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:allMatches error:&error];
    //error handling goes here
    for (NSManagedObject * matc in mtch) {
        [[[DOKAppDelegate sharedAppDelegate] managedObjectContext] deleteObject:matc];
    }
    NSError *saveError = nil;
    if (![[[DOKAppDelegate sharedAppDelegate] managedObjectContext] save:&saveError]) {
        NSLog(@"Failed to remove all matches - error: %@", [error localizedDescription]);
    }
}

- (void)generateMatchesForTeams:(NSMutableArray *)teams inLeague:(int)league
{
    
    NSMutableArray *matches = [NSMutableArray array];
    NSMutableArray *filteredTeams = [NSMutableArray array];
    
    filteredTeams = [teams mutableCopy];
    for (int i=0;i<[teams count];i++) {
        DOKTeamModel *myHomeTeam = [teams objectAtIndex:i];
        [filteredTeams removeObject:myHomeTeam];
        for (int j=0; j < [filteredTeams count]; j++) {
            DOKTeamModel *myAwayTeam = [filteredTeams objectAtIndex:j];
            if (![myHomeTeam isEqual:myAwayTeam]) {
                int gameWeek = [self findNextEmptyGameWeekForHomeTeam:myHomeTeam andAwayTeam:myAwayTeam inMatches:matches];
                DOKMatch *newMatch = [[DOKMatch alloc] init];
                newMatch.homeTeam = myHomeTeam.teamName;
                newMatch.awayTeam = myAwayTeam.teamName;
                newMatch.gameWeek = [NSNumber numberWithInt:gameWeek];
                newMatch.league = [NSNumber numberWithInt:league];
                [matches addObject:newMatch];
                NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Match"
                                                                        inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]];
                
                [object setValue:newMatch.homeTeam forKey:@"homeTeam"];
                [object setValue:newMatch.awayTeam forKey:@"awayTeam"];
                [object setValue:newMatch.gameWeek forKey:@"gameWeek"];
                [object setValue:newMatch.league forKey:@"league"];
                
                NSError *error;
                if (![[[DOKAppDelegate sharedAppDelegate] managedObjectContext] save:&error]) {
                    NSLog(@"Failed to save - error: %@", [error localizedDescription]);
                }
            }
        }
    }
    
    filteredTeams = [teams mutableCopy];
    for (int i=[teams count]-1;i>-1;i--) {
        DOKTeamModel *myHomeTeam = [teams objectAtIndex:i];
        [filteredTeams removeObject:myHomeTeam];
        for (int j=[filteredTeams count]-1; j>-1; j--) {
            DOKTeamModel *myAwayTeam = [filteredTeams objectAtIndex:j];
            if (![myHomeTeam isEqual:myAwayTeam]) {
                int gameWeek = [self findNextEmptyGameWeekForHomeTeam:myHomeTeam andAwayTeam:myAwayTeam inMatches:matches];
                DOKMatch *newMatch = [[DOKMatch alloc] init];
                newMatch.homeTeam = myHomeTeam.teamName;
                newMatch.awayTeam = myAwayTeam.teamName;
                newMatch.gameWeek = [NSNumber numberWithInt:gameWeek];
                newMatch.league = [NSNumber numberWithInt:league];
                [matches addObject:newMatch];
                NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Match"
                                                                        inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]];
                
                [object setValue:newMatch.homeTeam forKey:@"homeTeam"];
                [object setValue:newMatch.awayTeam forKey:@"awayTeam"];
                [object setValue:newMatch.gameWeek forKey:@"gameWeek"];
                [object setValue:newMatch.league forKey:@"league"];
                
                NSError *error;
                if (![[[DOKAppDelegate sharedAppDelegate] managedObjectContext] save:&error]) {
                    NSLog(@"Failed to save - error: %@", [error localizedDescription]);
                }
            }
        }
    }
}

- (int)findNextEmptyGameWeekForHomeTeam:(DOKTeamModel *)homeTeam andAwayTeam:(DOKTeamModel *)awayTeam inMatches:(NSMutableArray *)matches
{
    for (int i=1;i<[self.teams count]*2-1;i++) {
        BOOL valid = true;
        for (DOKMatch *thisMatch in matches) {
            if ([thisMatch.gameWeek intValue] == i) {
                
                if ([thisMatch.homeTeam isEqualToString:homeTeam.teamName] || [thisMatch.awayTeam isEqualToString:homeTeam.teamName] || [thisMatch.homeTeam isEqualToString:awayTeam.teamName] || [thisMatch.awayTeam isEqualToString:awayTeam.teamName]) {
                    valid = false;
                }
            }
        }
        if (valid) {
            return i;
        }
    }
    return nil;
}

@end
