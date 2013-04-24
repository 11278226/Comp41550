//
//  DOKStatsTableViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 20/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKStatsTableViewController.h"
#import "DOKLeagueTableViewController.h"
#import "DOKGoalsLeaderBoardViewController.h"

@interface DOKStatsTableViewController ()



@end

@implementation DOKStatsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grid_pattern.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"statsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (((UIImageView *)[cell viewWithTag:1]).image == nil) {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"arrow_right.png"];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"League Table";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Goals Leaderboard";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Assists Leaderboard";
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if (indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"leagueTableSegue" sender:self];
    } else if(indexPath.row == 1)
    {
        [self performSegueWithIdentifier:@"playerLeaderBoardSegue" sender:self];
    } else if(indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"playerLeaderBoardSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"leagueTableSegue"]) {
        
//        DOKLeagueTableViewController *vc = [segue destinationViewController];
        
        
    } else if ([[segue identifier] isEqualToString:@"playerLeaderBoardSegue"]) {
        DOKGoalsLeaderBoardViewController *vc = [segue destinationViewController];
        if (path.row == 2) {
            vc.isAssists = YES;
        }
    } 
}

@end
