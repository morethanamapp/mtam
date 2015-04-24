//
//  MappViewController.h
//  MTAM
//
//  Created by Haldane Henry on 6/15/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ListViewController.h"
#import "HJObjManager.h"

@class MTAMAppDelegate;

@interface MappViewController : UIViewController <FlipsideThreeViewControllerDelegate, MKMapViewDelegate, UIActionSheetDelegate, CLLocationManagerDelegate> {
	MTAMAppDelegate* appDelegate;
	IBOutlet UIView* screen;
	IBOutlet MKMapView *theMapView;
	IBOutlet UIButton *rightAccessoryButton;
	
	NSMutableData *connectionData;
	NSURLConnection *connection;
	BOOL dataReceived;
	BOOL first;
	BOOL showingUser;
	UIActivityIndicatorView *activityIndicator;
	HJObjManager* objMan;		
}

@property (nonatomic, retain) IBOutlet MKMapView *theMapView;
@property (nonatomic, retain) IBOutlet UIButton *rightAccessoryButton;
@property (nonatomic, retain) IBOutlet UIView *screen;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *connectionData;
@property (nonatomic, assign) BOOL dataReceived;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) BOOL showingUser;

- (IBAction) locationClick:(id)sender;
- (IBAction) layersClick:(id)sender;
- (IBAction) listviewClick:(id)sender;
- (void) closeView:(id)sender;
- (void) popView:(id)sender;
- (void) setUpMappViewButtons;
- (void) addMappPoints;
- (void) back:(id)sender;

@end
