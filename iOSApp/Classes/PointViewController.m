//
//  PointViewController.m
//  MTAM
//
//  Created by Haldane Henry on 7/5/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "PointViewController.h"
#import "CustomUIToolbar.h"
#import "HJManagedImageV.h"
#import "MTAMAppDelegate.h"
#import <objc/runtime.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ViewOnMapController.h"
#import "SHK.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "MoreContentListViewController.h"
#import "EGOPhotoGlobal.h"
#import "MyPhotoSource.h"
#import "GANTracker.h"

@implementation PointViewController

@synthesize alandmark, scroller, profilePic, moreContent, videoButton, audioButton, photoButton, linksButton, viewOnMapView;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	//CREATE MANAGE IMAGE AND SET UP PROFILE PIC
	HJManagedImageV* mImg;
	mImg = [[[HJManagedImageV alloc] initWithFrame:CGRectMake(32, 20, 254, 165)] autorelease];
	
	
	//SET UP PROFILE PIC
	//UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(39, 25, 254, 165)];
	//imgV.image = alandmark.photo;
	
	[self.profilePic addSubview:mImg];
	
	mImg.url = [NSURL URLWithString:alandmark.photo];
	[appDelegate.objMan manage:mImg];
	//[imgV release];
	
	[self setUpPointViewButtons];
	[self setUpScroll];
	
	///-----------------------------------------------------------
	///-----------------------------------------------------------
	NSError * error;
	NSString * trackpath = [NSString stringWithFormat:@"/app_point_%@",alandmark.title];
	
	if (![[GANTracker sharedTracker] trackPageview:trackpath 
										 withError:&error]) {
		
		//NSLog(@"GANTracker Error: %@", error);
	}
	
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

- (IBAction) directionsClick:(id)sender {
	
	
	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Get Directions" 
													  message:@"You are about to leave the app"
													 delegate:self
											cancelButtonTitle:@"Cancel" 
											otherButtonTitles:@"Ok, leave!",nil];
	
	[message show];
	[message release];			
}


- (IBAction) shareClick:(id)sender {
	
	UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"SHARE" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter",@"Facebook",@"Email",nil];
	
	shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[shareActionSheet showInView:self.view];
	[shareActionSheet release];
	
}

- (IBAction) bookmarkClick:(id)sender {
	
	[self assignNewBookmark];		
	
}



- (IBAction) showOnMap:(id)sender {
	
	/*UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"View On Map" 
													  message:@"Successfully Clicked" 
													 delegate:nil 
											cancelButtonTitle:@"OK" 
											otherButtonTitles:nil];
	
	[message show];
	[message release];*/
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	backbutton.width = 65.0;
	
	ViewOnMapController * vomVC = [[ViewOnMapController alloc] initWithNibName:@"ViewOnMapController" bundle:nil];
	vomVC.navigationItem.leftBarButtonItem = backbutton;	
	vomVC.navigationItem.hidesBackButton = YES;
	vomVC.alandmark = self.alandmark;
	
	[self.navigationController pushViewController:vomVC animated:YES];
	
	[vomVC release];
	//[backImg release];
	[backbutton release];
}

- (void) assignNewBookmark {
	
	NSString * errorDesc = nil;
	NSPropertyListFormat format;
	NSString * plistPath;
	NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	plistPath = [rootPath stringByAppendingPathComponent:@"mtamBookmarks.plist"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		//Create First Bookmark and save plist to path
		
		/*NSMutableDictionary * rootObj = [NSMutableDictionary dictionaryWithCapacity:1];
		NSDictionary * innerDict;
		
		innerDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:alandmark.title, alandmark.details, alandmark.excerpt, alandmark.photo, alandmark.address, alandmark.longtitude, alandmark.latitude, alandmark.gallery, alandmark.videos, alandmark.audios, alandmark.links,nil] forKeys:[NSArray arrayWithObjects:@"title",@"details", @"excerpt", @"photo", @"address", @"longtitude", @"latitude", @"gallery", @"videos", @"audios", @"links", nil]];
		[rootObj setObject:innerDict forKey:@"Landmark1"];*/
		
		NSArray * landmarkIDs = [NSArray arrayWithObject:[NSNumber numberWithInt:alandmark.landmarkid]];
		
		NSDictionary * rootDict = [NSDictionary dictionaryWithObject:landmarkIDs forKey:@"MyBookmarks"];
		
		NSData * plistData = [NSPropertyListSerialization dataFromPropertyList:rootDict 
																		format:NSPropertyListXMLFormat_v1_0 
															  errorDescription:&errorDesc];
		
		if (plistData) {
			[plistData writeToFile:plistPath atomically:YES];
			
			UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Bookmark" 
															  message:@"Successfully Added Bookmark" 
															 delegate:nil 
													cancelButtonTitle:@"OK" 
													otherButtonTitles:nil];
			
			[message show];
			[message release];
			
		}else {
			//NSLog(@"Error: %@",errorDesc);
			[errorDesc release];
		}

		
	}else {
		//Add to Bookmarks and Save File
		
		NSData * plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
		NSDictionary * temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML 
																			   mutabilityOption:NSPropertyListMutableContainersAndLeaves 
																						 format:&format 
																			   errorDescription:&errorDesc];
		
		if(!temp){
			//NSLog(@"Error reading plist: %@, format %d", errorDesc, format);
		}
		
		NSMutableArray * bookmarks = [NSMutableArray arrayWithArray:[temp objectForKey:@"MyBookmarks"]];
		BOOL foundID = NO;
		
		for(NSNumber * item in bookmarks){			
			if ([item intValue] == alandmark.landmarkid) {
				foundID = YES;
			}
		}
		
		if (!foundID) {
			//Add ID and Save update plist to file
			[bookmarks addObject:[NSNumber numberWithInt:alandmark.landmarkid]];
			
			NSDictionary * rootDict = [NSDictionary dictionaryWithObject:bookmarks forKey:@"MyBookmarks"];
			
			NSData * plistData = [NSPropertyListSerialization dataFromPropertyList:rootDict 
																			format:NSPropertyListXMLFormat_v1_0 
																  errorDescription:&errorDesc];
			
			if (plistData) {
				[plistData writeToFile:plistPath atomically:YES];
				
				UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Bookmark" 
																  message:@"Successfully Added Bookmark" 
																 delegate:nil 
														cancelButtonTitle:@"OK" 
														otherButtonTitles:nil];
				
				[message show];
				[message release];
				
			}else {
				//NSLog(@"Error: %@",errorDesc);
				[errorDesc release];
			}
			
		}else {
			
			UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Bookmark"
															  message:@"Bookmark Already In MyBookmarks"
															 delegate:nil
													cancelButtonTitle:@"OK"
													otherButtonTitles:nil];
			
			[message show];
			[message release];
			
		}

	}
}

- (void) back:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
}
	 
- (void) setUpPointViewButtons {
		 
	CustomUIToolbar *toolbar = [[CustomUIToolbar alloc] initWithFrame:CGRectMake(0, 0, 122, 44)];
		 
		 
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:5];
		 
	UIImage *directionImg = [UIImage imageNamed:@"icon_directions_v2.png"];
	UIImage *shareImg = [UIImage imageNamed:@"icon_share.png"];
	UIImage *bookmarkImg = [UIImage imageNamed:@"icon_bookmark_v2.png"];
		 
	UIBarButtonItem *directionButton = [[UIBarButtonItem alloc] initWithImage:directionImg style:UIBarButtonItemStyleBordered target:self action:@selector(directionsClick:)];
	directionButton.width = 32.0;
	[buttons addObject:directionButton];
	[directionButton release];
		 
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[buttons addObject:spacer];
		 	
	//UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareClick:)];
	//shareButton.style = UIBarButtonItemStyleBordered;
	UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareImg style:UIBarButtonItemStyleBordered target:self action:@selector(shareClick:)];
	shareButton.width = 32.0;
	[buttons addObject:shareButton];
	[shareButton release];
		 
	[buttons addObject:spacer];
		 
	//UIBarButtonItem *bookmarkButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkClick:)];
	//bookmarkButton.style = UIBarButtonItemStyleBordered;
	UIBarButtonItem *bookmarkButton = [[UIBarButtonItem alloc] initWithImage:bookmarkImg style:UIBarButtonItemStyleBordered target:self action:@selector(bookmarkClick:)];
	bookmarkButton.width = 32.0;
	[buttons addObject:bookmarkButton];
	[bookmarkButton release];	
	
		 
	[toolbar setItems:buttons animated:NO];
		 
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolbar] autorelease];
	
	[toolbar release];
	[buttons release];
	//[directionImg release];
	//[shareImg release];
	//[bookmarkImg release];
	[spacer release];
		 
}	 
	 

- (void) setUpScroll {
	
	[self.scroller setContentSize:CGSizeMake(0, 0)];	
	
	[self.scroller addSubview:self.profilePic];
	CGRect theframe = self.profilePic.frame;
	CGFloat contentHeight = 0.0;
	
	//ASSIGN VIEW ON MAP
	self.viewOnMapView.frame = CGRectMake(0, 0 + theframe.origin.y + theframe.size.height, self.viewOnMapView.frame.size.width, self.viewOnMapView.frame.size.height);
	[self.scroller addSubview:self.viewOnMapView];
	theframe = self.viewOnMapView.frame;
	
	
	//ASSIGN TITLE
	UILabel *lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 5 + theframe.origin.y + theframe.size.height, 280, 45)];
	lbltitle.text = alandmark.title;
	lbltitle.textColor = [[[UIColor alloc] initWithRed:0.929 green:0.607 blue:0.141 alpha:1.0] autorelease];
	lbltitle.shadowColor = [UIColor blackColor];
	lbltitle.font = [UIFont boldSystemFontOfSize:20];
	lbltitle.textAlignment = UITextAlignmentLeft;
	lbltitle.numberOfLines = 3;
	lbltitle.lineBreakMode = UILineBreakModeWordWrap;
	lbltitle.backgroundColor = [UIColor clearColor];
	
	[self.scroller addSubview:lbltitle];
	theframe = lbltitle.frame;
	
	
	//ASSIGN ADDRESS;
	UITextView *textViewAddr = [[UITextView alloc] initWithFrame:CGRectMake(10, 5 + theframe.origin.y + theframe.size.height, 300, 20)];
	textViewAddr.text = alandmark.address;
	textViewAddr.textColor = [UIColor whiteColor];
	textViewAddr.font = [UIFont boldSystemFontOfSize:16];
	textViewAddr.backgroundColor = [UIColor clearColor];
	textViewAddr.scrollEnabled = NO;
	textViewAddr.editable = NO;
	
	[self.scroller addSubview:textViewAddr];
	theframe = textViewAddr.frame;
	theframe.size.height = textViewAddr.contentSize.height;
	textViewAddr.frame = theframe;
	
	
	//ASSIGN CONTENT TEXT;
	UITextView *textViewContent = [[UITextView alloc] initWithFrame:CGRectMake(10, 10 + theframe.origin.y + theframe.size.height, 300, 20)];
	textViewContent.text = alandmark.details;
	textViewContent.textColor = [UIColor whiteColor];
	textViewContent.font = [UIFont boldSystemFontOfSize:16];
	textViewContent.backgroundColor = [UIColor clearColor];
	textViewContent.scrollEnabled = NO;
	textViewContent.editable = NO;
	
	[self.scroller addSubview:textViewContent];
	theframe = textViewContent.frame;
	theframe.size.height = textViewContent.contentSize.height;
	textViewContent.frame = theframe;
	
	if(alandmark.videos != nil || alandmark.audios != nil || alandmark.gallery != nil || alandmark.links != nil){
	
		//ASSIGN MORE CONTENT BLOCK
		self.moreContent.frame = CGRectMake(0, 5 + theframe.origin.y + theframe.size.height, self.moreContent.frame.size.width, self.moreContent.frame.size.height);	
		[self setUpMoreContent];
		[self.scroller addSubview:self.moreContent];	
	
		//CALCULATE CONTENT HEIGHT
		contentHeight = (5 + theframe.origin.y + theframe.size.height) + self.moreContent.frame.size.height + 20;
		
	}else {
		
		//CALCULATE CONTENT HEIGHT
		contentHeight = (5 + theframe.origin.y + theframe.size.height) + 20;
	}	
		
	[self.scroller setContentSize:CGSizeMake(self.scroller.frame.size.width, contentHeight)];	
	
	[lbltitle release];
	[textViewAddr release];
	[textViewContent release];
}

- (void) setUpMoreContent {

	CGRect firstSlot = CGRectMake(57, 25, 74, 25);
	CGRect secondSlot = CGRectMake(168, 25, 71, 25);
	CGRect thirdSlot = CGRectMake(57, 72, 81, 22);
	CGRect fourthSlot = CGRectMake(168, 71, 70, 23);
	
	if(alandmark.videos != nil){
		
		videoButton.frame = firstSlot;
		[self.moreContent addSubview:videoButton];
		
	}else {
		fourthSlot = thirdSlot;
		thirdSlot = secondSlot;
		secondSlot = firstSlot;
		
	}

		
	if (alandmark.audios != nil) {
		
		audioButton.frame = secondSlot;
		[self.moreContent addSubview:audioButton];
		
	}else{
		fourthSlot = thirdSlot;
		thirdSlot = secondSlot;
	}
	
	if(alandmark.gallery != nil){
		
		photoButton.frame = thirdSlot;
		[self.moreContent addSubview:photoButton];
		
	}else {
		
		fourthSlot = thirdSlot;
	}

		
	if (alandmark.links != nil) {
		
		linksButton.frame = fourthSlot;
		[self.moreContent addSubview:linksButton];
	}
	
}


- (IBAction) audioButtonClick:(id)sender{
	
	
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	backbutton.width = 65.0;
	
	MoreContentListViewController * mcLVC = [[MoreContentListViewController alloc] initWithNibName:@"MoreContentListViewController" bundle:nil];
	mcLVC.navigationItem.leftBarButtonItem = backbutton;
	mcLVC.navigationItem.hidesBackButton = YES;
	mcLVC.theList = self.alandmark.audios;
	mcLVC.moreType = @"Audio";
	mcLVC.title = @"Audios";
	
	[self.navigationController pushViewController:mcLVC animated:YES];
	
	[mcLVC release];
	//[backImg release];
	[backbutton release];
	
}

- (IBAction) videoButtonClick:(id)sender{
	
	
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	backbutton.width = 65.0;
	
	//NSLog(@"VideoButtonClick");
	
	MoreContentListViewController * mcLVC = [[MoreContentListViewController alloc] initWithNibName:@"MoreContentListViewController" bundle:nil];
	mcLVC.navigationItem.leftBarButtonItem = backbutton;
	mcLVC.navigationItem.hidesBackButton = YES;
	mcLVC.theList = self.alandmark.videos;
	mcLVC.moreType = @"Video";
	mcLVC.title = @"Videos";
	
	[self.navigationController pushViewController:mcLVC animated:YES];
	
	[mcLVC release];
	//[backImg release];
	[backbutton release];
}

- (IBAction) linksButtonClick:(id)sender{
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	backbutton.width = 65.0;
	
	//NSLog(@"LinksButtonClick");
	
	MoreContentListViewController * mcLVC = [[MoreContentListViewController alloc] initWithNibName:@"MoreContentListViewController" bundle:nil];
	mcLVC.navigationItem.leftBarButtonItem = backbutton;
	mcLVC.navigationItem.hidesBackButton = YES;	
	mcLVC.theList = self.alandmark.links;
	mcLVC.moreType = @"Link";
	mcLVC.title = @"Links";
	
	
	[self.navigationController pushViewController:mcLVC animated:YES];	
	
	[mcLVC release];
	//[backImg release];
	[backbutton release];
	
}

- (IBAction) photosButtonClick:(id)sender{
	
	
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
	backbutton.width = 65.0;
	
	/*MoreContentListViewController * mcLVC = [[MoreContentListViewController alloc] initWithNibName:@"MoreContentListViewController" bundle:nil];
	mcLVC.navigationItem.leftBarButtonItem = backbutton;
	mcLVC.navigationItem.hidesBackButton = YES;
	mcLVC.theList = self.alandmark.gallery;
	mcLVC.moreType = @"Photo";
	mcLVC.title = @"Photos";*/
	
	MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:self.alandmark.gallery];
	
	EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
	//photoController.title = @"Photos";
	photoController.navigationItem.leftBarButtonItem = backbutton;
	photoController.navigationItem.hidesBackButton = YES;
	
	//[self.navigationController pushViewController:mcLVC animated:YES];
	[self.navigationController pushViewController:photoController animated:YES];
	
	[photoController release];
	[source release];
	//[mcLVC release];
	//[backImg release];
	[backbutton release];
	
}


	 
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
	
	[videoButton release];
	[audioButton release];
	[photoButton release];
	[linksButton release];
	[alandmark release];
	[scroller release];
	[profilePic release];
	[viewOnMapView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	NSString * buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	
	if ([buttonTitle isEqualToString:@"Ok, leave!"]) {
		
		NSString *address = alandmark.address;
		
		NSString * url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@", appDelegate.mylocation.latitude, appDelegate.mylocation.longitude, [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
		
	}
	
}


#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void) actionSheet:(UIActionSheet *)actionsheet
clickedButtonAtIndex:(NSInteger )buttonIndex {

	NSString *buttonTitle = [actionsheet buttonTitleAtIndex:buttonIndex];
	
    //NSLog(@"%@",buttonTitle);
	
	if ([buttonTitle isEqualToString:@"Twitter"]) {
		//TWITTER       
        
		NSString * tweetText = [NSString stringWithFormat:@"I found this cool landmark on More Than A Map(p), Name:%@, Addr:%@", alandmark.title, alandmark.address];
		SHKItem * item = [SHKItem text:tweetText];
		
		[SHKTwitter shareItem:item];
		
	}else if ([buttonTitle isEqualToString:@"Facebook"]) {
		//FACEBOOK
		NSString * facebookText = [NSString stringWithFormat:@"I found this cool landmark on More Than A Map(p), the app that lets you explore and upload African American History in the palm of your hand! \n Name: %@ Addr: %@ \nGet This App http://www.morethanamapp.org", alandmark.title, alandmark.address];
		      
        //NSString * facebookTitle = @"More Than A Map(p) Point";
		
		NSURL * ImgURL = [NSURL URLWithString:alandmark.photo];
		NSData * data = [NSData dataWithContentsOfURL:ImgURL];
		UIImage * image = [UIImage imageWithData:data];
		
		//SHKItem * item = [SHKItem text:facebookText];
		//SHKItem * item = [SHKItem image:image title:facebookTitle];
        SHKItem * item = [SHKItem image:image title:facebookText];
		//item.text = facebookText;
		
		[SHKFacebook shareItem:item];
		
		
	}else if ([buttonTitle isEqualToString:@"Email"]) {
		//EMAIL BUTTON
		MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
		mailController.mailComposeDelegate = self;
		
		NSString * subject = [NSString stringWithFormat:@"[More Than A Map(p)] Check out this cool landmark"];
		NSString * body = [NSString stringWithFormat:@"I found this cool landmark on More Than A Map(p), the app that lets you explore and upload African American History in the palm of your hand!<br><br><b>Landmark Name:</b> %@<br><b>Address:</b> %@<br><br><img src='%@'/><br><br>Brought to You by <b>More Than A Map(p)</b><br><a href='http://www.morethanamapp.org'>Get This App</a>",alandmark.title, alandmark.address, alandmark.photo];
		
		[mailController setSubject:subject];
		[mailController setMessageBody:body isHTML:YES];
		[self presentModalViewController:mailController animated:YES];
		[mailController release];
		
	}else if (buttonTitle == @"Cancel") {
		//CANCEL BUTTON
		
	}
	
}

- (void) mailComposeController:(MFMailComposeViewController *)controller 
		   didFinishWithResult:(MFMailComposeResult)result 
						 error:(NSError*)error {
		
	if(result == MFMailComposeResultSent){
	
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Email" 
														  message:@"Successfully Sent Email" 
														 delegate:nil 
												cancelButtonTitle:@"OK" 
												otherButtonTitles:nil];
		
		[message show];
		[message release];
		
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
}


@end
