//
//  DOKPlayerDetailViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 02/02/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKPlayerDetailViewController.h"
#import "DOKPlayerModel+Details.h"

@interface DOKPlayerDetailViewController ()

@end

@implementation DOKPlayerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [self.player name];
}

- (void)viewWillAppear:(BOOL)animated {
    // Update the view with current data before it is displayed.
    [super viewWillAppear:animated];
    
    // Scroll the table view to the top before it appears
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
    self.title = self.player.name;
    
//    int overall = [[self.player overall] intValue];
    int overall = [DOKPlayerModel overallForPlayer:self.player];
    if (overall < 98) {
        NSLog(@"One Star");
    } else if (overall < 122) {
        NSLog(@"Two Star");
    } else if (overall < 146) {
        NSLog(@"Three Star");
    } else if (overall < 170) {
        NSLog(@"Four Star");
    } else {
        NSLog(@"Five Star");
    }    
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There are three sections, for date, genre, and characters, in that order.
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            // For genre and date there is just one row.
            rows = 1;
            break;
        case 2:
            // For genre and date there is just one row.
            rows = 1;
            break;
        case 3:
            // For genre and date there is just one row.
            rows = 11;
            break;
        default:
            break;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Set the text in the cell for the section/row.
    
    NSString *cellText = nil;
    
    switch (indexPath.section) {
        case 0:
            [cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
            [cell.textLabel setNumberOfLines:1];
            cellText = self.player.name;
            break;
        case 1:
            [cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:12]];
            [cell.textLabel setNumberOfLines:2];
            cellText = [self strengths];
            break;
        case 2:
            [cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:12]];
            [cell.textLabel setNumberOfLines:2];
            cellText = [self weaknesses];
            break;
        case 3:
            [cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
            [cell.textLabel setNumberOfLines:1];
            switch (indexPath.row) {
                    
                case 0:
                    cellText = [NSString stringWithFormat:@"Offensive Positioning: %@",self.player.offensivePositioning];
                    break;
                case 1:
                    cellText = [NSString stringWithFormat:@"Defensive Positioning: %@",self.player.defensivePositioning];
                    break;
                case 2:
                    cellText = [NSString stringWithFormat:@"Strength: %@",self.player.strength];
                    break;
                case 3:
                    cellText = [NSString stringWithFormat:@"Shooting: %@",self.player.shooting];
                    break;
                case 4:
                    cellText = [NSString stringWithFormat:@"Tackling: %@",self.player.tackling];
                    break;
                case 5:
                    cellText = [NSString stringWithFormat:@"Goalkeeping: %@",self.player.goalkeeping];
                    break;
                case 6:
                    cellText = [NSString stringWithFormat:@"Passing: %@",self.player.passing];
                    break;
                case 7:
                    cellText = [NSString stringWithFormat:@"Dribbling: %@",self.player.dribbling];
                    break;
                case 8:
                    cellText = [NSString stringWithFormat:@"Speed: %@",self.player.speed];
                    break;
                case 9:
                    cellText = [NSString stringWithFormat:@"Stamina: %@",self.player.stamina];
                    break;
                case 10:
                    cellText = [NSString stringWithFormat:@"Composure: %@",self.player.composure];
                    break;
                default:
                    break;
            }
            cell.detailTextLabel.text = @"SD";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = cellText;
    return cell;
}


#pragma mark -
#pragma mark Section header titles

/*
 HIG note: In this case, since the content of each section is obvious, there's probably no need to provide a title, but the code is useful for illustration.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = @"Name";
            break;
        case 1:
            title = @"Strengths";
            break;
        case 2:
            title = @"Weaknesses";
            break;
        case 3:
            title = @"Attributes";
            break;
        default:
            break;
    }
    return title;
}

-(NSString *)strengths {
    NSString *ans = @"";
    if ([self.player.offensivePositioning intValue] > 15) {
        ans = [ans stringByAppendingString:@"Offensive Positioning, "];
    }
    if ([self.player.defensivePositioning intValue] > 15) {
        ans = [ans stringByAppendingString:@"Defensive Positioning, "];
    }
    if ([self.player.strength intValue] > 15) {
        ans = [ans stringByAppendingString:@"Strength, "];
    }
    if ([self.player.shooting intValue] > 15) {
        ans = [ans stringByAppendingString:@"Shooting, "];
    }
    if ([self.player.tackling intValue] > 15) {
        ans = [ans stringByAppendingString:@"Tackling, "];
    }
    if ([self.player.goalkeeping intValue] > 15) {
        ans = [ans stringByAppendingString:@"Goalkeeping, "];
    }
    if ([self.player.passing intValue] > 15) {
        ans = [ans stringByAppendingString:@"Passing, "];
    }
    if ([self.player.dribbling intValue] > 15) {
        ans = [ans stringByAppendingString:@"Dribbling, "];
    }
    if ([self.player.speed intValue] > 15) {
        ans = [ans stringByAppendingString:@"Speed, "];
    }
    if ([self.player.stamina intValue] > 15) {
        ans = [ans stringByAppendingString:@"Stamina, "];
    }
    if ([self.player.composure intValue] > 15) {
        ans = [ans stringByAppendingString:@"Composure, "];
    }
    
    if (ans.length > 0) {
        ans = [ans substringToIndex:[ans length] - 2];
    }
    
    return ans;
}

-(NSString *)weaknesses {
    NSString *ans = @"";
    if ([self.player.offensivePositioning intValue] < 5) {
        ans = [ans stringByAppendingString:@"Offensive Positioning, "];
    }
    if ([self.player.defensivePositioning intValue] < 5) {
        ans = [ans stringByAppendingString:@"Defensive Positioning, "];
    }
    if ([self.player.strength intValue] < 5) {
        ans = [ans stringByAppendingString:@"Strength, "];
    }
    if ([self.player.shooting intValue] < 5) {
        ans = [ans stringByAppendingString:@"Shooting, "];
    }
    if ([self.player.tackling intValue] < 5) {
        ans = [ans stringByAppendingString:@"Tackling, "];
    }
    if ([self.player.goalkeeping intValue] < 5) {
        ans = [ans stringByAppendingString:@"Goalkeeping, "];
    }
    if ([self.player.passing intValue] < 5) {
        ans = [ans stringByAppendingString:@"Passing, "];
    }
    if ([self.player.dribbling intValue] < 5) {
        ans = [ans stringByAppendingString:@"Dribbling, "];
    }
    if ([self.player.speed intValue] < 5) {
        ans = [ans stringByAppendingString:@"Speed, "];
    }
    if ([self.player.stamina intValue] < 5) {
        ans = [ans stringByAppendingString:@"Stamina, "];
    }
    if ([self.player.composure intValue] < 5) {
        ans = [ans stringByAppendingString:@"Composure, "];
    }
    
    if (ans.length > 0) {
        ans = [ans substringToIndex:[ans length] - 2];
    }
    return ans;
}


@end
