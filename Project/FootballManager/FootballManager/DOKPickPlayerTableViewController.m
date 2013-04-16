//
//  DOKFormationTableViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 14/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKPickPlayerTableViewController.h"
#import "DOKPlayerDetailViewController.h"

@interface DOKPickPlayerTableViewController ()

@property (nonatomic, retain) NSString *currentFormation;

@end

@implementation DOKPickPlayerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.originalPlayer = self.thisPlayer;

//    self.formations = [NSMutableArray array];
    
    self.currentFormation = [[NSUserDefaults standardUserDefaults] objectForKey:@"Formation"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        DOKPlayerModel *playerToRemove;
        DOKPlayerModel *playerToPick;
        for (DOKPlayerModel *currPlayer in self.players) {
            if ([self.thisPlayer isEqualToString:[currPlayer name]]) {
                playerToPick = currPlayer;
            }
            if ([self.originalPlayer isEqualToString:[currPlayer name]]) {
                playerToRemove = currPlayer;
            }
             
        }
        [self.pickPlayerDelegate pickPlayerViewControllerPlayerPicked:playerToPick playerRemoved:playerToRemove forTag:self.thisPlayerTag];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"teamName"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Formation Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    DOKPlayerModel *currPlayer = [self.players objectAtIndex:indexPath.row];
    
    
    if ([self.thisPlayer isEqualToString:currPlayer.name]) {
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"check-mark.png"];
    } else
        ((UIImageView *)[cell viewWithTag:1]).image = nil;
    
    ((UILabel *)[cell viewWithTag:2]).text = currPlayer.name;
    ((UILabel *)[cell viewWithTag:3]).text = [DOKPlayerModel preferredPosition:currPlayer];
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

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.thisPlayer = ((UILabel *)[cell viewWithTag:2]).text;
    [self.tableView reloadData];
    // Navigation logic may go here. Create and push another view controller.
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Show Selected Player"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForCell:sender];
        DOKPlayerDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.player = [self.players objectAtIndex:selectedRowIndex.row];
    }
}

@end
