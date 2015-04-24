	//
//  MappViewController.m
//  MTAM
//
//  Created by Haldane Henry on 6/15/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "MappViewController.h"
#import "CustomUIToolbar.h"
#import "ListViewController.h"
#import "MTAMAppDelegate.h"
#import "XMLParser.h"
#import "landmark.h"
#import "AnnotationPoint.h"
#import "PointViewController.h"
#import "BookmarkLayerViewController.h"
#import "PointsLayerViewController.h"
#import <objc/runtime.h>
#import "MBProgressHUD.h"
#import "SelectStateViewController.h"
#import "SearchViewController.h"
#import "GANTracker.h"

@implementation MappViewController

@synthesize theMapView, rightAccessoryButton, screen, connectionData, connection, dataReceived, first, showingUser;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	first = YES;
	showingUser = NO;
	
	//---------------------
	
	self.dataReceived = NO;
	
	[self.view addSubview:screen];
	
	/*activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview:activityIndicator];*/
		
	
	NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.morethanamapp.org/request/get-mapp-points.php?lat=%f&long=%f", appDelegate.mylocation.latitude, appDelegate.mylocation.longitude]];
	/*NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.morethanamapp.org/request/get-mapp-points.php?lat=%f&long=%f", 40.8716660, -73.8392810]];*/
	//NSLog(@"URL: %@", url);
	 
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	self.connection = nil;
	self.connectionData = nil;
	
	NSMutableData *newData = [[NSMutableData alloc] init];
	self.connectionData = newData;
	[newData release];
	
	NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	self.connection = newConnection;
	[newConnection release];
	
	[url release];
	
	///-----------------------------------------------------------
	///-----------------------------------------------------------
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"Loading...";
		
	[self setUpMappViewButtons];
	
	
	///-----------------------------------------------------------
	///-----------------------------------------------------------
	NSError * error;
	
	if (![[GANTracker sharedTracker] trackPageview:@"/app_points_mapview" 
										 withError:&error]) {
		
		//NSLog(@"GANTracker Error: %@", error);
	}
		
}



- (IBAction) locationClick:(id)sender{
	
	if (showingUser) {
		theMapView.showsUserLocation = NO;
		showingUser = NO;
	}else {
		theMapView.showsUserLocation = YES;
		showingUser = YES;
	}
		
}

- (IBAction) layersClick:(id)sender{
	
	UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"LAYERS" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"All Points",@"More Than A Month Points",@"Mapper Points", @"My Bookmarks", @"Search",nil];
	
	shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[shareActionSheet showInView:self.view];
	[shareActionSheet release];
	
}

- (IBAction) listviewClick:(id)sender{
	//NSLog(@"Show ListView");
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(closeView:)];
	backbutton.width = 65.0;
	
	ListViewController *listViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];	
	listViewController.delegate = self;	
	listViewController.navigationItem.leftBarButtonItem = backbutton;	
	listViewController.navigationItem.hidesBackButton = YES;
	//[listViewController.navigationController setNavigationBarHidden:NO animated:NO];
	
	CustomNavController *navCon = [[[CustomNavController alloc] initWithRootViewController:listViewController] autorelease];
	navCon.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	//listViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;	
	[self presentModalViewController:navCon animated:YES];
	
	[listViewController release];
	[backbutton release];
	//[backImg release];
}


- (void) closeView:(id)sender {
	[self dismissModalViewControllerAnimated:NO];
	[self.navigationController popViewControllerAnimated:YES];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) back:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void) popView:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


- (void) setUpMappViewButtons {
	
	CustomUIToolbar *toolbar = [[CustomUIToolbar alloc] initWithFrame:CGRectMake(0, 0, 122, 44)];
	
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:5];
	
	UIImage *locationImg = [UIImage imageNamed:@"icon_location.png"];
	UIImage *layersImg = [UIImage imageNamed:@"icon_layers.png"];
	UIImage *mappviewImg = [UIImage imageNamed:@"icon_listview_v2.png"];
	
	UIBarButtonItem *locationButton = [[UIBarButtonItem alloc] initWithImage:locationImg style:UIBarButtonItemStyleBordered target:self action:@selector(locationClick:)];
	locationButton.width = 32.0;
	[buttons addObject:locationButton];
	[locationButton release];
	
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	spacer.width = 1.0;
	[buttons addObject:spacer];
	
	UIBarButtonItem *layersButton = [[UIBarButtonItem alloc] initWithImage:layersImg style:UIBarButtonItemStyleBordered target:self action:@selector(layersClick:)];
	layersButton.width = 32.0;
	[buttons addObject:layersButton];
	[layersButton release];
	
	[buttons addObject:spacer];
	
	UIBarButtonItem *mappviewButton = [[UIBarButtonItem alloc] initWithImage:mappviewImg style:UIBarButtonItemStyleBordered target:self action:@selector(listviewClick:)];
	mappviewButton.width = 32.0;
	[buttons addObject:mappviewButton];
	[mappviewButton release];
	
	//[locationImg release];
	//[layersImg release];
	//[mappviewImg release];	
	
	[toolbar setItems:buttons animated:NO];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolbar] autorelease];
	
	[spacer release];
	[buttons release];
	[toolbar release];
	
}

- (void)flipsideViewControllerDidFinish:(UIViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)addMappPoints {
	
	NSInteger thecount = [appDelegate.entries count];
	
	NSMutableArray* annotationsARR = [[NSMutableArray alloc] initWithCapacity:thecount];
	AnnotationPoint *annotation = nil; 	
	landmark * alandmark = [appDelegate.entries objectAtIndex:0];
	float max_long = alandmark.longtitude;
	float min_long = alandmark.longtitude;
	float max_lat = alandmark.latitude;
	float min_lat = alandmark.latitude;
	
	for (int n = 0; n < thecount; n = n + 1) {
		
		alandmark = [appDelegate.entries objectAtIndex:n];
		CLLocationCoordinate2D location;
		location.latitude = alandmark.latitude;
		location.longitude = alandmark.longtitude;
		
		//NSLog(@"latitude: %f", location.latitude);
		//NSLog(@"longtitude %f", location.longitude);
		
		annotation = [[AnnotationPoint alloc] initWithCoordinates:location 
															title:alandmark.title 
														 subTitle:alandmark.address];
		
		annotation.itemIndex = n;
		//annotation.pinColor = MKPinAnnotationColorRed;
		annotation.pinColor = MKPinAnnotationColorGreen;
		
		[annotationsARR addObject:annotation];
		
		//FIND MAX LONG AND LAT
		if (alandmark.latitude > max_lat) {
			max_lat = alandmark.latitude;
		}
		
		if (alandmark.latitude < min_lat) {
			min_lat = alandmark.latitude;
		}
		
		if(alandmark.longtitude > max_long){
			max_long = alandmark.longtitude;
		}
		
		if (alandmark.longtitude < min_long) {
			min_long = alandmark.longtitude;
		}			
		
		[annotation release];
	}
	
	float center_long = 0.0;
	float center_lat = 0.0;
	
	float deltaLat = 0.0;
	float deltaLong = 0.0;
	
	landmark * closestlandmark = [appDelegate.entries objectAtIndex:0];
	
	if (appDelegate.nearMeCount > 20 && closestlandmark.distance > 3.0) {
		
		max_long = appDelegate.mylocation.longitude;
		min_long = appDelegate.mylocation.longitude;
		max_lat = appDelegate.mylocation.latitude;
		min_lat = appDelegate.mylocation.latitude;
		
		if (closestlandmark.latitude > max_lat) {
			max_lat = closestlandmark.latitude;
		}
		
		if (closestlandmark.latitude < min_lat) {
			min_lat = closestlandmark.latitude;
		}
		
		if (closestlandmark.longtitude > max_long) {
			max_long = closestlandmark.longtitude;
		}
		
		if (closestlandmark.longtitude < min_long) {
			min_long = closestlandmark.longtitude;
		}
		
		center_long = (max_long + min_long) / 2;
		center_lat = (max_lat + min_lat) / 2;
		deltaLat = fabs(max_lat - min_lat);
		deltaLong = fabs(max_long - min_long);
		
		/*center_long = appDelegate.mylocation.longitude;
		center_lat = appDelegate.mylocation.latitude;
		deltaLat = 0.1;
		deltaLong = 0.1;*/			
		
	}else {
		
		center_long = (max_long + min_long) / 2;
		center_lat = (max_lat + min_lat) / 2;
		deltaLat = fabs(max_lat - min_lat);
		deltaLong = fabs(max_long - min_long);
		
	}
	
	//NSLog(@"DeltaLat: %f", deltaLat);
	//NSLog(@"DeltaLong: %f", deltaLong);
	
	
	CLLocationCoordinate2D center_coord = {.latitude=center_lat, .longitude=center_long};
	MKCoordinateSpan span = MKCoordinateSpanMake(deltaLat, deltaLong);
	MKCoordinateRegion region = {center_coord, span};	
	
	[self.theMapView addAnnotations:annotationsARR];
	[self.theMapView setRegion:region animated:NO];
	
	//SHOW USER
	theMapView.showsUserLocation = YES;
	showingUser = YES;
	
	//[alandmark release];
	[annotationsARR release];
	
	
}

//Rotation Controls

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
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
			
	annotationView.rightCalloutAccessoryView = rightAccessoryButton;
	annotationView.pinColor = senderAnnotation.pinColor;
	annotationView.animatesDrop = YES;
	
	
	result = annotationView;
		
	return(result);
	[annotationView release];
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	
	AnnotationPoint *senderAnnotation = (AnnotationPoint *)view.annotation;
	
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(popView:)];
	backbutton.width = 65.0;
	
	landmark *lm = [appDelegate.entries objectAtIndex:senderAnnotation.itemIndex];
	PointViewController *pointVC = [[PointViewController alloc] initWithNibName:@"PointViewController" bundle:nil];
	pointVC.navigationItem.leftBarButtonItem = backbutton;	
	pointVC.navigationItem.hidesBackButton = YES;
	pointVC.alandmark = lm;
	
	[self.navigationController pushViewController:pointVC animated:YES];
	
	//[backImg release];
	[backbutton release];
	[pointVC release];
	
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
	
}

- (void)mapView: (MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	
}

- (void)mapView: (MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	
}


#pragma mark -
#pragma mark NSURLConnection Delegate

///------------------------------------------
///------NSURLCONNECTION DELEGATE -----------
///------------------------------------------

- (void) connection:(NSURLConnection *)connection
 didReceiveResponse:(NSURLResponse *)response{
	
	[self.connectionData setLength:0];
}

- (void) connection:(NSURLConnection *)connection
	 didReceiveData:(NSData *)data{
	
	[self.connectionData appendData:data];
}

- (void) connection:(NSURLConnection *)connection
   didFailWithError:(NSError *)error{
	
	//NSLog(@"A connection error has occurred.");
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	
	if (self.connectionData != nil) {
		
		//NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:self.connectionData];
		
		//Initialize the delegate.
		XMLParser *parser = [[XMLParser alloc] initXMLParser];
		
		//Set delegate
		[xmlParser setDelegate:parser];
		
		//Start parsing the XML file.
		BOOL success = [xmlParser parse];
		
		if(success){
			//NSLog(@"No Errors");
			self.dataReceived = YES;
									
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			
			[MBProgressHUD hideHUDForView:self.view animated:YES];			
			
			
			if(appDelegate.nearMeCount == 0 ){
				UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Sorry" 
																  message:@"There are no points near to you. Please select and view all points to continue." 
																 delegate:nil 
														cancelButtonTitle:@"OK" 
														otherButtonTitles:nil];
				
				[message show];
				[message release];
				
			}else {
				[self addMappPoints];
				[self.screen removeFromSuperview];
			}

			
		}else{
			//NSLog(@"Error Error Error!!!");
			
		}
		
		[xmlParser release];
		[parser release];
	}
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
	if (connection != nil) {
		[connection cancel];
	}
	
	[connection release];		
	[connectionData release];
	[activityIndicator release];
	[theMapView release];
	[rightAccessoryButton release];
	[screen release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void) actionSheet:(UIActionSheet *)actionsheet
clickedButtonAtIndex:(NSInteger )buttonIndex {
	
	NSString *buttonTitle = [actionsheet buttonTitleAtIndex:buttonIndex];
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	backbutton.width = 65.0;
	
	if ([buttonTitle isEqualToString:@"All Points"]) {
		
		SelectStateViewController * statesVC = [[SelectStateViewController alloc] initWithNibName:@"SelectStateViewController" bundle:nil];
		statesVC.navigationItem.leftBarButtonItem = backbutton;
		statesVC.navigationItem.hidesBackButton = YES;
		
		[self.navigationController pushViewController:statesVC animated:YES];
		[statesVC release];
		
	}else if ([buttonTitle isEqualToString:@"More Than A Month Points"]) {
		
		PointsLayerViewController * pointsLV = [[PointsLayerViewController alloc] initWithNibName:@"PointsLayerViewController" bundle:nil];
		pointsLV.navigationItem.leftBarButtonItem = backbutton;
		pointsLV.navigationItem.hidesBackButton = YES;
		pointsLV.pointType = @"film";
		
		[self.navigationController pushViewController:pointsLV animated:YES];
		[pointsLV release];
		
	}else if ([buttonTitle isEqualToString:@"Mapper Points"]) {
		
		PointsLayerViewController * pointsLV = [[PointsLayerViewController alloc] initWithNibName:@"PointsLayerViewController" bundle:nil];
		pointsLV.navigationItem.leftBarButtonItem = backbutton;
		pointsLV.navigationItem.hidesBackButton = YES;
		pointsLV.pointType = @"users";
		
		[self.navigationController pushViewController:pointsLV animated:YES];
		[pointsLV release];
		
	}else if ([buttonTitle isEqualToString:@"My Bookmarks"]) {
		
		BookmarkLayerViewController * bookmarksLV = [[BookmarkLayerViewController alloc] initWithNibName:@"BookmarkLayerViewController" bundle:nil];
		bookmarksLV.navigationItem.leftBarButtonItem = backbutton;
		bookmarksLV.navigationItem.hidesBackButton = YES;
		
		[self.navigationController pushViewController:bookmarksLV animated:YES];
		[bookmarksLV release];
		
	}else if ([buttonTitle isEqualToString:@"Search"]) {
		
		SearchViewController * searchVC = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
		searchVC.navigationItem.leftBarButtonItem = backbutton;
		searchVC.navigationItem.hidesBackButton = YES;
		
		[self.navigationController pushViewController:searchVC animated:YES];
		[searchVC release];
		
	}
	
	//[backImg release];
	[backbutton release];
	
}


@end
