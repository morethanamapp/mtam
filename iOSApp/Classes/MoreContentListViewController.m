//
//  MoreContentListViewController.m
//  MTAM
//
//  Created by Haldane Henry on 8/26/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "MoreContentListViewController.h"
#import "MyWebViewController.h"
#import "MTAMAppDelegate.h"
#import "YoutubeView.h"


@implementation MoreContentListViewController

@synthesize thetableView, theList, moreType;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	thetableView.backgroundColor = [UIColor clearColor];
	thetableView.opaque = NO;
	thetableView.backgroundView = nil;
	
	//NSLog(@"theList %@", theList);
	//NSInteger rowCount = [theList count];
	//NSLog(@"theList count %d", rowCount);
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

- (void) back:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger num = 1;

    return num;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	NSInteger rowCount = [theList count];
	//NSLog(@"theList count %d", rowCount);
	
    return rowCount;
	//return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//NSLog(@"cellForRowAtPath");
	
    static NSString *CellIdentifier = @"Cell";
    
	//HJManagedImageV* mImg;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		
		//Create a managed image view and add it to the cell (layout is very naieve)
		//mImg = [[[HJManagedImageV alloc] initWithFrame:CGRectMake(10,11,106,68)] autorelease];
		//mImg.tag = 999;
		//[cell addSubview:mImg];
    }
	
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
	
	UIView *sldview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
	sldview.backgroundColor = [[[UIColor alloc] initWithRed:0.929 green:0.607 blue:0.141 alpha:0.5] autorelease];
	sldview.alpha = 0.5;
	
	cell.selectedBackgroundView = sldview;
	//[sldview release];
	
	NSInteger linknum = indexPath.row + 1;
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %d",moreType, linknum];
	//cell.textLabel.text = [NSString stringWithFormat:@"%@",moreType];
	cell.textLabel.textAlignment = UITextAlignmentLeft;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:22];
	cell.textLabel.textColor = [[[UIColor alloc] initWithRed:0.929 green:0.607 blue:0.141 alpha:1.0] autorelease];
	cell.textLabel.shadowColor = [UIColor blackColor];
	cell.textLabel.numberOfLines = 2;
	//cell.textLabel.adjustsFontSizeToFitWidth = YES;	
	//cell.textLabel.minimumFontSize = 10;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	NSString * link = [theList objectAtIndex:indexPath.row];
	NSString * substring = [link substringToIndex:4];
	//NSLog(@"%@",substring);
	
	if ([substring isEqualToString:@"http"]) {
		//do nothing
	}else {
		link = [NSString stringWithFormat:@"http://%@",link];
	}

	
	cell.detailTextLabel.text = link;
	cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
	cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
	cell.detailTextLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.numberOfLines = 2;
	
	cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_accessoryview_image.png"]] autorelease];
	
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
	
	NSString * link = [theList objectAtIndex:indexPath.row];
		
	if([link rangeOfString:@"http"].location == NSNotFound){		
		link = [NSString stringWithFormat:@"http://%@",link];		
	}else {
		// do nothing
	}
	
	if([link rangeOfString:@"youtube.com"].location == NSNotFound){
		
		MyWebViewController *webVC = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil];
		webVC.navigationItem.leftBarButtonItem = backbutton;	
		webVC.navigationItem.hidesBackButton = YES;
		webVC.location = [NSURL URLWithString:link];
		
		[self.navigationController pushViewController:webVC animated:YES];
		
		[webVC release];
		
				
	}else {
		
		YoutubeView * ytVC = [[YoutubeView alloc] initWithNibName:@"YoutubeView" bundle:nil];
		ytVC.navigationItem.leftBarButtonItem = backbutton;
		ytVC.navigationItem.hidesBackButton = YES;
		ytVC.ytLink = link;
		
		[self.navigationController pushViewController:ytVC animated:YES];
		[ytVC release];
		
	}

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
	[theList release];
    [super dealloc];
}


@end
