//
//  DOKSquadViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 02/02/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKSquadViewController.h"
#import "DOKPlayerModel.h"
#import "DOKAppDelegate.h"
#import "DOKPlayerDetailViewController.h"

@interface DOKSquadViewController ()

@property NSMutableArray *playersInTeam;

@end

@implementation DOKSquadViewController

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
    self.playersInTeam = [[NSMutableArray alloc] init];
    NSError *error;
    
    
    //NSString *name = [defaults objectForKey:@"name"];
    if (self.teamName.length == 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.teamName = [defaults objectForKey:@"teamName"];
    }
    
    
    NSFetchRequest *fetchRequestImages = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityImages = [NSEntityDescription entityForName:@"Players"
                                                    inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]];
    [fetchRequestImages setEntity:entityImages];
    NSArray *fetchedObjectsImages = [[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:fetchRequestImages error:&error];
    for (DOKPlayerModel *info in fetchedObjectsImages) {
        if([self.teamName isEqualToString:info.teamName])
            [self.playersInTeam addObject:info];
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
    return [self.playersInTeam count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.playersInTeam objectAtIndex:indexPath.row] name];
    
    int overall = [[[self.playersInTeam objectAtIndex:indexPath.row] offensivePositioning] intValue] + [[[self.playersInTeam objectAtIndex:indexPath.row] defensivePositioning] intValue] +[[[self.playersInTeam objectAtIndex:indexPath.row] strength] intValue] +[[[self.playersInTeam objectAtIndex:indexPath.row] stamina] intValue] +[[[self.playersInTeam objectAtIndex:indexPath.row] speed] intValue] +[[[self.playersInTeam objectAtIndex:indexPath.row] tackling] intValue] +[[[self.playersInTeam objectAtIndex:indexPath.row] goalkeeping] intValue] +[[[self.playersInTeam objectAtIndex:indexPath.row] shooting] intValue] +[[[self.playersInTeam objectAtIndex:indexPath.row] passing] intValue] +[[[self.playersInTeam objectAtIndex:indexPath.row] dribbling] intValue] +[[[self.playersInTeam objectAtIndex:indexPath.row] composure] intValue];
    
    if (overall < 98) {
        cell.imageView.image = [UIImage imageNamed:@"1StarSmall"];
    } else if (overall < 122) {
        cell.imageView.image = [UIImage imageNamed:@"2StarsSmall"];
    } else if (overall < 146) {
        cell.imageView.image = [UIImage imageNamed:@"3StarsSmall"];
    } else if (overall < 170) {
        cell.imageView.image = [UIImage imageNamed:@"4StarsSmall"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"5StarsSmall"];
    }
    
    //[cell addSubview:self.starImage];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DOKPlayerDetailViewController *detailViewController = [[DOKPlayerDetailViewController alloc] init];
    detailViewController.player = [self.playersInTeam objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"ShowSelectedPlayer"]) {
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        DOKPlayerDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.player = [self.playersInTeam objectAtIndex:selectedRowIndex.row];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
