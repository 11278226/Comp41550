//
//  DOKViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 18/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKViewController.h"
#import "DOKTabBarViewController.h"
#import "AddThis.h"

@interface DOKViewController ()
- (IBAction)continueCareerPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *continueCareerButton;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *divisionLabel;
- (IBAction)twitterButton:(id)sender;
- (IBAction)facebookButton:(id)sender;

@end

@implementation DOKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ADDTHIS
    [AddThisSDK setAddThisUserName:@"Dermo"];
    [AddThisSDK setAddThisPubId:@"ra-51699ad6080e9b2f"];
    [AddThisSDK setAddThisApplicationId:@"5169a6573d8d2734"];

//    self.navigationController.navigationBarHidden = YES;
    [self reloadView];
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)reloadView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"name"];
    NSString *teamName = [defaults objectForKey:@"teamName"];
    NSString *numberOfDivisions = [defaults objectForKey:@"numberOfDivisions"];
    NSString *division = [defaults objectForKey:@"division"];
    
    if (name && teamName && numberOfDivisions && division) {
        self.continueCareerButton.hidden = NO;
        self.subView.hidden = NO;
        self.nameLabel.text = name;
        self.teamNameLabel.text = teamName;
        self.divisionLabel.text = division;
    } else {
        self.continueCareerButton.hidden = YES;
        self.subView.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadView];
    [self.mainScreenTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
            CGRect frame = CGRectMake(10, 3, 300, 16);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:frame];
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    //headerLabel.text = @"7 a-side Manager";
    return headerLabel;
    } else {
        return nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	if (indexPath.section == 0) {
        cell.textLabel.text = @"New Career";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"Load Career";
    }
    // Set up the cell
    //    DubAirportTest *appDelegate = (DubAirportTest *)[[UIApplication sharedApplication] delegate];
    //	Area *animal = (Area *)[appDelegate.animals objectAtIndex:indexPath.row];
    //
    //	cell.textLabel.text = animal.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        DOKNewCareerViewController *viewController = [[DOKNewCareerViewController alloc] initWithNibName:@"DOKNewCareerViewController" bundle:nil];
//        [self.navigationController pushViewController:viewController animated:YES];
    } else {
//        [self.navigationController pushViewController:myAlertTable animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"continue"]) {
        DOKTabBarViewController *destinationVC = [segue destinationViewController];
        destinationVC.futureDelegate = self;
    }
}

- (void)popToRootView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)twitterButton:(id)sender {
    [AddThisSDK shareURL:nil
             withService:@"twitter"
                   title:@""
             description:@"Check this app out, 7 a-side Manager!"];
}

- (IBAction)facebookButton:(id)sender {
    [AddThisSDK shareURL:nil
             withService:@"facebook"
                   title:@"7 a-side Football Manager"
             description:@"Check this app out, 7 a-side Manager!"];
}
@end
