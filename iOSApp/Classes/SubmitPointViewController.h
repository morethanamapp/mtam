//
//  SubmitPointViewController.h
//  MTAM
//
//  Created by Haldane Henry on 7/24/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTableViewModel.h"

@class MTAMAppDelegate;

@interface SubmitPointViewController : UIViewController <SCTableViewModelDelegate, SCTableViewCellDelegate>{
	MTAMAppDelegate* appDelegate;
	SCTableViewModel *tableModel;
	IBOutlet UITableView *thetableView;
	
	IBOutlet UIView *sectionHeaderView;
	IBOutlet UIView *sectionFooterView;
	IBOutlet UISwitch *toggleSwitch;
	IBOutlet UILabel *termsAndConditions;
	
	NSData * imageData;
	NSMutableArray *statesARR;
}

@property (nonatomic, retain) IBOutlet UITableView *thetableView;
@property (nonatomic, retain) IBOutlet UIView *sectionHeaderView;
@property (nonatomic, retain) IBOutlet UIView *sectionFooterView;
@property (nonatomic, retain) IBOutlet UISwitch *toggleSwitch;
@property (nonatomic, retain) IBOutlet UILabel *termsAndConditions;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSMutableArray *statesARR;

- (IBAction) closeClick:(id)sender;
- (IBAction) addClick:(id)sender;
- (IBAction) switchValueChanged:(id)sender;
- (void) userTappedLink:(UIGestureRecognizer*)gestureRecognizer;

@end
