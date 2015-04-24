//
//  ListViewController.m
//  MTAM
//
//  Created by Haldane Henry on 6/16/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "ListViewController.h"
#import "CustomUIToolbar.h"
#import "MTAMAppDelegate.h"
#import "HJObjManager.h"
#import "HJManagedImageV.h"
#import "XMLParser.h"
#import "landmark.h"
#import "PointViewController.h"
#import "PointsLayerViewController.h"
#import "BookmarkLayerViewController.h"
#import "SelectStateViewController.h"
#import "SearchViewController.h"
#import "GANTracker.h"

@implementation ListViewController

@synthesize delegate, thetableView, screen, connectionData, connection, dataReceived;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.dataReceived = YES;
			
	thetableView.backgroundColor = [UIColor clearColor];
	thetableView.opaque = NO;
	thetableView.backgroundView = nil;
	
	//[self setTitle:@"List View"];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self setUpListViewButtons];
	
	
	NSError * error;
	
	if (![[GANTracker sharedTracker] trackPageview:@"/app_points_listview" 
										 withError:&error]) {
		
		//NSLog(@"GANTracker Error: %@", error);
	}
}


#pragma mark -
#pragma mark Local Methods

- (IBAction) locationClick:(id)sender{
	
}

- (IBAction) layersClick:(id)sender{
	
	UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"LAYERS" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"All Points",@"More Than A Month Points",@"Mapper Points", @"My Bookmarks", @"Search",nil];
	
	shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[shareActionSheet showInView:self.view];
	[shareActionSheet release];
	
}

- (IBAction) mapviewClick:(id)sender{
	//NSLog(@"Dismiss Map View");
	[self.delegate flipsideViewControllerDidFinish:self.navigationController];
}

- (void) closeView:(id)sender {
	//[self dismissModalViewControllerAnimated:NO];
	[self.navigationController popViewControllerAnimated:YES];
	//[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) back:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void) setUpListViewButtons {
	
	CustomUIToolbar *toolbar = [[CustomUIToolbar alloc] initWithFrame:CGRectMake(0, 0, 118, 44)];
	
	
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:5];
	
	//UIImage *locationImg = [UIImage imageNamed:@"icon_location.png"];
	UIImage *layersImg = [UIImage imageNamed:@"icon_layers.png"];
	UIImage *mappviewImg = [UIImage imageNamed:@"icon_mapview.png"];
	
	/*UIBarButtonItem *locationButton = [[UIBarButtonItem alloc] initWithImage:locationImg style:UIBarButtonItemStyleBordered target:self action:@selector(locationClick:)];
	locationButton.width = 28.0;
	[buttons addObject:locationButton];
	[locationButton release];*/
	
	UIBarButtonItem *spacerv2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	spacerv2.width = 28.0;
	[buttons addObject:spacerv2];
	
	UIBarButtonItem *layersButton = [[UIBarButtonItem alloc] initWithImage:layersImg style:UIBarButtonItemStyleBordered target:self action:@selector(layersClick:)];
	layersButton.width = 32.0;
	[buttons addObject:layersButton];
	[layersButton release];
	
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	spacer.width = 2.0;
	[buttons addObject:spacer];
	
	UIBarButtonItem *mappviewButton = [[UIBarButtonItem alloc] initWithImage:mappviewImg style:UIBarButtonItemStyleBordered target:self action:@selector(mapviewClick:)];
	mappviewButton.width = 32.0;
	[buttons addObject:mappviewButton];
	[mappviewButton release];
	
	//[locationImg release];
	//[layersImg release];
	//[mappviewImg release];
	
	
	[toolbar setItems:buttons animated:NO];
	
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolbar] autorelease];
	
	[spacerv2 release];
	[toolbar release];	
	[spacer release];
	[buttons release];
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
			[self.thetableView reloadData];
			
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			[activityIndicator stopAnimating];
			[self.screen removeFromSuperview];
			
		}else{
			//NSLog(@"Error Error Error!!!");
			
		}
		
		[xmlParser release];
		[parser release];
	}
}


///--------------------------------------------
///--------------------------------------------


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
	//NSLog(@"count: %d", [appDelegate.entries count]);
    return [appDelegate.entries count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	HJManagedImageV* mImg;
	UILabel * mLabel;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		
		//Create a managed image view and add it to the cell (layout is very naieve)
		mImg = [[[HJManagedImageV alloc] initWithFrame:CGRectMake(10,11,106,68)] autorelease];
		mImg.tag = 999;
		[cell addSubview:mImg];
		
		//create managed label
		mLabel = [[[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width - 40), 0, 50, 25)] autorelease];
		mLabel.tag = 888;
		mLabel.backgroundColor = [UIColor clearColor];
		mLabel.textColor = [UIColor whiteColor];
		mLabel.userInteractionEnabled = NO;
		mLabel.font = [UIFont systemFontOfSize:11];
		[cell addSubview:mLabel];
    } else {
		//Get a reference to the managed image view that was already in the recycled cell, and clear it
		mImg = (HJManagedImageV*)[cell viewWithTag:999];
		[mImg clear];
		
		//Get reference to mLabel
		mLabel = (UILabel *)[cell viewWithTag:888];
	}
	
	landmark *alandmark = [appDelegate.entries objectAtIndex:indexPath.row];
	
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
	
	UIView *sldview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
	sldview.backgroundColor = [[[UIColor alloc] initWithRed:0.929 green:0.607 blue:0.141 alpha:0.5] autorelease];
	sldview.alpha = 0.5;
	
	cell.selectedBackgroundView = sldview;
	//[sldview release];
	
	
	//SET Distance Text
	mLabel.text = [NSString stringWithFormat:@"%.01f mi",alandmark.distance];
	
	
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


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(closeView:)];
	backbutton.width = 65.0;
	
	landmark *lm = [appDelegate.entries objectAtIndex:indexPath.row];
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
#pragma mark Memory management

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
	
	[thetableView release];
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
