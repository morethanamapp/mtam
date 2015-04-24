//
//  AddPointViewController.h
//  MTAM
//
//  Created by Haldane Henry on 6/14/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "InfoViewController.h"

@class MTAMAppDelegate;

@protocol FlipsideTwoViewControllerDelegate;

@interface AddPointViewController : UIViewController <LoginViewDelegate, CurlUpViewControllerDelegate>{
	
	MTAMAppDelegate* appDelegate;
	
	IBOutlet UITextView * text1;
	IBOutlet UITextView * text2;
	IBOutlet UIButton * anewMapperButton;
	IBOutlet UIButton * signOutButton;
	IBOutlet UIButton * signInButton;
	
	BOOL signOutVisible;
	BOOL firstLoad;
	
	id <FlipsideTwoViewControllerDelegate> delegate;
}
	
@property (nonatomic, retain) UITextView *text1;
@property (nonatomic, retain) UITextView *text2;
@property (nonatomic, retain) UIButton * anewMapperButton;
@property (nonatomic, retain) UIButton * signOutButton;
@property (nonatomic, retain) UIButton * signInButton;
@property (nonatomic, assign) id <FlipsideTwoViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL signOutVisible;
@property (nonatomic, assign) BOOL firstLoad;

- (IBAction)done:(id)sender;
- (IBAction)newMapper:(id)sender;
- (IBAction)addPoint:(id)sender;
- (IBAction)signOut:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)showInfo:(id)sender;

@end


@protocol FlipsideTwoViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(UIViewController *)controller;
@end