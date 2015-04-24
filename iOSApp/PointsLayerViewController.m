//
//  PointsLayerViewController.m
//  MTAM
//
//  Created by Haldane Henry on 7/27/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "PointsLayerViewController.h"
#import "MTAMAppDelegate.h"
#import "XMLSubParser.h"
#import "landmark.h"
#import "HJManagedImageV.h"
#import "PointViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"

@implementation PointsLayerViewController

@synthesize pointType, thetableView, screen, connectionData, connection, dataReceived, upperLimit, lowerLimit, prevButton, nextButton, tableFooter, getThis, stateINT;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		// Custom initialization.
		
		self.stateINT = -1;
	}
	
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	if (pointType == @"all") {
		//self.title = @"All Points";
		self.getThis = @"all";
		
	}else if (pointType == @"users") {
		self.title = @"Mapper Points";
		self.getThis = @"users";
		
	}else if (pointType == @"film") {
		self.title = @"More Than A Month Points";
		self.getThis = @"film";
	}
			
	self.dataReceived = NO;
	
	upperLimit = RESULTINTERVAL;
	lowerLimit = 0;
	prevButton.hidden = YES;
	
	/*[self.view addSubview:screen];*/
	
	/*activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview:activityIndicator];*/	
		
	
	//NSString * auth = [self createSHA512:[NSString stringWithFormat:@"%@%@",appDelegate.mtamWebSalt, appDelegate.mtamAuthKey]];
	
	[self getMapPoints];
	
	thetableView.backgroundColor = [UIColor clearColor];
	thetableView.opaque = NO;
	thetableView.backgroundView = nil;
	
}

//Rotation Controls

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
#pragma mark Local Methods

- (NSString *) createSHA512:(NSString *)source {
	
	const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
	
	NSData * keyData = [NSData dataWithBytes:s length:strlen(s)];
	
	uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
	
	CC_SHA512(keyData.bytes, keyData.length, digest);
	
	NSData * out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
	
	return [out description];
	
}


- (void) back:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction) previous:(id)sender{
	
	appDelegate.resetResults = YES;
	
	lowerLimit = lowerLimit - RESULTINTERVAL;
	upperLimit = upperLimit - RESULTINTERVAL;
	
	if(lowerLimit < 0){
		lowerLimit = 0;	
	}
	
	if(upperLimit < RESULTINTERVAL){
		upperLimit = RESULTINTERVAL;		
	}
	
	if (lowerLimit == 0) {
		prevButton.hidden = YES;
	}		
	
	//NSLog(@"Layer Result Count: %d",appDelegate.layerResultCount);
	
	if(upperLimit < appDelegate.layerResultCount){
		nextButton.hidden = NO;
	}
	
	/*self.dataReceived = NO;
	[self.thetableView reloadData];*/
	[self getMapPoints];
	
}


- (IBAction) next:(id)sender {
	
	appDelegate.resetResults = YES;
	
	//NSLog(@"Results Count: %d", appDelegate.layerResultCount);
	
	lowerLimit = lowerLimit + RESULTINTERVAL;
	upperLimit = upperLimit + RESULTINTERVAL;	
	
	//NSLog(@"Layer Result Count: %d",appDelegate.layerResultCount);
	
	if (upperLimit > appDelegate.layerResultCount) {
		
		upperLimit = appDelegate.layerResultCount;
		nextButton.hidden = YES;
	}
	
	if (lowerLimit > 0) {
		prevButton.hidden = NO;
	}
	
	/*self.dataReceived = NO;
	[self.thetableView reloadData];*/
	[self getMapPoints];
	
}

- (void) getMapPoints {	
		
	NSURL * url = nil;
	
	if(stateINT == -1){
		url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.morethanamapp.org/request/get-mapp-points.php?lat=%d&long=%d&get_all=%@&upper=%d&lower=%d", 0, 0, self.getThis, upperLimit, lowerLimit]];
		
	}else {
		url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.morethanamapp.org/request/get-mapp-points.php?lat=%d&long=%d&get_all=%@&upper=%d&lower=%d&state=%d", 0, 0, self.getThis, upperLimit, lowerLimit, stateINT]];
	}

	
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
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"Loading...";
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
	
	self.dataReceived = NO;
	[self.thetableView reloadData];
	
}

- (void) connection:(NSURLConnection *)connection
   didFailWithError:(NSError *)error{
	
	//NSLog(@"A connection error has occurred.");
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	
	if (self.connectionData != nil) {
		
		NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:self.connectionData];
		
		//Initialize the delegate.
		XMLSubParser *parser = [[XMLSubParser alloc] initXMLParser];
		
		//Set delegate
		[xmlParser setDelegate:parser];
		
		//Start parsing the XML file.
		BOOL success = [xmlParser parse];
		
		if(success){
			//NSLog(@"No Errors");
			self.dataReceived = YES;
			[self.thetableView reloadData];
			
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			[MBProgressHUD hideHUDForView:self.view animated:YES];
			
			if(appDelegate.layerResultCount > RESULTINTERVAL ){
				thetableView.tableFooterView = self.tableFooter;
			}
			
			if(appDelegate.layerResultCount == 0 ){
				UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Sorry" 
																  message:@"There are no points at this time" 
																 delegate:nil 
														cancelButtonTitle:@"OK" 
														otherButtonTitles:nil];
				
				[message show];
				[message release];
			}
			
			/*[activityIndicator stopAnimating];
			[self.screen removeFromSuperview];*/
			
		}else{
			//NSLog(@"Error Error Error!!!");
			//NSLog(@"Error: %@", self.connectionData);
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			[MBProgressHUD hideHUDForView:self.view animated:YES];
		}
		
		[xmlParser release];
		[parser release];
		
	}
}


#pragma mark -
#pragma mark TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger num = 0;
	
	if (self.dataReceived == YES) {
		num = 1;
	}else {
		num = 0;
	}
	
	//NSLog(@"sections: %d",num);
	
    return num;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	//NSLog(@"count: %d", [appDelegate.subEntries count]);
    return [appDelegate.subEntries count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	HJManagedImageV* mImg;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		
		//Create a managed image view and add it to the cell (layout is very naieve)
		mImg = [[[HJManagedImageV alloc] initWithFrame:CGRectMake(10,11,106,68)] autorelease];
		mImg.tag = 999;
		[cell addSubview:mImg];
    } else {
		//Get a reference to the managed image view that was already in the recycled cell, and clear it
		mImg = (HJManagedImageV*)[cell viewWithTag:999];
		[mImg clear];
	}
	
	landmark *alandmark = [appDelegate.subEntries objectAtIndex:indexPath.row];
	
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
	
	UIView *sldview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
	sldview.backgroundColor = [[[UIColor alloc] initWithRed:0.929 green:0.607 blue:0.141 alpha:0.5] autorelease];
	sldview.alpha = 0.5;
	
	cell.selectedBackgroundView = sldview;
	//[sldview release];
	
	
	cell.textLabel.text = alandmark.title;
	cell.textLabel.textAlignment = UITextAlignmentLeft;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
	cell.textLabel.textColor = [[[UIColor alloc] initWithRed:0.929 green:0.607 blue:0.141 alpha:1.0] autorelease];
	cell.textLabel.shadowColor = [UIColor blackColor];
	cell.textLabel.numberOfLines = 2;
	//cell.textLabel.adjustsFontSizeToFitWidth = YES;	
	//cell.textLabel.minimumFontSize = 10;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	cell.detailTextLabel.text = alandmark.excerpt;
	cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
	cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
	cell.detailTextLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.numberOfLines = 2;
	
	cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_accessoryview_image.png"]] autorelease];
	
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"emptyCellGraphic" ofType:@"png"];
	//UIImage *theImage = [UIImage imageWithContentsOfFile:path];
	//cell.imageView.image = theImage;
	//[theImage release];
	
	if (alandmark.photo == (id)[NSNull null] || alandmark.photo.length == 0 ) {
		
		cell.imageView.image = [UIImage imageNamed:@"list_image_frame_with_icon.png"];
		
	}else {
		
		cell.imageView.image = [UIImage imageNamed:@"list_image_frame.png"];
	}
	
	//set the URL that we want the managed image view to load
	mImg.url = [NSURL URLWithString:alandmark.photo];
	
	//tell the object manager to manage the managed image view, 
	//this causes the cached image to display, or the image to be loaded, cached, and displayed
	[appDelegate.objMan manage:mImg];		
	
    [sldview release];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat rowHeight = 100;
	
	return rowHeight;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	backbutton.width = 65.0;
	
	landmark *lm = [appDelegate.subEntries objectAtIndex:indexPath.row];
	PointViewController *pointVC = [[PointViewController alloc] initWithNibName:@"PointViewController" bundle:nil];
	pointVC.navigationItem.leftBarButtonItem = backbutton;	
	pointVC.navigationItem.hidesBackButton = YES;
	pointVC.alandmark = lm;
	
	[self.navigationController pushViewController:pointVC animated:YES];
	
	[pointVC release];
	//[backImg release];
	[backbutton release];
	
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
	[thetableView release];
	[pointType release];
	
    [super dealloc];
}


@end
