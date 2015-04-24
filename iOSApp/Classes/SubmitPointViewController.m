//
//  SubmitPointViewController.m
//  MTAM
//
//  Created by Haldane Henry on 7/24/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "SubmitPointViewController.h"
#import "MTAMAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "GANTracker.h"
#import "MyWebViewController.h"

@implementation SubmitPointViewController

@synthesize thetableView, sectionFooterView, sectionHeaderView, imageData, statesARR, toggleSwitch, termsAndConditions;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];
	imageData = [NSData alloc];
	
	UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedLink:)];
	[termsAndConditions setUserInteractionEnabled:YES];
	[termsAndConditions addGestureRecognizer:gesture];
	
	
	thetableView.backgroundColor = [UIColor clearColor];
	thetableView.opaque = NO;
	thetableView.backgroundView = nil;
	
    [gesture release];
    
	// Gracefully handle reloading the view controller after a memory warning
    tableModel = [[SCModelCenter sharedModelCenter] modelForViewController:self];
    if(tableModel)
    {
        [tableModel replaceModeledTableViewWith:self.thetableView];
        return;
    }
	
	
	tableModel = [[SCTableViewModel alloc] initWithTableView:self.thetableView withViewController:self];
	
	SCTableViewSection *section = [SCTableViewSection sectionWithHeaderTitle:@"Section Header"];
	section.headerView = self.sectionHeaderView;
	section.footerView = self.sectionFooterView;
	
	[tableModel addSection:section];
	
	statesARR = [NSMutableArray arrayWithObjects:@"Alabama",@"Alaska",@"Arizona",@"Arkansas",@"California",@"Colorado",@"Connecticut",@"Delaware",@"District of Columbia",@"Florida",@"Georgia",@"Hawaii",@"Idaho",@"Illinois",@"Indiana",@"Iowa",@"Kansas",@"Kentucky",@"Louisiana",@"Maine",@"Maryland",@"Massachusetts",@"Michigan",@"Minnesota",@"Mississippi",@"Missouri",@"Montana",@"Nebraska",@"Nevada",@"New Hampshire",@"New Jersey",@"New Mexico",@"New York",@"North Carolina",@"North Dakota",@"Ohio",@"Oklahoma",@"Oregon",@"Pennsylvania",@"Rhode Island",@"South Carolina",@"South Dakota",@"Tennessee",@"Texas",@"Utah",@"Vermont",@"Virginia",@"Washington",@"West Virginia",@"Wisconsin",@"Wyoming",nil];
	
	
	SCTextFieldCell *locationTextFieldCell = [SCTextFieldCell cellWithText:@"Name" withPlaceholder:@"location name" 
															  withBoundKey:@"location" withTextFieldTextValue:nil];
	locationTextFieldCell.valueRequired = TRUE;
	locationTextFieldCell.backgroundColor = [[[UIColor alloc] initWithRed:0.827 green:0.827 blue:0.827 alpha:1.0] autorelease];
	
	
	SCTextFieldCell *addressTextFieldCell = [SCTextFieldCell cellWithText:@"Address" withPlaceholder:@"enter address" 
														   withBoundKey:@"address" withTextFieldTextValue:nil];
	addressTextFieldCell.valueRequired = TRUE;
	addressTextFieldCell.backgroundColor = [[[UIColor alloc] initWithRed:0.827 green:0.827 blue:0.827 alpha:1.0] autorelease];
	
	SCTextFieldCell *cityTextFieldCell = [SCTextFieldCell cellWithText:@"City" withPlaceholder:@"enter city" 
															  withBoundKey:@"city" withTextFieldTextValue:nil];
	cityTextFieldCell.valueRequired = TRUE;
	cityTextFieldCell.backgroundColor = [[[UIColor alloc] initWithRed:0.827 green:0.827 blue:0.827 alpha:1.0] autorelease];
	
	SCTextFieldCell *stateSelectionCell = [SCSelectionCell cellWithText:@"State" withBoundKey:@"state" withSelectedIndexValue:nil withItems:statesARR];
	stateSelectionCell.valueRequired = TRUE;
	stateSelectionCell.backgroundColor = [[[UIColor alloc] initWithRed:0.827 green:0.827 blue:0.827 alpha:1.0] autorelease];
	
	SCNumericTextFieldCell *numTextFieldCell = [SCNumericTextFieldCell cellWithText:@"Zip" withPlaceholder:@"enter zip"
																	   withBoundKey:@"zip" withTextFieldTextValue:nil];
	//numTextFieldCell.valueRequired = FALSE;
	numTextFieldCell.backgroundColor = [[[UIColor alloc] initWithRed:0.827 green:0.827 blue:0.827 alpha:1.0] autorelease];
	
	SCTextViewCell *descriptionCell = [SCTextViewCell cellWithText:@"Description" withBoundKey:@"desc" withTextViewTextValue:nil];
	
	descriptionCell.valueRequired = TRUE;
	descriptionCell.backgroundColor = [[[UIColor alloc] initWithRed:0.827 green:0.827 blue:0.827 alpha:1.0] autorelease];
	descriptionCell.autoResize = TRUE;
	descriptionCell.editable = TRUE;
	descriptionCell.minimumHeight = 80;
	descriptionCell.maximumHeight = 150;
	
	SCImagePickerCell *imgPickerCell =[SCImagePickerCell cellWithText:@"Choose Photo" withBoundKey:@"photo" withImageNameValue:nil];
	imgPickerCell.backgroundColor = [[[UIColor alloc] initWithRed:0.827 green:0.827 blue:0.827 alpha:1.0] autorelease];
	imgPickerCell.displayImageNameAsCellText = FALSE;
	imgPickerCell.imageViewFrame = CGRectMake(1, 8, 75, 85);
	
	
		
	[section addCell:locationTextFieldCell];
	[section addCell:addressTextFieldCell];
	[section addCell:cityTextFieldCell];
	[section addCell:stateSelectionCell];
	[section addCell:numTextFieldCell];
	[section addCell:descriptionCell];
	[section addCell:imgPickerCell];
	
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
	
	if (imageData != nil) {
		[imageData release];
	}
	
	[thetableView release];
	[tableModel release];
	[sectionFooterView release];
	[sectionHeaderView release];
    [super dealloc];
}


#pragma mark -
#pragma mark View Methods


- (IBAction) closeClick:(id)sender {
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (IBAction) switchValueChanged:(id)sender {
	
}

- (void) userTappedLink:(UIGestureRecognizer*)gestureRecognizer {
		
	UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(closeClick:)];
	
	MyWebViewController * wVC = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil];
	wVC.navigationItem.leftBarButtonItem = doneButton;
	wVC.navigationItem.hidesBackButton = YES;
	wVC.location = [NSURL URLWithString:@"http://www.morethanamapp.org/request/upload_t_and_c.html"];
	
	UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:wVC];	
	
	[self presentModalViewController:navCon animated:YES];
	
	[doneButton release];
	[wVC release];
    [navCon release];
	
}

- (IBAction) addClick:(id)sender {
	
	if(tableModel.valuesAreValid && toggleSwitch.on){
		
		[tableModel.activeCell resignFirstResponder];
		
		NSString * location = [tableModel.modelKeyValues valueForKey:@"location"];
		NSString * address = [tableModel.modelKeyValues valueForKey:@"address"];
		NSString * city = [tableModel.modelKeyValues valueForKey:@"city"];
		
		//NSInteger stateINT = [(NSInteger )[tableModel.modelKeyValues valueForKey:@"state"]];
		//NSString * state = [statesARR objectAtIndex:stateINT];
		NSString * state = [tableModel.modelKeyValues valueForKey:@"state"];
		
		NSString * zip = [tableModel.modelKeyValues valueForKey:@"zip"];
		NSString * desc = [tableModel.modelKeyValues valueForKey:@"desc"];
		
		//NSIndexPath * imageCellPath = [NSIndexPath indexPathWithIndex:6];		
		
		//NSLog(@"Description: %@", desc);
		
		NSURL * url = [NSURL URLWithString:@"http://www.morethanamapp.org/request/add-mapp-point.php"];
		ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
		[request setPostValue:appDelegate.userId forKey:@"user_id"];
		[request setPostValue:location forKey:@"title"];
		[request setPostValue:address forKey:@"addr"];
		[request setPostValue:city forKey:@"city"];
		[request setPostValue:state forKey:@"state"];
		[request setPostValue:zip forKey:@"zip"];
		[request setPostValue:desc forKey:@"details"];
		
		NSString * photoName = [NSString stringWithFormat:@"%@.jpg",location];
		photoName = [photoName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
		
		NSLog(@"photoName: %@",photoName);
		
		if(imageData != nil) {
			//NSLog(@"Hey Photo Whats Good");
			[request setData:imageData withFileName:photoName andContentType:@"image/jpeg" forKey:@"mappphoto"];
		}
		
		
		[request setDelegate:self];
		[request startAsynchronous];
		
		MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.labelText = @"Adding Point...";
		
	}else {
		
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Add A Point"
														  message:@"Please Complete all required fields"
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
		
		[message show];
		[message release];
		
	}

	
}


#pragma mark -
#pragma mark ASIFormDataRequest delegate

- (void)requestFinished:(ASIHTTPRequest *) request {
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	if (request.responseStatusCode == 400) {
		
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Add A Point"
														  message:@"Invalid Request"
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
		
		[message show];
		[message release];
		
	}else if (request.responseStatusCode == 200) {
		
		NSError * error;
		if (![[GANTracker sharedTracker] trackEvent:@"Submit_New_Point"
											 action:@"Submit_Point" 
											  label:@"Successful_Point_Submission" 
											  value:-1 
										  withError:&error]) {
			NSLog(@"GANTracker Error: %@",error);
		}
		
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success" 
														  message:@"Your point was successful added for review and will be available once its approved" 
														 delegate:nil 
												cancelButtonTitle:@"OK" 
												otherButtonTitles:nil];
		
		[message show];
		[message release];
		
		[self dismissModalViewControllerAnimated:YES];
	}
	
}


- (void)requestFailed:(ASIHTTPRequest *)request {
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	NSError * error = [request error];
	NSLog(@"ERROR: %@",error.localizedDescription);
	
	
	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Add A Point" 
													  message:@"Connection Timed Out, Try Again." 
													 delegate:nil 
											cancelButtonTitle:@"OK" 
											otherButtonTitles:nil];
	
	[message show];
	[message release];
}



#pragma mark -
#pragma mark SCTableViewModelDelegate Methods

- (void)tableViewModel:(SCTableViewModel *) tableViewModel willConfigureCell:(SCTableViewCell *) cell forRowAtIndexPath:(NSIndexPath *) indexPath
{
	
	if (indexPath.row == 6) {
		
		cell.height = 100;
		
	}
	
}

- (void)tableViewModel:(SCTableViewModel *)tableViewModel didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	SCTableViewCell *cell = [tableViewModel cellAtIndexPath:indexPath];
	[cell setSelected:FALSE animated:YES];
}

- (void)tableViewModel:(SCTableViewModel *)tableViewModel valueChangedForRowAtIndexPath:(NSIndexPath *)indexPath {
			
	SCTableViewCell * cell = [tableModel cellAtIndexPath:indexPath];
	
	if([cell isKindOfClass:[SCImagePickerCell class]]){
		//NSLog(@"Hey Photo WTF");
		
		//UIImage * selectedImg = [UIImage alloc];
		UIImage * selectedImg = ((SCImagePickerCell *)cell).selectedImage;
		
		if(selectedImg){
			imageData = [NSData dataWithData:UIImageJPEGRepresentation(selectedImg, 1.0)];
			[imageData retain];
		}
		
		//[selectedImg release];
	}
}

/*- (void)tableViewModel:(SCTableViewModel *)tableViewModel returnButtonTappedForAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableViewModel.activeCell resignFirstResponder];
	
}*/

#pragma mark -
#pragma mark SCTableViewCellDelegate Methods


@end
