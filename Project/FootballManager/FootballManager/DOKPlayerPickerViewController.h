//
//  DOKPlayerPickerViewController.h
//  FootballManager
//
//  Created by Diarmuid O'Keeffe on 02/02/2013.
//  Copyright (c) 2013 dermo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOKPlayerPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak) IBOutlet UIPickerView *pickerView;
@property NSMutableArray *myTeamPlayers;

@end
