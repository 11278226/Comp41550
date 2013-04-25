//
//  DOKSettingsViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 13/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKSettingsViewController.h"
#import "DOKViewController.h"

@interface DOKSettingsViewController ()
- (IBAction)cellSwitchButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event;

@end

@implementation DOKSettingsViewController

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Basic Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Exit Game";
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Instant Matches";
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            ((UISwitch *)[cell viewWithTag:2]).hidden = NO;
            [((UISwitch *)[cell viewWithTag:2]) setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"Instant Matches"]];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Perfect Scouting";
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            ((UISwitch *)[cell viewWithTag:2]).hidden = NO;
            [((UISwitch *)[cell viewWithTag:2]) setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"Perfect Scouting"]];
        }
        
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
    if (indexPath.section == 0) {
        if ([self.myDelegate respondsToSelector:@selector(popToRootView)])
            [self.myDelegate popToRootView];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)cellSwitchButtonPressed:(UISwitch *)sender forEvent:(UIEvent *)event {
    
    UITableViewCell *myCell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:myCell];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.row == 0) {
        if ([sender isOn])
            [defaults setBool:YES forKey:@"Instant Matches"];
        else
            [defaults setBool:NO forKey:@"Instant Matches"];
    } else if (indexPath.row == 1) {
        if ([sender isOn])
            [defaults setBool:YES forKey:@"Perfect Scouting"];
        else
            [defaults setBool:NO forKey:@"Perfect Scouting"];
    }
    [defaults synchronize];
}
@end
