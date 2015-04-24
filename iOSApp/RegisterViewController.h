//
//  RegisterViewController.h
//  MTAM
//
//  Created by Haldane Henry on 7/24/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTableViewModel.h"

@class MTAMAppDelegate;

@interface RegisterViewController : UIViewController <SCTableViewModelDelegate>{
	MTAMAppDelegate* appDelegate;
	SCTableViewModel *tableModel;
	IBOutlet UITableView *thetableView;
	
	IBOutlet UIView *sectionHeaderView;
	IBOutlet UIView *sectionFooterView;
    
    BOOL firstLoad;
    
}

@property (nonatomic, retain) IBOutlet UITableView *thetableView;
@property (nonatomic, retain) IBOutlet UIView *sectionHeaderView;
@property (nonatomic, retain) IBOutlet UIView *sectionFooterView;
@property (nonatomic, assign) BOOL firstLoad;

- (IBAction) facebookClick:(id)sender;
- (IBAction) closeClick:(id)sender;
- (IBAction) registerClick:(id)sender;

@end
