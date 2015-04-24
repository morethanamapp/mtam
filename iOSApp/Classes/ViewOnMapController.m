//
//  ViewOnMapController.m
//  MTAM
//
//  Created by Haldane Henry on 8/25/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "ViewOnMapController.h"
#import "MTAMAppDelegate.h"
#import "landmark.h"
#import "AnnotationPoint.h"
#import <objc/runtime.h>
#import "MBProgressHUD.h"

@implementation ViewOnMapController

@synthesize theMapView, thePoint, alandmark, showingUser;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	showingUser = NO;
	
	if (alandmark != nil) {
		
		AnnotationPoint * annotation = nil;
		
		CLLocationCoordinate2D location;
		location.latitude = alandmark.latitude;
		location.longitude = alandmark.longtitude;
				
		
		float max_long = alandmark.longtitude;
		float min_long = alandmark.longtitude;
		float max_lat = alandmark.latitude;
		float min_lat = alandmark.latitude;
		
		annotation = [[AnnotationPoint alloc] initWithCoordinates:location 
															title:alandmark.title 
														 subTitle:alandmark.address];
		
		annotation.itemIndex = 0;
		annotation.pinColor = MKPinAnnotationColorGreen;
		
		float center_long = (max_long + min_long) / 2;
		float center_lat = (max_lat + min_lat) / 2;
		
		float deltaLat = 0.005;//fabs(max_lat - min_lat);
		float deltaLong = 0.005;//fabs(max_long - min_long);
		
		CLLocationCoordinate2D center_coord = {.latitude = center_lat, .longitude = center_long};
		MKCoordinateSpan span = MKCoordinateSpanMake(deltaLat, deltaLong);
		MKCoordinateRegion region = {center_coord, span};	
		
		[self.theMapView addAnnotation:annotation];
		[self.theMapView setRegion:region animated:NO];
		[self.theMapView selectAnnotation:annotation animated:YES];
		
		[annotation release];
	}
	
	//ADD LOCATION BUTTON
	UIImage *locationImg = [UIImage imageNamed:@"icon_location.png"];
	UIBarButtonItem *locationButton = [[UIBarButtonItem alloc] initWithImage:locationImg style:UIBarButtonItemStyleBordered target:self action:@selector(locationClick:)];
	
	self.navigationItem.rightBarButtonItem = locationButton;
	[locationButton release];
}


- (IBAction) locationClick:(id)sender{
	
	if (showingUser) {
		theMapView.showsUserLocation = NO;
		showingUser = NO;
		
		float max_long = alandmark.longtitude;
		float min_long = alandmark.longtitude;
		float max_lat = alandmark.latitude;
		float min_lat = alandmark.latitude;
		
		float center_long = (max_long + min_long) / 2;
		float center_lat = (max_lat + min_lat) / 2;
		
		float deltaLat = 0.005;
		float deltaLong = 0.005;
		
		CLLocationCoordinate2D center_coord = {.latitude = center_lat, .longitude = center_long};
		MKCoordinateSpan span = MKCoordinateSpanMake(deltaLat, deltaLong);
		MKCoordinateRegion region = {center_coord, span};
		
		[self.theMapView setRegion:region animated:YES];
		
	}else {
		theMapView.showsUserLocation = YES;
		showingUser = YES;
		
		float max_long = alandmark.longtitude;
		float min_long = alandmark.longtitude;
		float max_lat = alandmark.latitude;
		float min_lat = alandmark.latitude;
		
		if (appDelegate.mylocation.longitude > max_long) {
			max_long = appDelegate.mylocation.longitude;
		}
		
		if (appDelegate.mylocation.longitude < min_long) {
			min_long = appDelegate.mylocation.longitude;
		}
		
		if (appDelegate.mylocation.latitude > max_lat) {
			max_lat = appDelegate.mylocation.latitude;
		}
		
		if (appDelegate.mylocation.latitude < min_lat) {
			min_lat = appDelegate.mylocation.latitude;
		}
		
		float center_long = (max_long + min_long) / 2;
		float center_lat = (max_lat + min_lat) / 2;
		
		float deltaLat = fabs(max_lat - min_lat);
		float deltaLong = fabs(max_long - min_long);
		
		CLLocationCoordinate2D center_coord = {.latitude = center_lat, .longitude = center_long};
		MKCoordinateSpan span = MKCoordinateSpanMake(deltaLat, deltaLong);
		MKCoordinateRegion region = {center_coord, span};
		
		[self.theMapView setRegion:region animated:YES];
	}
	
}

//Rotation Controls

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape ;
}

- (BOOL)shouldAutorotate {
    return YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark MKMapView Delegate

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
	
	
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	MKAnnotationView *result = nil;
	
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return(result);
	}
	
	if ([annotation isKindOfClass:[AnnotationPoint class]] == NO) {
		return(result);
	}
	
	if ([mapView isEqual:self.theMapView] == NO) {
		return(result);
	}
	
	AnnotationPoint *senderAnnotation = (AnnotationPoint *)annotation;
	
	NSString *pinReusableIdentifier = [AnnotationPoint resuableIdentifierforPinColor:senderAnnotation.pinColor];
	MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
	
	if(annotationView == nil){
		
		annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation 
														  reuseIdentifier:pinReusableIdentifier] autorelease];
		
		[annotationView setCanShowCallout:YES];
		
	}
	
	annotationView.pinColor = senderAnnotation.pinColor;
	annotationView.animatesDrop = YES;
	
	
	result = annotationView;
	
	return(result);
	[annotationView release];
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	
	
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
	
}

- (void)mapView: (MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	
}

- (void)mapView: (MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	
}



#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
