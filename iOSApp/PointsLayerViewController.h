//
//  PointsLayerViewController.h
//  MTAM
//
//  Created by Haldane Henry on 7/27/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RESULTINTERVAL 50


@class MTAMAppDelegate;

@interface PointsLayerViewController : UIViewController {
	MTAMAppDelegate* appDelegate;
	NSString * pointType;
	IBOutlet UITableView * thetableView;
	IBOutlet UIView* screen;
	
	NSMutableData *connectionData;
	NSURLConnection *connection;
	BOOL dataReceived;
	UIActivityIndicatorView *activityIndicator;
	NSString * getThis;
	
	NSInteger upperLimit;
	NSInteger lowerLimit;
	
	IBOutlet UIView * tableFooter;
	IBOutlet UIButton * prevButton;
	IBOutlet UIButton * nextButton;
	
	NSInteger stateINT;
	
}

@property (nonatomic, retain) NSString * pointType;
@property (nonatomic, retain) IBOutlet UITableView * thetableView;
@property (nonatomic, retain) IBOutlet UIView *screen;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *connectionData;
@property (nonatomic, assign) BOOL dataReceived;
@property (nonatomic, assign) NSInteger upperLimit;
@property (nonatomic, assign) NSInteger lowerLimit;
@property (nonatomic, retain) IBOutlet UIView * tableFooter;
@property (nonatomic, retain) IBOutlet UIButton * prevButton;
@property (nonatomic, retain) IBOutlet UIButton * nextButton;
@property (nonatomic, retain) NSString * getThis;
@property (nonatomic, assign) NSInteger stateINT;


- (void) back:(id)sender;
- (IBAction) previous:(id)sender;
- (IBAction) next:(id)sender;
- (void) getMapPoints;
- (NSString *) createSHA512:(NSString *)source;

@end
