//
//  ListViewController.h
//  MTAM
//
//  Created by Haldane Henry on 6/16/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTAMAppDelegate;

@protocol FlipsideThreeViewControllerDelegate;

@interface ListViewController : UIViewController <UIActionSheetDelegate>{
	MTAMAppDelegate* appDelegate;
	id <FlipsideThreeViewControllerDelegate> delegate;
	IBOutlet UITableView* thetableView;
	IBOutlet UIView* screen;
	
	NSMutableData *connectionData;
	NSURLConnection *connection;
	BOOL dataReceived;
	UIActivityIndicatorView *activityIndicator;
	//HJObjManager* objMan;
}

@property (nonatomic, assign) id <FlipsideThreeViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *thetableView;
@property (nonatomic, retain) IBOutlet UIView *screen;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *connectionData;
@property (nonatomic, assign) BOOL dataReceived;
- (void) setUpListViewButtons;
- (IBAction) layersClick:(id)sender;
- (IBAction) mapviewClick:(id)sender;
- (IBAction) locationClick:(id)sender;
- (void) closeView:(id)sender;
- (void) back:(id)sender;
@end


@protocol FlipsideThreeViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(UIViewController *)controller;
@end
