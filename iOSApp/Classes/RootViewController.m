//
//  RootViewController.m
//  MTAM
//
//  Created by Haldane Henry on 6/13/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "RootViewController.h"
#import "AboutViewController.h"
#import "AddPointViewController.h"
#import "MTAMAppDelegate.h"
#import "InfoViewController.h"
#import "MappViewController.h"
#import "GANTracker.h"

@implementation RootViewController
@synthesize frontView, backView, splashView, aboutButton, addPointButton, mappButton, path;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	if (appDelegate.firstRun) {
		
		appDelegate.firstRun = NO;
		
		[self initHomeAni];
		[self showSplash];
		
	}
	
	NSError * error;
	
	if (![[GANTracker sharedTracker] trackPageview:@"/app_home" 
										 withError:&error]) {
		
		//NSLog(@"GANTracker Error: %@", error);
	}
	
	//NSLog(@"My Username: %@",appDelegate.username);
	//NSLog(@"My UserID: %@",appDelegate.userId);
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];	
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */
- (void) initHomeAni {

	aboutButton.alpha = 0;
	aboutButton.frame = CGRectMake(300, 73, aboutButton.frame.size.width, aboutButton.frame.size.height);
	//aboutButton.center = CGPointMake(300, 73);
	
	addPointButton.alpha = 0;
	addPointButton.frame = CGRectMake(-300, 93, addPointButton.frame.size.width, addPointButton.frame.size.height);
	//addPointButton.center = CGPointMake(-300, 93);
	
	mappButton.alpha = 0;
	mappButton.frame = CGRectMake(320, 237, mappButton.frame.size.width, mappButton.frame.size.height);
	//mappButton.center = CGPointMake(320, 237);
	
	path.alpha = 0;
	
	
	
}

- (void) setHomeAni {
	
	[UIView animateWithDuration:0.5
	 
						  delay:0.0			 
	 
						options: UIViewAnimationOptionCurveEaseOut
	 
					 animations:^{
						 
						 aboutButton.alpha = 1.0;
						 aboutButton.frame = CGRectMake(182, 73, aboutButton.frame.size.width, aboutButton.frame.size.height);
						 //aboutButton.center = CGPointMake(182, 73);
						 
					 }
	 
					 completion:^(BOOL finished) {
						
						 [UIView animateWithDuration:0.5
						  
											   delay: 0.0			 
						  
											 options: UIViewAnimationOptionCurveEaseOut
						  
										  animations:^{
											  
											  addPointButton.alpha = 1.0;
											  addPointButton.frame = CGRectMake(-1, 93, addPointButton.frame.size.width, addPointButton.frame.size.height);
											  //addPointButton.center = CGPointMake(-1, 93);
											  
										  }
						  
										  completion:^(BOOL finished) {
											  
											  [UIView animateWithDuration:0.5
											   
																	delay: 0.0			 
											   
																  options: UIViewAnimationOptionCurveEaseOut
											   
															   animations:^{
																   
																   mappButton.alpha = 1.0;
																   mappButton.frame = CGRectMake(51, 237, mappButton.frame.size.width, mappButton.frame.size.height);
																   //mappButton.center = CGPointMake(51, 237);
																   
															   }
											   
															   completion:^(BOOL finished) {
																   
																   [UIView animateWithDuration:1.0
																	
																						 delay: 0.3		 
																	
																					   options: UIViewAnimationOptionCurveEaseIn
																	
																					animations:^{
																						
																						path.alpha = 1.0;
																					}
																	
																					completion:nil];
															   }];
										  }];
						 
					 }];
	
	
}


- (void) showSplash {
		
	[self.view addSubview:splashView];
	[self performSelector:@selector(hideSplash) withObject:nil afterDelay:2.0];
	
}


- (void) hideSplash {
	
	[UIView animateWithDuration:1.0
		
	    delay: 0.0			 
		
		options: UIViewAnimationOptionCurveEaseIn
		
		animations:^{
		
			splashView.alpha = 0.0;

		}
		
		completion:^(BOOL finished) {
						 
			//[self dismissModalViewControllerAnimated:NO];
			[splashView removeFromSuperview];
			[self setHomeAni];
		}];
	
}


#pragma mark -
#pragma mark Home Button Actions


- (IBAction) showAbout:(id)sender {
	
	//NSLog(@"Show About");
	AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];	
	aboutViewController.delegate = self;
	
	aboutViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	//aboutViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
	[self presentModalViewController:aboutViewController animated:YES];
	
	[aboutViewController release];
	
	/*[UIView transitionFromView:self.view
						toView:backView
					  duration:1.0 
					   options:UIViewAnimationOptionTransitionFlipFromLeft 
					completion:nil];*/
	
}

- (IBAction) addPoint:(id)sender {
	
	//NSLog(@"Show Add Point");
	AddPointViewController *addPointViewController = [[AddPointViewController alloc] initWithNibName:@"AddPointViewController" bundle:nil];	
	addPointViewController.delegate = self;
	
	addPointViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	//addPointViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
	[self presentModalViewController:addPointViewController animated:YES];
	
	[addPointViewController release];
	
	//[self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction) showMapp:(id)sender {
	
	//NSLog(@"Show Mapp");
	
	UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
	UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(popView:)];
	backbutton.width = 60.0;
	
	MappViewController *mpViewController = [[MappViewController alloc] initWithNibName:@"MappViewController" bundle:nil];
	mpViewController.navigationItem.leftBarButtonItem = backbutton;
	mpViewController.navigationItem.hidesBackButton = YES;
	
	//[backImg release];
	[backbutton release];
	
	[self.navigationController pushViewController:mpViewController animated:YES];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	[mpViewController release];
}

- (IBAction) showInfo:(id)sender {
	
	//NSLog(@"Show Info");
	InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];	
	infoViewController.delegate = self;
	infoViewController.htmlfile = @"appmain";
	
	infoViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
	[self presentModalViewController:infoViewController animated:YES];
	
	[infoViewController release];
	
}

- (IBAction) popView:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
	//[self.navigationController setNavigationBarHidden:YES animated:YES];
}

//-------------------------------------
//FLIP SIDE DELEGATE-------------------
//-------------------------------------


- (void)flipsideViewControllerDidFinish:(UIViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)CurlUpViewControllerDidFinish:(UIViewController *)controller {
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) removeModalView:(id)sender {
	
}


//------------------------------
//ROTATION HANDLES -------------
//------------------------------

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait ;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	
	//NSLog(@"RootViewUnload");
}


- (void)dealloc {
	
	[mappButton release];
	[aboutButton release];
	[addPointButton release];
	[path release];
	[splashView release];
	[frontView release];
	[backView release];
    [super dealloc];
}


@end

