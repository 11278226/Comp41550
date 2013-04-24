//
//  DOKCareerMainScreenViewController.m
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 19/01/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import "DOKCareerMainScreenViewController.h"
#import "DOKAppDelegate.h"
#import "DOKPlayerModel+Details.h"
#import <QuartzCore/CoreAnimation.h>
#import "DOKPlayerDetailViewController.h"

@interface DOKCareerMainScreenViewController () {
    UIActionSheet *actionSheet;
    int currentTag;
    NSNumber *pickerRow;
    UIPickerView *pickerView2;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *playerSeven;
@property (weak, nonatomic) IBOutlet UIView *playerSix;
@property (weak, nonatomic) IBOutlet UIView *playerFive;
@property (weak, nonatomic) IBOutlet UIView *playerFour;
@property (weak, nonatomic) IBOutlet UIView *playerThree;
@property (weak, nonatomic) IBOutlet UIView *playerTwo;
- (IBAction)formationButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *formationButton;
@property (weak, nonatomic) IBOutlet UITableView *playersTableView;
@property (strong, nonatomic) NSMutableArray *playersInTeam;
@property (strong, nonatomic) NSMutableArray *formations;
@property (strong, nonatomic) NSMutableArray *passing;
@property (strong, nonatomic) NSMutableArray *tackling;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
//@property (strong, nonatomic) NSMutableDictionary *myTeam;
- (IBAction)pickPlayer:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *selectionKeeper;
@property (weak, nonatomic) IBOutlet UILabel *selectionDefence;
@property (weak, nonatomic) IBOutlet UILabel *selectionDefenceTwo;
@property (weak, nonatomic) IBOutlet UILabel *selectionWing;
@property (weak, nonatomic) IBOutlet UILabel *selectionWingTwo;
@property (weak, nonatomic) IBOutlet UILabel *selectionMid;
@property (weak, nonatomic) IBOutlet UILabel *selectionStriker;
@property (weak, nonatomic) IBOutlet UIButton *tacklingButton;
@property (weak, nonatomic) IBOutlet UIButton *passingButton;
- (IBAction)passingButtonPressed:(UIButton *)sender;
- (IBAction)tacklingButtonPressed:(UIButton *)sender;

//@property (retain, nonatomic) DOKPlayerModel *playerToJoinTeam;
//@property (retain, nonatomic) DOKPlayerModel *playerToLeaveTeam;

@end

@implementation DOKCareerMainScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void) handleBack:(id)sender
{
    // pop to root view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setFormationImagesForFormation:[self.userDefaults objectForKey:@"Formation"]];
    
    if ([self.userDefaults objectForKey:@"myTeam"]) {
        NSMutableDictionary *myTeam = [[self.userDefaults objectForKey:@"myTeam"] mutableCopy];
        self.selectionKeeper.text = [myTeam objectForKey:@"playerOne"];
        self.selectionDefence.text = [myTeam objectForKey:@"playerTwo"];
        self.selectionDefenceTwo.text = [myTeam objectForKey:@"playerThree"];
        self.selectionWing.text = [myTeam objectForKey:@"playerFour"];
        self.selectionMid.text = [myTeam objectForKey:@"playerFive"];
        self.selectionWingTwo.text = [myTeam objectForKey:@"playerSix"];
        self.selectionStriker.text = [myTeam objectForKey:@"playerSeven"];
        
    }
    [self.passingButton setTitle:[self.userDefaults objectForKey:@"Passing"] forState:UIControlStateNormal];
    [self.passingButton setTitle:[self.userDefaults objectForKey:@"Passing"] forState:UIControlStateHighlighted];
    [self.tacklingButton setTitle:[self.userDefaults objectForKey:@"Tackling"] forState:UIControlStateNormal];
    [self.tacklingButton setTitle:[self.userDefaults objectForKey:@"Tackling"] forState:UIControlStateHighlighted];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if(fromInterfaceOrientation == 0 || fromInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.myScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 32 - 50);
    } else if(fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        self.myScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 50);
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == 0 || toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.myScrollView.frame = CGRectMake(0, 0, 800, [UIScreen mainScreen].bounds.size.height - 44 - 50);
    } else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.myScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 32 - 50);
    }
//    [self.myScrollView setContentSize:(CGSizeMake(320,500))];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myScrollView.delegate = self;
    [self.myScrollView setScrollEnabled:YES];
    [self.myScrollView setClipsToBounds:YES];
    [self.myScrollView setUserInteractionEnabled:YES];
    [self.myScrollView setContentSize:(CGSizeMake(320,440))];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == 0 || orientation == UIInterfaceOrientationPortrait) {
        self.myScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 50);
    } else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.myScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 32 - 50);
        
    }
    
    CAGradientLayer *gradientSelected = [CAGradientLayer layer];
    gradientSelected.frame = self.selectionDefence.frame;
    gradientSelected.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.75] CGColor], (id)[[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.75] CGColor], (id)[[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.75] CGColor], nil];
    gradientSelected.cornerRadius = 10.0f;
    
    self.selectionKeeper.backgroundColor = [UIColor darkGrayColor];
    self.selectionDefence.backgroundColor = [UIColor darkGrayColor];
    self.selectionDefenceTwo.backgroundColor = [UIColor darkGrayColor];
    self.selectionMid.backgroundColor = [UIColor darkGrayColor];
    self.selectionWing.backgroundColor = [UIColor darkGrayColor];
    self.selectionWingTwo.backgroundColor = [UIColor darkGrayColor];
    self.selectionStriker.backgroundColor = [UIColor darkGrayColor];
    
    self.formations = [NSMutableArray array];
    [self.formations addObject:@"1-2-3"];
    [self.formations addObject:@"1-3-2"];
    [self.formations addObject:@"2-3-1"];
    [self.formations addObject:@"2-1-3"];
    [self.formations addObject:@"2-2-2"];
    [self.formations addObject:@"3-2-1"];
    [self.formations addObject:@"3-3-0"];
    [self.formations addObject:@"3-1-2"];
    
    self.passing = [[NSMutableArray alloc] initWithObjects:@"Short",@"Medium",@"Long", nil];
    self.tackling = [[NSMutableArray alloc] initWithObjects:@"Weak",@"Medium",@"Strong", nil];
    
    UIImage *buttonImage = [UIImage imageNamed:@"back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.playersInTeam = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    //NSString *name = [defaults objectForKey:@"name"];
    NSString *teamName = [self.userDefaults objectForKey:@"teamName"];
    [self.formationButton setTitle:[self.userDefaults objectForKey:@"Formation"] forState:UIControlStateNormal];
    [self.formationButton setTitle:[self.userDefaults objectForKey:@"Formation"] forState:UIControlStateHighlighted];
    [self setFormationImagesForFormation:[self.userDefaults objectForKey:@"Formation"]];
    
    
    NSFetchRequest *fetchRequestImages = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityImages = [NSEntityDescription entityForName:@"Players"
                                                    inManagedObjectContext:[[DOKAppDelegate sharedAppDelegate] managedObjectContext]];
    [fetchRequestImages setEntity:entityImages];
    NSArray *fetchedObjectsImages = [[[DOKAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:fetchRequestImages error:&error];
    for (DOKPlayerModel *info in fetchedObjectsImages) {
        if([teamName isEqualToString:info.teamName])
            [self.playersInTeam addObject:info];
    }
    
    if ([self.userDefaults objectForKey:@"myTeam"]) {
        NSMutableDictionary *myTeam = [[self.userDefaults objectForKey:@"myTeam"] mutableCopy];
        self.selectionKeeper.text = [myTeam objectForKey:@"playerOne"];
        self.selectionDefence.text = [myTeam objectForKey:@"playerTwo"];
        self.selectionDefenceTwo.text = [myTeam objectForKey:@"playerThree"];
        self.selectionWing.text = [myTeam objectForKey:@"playerFour"];
        self.selectionMid.text = [myTeam objectForKey:@"playerFive"];
        self.selectionWingTwo.text = [myTeam objectForKey:@"playerSix"];
        self.selectionStriker.text = [myTeam objectForKey:@"playerSeven"];
        
    } else {
        NSMutableDictionary *myTeam = [NSMutableDictionary dictionary];
        
        [myTeam setObject:[[self.playersInTeam objectAtIndex:0] name] forKey:@"playerOne"];
        [myTeam setObject:[[self.playersInTeam objectAtIndex:1] name] forKey:@"playerTwo"];
        [myTeam setObject:[[self.playersInTeam objectAtIndex:2] name] forKey:@"playerThree"];
        [myTeam setObject:[[self.playersInTeam objectAtIndex:3] name] forKey:@"playerFour"];
        [myTeam setObject:[[self.playersInTeam objectAtIndex:4] name] forKey:@"playerFive"];
        [myTeam setObject:[[self.playersInTeam objectAtIndex:5] name] forKey:@"playerSix"];
        [myTeam setObject:[[self.playersInTeam objectAtIndex:6] name] forKey:@"playerSeven"];
        
        [self.userDefaults setObject:myTeam forKey:@"myTeam"];
        [self.userDefaults synchronize];
        
        self.selectionKeeper.text = [[self.playersInTeam objectAtIndex:0] name];
        self.selectionDefence.text = [[self.playersInTeam objectAtIndex:1] name];
        self.selectionDefenceTwo.text = [[self.playersInTeam objectAtIndex:2] name];
        self.selectionWing.text = [[self.playersInTeam objectAtIndex:3] name];
        self.selectionMid.text = [[self.playersInTeam objectAtIndex:4] name];
        self.selectionWingTwo.text = [[self.playersInTeam objectAtIndex:5] name];
        self.selectionStriker.text = [[self.playersInTeam objectAtIndex:6] name];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissActionSheet:(id)sender {
//    if (pickerRow != nil) {
//        
//        DOKPlayerModel *playerPicked = [self.filteredPlayersNotInTeam objectAtIndex:[pickerRow intValue]];
//        if (!playerPicked) {
//            return;
//        }
//        NSString *playerToBeRemoved = @"";
//        switch (currentTag) {
//            case 1:
//                playerToBeRemoved = self.selectionKeeper.text;
//                self.selectionKeeper.text = [[self.filteredPlayersNotInTeam objectAtIndex:[pickerRow intValue]] name];
//                [self.myTeam setObject:self.selectionKeeper.text forKey:@"selectionKeeper"];
//                break;
//            case 2:
//                playerToBeRemoved = self.selectionDefence.text;
//                self.selectionDefence.text = [[self.filteredPlayersNotInTeam objectAtIndex:[pickerRow intValue]] name];
//                [self.myTeam setObject:self.selectionDefence.text forKey:@"selectionDefence"];
//                break;
//            case 3:
//                playerToBeRemoved = self.selectionDefenceTwo.text;
//                self.selectionDefenceTwo.text = [[self.filteredPlayersNotInTeam objectAtIndex:[pickerRow intValue]] name];
//                [self.myTeam setObject:self.selectionDefenceTwo.text forKey:@"selectionDefenceTwo"];
//                break;
//            case 4:
//                playerToBeRemoved = self.selectionWing.text;
//                self.selectionWing.text = [[self.filteredPlayersNotInTeam objectAtIndex:[pickerRow intValue]] name];
//                [self.myTeam setObject:self.selectionWing.text forKey:@"selectionWing"];
//                break;
//            case 5:
//                playerToBeRemoved = self.selectionMid.text;
//                self.selectionMid.text = [[self.filteredPlayersNotInTeam objectAtIndex:[pickerRow intValue]] name];
//                [self.myTeam setObject:self.selectionMid.text forKey:@"selectionMid"];
//                break;
//            case 6:
//                playerToBeRemoved = self.selectionWingTwo.text;
//                self.selectionWingTwo.text = [[self.filteredPlayersNotInTeam objectAtIndex:[pickerRow intValue]] name];
//                [self.myTeam setObject:self.selectionWingTwo.text forKey:@"selectionWingTwo"];
//                break;
//            case 7:
//                playerToBeRemoved = self.selectionStriker.text;
//                self.selectionStriker.text = [[self.filteredPlayersNotInTeam objectAtIndex:[pickerRow intValue]] name];
//                [self.myTeam setObject:self.selectionStriker.text forKey:@"selectionStriker"];
//                break;
//                
//            default:
//                break;
//        }
//        DOKPlayerModel *thisPlayer;
//        for (DOKPlayerModel *playerRemoved in self.filteredPlayersInTeam) {
//            if ([playerRemoved.name isEqualToString:playerToBeRemoved]) {
//                thisPlayer = playerRemoved;
//            }
//        }
//        if (thisPlayer != nil && playerPicked != nil) {
//            [self.filteredPlayersInTeam removeObject:thisPlayer];
//            [self.filteredPlayersInTeam addObject:playerPicked];
//            [self.filteredPlayersNotInTeam addObject:thisPlayer];
//            [self.filteredPlayersNotInTeam removeObject:playerPicked];
//        } else {
//            
//        }
//        
//        [self.userDefaults setObject:self.myTeam forKey:@"myTeam"];
//        [self.userDefaults synchronize];
//        pickerRow = nil;
//    }
//    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void)updateButtons
{
    [self.passingButton setTitle:[self.userDefaults objectForKey:@"Passing"] forState:UIControlStateNormal];
    [self.passingButton setTitle:[self.userDefaults objectForKey:@"Passing"] forState:UIControlStateHighlighted];
    [self.tacklingButton setTitle:[self.userDefaults objectForKey:@"Tackling"] forState:UIControlStateNormal];
    [self.tacklingButton setTitle:[self.userDefaults objectForKey:@"Tackling"] forState:UIControlStateHighlighted];
}


- (void)setFormationImagesForFormation:(NSString *)currFormation
{
    [self.formationButton setTitle:[self.userDefaults objectForKey:@"Formation"] forState:UIControlStateNormal];
    [self.formationButton setTitle:[self.userDefaults objectForKey:@"Formation"] forState:UIControlStateHighlighted];
    if ([currFormation isEqualToString:@"1-2-3"]) {
        self.playerTwo.frame = CGRectMake(85+35, 74, 80, 50);
        self.playerThree.frame = CGRectMake(37+35, 162, 80, 50);
        self.playerFour.frame = CGRectMake(137+35, 162, 80, 50);
        self.playerFive.frame = CGRectMake(0+35, 258, 80, 50);
        self.playerSix.frame = CGRectMake(85+35, 258, 80, 50);
        self.playerSeven.frame = CGRectMake(170+35, 258, 80, 50);
    } else if ([currFormation isEqualToString:@"1-3-2"]) {
        self.playerTwo.frame = CGRectMake(85+35, 74, 80, 50);
        self.playerThree.frame = CGRectMake(0+35, 162, 80, 50);
        self.playerFour.frame = CGRectMake(85+35, 162, 80, 50);
        self.playerFive.frame = CGRectMake(170+35, 162, 80, 50);
        self.playerSix.frame = CGRectMake(37+35, 258, 80, 50);
        self.playerSeven.frame = CGRectMake(137+35, 258, 80, 50);
    } else if ([currFormation isEqualToString:@"2-3-1"]) {
        self.playerTwo.frame = CGRectMake(37+35, 74, 80, 50);
        self.playerThree.frame = CGRectMake(137+35, 74, 80, 50);
        self.playerFour.frame = CGRectMake(0+35, 162, 80, 50);
        self.playerFive.frame = CGRectMake(85+35, 162, 80, 50);
        self.playerSix.frame = CGRectMake(170+35, 162, 80, 50);
        self.playerSeven.frame = CGRectMake(85+35, 258, 80, 50);
    } else if ([currFormation isEqualToString:@"2-1-3"]) {
        self.playerTwo.frame = CGRectMake(37+35, 74, 80, 50);
        self.playerThree.frame = CGRectMake(137+35, 74, 80, 50);
        self.playerFour.frame = CGRectMake(85+35, 162, 80, 50);
        self.playerFive.frame = CGRectMake(0+35, 258, 80, 50);
        self.playerSix.frame = CGRectMake(85+35, 258, 80, 50);
        self.playerSeven.frame = CGRectMake(170+35, 258, 80, 50);
    } else if ([currFormation isEqualToString:@"2-2-2"]) {
        self.playerTwo.frame = CGRectMake(37+35, 74, 80, 50);
        self.playerThree.frame = CGRectMake(137+35, 74, 80, 50);
        self.playerFour.frame = CGRectMake(37+35, 162, 80, 50);
        self.playerFive.frame = CGRectMake(137+35, 162, 80, 50);
        self.playerSix.frame = CGRectMake(37+35, 258, 80, 50);
        self.playerSeven.frame = CGRectMake(137+35, 258, 80, 50);
    } else if ([currFormation isEqualToString:@"3-2-1"]) {
        self.playerTwo.frame = CGRectMake(0+35, 74, 80, 50);
        self.playerThree.frame = CGRectMake(85+35, 74, 80, 50);
        self.playerFour.frame = CGRectMake(170+35, 74, 80, 50);
        self.playerFive.frame = CGRectMake(37+35, 162, 80, 50);
        self.playerSix.frame = CGRectMake(137+35, 162, 80, 50);
        self.playerSeven.frame = CGRectMake(85+35, 258, 80, 50);
    } else if ([currFormation isEqualToString:@"3-3-0"]) {
        self.playerTwo.frame = CGRectMake(0+35, 74, 80, 50);
        self.playerThree.frame = CGRectMake(85+35, 74, 80, 50);
        self.playerFour.frame = CGRectMake(170+35, 74, 80, 50);
        self.playerFive.frame = CGRectMake(0+35, 162, 80, 50);
        self.playerSix.frame = CGRectMake(85+35, 162, 80, 50);
        self.playerSeven.frame = CGRectMake(170+35, 162, 80, 50);
    } else if ([currFormation isEqualToString:@"3-1-2"]) {
        self.playerTwo.frame = CGRectMake(0+35, 74, 80, 50);
        self.playerThree.frame = CGRectMake(85+35, 74, 80, 50);
        self.playerFour.frame = CGRectMake(170+35, 74, 80, 50);
        self.playerFive.frame = CGRectMake(85+35, 162, 80, 50);
        self.playerSix.frame = CGRectMake(37+35, 258, 80, 50);
        self.playerSeven.frame = CGRectMake(137+35, 258, 80, 50);
    } 
}

- (void)actionSheet:(UIActionSheet *)myActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != myActionSheet.cancelButtonIndex && myActionSheet.tag == 1) {
        [self.userDefaults setValue:[myActionSheet buttonTitleAtIndex:buttonIndex] forKey:@"Formation"];
        [self.userDefaults synchronize];
        [self setFormationImagesForFormation:[self.userDefaults objectForKey:@"Formation"]];
    } else if (buttonIndex != myActionSheet.cancelButtonIndex && myActionSheet.tag == 2) {
        [self.userDefaults setValue:[myActionSheet buttonTitleAtIndex:buttonIndex] forKey:@"Passing"];
        [self.userDefaults synchronize];
        [self updateButtons];
    } else if (buttonIndex != myActionSheet.cancelButtonIndex && myActionSheet.tag == 3) {
        [self.userDefaults setValue:[myActionSheet buttonTitleAtIndex:buttonIndex] forKey:@"Tackling"];
        [self.userDefaults synchronize];
        [self updateButtons];
    }
}

- (IBAction)pickPlayer:(UIButton *)sender {
    [self performSegueWithIdentifier:@"PickPlayer" sender:sender];
    
    
//    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                              delegate:nil
//                                     cancelButtonTitle:nil
//                                destructiveButtonTitle:nil
//                                     otherButtonTitles:nil];
//    
//    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
//    
//    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
//    
//    pickerView2 = [[UIPickerView alloc] initWithFrame:pickerFrame];
//    pickerView2.showsSelectionIndicator = YES;
//    pickerView2.dataSource = self;
//    pickerView2.delegate = self;
//    
//    [actionSheet addSubview:pickerView2];
//    
//    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
//    closeButton.momentary = YES;
//    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
//    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
//    closeButton.tintColor = [UIColor blackColor];
//    currentTag = [sender tag];
//    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
//    [actionSheet addSubview:closeButton];
//    
//    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
//    
//    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.playersInTeam count];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //    self.playerToJoinTeam = nil;
    //    self.playerToLeaveTeam = nil;
    pickerRow = [NSNumber numberWithInteger:row];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 280, 30)];
    UILabel *pickerLabel;
    pickerLabel.tag = 1;
    CGRect frame = CGRectMake(0.0, 0.0, 200, 20);
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    [pickerLabel setBackgroundColor:[UIColor clearColor]];
    
    
    UILabel *strengthsLabel;
    CGRect strengthsFrame = CGRectMake(0.0, 20.0, 200, 12);
    strengthsLabel.tag = 2;
    strengthsLabel = [[UILabel alloc] initWithFrame:strengthsFrame];
    strengthsLabel.font = [strengthsLabel.font fontWithSize:10];
    [strengthsLabel setBackgroundColor:[UIColor clearColor]];
    
    
    UIImageView *temp;
    temp.tag = 3;
    temp = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 80, 20)];
    
    [view addSubview:temp];
    [view addSubview:pickerLabel];
    [view addSubview:strengthsLabel];
    

    
    return view;
}

-(NSString *)findStrengthsOfPlayer:(DOKPlayerModel *)player {
    NSString *ans = @"";
    if ([player.offensivePositioning intValue] > 15) {
        ans = [ans stringByAppendingString:@"Offensive Positioning, "];
    }
    if ([player.defensivePositioning intValue] > 15) {
        ans = [ans stringByAppendingString:@"Defensive Positioning, "];
    }
    if ([player.strength intValue] > 15) {
        ans = [ans stringByAppendingString:@"Strength, "];
    }
    if ([player.shooting intValue] > 15) {
        ans = [ans stringByAppendingString:@"Shooting, "];
    }
    if ([player.tackling intValue] > 15) {
        ans = [ans stringByAppendingString:@"Tackling, "];
    }
    if ([player.goalkeeping intValue] > 15) {
        ans = [ans stringByAppendingString:@"Goalkeeping, "];
    }
    if ([player.passing intValue] > 15) {
        ans = [ans stringByAppendingString:@"Passing, "];
    }
    if ([player.dribbling intValue] > 15) {
        ans = [ans stringByAppendingString:@"Dribbling, "];
    }
    if ([player.speed intValue] > 15) {
        ans = [ans stringByAppendingString:@"Speed, "];
    }
    if ([player.stamina intValue] > 15) {
        ans = [ans stringByAppendingString:@"Stamina, "];
    }
    if ([player.composure intValue] > 15) {
        ans = [ans stringByAppendingString:@"Composure, "];
    }
    
    if (ans.length > 0) {
        ans = [ans substringToIndex:[ans length] - 2];
    }
    
    return ans;
}

-(NSString *)weaknessesForPlayer:(DOKPlayerModel *)player {
    NSString *ans = @"";
    if ([player.offensivePositioning intValue] < 5) {
        ans = [ans stringByAppendingString:@"Offensive Positioning, "];
    }
    if ([player.defensivePositioning intValue] < 5) {
        ans = [ans stringByAppendingString:@"Defensive Positioning, "];
    }
    if ([player.strength intValue] < 5) {
        ans = [ans stringByAppendingString:@"Strength, "];
    }
    if ([player.shooting intValue] < 5) {
        ans = [ans stringByAppendingString:@"Shooting, "];
    }
    if ([player.tackling intValue] < 5) {
        ans = [ans stringByAppendingString:@"Tackling, "];
    }
    if ([player.goalkeeping intValue] < 5) {
        ans = [ans stringByAppendingString:@"Goalkeeping, "];
    }
    if ([player.passing intValue] < 5) {
        ans = [ans stringByAppendingString:@"Passing, "];
    }
    if ([player.dribbling intValue] < 5) {
        ans = [ans stringByAppendingString:@"Dribbling, "];
    }
    if ([player.speed intValue] < 5) {
        ans = [ans stringByAppendingString:@"Speed, "];
    }
    if ([player.stamina intValue] < 5) {
        ans = [ans stringByAppendingString:@"Stamina, "];
    }
    if ([player.composure intValue] < 5) {
        ans = [ans stringByAppendingString:@"Composure, "];
    }
    
    if (ans.length > 0) {
        ans = [ans substringToIndex:[ans length] - 2];
    }
    return ans;
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
    
    [cell.textLabel.font fontWithSize:8];
    cell.textLabel.text = [[self.playersInTeam objectAtIndex:indexPath.row] name];
    
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
    if ([[segue identifier] isEqualToString:@"ShowThisPlayer"]) {
        
        NSIndexPath *selectedRowIndex = [self.playersTableView indexPathForSelectedRow];
        DOKPlayerDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.player = [self.playersInTeam objectAtIndex:selectedRowIndex.row];
    } else if ([[segue identifier] isEqualToString:@"PickPlayer"]) {
        DOKPickPlayerTableViewController *detailViewController = [segue destinationViewController];
        detailViewController.thisPlayerTag = [sender tag];
        detailViewController.players = [self.playersInTeam mutableCopy];
        detailViewController.thisPlayer = [self findPlayerForTag:[sender tag]];
        detailViewController.pickPlayerDelegate = self;
    }
}

- (NSString *)findPlayerForTag:(int)tag
{
    switch (tag) {
        case 1:
            return self.selectionKeeper.text;
            break;
        case 2:
            return self.selectionDefence.text;
            break;
        case 3:
            return self.selectionDefenceTwo.text;
            break;
        case 4:
            return self.selectionWing.text;
            break;
        case 5:
            return self.selectionMid.text;
            break;
        case 6:
            return self.selectionWingTwo.text;
            break;
        case 7:
            return self.selectionStriker.text;
            break;
        default:
            return nil;
            break;
    }
}

- (IBAction)formationButtonPressed:(UIButton *)sender {
    UIActionSheet *buttonActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a formation:"
                                                             delegate:(id)self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    buttonActionSheet.tag = 1;
    buttonActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    // add buttons
    for (NSString *currFormation in self.formations) {
        [buttonActionSheet addButtonWithTitle:currFormation];
    }
    
    // add cancel button
    [buttonActionSheet addButtonWithTitle:@"Cancel"];
    buttonActionSheet.cancelButtonIndex = buttonActionSheet.numberOfButtons - 1;
    
    // show actionsheet
    [buttonActionSheet showInView:self.tabBarController.view];

}

- (void)pickPlayerViewControllerPlayerPicked:(DOKPlayerModel *)playerPicked playerRemoved:(DOKPlayerModel *)playerRemoved forTag:(int)tag
{
    [self.playersInTeam exchangeObjectAtIndex:[self.playersInTeam indexOfObject:playerPicked] withObjectAtIndex:[self.playersInTeam indexOfObject:playerRemoved]];
    [self updatePlayerLabels];
}

- (void) updatePlayerLabels {
    NSMutableDictionary *myTeam = [[self.userDefaults objectForKey:@"myTeam"] mutableCopy];
    [myTeam setObject:[[self.playersInTeam objectAtIndex:0] name] forKey:@"playerOne"];
    [myTeam setObject:[[self.playersInTeam objectAtIndex:1] name] forKey:@"playerTwo"];
    [myTeam setObject:[[self.playersInTeam objectAtIndex:2] name] forKey:@"playerThree"];
    [myTeam setObject:[[self.playersInTeam objectAtIndex:3] name] forKey:@"playerFour"];
    [myTeam setObject:[[self.playersInTeam objectAtIndex:4] name] forKey:@"playerFive"];
    [myTeam setObject:[[self.playersInTeam objectAtIndex:5] name] forKey:@"playerSix"];
    [myTeam setObject:[[self.playersInTeam objectAtIndex:6] name] forKey:@"playerSeven"];
    
    [self.userDefaults setObject:myTeam forKey:@"myTeam"];
    
    
    [self.userDefaults synchronize];
    
    self.selectionKeeper.text = [[self.playersInTeam objectAtIndex:0] name];
    self.selectionDefence.text = [[self.playersInTeam objectAtIndex:1] name];
    self.selectionDefenceTwo.text = [[self.playersInTeam objectAtIndex:2] name];
    self.selectionMid.text = [[self.playersInTeam objectAtIndex:3] name];
    self.selectionWing.text = [[self.playersInTeam objectAtIndex:4] name];
    self.selectionWingTwo.text = [[self.playersInTeam objectAtIndex:5] name];
    self.selectionStriker.text = [[self.playersInTeam objectAtIndex:6] name];
}
- (IBAction)passingButtonPressed:(UIButton *)sender {
    UIActionSheet *buttonActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a passing style:"
                                                                   delegate:(id)self
                                                          cancelButtonTitle:nil
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:nil];
    
    buttonActionSheet.tag = 2;
    buttonActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    // add buttons
    for (NSString *currFormation in self.passing) {
        [buttonActionSheet addButtonWithTitle:currFormation];
    }
    
    // add cancel button
    [buttonActionSheet addButtonWithTitle:@"Cancel"];
    buttonActionSheet.cancelButtonIndex = buttonActionSheet.numberOfButtons - 1;
    
    // show actionsheet
    [buttonActionSheet showInView:self.tabBarController.view];
}

- (IBAction)tacklingButtonPressed:(UIButton *)sender {
    UIActionSheet *buttonActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a tackling strength:"
                                                                   delegate:(id)self
                                                          cancelButtonTitle:nil
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:nil];
    
    buttonActionSheet.tag = 3;
    buttonActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    // add buttons
    for (NSString *currFormation in self.tackling) {
        [buttonActionSheet addButtonWithTitle:currFormation];
    }
    
    // add cancel button
    [buttonActionSheet addButtonWithTitle:@"Cancel"];
    buttonActionSheet.cancelButtonIndex = buttonActionSheet.numberOfButtons - 1;
    
    // show actionsheet
    [buttonActionSheet showInView:self.tabBarController.view];
}
@end
