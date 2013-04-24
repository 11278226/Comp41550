//
//  DOKLeagueTableViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 01/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKLeagueTableViewController.h"
#import "DOKAppDelegate.h"
#import "DOKTeamModel+LeagueTable.h"

@interface DOKLeagueTableViewController ()

@end

@implementation DOKLeagueTableViewController

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
    [self setupFetchedResultsController];
    [self fetchTeamData];
}

- (void)setupFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teams"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"points"
                                                                                      ascending:NO
                                                                                       selector:nil],[NSSortDescriptor sortDescriptorWithKey:@"goalsFor"
                                                                                                                                   ascending:NO
                                                                                                                                    selector:nil], nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)fetchTeamData
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
//        NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
//        dispatch_async(dispatch_get_main_queue(),^{
//            for (NSDictionary *flickrInfo in photos) {
//                [Photo photoWithFlickrInfo:flickrInfo inManagedObjectContext:self.managedObjectContext];
//            }
//            [((DOKAppDelegate *)[UIApplication sharedApplication].delegate) saveContext];
        
//        });
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [self tableView:self.tableView viewForHeaderInSection:0];
    [self.tableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 22;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    
    CGRect frame = CGRectMake(0, 0, 30, 22);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.numberOfLines = 1;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
    label.text = @"Pos";
    [headerView addSubview:label];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(orientation == 0 || orientation == UIInterfaceOrientationPortrait) {//Default orientation
        frame = CGRectMake(30, 0, tableView.bounds.size.width - 130 - 40, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"Team";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 150,0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"PLD";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 120,0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"W";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 90, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"D";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 60, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"L";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 30, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"PTS";
        [headerView addSubview:label];
        
    } else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        frame = CGRectMake(30,0, tableView.bounds.size.width - 220 - 40, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"Team";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 240, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"PLD";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 210, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"W";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 180, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"D";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 150, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"L";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 120, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"GF";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 90, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"GA";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 60, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"DIFF";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 30, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"PTS";
        [headerView addSubview:label];
    }
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showCalGradient.png"]];
    imageView.frame = CGRectMake(0, 0, headerView.bounds.size.width, headerView.bounds.size.height);

    [headerView addSubview:imageView];
    [headerView sendSubviewToBack:imageView];
    
     //= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"showCalGradient.png"]];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Table Team Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger positionTag = 1;
    NSInteger titleTag = 2;
    NSInteger playTag = 3;
    NSInteger wonTag = 4;
    NSInteger drewTag = 5;
    NSInteger loseTag = 6;
    NSInteger goalsForTag = 7;
    NSInteger goalsAgainstTag = 8;
    NSInteger goalDifferenceTag = 9;
    NSInteger pointsTag = 10;
    
    if (((UILabel *)[cell viewWithTag:playTag]) == nil) {
        CGRect frame = CGRectMake(tableView.bounds.size.width - 150, 0, 30, 43);
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.backgroundColor = [UIColor clearColor];
        label.tag = playTag;
        label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 120, 0, 30, 43);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.tag = wonTag;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        [cell addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 90, 0, 30, 43);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.tag = drewTag;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        [cell addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 60, 0, 30, 43);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.tag = loseTag;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        [cell addSubview:label];
    }
    
    DOKTeamModel *team = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.textLabel.text = team.teamName;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(orientation == 0 || orientation == UIInterfaceOrientationPortrait) {//Default orientation
        ((UILabel *)[cell viewWithTag:positionTag]).text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        ((UILabel *)[cell viewWithTag:titleTag]).text = [NSString stringWithFormat:@"%@",team.teamName];
        ((UILabel *)[cell viewWithTag:playTag]).text = [NSString stringWithFormat:@"%d",[team.wins intValue] + [team.losses intValue] + [team.draws intValue]];
        ((UILabel *)[cell viewWithTag:wonTag]).text = [NSString stringWithFormat:@"%d",[team.wins intValue]];
        ((UILabel *)[cell viewWithTag:drewTag]).text = [NSString stringWithFormat:@"%d",[team.draws intValue]];
        ((UILabel *)[cell viewWithTag:loseTag]).text = [NSString stringWithFormat:@"%d",[team.losses intValue]];
        ((UILabel *)[cell viewWithTag:pointsTag]).text = [NSString stringWithFormat:@"%@",team.points];
        ((UILabel *)[cell viewWithTag:goalsForTag]).hidden = YES;
        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).hidden = YES;
        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).hidden = YES;
        
    } else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        
        
        ((UILabel *)[cell viewWithTag:positionTag]).text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        ((UILabel *)[cell viewWithTag:titleTag]).text = [NSString stringWithFormat:@"%@",team.teamName];
        ((UILabel *)[cell viewWithTag:playTag]).text = [NSString stringWithFormat:@"%d",[team.wins intValue] + [team.losses intValue] + [team.draws intValue]];
        ((UILabel *)[cell viewWithTag:wonTag]).text = [NSString stringWithFormat:@"%d",[team.wins intValue]];
        ((UILabel *)[cell viewWithTag:drewTag]).text = [NSString stringWithFormat:@"%d",[team.draws intValue]];
        ((UILabel *)[cell viewWithTag:loseTag]).text = [NSString stringWithFormat:@"%d",[team.losses intValue]];
        ((UILabel *)[cell viewWithTag:pointsTag]).text = [NSString stringWithFormat:@"%d",[team.points intValue]];
        ((UILabel *)[cell viewWithTag:goalsForTag]).hidden = NO;
        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).hidden = NO;
        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).hidden = NO;
        ((UILabel *)[cell viewWithTag:goalsForTag]).text = [NSString stringWithFormat:@"%@",team.goalsFor];
        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).text = [NSString stringWithFormat:@"%@",team.goalsAgainst];
        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).text = [NSString stringWithFormat:@"%d",[team.goalsFor intValue] - [team.goalsAgainst intValue]];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *teamName = [defaults objectForKey:@"teamName"];
    if ([team.teamName isEqualToString:teamName]) {
        ((UILabel *)[cell viewWithTag:positionTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:titleTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:playTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:wonTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:drewTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:loseTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:goalsForTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:pointsTag]).textColor = [UIColor yellowColor];
    } else {
        ((UILabel *)[cell viewWithTag:positionTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:titleTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:playTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:wonTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:drewTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:loseTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:goalsForTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:pointsTag]).textColor = [UIColor whiteColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger positionTag = 1;
    NSInteger playTag = 3;
    NSInteger wonTag = 4;
    NSInteger drewTag = 5;
    NSInteger loseTag = 6;
    NSInteger goalsForTag = 7;
    NSInteger goalsAgainstTag = 8;
    NSInteger goalDifferenceTag = 9;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == 0 || orientation == UIInterfaceOrientationPortrait) {//Default orientation
        ((UILabel *)[cell viewWithTag:goalsForTag]).hidden = YES;
        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).hidden = YES;
        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).hidden = YES;
        
        ((UILabel *)[cell viewWithTag:playTag]).frame = CGRectMake(tableView.bounds.size.width - 150, 0, 30, 43);
        ((UILabel *)[cell viewWithTag:wonTag]).frame = CGRectMake(tableView.bounds.size.width - 120, 0, 30, 43);
        ((UILabel *)[cell viewWithTag:drewTag]).frame = CGRectMake(tableView.bounds.size.width - 90, 0, 30, 43);
        ((UILabel *)[cell viewWithTag:loseTag]).frame = CGRectMake(tableView.bounds.size.width - 60, 0, 30, 43);
        
    } else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        
        
        ((UILabel *)[cell viewWithTag:positionTag]).text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        ((UILabel *)[cell viewWithTag:goalsForTag]).hidden = NO;
        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).hidden = NO;
        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).hidden = NO;
        
        ((UILabel *)[cell viewWithTag:playTag]).frame = CGRectMake(tableView.bounds.size.width - 240, 0, 30, 43);
        ((UILabel *)[cell viewWithTag:wonTag]).frame = CGRectMake(tableView.bounds.size.width - 210, 0, 30, 43);
        ((UILabel *)[cell viewWithTag:drewTag]).frame = CGRectMake(tableView.bounds.size.width - 180, 0, 30, 43);
        ((UILabel *)[cell viewWithTag:loseTag]).frame = CGRectMake(tableView.bounds.size.width - 150, 0, 30, 43);
//        ((UILabel *)[cell viewWithTag:goalsForTag]).frame = CGRectMake(tableView.bounds.size.width - 120, 0, 30, 43);
//        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).frame = CGRectMake(tableView.bounds.size.width - 90, 0, 30, 43);
//        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).frame = CGRectMake(tableView.bounds.size.width - 60, 0, 30, 43);
//        ((UILabel *)[cell viewWithTag:pointsTag]).frame = CGRectMake(tableView.bounds.size.width - 30, 0, 30, 43);
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
