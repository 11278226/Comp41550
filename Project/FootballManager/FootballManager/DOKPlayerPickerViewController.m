//
//  DOKPlayerPickerViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 02/02/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKPlayerPickerViewController.h"
#import "DOKAppDelegate.h"
#import "DOKPlayerModel.h"
#import "DOKTeamModel.h"

@interface DOKPlayerPickerViewController ()

@end

@implementation DOKPlayerPickerViewController

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
    self.myTeamPlayers = [[NSMutableArray alloc] init];
    NSError *error;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSString *name = [defaults objectForKey:@"name"];
    NSString *teamName = [defaults objectForKey:@"teamName"];
    
    NSFetchRequest *fetchRequestImages = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityImages = [NSEntityDescription entityForName:@"Players"
                                                    inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]];
    [fetchRequestImages setEntity:entityImages];
    NSArray *fetchedObjectsImages = [[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:fetchRequestImages error:&error];
    for (DOKPlayerModel *info in fetchedObjectsImages) {
        if([teamName isEqualToString:info.teamName])
            [self.myTeamPlayers addObject:info];
    }

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.myTeamPlayers count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.myTeamPlayers objectAtIndex:row] name];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //self.teamNameField.text = [[self.teams objectAtIndex:row] name];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    int overall = [[[self.myTeamPlayers objectAtIndex:row] offensivePositioning] intValue] + [[[self.myTeamPlayers objectAtIndex:row] defensivePositioning] intValue] +[[[self.myTeamPlayers objectAtIndex:row] strength] intValue] +[[[self.myTeamPlayers objectAtIndex:row] stamina] intValue] +[[[self.myTeamPlayers objectAtIndex:row] speed] intValue] +[[[self.myTeamPlayers objectAtIndex:row] tackling] intValue] +[[[self.myTeamPlayers objectAtIndex:row] goalkeeping] intValue] +[[[self.myTeamPlayers objectAtIndex:row] shooting] intValue] +[[[self.myTeamPlayers objectAtIndex:row] passing] intValue] +[[[self.myTeamPlayers objectAtIndex:row] dribbling] intValue] +[[[self.myTeamPlayers objectAtIndex:row] composure ]intValue];
    view =nil;
    UIView *myView = view;
    if (myView == nil) {
        myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 280, 30)];
    }
    UILabel *pickerLabel;
    //if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 200, 32);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    //}
    
    [pickerLabel setText:[[self.myTeamPlayers objectAtIndex:row] name]];
    UIImageView *temp;
    temp = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 80, 20)];
    
    if (overall < 98) {
        temp.image = [UIImage imageNamed:@"1StarSmall"];
    } else if (overall < 122) {
        temp.image = [UIImage imageNamed:@"2StarsSmall"];
    } else if (overall < 146) {
        temp.image = [UIImage imageNamed:@"3StarsSmall"];
    } else if (overall < 170) {
        temp.image = [UIImage imageNamed:@"4StarsSmall"];
    } else {
        temp.image = [UIImage imageNamed:@"5StarsSmall"];
    }
                          
    [myView addSubview:temp];
    [myView addSubview:pickerLabel];

    return myView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
