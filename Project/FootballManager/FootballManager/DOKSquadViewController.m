//
//  DOKSquadViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 02/02/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKSquadViewController.h"
#import "DOKPlayerModel+Details.h"
#import "DOKAppDelegate.h"
#import "DOKPlayerDetailViewController.h"
#import "DOKPlayerPageViewController.h"

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
    self.navigationItem.title = self.teamName;
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
    DOKPlayerModel *currPlayer = [self.playersInTeam objectAtIndex:indexPath.row];
    cell.textLabel.text = [currPlayer name];
    
    int overall = [DOKPlayerModel overallForPlayer:currPlayer];
    
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
        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DOKPlayerPageViewController *detailViewController = [[DOKPlayerPageViewController alloc] init];
    detailViewController.player = [self.playersInTeam objectAtIndex:indexPath.row];
    detailViewController.playerArray = self.playersInTeam;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
//    DOKPlayerDetailViewController *detailViewController = [[DOKPlayerDetailViewController alloc] init];
//    detailViewController.player = [self.playersInTeam objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:detailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
//    if ([[segue identifier] isEqualToString:@"ShowSelectedPlayer"]) {
//        
//        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
//        DOKPlayerDetailViewController *detailViewController = [segue destinationViewController];
//        detailViewController.player = [self.playersInTeam objectAtIndex:selectedRowIndex.row];
//    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
