//
//  SelectStateViewController.m
//  MTAM
//
//  Created by Haldane Henry on 8/31/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "SelectStateViewController.h"
#import "PointsLayerViewController.h"

@implementation SelectStateViewController

@synthesize thetableView, statesARR;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 
	if (self) {
		// Custom initialization.
		
		self.statesARR = [NSMutableArray arrayWithObjects:@"Alabama",@"Alaska",@"Arizona",@"Arkansas",@"California",@"Colorado",@"Connecticut",@"Delaware",@"District of Columbia",@"Florida",@"Georgia",@"Hawaii",@"Idaho",@"Illinois",@"Indiana",@"Iowa",@"Kansas",@"Kentucky",@"Louisiana",@"Maine",@"Maryland",@"Massachusetts",@"Michigan",@"Minnesota",@"Mississippi",@"Missouri",@"Montana",@"Nebraska",@"Nevada",@"New Hampshire",@"New Jersey",@"New Mexico",@"New York",@"North Carolina",@"North Dakota",@"Ohio",@"Oklahoma",@"Oregon",@"Pennsylvania",@"Rhode Island",@"South Carolina",@"South Dakota",@"Tennessee",@"Texas",@"Utah",@"Vermont",@"Virginia",@"Washington",@"West Virginia",@"Wisconsin",@"Wyoming",nil];
	}
	
	return self;
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Select State";
	
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
#pragma mark TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger num = 1;
	//NSLog(@"states sections: %d", num);	
    return num;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	//NSLog(@"states count: %d", [statesARR count]);
    return [statesARR count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    		
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	
    } 
	
	NSString * stateName = [statesARR objectAtIndex:indexPath.row];
	
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
	
	UIView *sldview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
	sldview.backgroundColor = [[[UIColor alloc] initWithRed:0.929 green:0.607 blue:0.141 alpha:0.5] autorelease];
	sldview.alpha = 0.5;
	
	cell.selectedBackgroundView = sldview;
	//[sldview release];
	
	
	cell.textLabel.text = stateName;
	cell.textLabel.textAlignment = UITextAlignmentLeft;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
	cell.textLabel.textColor = [[[UIColor alloc] initWithRed:0.929 green:0.607 blue:0.141 alpha:1.0] autorelease];
	cell.textLabel.shadowColor = [UIColor blackColor];
	cell.textLabel.numberOfLines = 1;
	//cell.textLabel.adjustsFontSizeToFitWidth = YES;	
	//cell.textLabel.minimumFontSize = 10;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_accessoryview_image.png"]] autorelease];
    
    [sldview release];
				
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat rowHeight = 60.0;
	
	return rowHeight;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString * stateName = [statesARR objectAtIndex:indexPath.row];
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	backbutton.width = 65.0;
	
	PointsLayerViewController * pointsLV = [[PointsLayerViewController alloc] initWithNibName:@"PointsLayerViewController" bundle:nil];
	pointsLV.navigationItem.leftBarButtonItem = backbutton;
	pointsLV.navigationItem.hidesBackButton = YES;
	pointsLV.pointType = @"all";
	pointsLV.stateINT = indexPath.row;
	pointsLV.title = stateName;
	
	[self.navigationController pushViewController:pointsLV animated:YES];
	
	[pointsLV release];
	//[backImg release];
	[backbutton release];
	
}


#pragma mark -
#pragma mark Local Metods

- (void) back:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
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
	[statesARR release];
    [super dealloc];
}


@end
