//
//  DOKOtherTeamsViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 03/02/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKOtherTeamsViewController.h"
#import "DOKSquadViewController.h"
#import "DOKTeamModel.h"
#import "DOKAppDelegate.h"

@interface DOKOtherTeamsViewController ()

@property NSMutableArray *teams;

@end

@implementation DOKOtherTeamsViewController

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
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grid_pattern.png"]];
    self.teams = [[NSMutableArray alloc] init];
    NSError *error;
    NSFetchRequest *fetchRequestImages = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityImages = [NSEntityDescription entityForName:@"Teams"
                                                    inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]];
    [fetchRequestImages setEntity:entityImages];
    NSArray *fetchedObjectsImages = [[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:fetchRequestImages error:&error];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *teamName = [defaults objectForKey:@"teamName"];
    
    for (DOKTeamModel *info in fetchedObjectsImages) {
//        if(![teamName isEqualToString:info.teamName])
            [self.teams addObject:info];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.teams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TeamCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (((UIImageView *)[cell viewWithTag:1]).image == nil) {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"arrow_right.png"];
    }
    
    cell.textLabel.text = [[self.teams objectAtIndex:indexPath.row] teamName];
    if ([cell.textLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"teamName"]]) 
        cell.textLabel.textColor = [UIColor yellowColor];
    else
        cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Perfect Scouting"]) {
        DOKSquadViewController *detailViewController = [[DOKSquadViewController alloc] init];
        detailViewController.teamName = [[self.teams objectAtIndex:indexPath.row] teamName];
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    } else {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"teamName"] isEqualToString:[[self.teams objectAtIndex:indexPath.row] teamName]]) {
            DOKSquadViewController *detailViewController = [[DOKSquadViewController alloc] init];
            detailViewController.teamName = [[self.teams objectAtIndex:indexPath.row] teamName];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"ShowSelectedTeam"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        
            DOKSquadViewController *detailViewController = [segue destinationViewController];
            detailViewController.teamName = [[self.teams objectAtIndex:selectedRowIndex.row] teamName];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
