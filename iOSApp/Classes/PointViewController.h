//
//  PointViewController.h
//  MTAM
//
//  Created by Haldane Henry on 7/5/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "landmark.h"
#import "HJObjManager.h"

@class MTAMAppDelegate;

@interface PointViewController : UIViewController <CLLocationManagerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
	MTAMAppDelegate* appDelegate;
	landmark* alandmark;
	IBOutlet UIScrollView* scroller;
	IBOutlet UIView* profilePic;
	IBOutlet UIView* viewOnMapView;
	
	IBOutlet UIView* moreContent;
	IBOutlet UIButton* videoButton;
	IBOutlet UIButton* audioButton;
	IBOutlet UIButton* photoButton;
	IBOutlet UIButton* linksButton;
	
}

@property (nonatomic, retain) landmark *alandmark;
@property (nonatomic, retain) IBOutlet UIScrollView * scroller;
@property (nonatomic, retain) IBOutlet UIView * profilePic;
@property (nonatomic, retain) IBOutlet UIView * viewOnMapView;
@property (nonatomic, retain) IBOutlet UIView * moreContent;
@property (nonatomic, retain) IBOutlet UIButton * videoButton;
@property (nonatomic, retain) IBOutlet UIButton * audioButton;
@property (nonatomic, retain) IBOutlet UIButton * photoButton;
@property (nonatomic, retain) IBOutlet UIButton * linksButton;

- (void) setUpScroll;
- (void) setUpPointViewButtons;
- (void) setUpMoreContent;
- (void) back:(id)sender;
- (void) assignNewBookmark;

- (IBAction) directionsClick:(id)sender;
- (IBAction) shareClick:(id)sender;
- (IBAction) bookmarkClick:(id)sender;
- (IBAction) showOnMap:(id)sender;


- (IBAction) audioButtonClick:(id)sender;
- (IBAction) videoButtonClick:(id)sender;
- (IBAction) linksButtonClick:(id)sender;
- (IBAction) photosButtonClick:(id)sender;

@end
