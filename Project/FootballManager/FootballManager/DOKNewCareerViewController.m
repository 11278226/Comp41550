//
//  DOKNewCareerViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 18/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKAppDelegate.h"
#import "DOKTeamModel.h"
#import "DOKPlayerModel.h"
#import "DOKNewCareerViewController.h"
#import "DOKMatchModel.h"
#import "DOKMatch.h"
#import "DOKTabBarViewController.h"
#import "Flurry.h"

@interface DOKNewCareerViewController () {
    UIActionSheet *actionSheet;
}

@property (nonatomic, weak) IBOutlet UITextField *division;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *teamNameField;
@property (weak, nonatomic) IBOutlet UITextField *numberOfDivisions;
- (IBAction)changeNumberOfDivisions:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UIStepper *divisionStepper;
- (IBAction)changeTeamDivision:(UIStepper *)sender;
- (IBAction)generateCareer:(UIButton *)sender;
@property (nonatomic) NSMutableArray *teams;
- (IBAction)chooseTeam:(UIButton *)sender;
@property (nonatomic) NSMutableArray *fetchedTeams;
@property (weak, nonatomic) IBOutlet UIButton *chooseTeamButton;

@end

@implementation DOKNewCareerViewController

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
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)changeNumberOfDivisions:(UIStepper *)sender {
    int value = [sender value];
    //[self.divisionModel setNumberOfSides:value];
    
    if(self.divisionStepper.maximumValue > value) {
        
        self.division.text = [NSString stringWithFormat:@"%d",value];
    }
    self.divisionStepper.maximumValue = value;
    self.numberOfDivisions.text = [NSString stringWithFormat:@"%d",value];
}

-(void)dismissActionSheet:(id)sender {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dismissKeyboard {
    [self.division resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.teamNameField resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.teams count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.teams objectAtIndex:row] teamName];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.teamNameField.text = [[self.teams objectAtIndex:row] teamName];
    [self.chooseTeamButton setTitle:[[self.teams objectAtIndex:row] teamName] forState:UIControlStateHighlighted];
    [self.chooseTeamButton setTitle:[[self.teams objectAtIndex:row] teamName] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeTeamDivision:(UIStepper *)sender {
    int value = [sender value];
    self.division.text = [NSString stringWithFormat:@"%d",value];
}

- (IBAction)generateCareer:(UIButton *)sender {
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (self.nameField.text.length > 0 && self.teamNameField.text.length > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:self.nameField.text forKey:@"name"];
        [defaults setValue:self.teamNameField.text forKey:@"teamName"];
        [defaults setValue:self.numberOfDivisions.text forKey:@"numberOfDivisions"];
        [defaults setValue:self.division.text forKey:@"division"];
        [defaults setValue:nil forKey:@"myTeam"];
        [defaults setValue:[NSNumber numberWithInt:1] forKey:@"gameWeek"];
        [defaults setBool:NO forKey:@"Instant Matches"];
        [defaults setBool:YES forKey:@"Perfect Scouting"];
        [defaults setValue:@"2-3-1" forKey:@"Formation"];
        [defaults synchronize];
        NSLog(@"Data saved");
        [self generateMatchesForTeams:self.fetchedTeams];
        NSDictionary *myFlurryDict = [NSDictionary dictionaryWithObjectsAndKeys:self.nameField.text, @"Name", self.teamNameField.text, @"Team", nil];
        [Flurry logEvent:@"Started Career" withParameters:myFlurryDict];
        
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
    
    NSError * error = nil;
    NSArray * team = [[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:allTeams error:&error];
    //error handling goes here
    for (DOKTeamModel * thisTeam in team) {
        thisTeam.goalsFor = [NSNumber numberWithInt:0];
        thisTeam.goalsAgainst = [NSNumber numberWithInt:0];
        thisTeam.points = [NSNumber numberWithInt:0];
        thisTeam.wins = [NSNumber numberWithInt:0];
        thisTeam.draws = [NSNumber numberWithInt:0];
        thisTeam.losses = [NSNumber numberWithInt:0];
        [[DOKAppDelegate sharedAppDelegate] managedObjectContext];
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

- (void)generateMatchesForTeams:(NSMutableArray *)teams
{
    [self removeAllMatches];
    [self resetTeams];
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
                [matches addObject:newMatch];
                NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Match"
                                                                        inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]];
                
                [object setValue:newMatch.homeTeam forKey:@"homeTeam"];
                [object setValue:newMatch.awayTeam forKey:@"awayTeam"];
                [object setValue:newMatch.gameWeek forKey:@"gameWeek"];
                
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
                [matches addObject:newMatch];
                NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Match"
                                                                        inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]];
                
                [object setValue:newMatch.homeTeam forKey:@"homeTeam"];
                [object setValue:newMatch.awayTeam forKey:@"awayTeam"];
                [object setValue:newMatch.gameWeek forKey:@"gameWeek"];
                
                NSError *error;
                if (![[[DOKAppDelegate sharedAppDelegate] managedObjectContext] save:&error]) {
                    NSLog(@"Failed to save - error: %@", [error localizedDescription]);
                }
            }
        }
    }
//    for (DOKMatchModel *match in matches) {
//        NSLog(@"Week %@: %@ vs %@",match.gameWeek , match.homeTeam, match.awayTeam);
//    }
    
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

- (IBAction)chooseTeam:(UIButton *)sender {
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    UIPickerView *pickerView2 = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView2.showsSelectionIndicator = YES;
    pickerView2.dataSource = self;
    pickerView2.delegate = self;
    
    [actionSheet addSubview:pickerView2];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"new"]) {
        
        DOKTabBarViewController *destinationVC = [segue destinationViewController];
        destinationVC.futureDelegate = self;
//
//        [self.navigationController pushViewController:destinationVC animated:YES];
    }
}

- (void)popToRootView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}


@end
