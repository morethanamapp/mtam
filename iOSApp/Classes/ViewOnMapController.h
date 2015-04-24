//
//  ViewOnMapController.h
//  MTAM
//
//  Created by Haldane Henry on 8/25/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "landmark.h"

@class MTAMAppDelegate;

@interface ViewOnMapController : UIViewController <MKMapViewDelegate>{
	MTAMAppDelegate* appDelegate;
	IBOutlet MKMapView *theMapView;
	
	landmark * alandmark;	
	BOOL showingUser;
	
	CLLocationCoordinate2D thePoint;
}

@property (nonatomic, retain) landmark * alandmark;
@property (nonatomic, retain) IBOutlet MKMapView * theMapView;
@property (nonatomic, assign) BOOL showingUser;
@property (nonatomic, assign) CLLocationCoordinate2D thePoint;

- (IBAction) locationClick:(id)sender;

@end
