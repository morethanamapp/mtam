//
//  AddPointViewController.m
//  MTAM
//
//  Created by Haldane Henry on 6/14/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "AddPointViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "SubmitPointViewController.h"
#import "MTAMAppDelegate.h"
#import "SHK.h"
#import "SHKFacebook.h"
#import "GANTracker.h"
#import "UserDataPlistAccess.h"


@implementation AddPointViewController
@synthesize text1, text2, anewMapperButton, signOutButton, signInButton,signOutVisible, firstLoad, delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		// Custom initialization.
		
		self.firstLoad = YES;
	}
	
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	text2.font = [UIFont systemFontOfSize:14];
				
	
	///-----------------------------------------------------------
	///-----------------------------------------------------------
	NSError * error;
	
	if (![[GANTracker sharedTracker] trackPageview:@"/app_add_pointview"
										 withError:&error]) {
		
		//NSLog(@"GANTracker Error: %@", error);
	}
	
	firstLoad = NO;
	signOutVisible = NO;
	
	//NSLog(@"Login Stat: %@", appDelegate.loginOK ? @"YES" : @"NO");
	//NSLog(@"My Username: %@", appDelegate.username);
	//NSLog(@"My UserID: %@",appDelegate.userId);
	//NSLog(@"My Username: %@",appDelegate.username);
	
	if (appDelegate.loginOK) {
		text1.font = [UIFont systemFontOfSize:22];
		anewMapperButton.hidden = YES;
		signInButton.hidden = YES;
		
		NSMutableDictionary * uData = [UserDataPlistAccess returnUserData];
		
		if ([[uData objectForKey:@"UserType"] isEqual:@"FbUser"]) {
			
			NSDictionary * fbuserinfo = [uData objectForKey:@"kSHKFacebookUserInfo"];
						
			
			text1.font = [UIFont systemFontOfSize:22];
			//text1.text = [NSString stringWithFormat:@"Welcome, %@", appDelegate.username];
			//text1.text = [NSString stringWithFormat:@"Welcome, %@", [fbuserinfo objectForKey:@"username"]];
			text1.text = [NSString stringWithFormat:@"Welcome, %@", [fbuserinfo objectForKey:@"name"]];
			
		}else if ([[uData objectForKey:@"UserType"] isEqual:@"MTAMDefUser"]) {
			
			text1.font = [UIFont systemFontOfSize:22];
			//text1.text = [NSString stringWithFormat:@"Welcome, %@", appDelegate.username];
			text1.text = [NSString stringWithFormat:@"Welcome, %@", [uData objectForKey:@"MtamUsername"]];
			
		}
		
		signOutButton.frame = CGRectMake(text1.frame.origin.x, (text1.frame.origin.y + 45 ), signOutButton.frame.size.width, signOutButton.frame.size.height);
		[self.view addSubview:signOutButton];
	 
		signOutVisible = YES;
	 
	}else {
		text1.font = [UIFont systemFontOfSize:14];
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (!self.firstLoad) {
		if (appDelegate.loginOK) {
			anewMapperButton.hidden = YES;
			signInButton.hidden = YES;
			
			NSMutableDictionary * uData = [UserDataPlistAccess returnUserData];
			
			if ([[uData objectForKey:@"UserType"] isEqual:@"FbUser"]) {
				
				NSDictionary * fbuserinfo = [uData objectForKey:@"kSHKFacebookUserInfo"];
				
				
				text1.font = [UIFont systemFontOfSize:22];
				//text1.text = [NSString stringWithFormat:@"Welcome, %@", appDelegate.username];
				//text1.text = [NSString stringWithFormat:@"Welcome, %@", [fbuserinfo objectForKey:@"username"]];
				text1.text = [NSString stringWithFormat:@"Welcome, %@", [fbuserinfo objectForKey:@"name"]];
				
			}else if ([[uData objectForKey:@"UserType"] isEqual:@"MTAMDefUser"]) {
				
				text1.font = [UIFont systemFontOfSize:22];
				//text1.text = [NSString stringWithFormat:@"Welcome, %@", appDelegate.username];
				text1.text = [NSString stringWithFormat:@"Welcome, %@", [uData objectForKey:@"MtamUsername"]];
				
			}
			
			
			if (!signOutVisible) {
				signOutButton.frame = CGRectMake(text1.frame.origin.x, (text1.frame.origin.y + 45 ), signOutButton.frame.size.width, signOutButton.frame.size.height);
				[self.view addSubview:signOutButton];
			}
			
			signOutVisible = YES;
		}
	}
	
	
}


- (IBAction)newMapper:(id)sender {
	
	RegisterViewController *registerView = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
	
	[self presentModalViewController:registerView animated:YES];
	[registerView release];
}


- (IBAction)signOut:(id)sender {
	
	NSMutableDictionary * uData = [UserDataPlistAccess returnUserData];
	
	if ([[uData objectForKey:@"UserType"] isEqual:@"FbUser"]) {
		
		[SHKFacebook logout];
					
		[UserDataPlistAccess removeUserData];
		
		appDelegate.loginOK = FALSE;
		appDelegate.userId = @"EMPTY";
		//appDelegate.username = @"";
		
		anewMapperButton.hidden = NO;
		signInButton.hidden = NO;
		signOutButton.hidden = YES;
		text1.font = [UIFont systemFontOfSize:14];
		text1.text = @"Please Sign In to add your point. Not a mapper? Set up your account now. Just click on 'New Mapper'";
		
		signOutVisible = NO;
		
		
	}else if ([[uData objectForKey:@"UserType"] isEqual:@"MTAMDefUser"]) {
						
		[UserDataPlistAccess removeUserData];
		
		appDelegate.loginOK = FALSE;
		appDelegate.userId = @"";
		//appDelegate.username = @"";
		
		anewMapperButton.hidden = NO;
		signInButton.hidden = NO;
		signOutButton.hidden = YES;
		text1.font = [UIFont systemFontOfSize:14];
		text1.text = @"Please Sign In to add your point. Not a mapper? Set up your account now. Just click on 'New Mapper'";
		
		signOutVisible = NO;
	}

	
}

- (IBAction)signIn:(id)sender {
	
	//SHOW SIGN IN FORM
	
	LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	loginView.delegate = self;
	[self presentModalViewController:loginView animated:YES];
	[loginView release];
	
}


- (IBAction)addPoint:(id)sender {
	
	if (appDelegate.loginOK) {
		//SHOW NEW MAP POINT FORM
		SubmitPointViewController *submitView = [[SubmitPointViewController alloc] initWithNibName:@"SubmitPointViewController" bundle:nil];
		
		[self presentModalViewController:submitView animated:YES];
		[submitView release];
		
	}else {
		//SHOW SIGN IN FORM
		
		LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
		loginView.delegate = self;
		[self presentModalViewController:loginView animated:YES];
		[loginView release];
		
	}

	
}

- (IBAction) done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];
}


- (IBAction) showInfo:(id)sender {
	
	//NSLog(@"Show Info");
	InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];	
	infoViewController.delegate = self;
	infoViewController.htmlfile = @"appaddapoint";
	
	infoViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
	[self presentModalViewController:infoViewController animated:YES];
	
	[infoViewController release];
	
}


- (void)LoginViewControllerDidFinish:(UIViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
	
	//SHOW NEW MAP POINT FORM
	SubmitPointViewController *submitView = [[SubmitPointViewController alloc] initWithNibName:@"SubmitPointViewController" bundle:nil];
	
	[self presentModalViewController:submitView animated:YES];
	[submitView release];
}

- (void)CurlUpViewControllerDidFinish:(UIViewController *)controller {
	
	[self dismissModalViewControllerAnimated:YES];
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
    [super dealloc];
}


@end
