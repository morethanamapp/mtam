//
//  SearchViewController.m
//  MTAM
//
//  Created by Haldane Henry on 9/9/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "SearchViewController.h"
#import "MTAMAppDelegate.h"
#import "XMLSubParser.h"
#import "MBProgressHUD.h"
#import "HJManagedImageV.h"
#import "landmark.h"
#import "PointViewController.h"

@implementation SearchViewController
@synthesize thetableView, searchDisplayController, searchBar, bgIMGView, searchResults, connectionData, connection, dataReceived;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.dataReceived = NO;
	
	thetableView.backgroundColor = [UIColor clearColor];
	thetableView.opaque = NO;
	thetableView.backgroundView = nil;
	
	UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
	self.thetableView.tableFooterView = footer;
	[footer release];
	
	searchDisplayController.searchResultsTableView.backgroundColor = [UIColor blackColor];
	searchDisplayController.searchResultsTableView.opaque = NO;
	searchDisplayController.searchResultsTableView.backgroundView = nil;		
	
	self.title = @"Search For A Point";
	
	bgIMGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appBG.png"]];
	
	//-----------------------------
	//GET ALL LANDMARKS FROM SERVER
	//-----------------------------
	NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.morethanamapp.org/request/get-mapp-points.php?lat=%d&long=%d&get_all=all", 0, 0]];
	
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


- (void) back:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
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
#pragma mark Search Delegate And Methods

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
	
	NSPredicate * resultPredicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@",searchText];
	NSArray * temp = [[appDelegate.subEntries copy] autorelease];
	
	self.searchResults = [temp filteredArrayUsingPredicate:resultPredicate];		
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	
	[self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
	
	return YES;
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
	
	[self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
	
	return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *) controller willShowSearchResultsTableView:(UITableView *)tableView {
			
	searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
	searchDisplayController.searchResultsTableView.opaque = NO;
	searchDisplayController.searchResultsTableView.backgroundView = bgIMGView;
	
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
	
	
}


#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	backbutton.width = 65.0;
	
	landmark * lm = nil;
	
	if([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
		lm = [self.searchResults objectAtIndex:indexPath.row];
	}else {
		lm = [appDelegate.subEntries objectAtIndex:indexPath.row];
	}
	
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
#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger num = 0;
	
	if (self.dataReceived == YES) {
		
		if([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
			num = 1;
		}else {
			
			if (self.searchResults == nil) {
				num = 1;
			}else {
				num = 1;
			}
			
		}
		
	}else {
		num = 0;
	}
	
    return num;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	NSInteger rows = 0;
	
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
		rows = [self.searchResults count];
	}else {
		
		if (self.searchResults == nil) {
			rows = 0;
		}else {
			rows = [self.searchResults count];
		}
				
	}
	
	return rows;
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
	
	landmark * alandmark = nil;
	
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
		
		alandmark = [self.searchResults objectAtIndex:indexPath.row];
		
	}else {
				
		if (self.searchResults == nil) {
			alandmark = [appDelegate.subEntries objectAtIndex:indexPath.row];
			
		}else {
			
			alandmark = [self.searchResults objectAtIndex:indexPath.row];
		}
		
	}
		
    
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
	
	[bgIMGView release];
	[connection release];		
	[connectionData release];
	[searchResults release];
	[thetableView release];
    [super dealloc];
}


@end
