//
//  RootViewController.h
//  MTAM
//
//  Created by Haldane Henry on 6/13/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "AddPointViewController.h"
#import "InfoViewController.h"

@class MTAMAppDelegate;

@interface RootViewController : UIViewController <FlipsideOneViewControllerDelegate, FlipsideTwoViewControllerDelegate, CurlUpViewControllerDelegate>{
	UIView* frontView;
	UIView* backView;
	MTAMAppDelegate* appDelegate;
	
	IBOutlet UIView* splashView;
	IBOutlet UIButton* aboutButton;
	IBOutlet UIButton* addPointButton;
	IBOutlet UIButton* mappButton;
	IBOutlet UIImageView* path;
}

@property (nonatomic, retain) UIView *frontView;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) IBOutlet UIView *splashView;
@property (nonatomic, retain) IBOutlet UIButton *aboutButton;
@property (nonatomic, retain) IBOutlet UIButton *addPointButton;
@property (nonatomic, retain) IBOutlet UIButton *mappButton;
@property (nonatomic, retain) IBOutlet UIImageView *path;

/*Load Sections*/
- (IBAction)showAbout:(id)sender;
- (IBAction)addPoint:(id)sender;
- (IBAction)showMapp:(id)sender;
- (IBAction)showInfo:(id)sender;

- (IBAction) removeModalView:(id)sender;
- (IBAction) popView:(id)sender;

- (void) showSplash;
- (void) hideSplash;
- (void) initHomeAni;
- (void) setHomeAni;

@end
