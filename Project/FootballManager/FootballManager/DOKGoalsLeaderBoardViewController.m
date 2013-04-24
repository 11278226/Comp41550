//
//  DOKGoalsLeaderBoardViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 20/04/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKGoalsLeaderBoardViewController.h"
#import "DOKAppDelegate.h"
#import "DOKPlayerModel.h"

@interface DOKGoalsLeaderBoardViewController ()

@end

@implementation DOKGoalsLeaderBoardViewController

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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Players"];
    if (self.isAssists) {
        request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"assists"
                                                                                          ascending:NO
                                                                                           selector:nil],[NSSortDescriptor sortDescriptorWithKey:@"goals"
                                                                                                                                       ascending:NO
                                                                                                                                        selector:nil], nil];
    } else {
        request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"goals"
                                                                                      ascending:NO
                                                                                       selector:nil],[NSSortDescriptor sortDescriptorWithKey:@"assists"
                                                                                                                                   ascending:NO
                                                                                                                                    selector:nil], nil];
    }
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
        label.text = @"Player/Team";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 70,0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"Assists";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 40, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"Goals";
        [headerView addSubview:label];
        
        
    } else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        frame = CGRectMake(30, 0, tableView.bounds.size.width - 130 - 40, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"Player/Team";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 70,0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"Assists";
        [headerView addSubview:label];
        
        frame = CGRectMake(tableView.bounds.size.width - 40, 0, 30, 22);
        label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:10];
        label.text = @"Goals";
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
    static NSString *CellIdentifier = @"GoalsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger positionTag = 1;
    NSInteger playerTag = 2;
    NSInteger teamTag = 3;
    NSInteger assistsTag = 4;
    NSInteger goalsTag = 5;
    
//    if (((UILabel *)[cell viewWithTag:positionTag]) == nil) {
//        CGRect frame = CGRectMake(tableView.bounds.size.width - 150, 0, 30, 43);
//        UILabel *label = [[UILabel alloc]initWithFrame:frame];
//        label.numberOfLines = 1;
//        label.backgroundColor = [UIColor clearColor];
//        label.tag = playerTag;
//        label.textAlignment = NSTextAlignmentRight;
//        [cell addSubview:label];
//        
//        frame = CGRectMake(tableView.bounds.size.width - 120, 0, 30, 43);
//        label = [[UILabel alloc]initWithFrame:frame];
//        label.numberOfLines = 1;
//        label.tag = teamTag;
//        label.textAlignment = NSTextAlignmentRight;
//        label.backgroundColor = [UIColor clearColor];
//        [cell addSubview:label];
//        
//        frame = CGRectMake(tableView.bounds.size.width - 90, 0, 30, 43);
//        label = [[UILabel alloc]initWithFrame:frame];
//        label.numberOfLines = 1;
//        label.tag = assistsTag;
//        label.textAlignment = NSTextAlignmentRight;
//        label.backgroundColor = [UIColor clearColor];
//        [cell addSubview:label];
//        
//        frame = CGRectMake(tableView.bounds.size.width - 60, 0, 30, 43);
//        label = [[UILabel alloc]initWithFrame:frame];
//        label.numberOfLines = 1;
//        label.tag = goalsTag;
//        label.textAlignment = NSTextAlignmentRight;
//        label.backgroundColor = [UIColor clearColor];
//        [cell addSubview:label];
//    }
    
    DOKPlayerModel *player = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ((UILabel *)[cell viewWithTag:positionTag]).text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    ((UILabel *)[cell viewWithTag:playerTag]).text = [NSString stringWithFormat:@"%@",player.name];
    ((UILabel *)[cell viewWithTag:teamTag]).text = [NSString stringWithFormat:@"%@",player.teamName];
    ((UILabel *)[cell viewWithTag:assistsTag]).text = [NSString stringWithFormat:@"%@",player.assists];
    ((UILabel *)[cell viewWithTag:goalsTag]).text = [NSString stringWithFormat:@"%@",player.goals];
    
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    
//    if(orientation == 0 || orientation == UIInterfaceOrientationPortrait) {//Default orientation
//        ((UILabel *)[cell viewWithTag:positionTag]).text = [NSString stringWithFormat:@"%d",indexPath.row+1];
//        ((UILabel *)[cell viewWithTag:playerTag]).text = [NSString stringWithFormat:@"%@",player.teamName];
//
//        
//    } else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
//        
//        
//        
//        ((UILabel *)[cell viewWithTag:positionTag]).text = [NSString stringWithFormat:@"%d",indexPath.row+1];
//        ((UILabel *)[cell viewWithTag:titleTag]).text = [NSString stringWithFormat:@"%@",player.teamName];
//
//        ((UILabel *)[cell viewWithTag:goalsForTag]).hidden = NO;
//        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).hidden = NO;
//        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).hidden = NO;
//
//    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *teamName = [defaults objectForKey:@"teamName"];
    if ([player.teamName isEqualToString:teamName]) {
        ((UILabel *)[cell viewWithTag:positionTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:playerTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:teamTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:assistsTag]).textColor = [UIColor yellowColor];
        ((UILabel *)[cell viewWithTag:goalsTag]).textColor = [UIColor yellowColor];
    } else {
        ((UILabel *)[cell viewWithTag:positionTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:playerTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:teamTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:assistsTag]).textColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:goalsTag]).textColor = [UIColor whiteColor];
    }
    return cell;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger positionTag = 1;
//    NSInteger playTag = 3;
//    NSInteger wonTag = 4;
//    NSInteger drewTag = 5;
//    NSInteger loseTag = 6;
//    NSInteger goalsForTag = 7;
//    NSInteger goalsAgainstTag = 8;
//    NSInteger goalDifferenceTag = 9;
//    
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if(orientation == 0 || orientation == UIInterfaceOrientationPortrait) {//Default orientation
//        ((UILabel *)[cell viewWithTag:goalsForTag]).hidden = YES;
//        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).hidden = YES;
//        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).hidden = YES;
//        
//        ((UILabel *)[cell viewWithTag:playTag]).frame = CGRectMake(tableView.bounds.size.width - 150, 0, 30, 43);
//        ((UILabel *)[cell viewWithTag:wonTag]).frame = CGRectMake(tableView.bounds.size.width - 120, 0, 30, 43);
//        ((UILabel *)[cell viewWithTag:drewTag]).frame = CGRectMake(tableView.bounds.size.width - 90, 0, 30, 43);
//        ((UILabel *)[cell viewWithTag:loseTag]).frame = CGRectMake(tableView.bounds.size.width - 60, 0, 30, 43);
//        
//    } else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
//        
//        
//        
//        ((UILabel *)[cell viewWithTag:positionTag]).text = [NSString stringWithFormat:@"%d",indexPath.row+1];
//        
//        ((UILabel *)[cell viewWithTag:goalsForTag]).hidden = NO;
//        ((UILabel *)[cell viewWithTag:goalsAgainstTag]).hidden = NO;
//        ((UILabel *)[cell viewWithTag:goalDifferenceTag]).hidden = NO;
//        
//        ((UILabel *)[cell viewWithTag:playTag]).frame = CGRectMake(tableView.bounds.size.width - 240, 0, 30, 43);
//        ((UILabel *)[cell viewWithTag:wonTag]).frame = CGRectMake(tableView.bounds.size.width - 210, 0, 30, 43);
//        ((UILabel *)[cell viewWithTag:drewTag]).frame = CGRectMake(tableView.bounds.size.width - 180, 0, 30, 43);
//        ((UILabel *)[cell viewWithTag:loseTag]).frame = CGRectMake(tableView.bounds.size.width - 150, 0, 30, 43);
//        
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
