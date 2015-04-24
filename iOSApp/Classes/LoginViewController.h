//
//  LoginViewController.h
//  MTAM
//
//  Created by Haldane Henry on 7/23/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTableViewModel.h"

@class MTAMAppDelegate;

@protocol LoginViewDelegate;

@interface LoginViewController : UIViewController <SCTableViewModelDelegate>{
	MTAMAppDelegate* appDelegate;
	SCTableViewModel *tableModel;
	IBOutlet UITableView *thetableView;
	
	IBOutlet UIView *sectionHeaderView;
	IBOutlet UIView *sectionFooterView;
	IBOutlet UILabel *forgotPassword;
	
    BOOL firstLoad;
    
	id <LoginViewDelegate> delegate;
	
}

@property (nonatomic, retain) IBOutlet UITableView *thetableView;
@property (nonatomic, retain) IBOutlet UIView *sectionHeaderView;
@property (nonatomic, retain) IBOutlet UIView *sectionFooterView;
@property (nonatomic, retain) IBOutlet UIView *forgotPassword;
@property (nonatomic, assign) BOOL firstLoad;

@property (nonatomic, assign) id <LoginViewDelegate> delegate;

- (IBAction) facebookClick:(id)sender;
- (IBAction) closeClick:(id)sender;
- (IBAction) signinClick:(id)sender;
- (void) userTappedLink:(UIGestureRecognizer*)gestureRecognizer; 

@end

@protocol LoginViewDelegate
- (void)LoginViewControllerDidFinish:(UIViewController *)controller;
@end