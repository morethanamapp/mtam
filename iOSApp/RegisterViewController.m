//
//  RegisterViewController.m
//  MTAM
//
//  Created by Haldane Henry on 7/24/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "RegisterViewController.h"
#import "MTAMAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "GANTracker.h"
#import "UserDataPlistAccess.h"
#import "FacebookSDK.h"
#import "SHKConfiguration.h"

@implementation RegisterViewController

@synthesize thetableView, sectionFooterView, sectionHeaderView, firstLoad;

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
	
	self.title = @"RegisterView";
    
    firstLoad = NO;
	
	appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	thetableView.backgroundColor = [UIColor clearColor];
	thetableView.opaque = NO;
	thetableView.backgroundView = nil;
	
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
	
	SCTextFieldCell *usernameTextFieldCell = [SCTextFieldCell cellWithText:@"Username" withPlaceholder:@"enter username" 
															  withBoundKey:@"username" withTextFieldTextValue:nil];
	usernameTextFieldCell.valueRequired = TRUE;
	usernameTextFieldCell.backgroundColor = [[[UIColor alloc] initWithRed:0.827 green:0.827 blue:0.827 alpha:1.0] autorelease];
	
	
	SCTextFieldCell *emailTextFieldCell = [SCTextFieldCell cellWithText:@"Email" withPlaceholder:@"enter email" 
															  withBoundKey:@"email" withTextFieldTextValue:nil];
	emailTextFieldCell.valueRequired = TRUE;
	emailTextFieldCell.backgroundColor = [[[UIColor alloc] initWithRed:0.827 green:0.827 blue:0.827 alpha:1.0] autorelease];
	
	SCTextFieldCell *passwordTextFieldCell = [SCTextFieldCell cellWithText:@"Password" withPlaceholder:@"enter password" 
															  withBoundKey:@"password" withTextFieldTextValue:nil];
	passwordTextFieldCell.valueRequired = TRUE;
	passwordTextFieldCell.textField.secureTextEntry = TRUE;
	passwordTextFieldCell.backgroundColor = [[[UIColor alloc] initWithRed:0.827 green:0.827 blue:0.827 alpha:1.0] autorelease];
	
	[section addCell:usernameTextFieldCell];
	[section addCell:emailTextFieldCell];
	[section addCell:passwordTextFieldCell];
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*if (!self.firstLoad) {
        if (FBSession.activeSession.isOpen) {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     //self.userNameLabel.text = user.name;
                     //self.userProfileImage.profileID = user.id;
                     
                     NSMutableDictionary * uData = [UserDataPlistAccess returnUserData];                     
                     
                     if ([[uData objectForKey:@"UserType"] isEqual:@"FbUser"]) {
                         
                         [uData setObject:user forKey:@"kSHKFacebookUserInfo"];
                         [UserDataPlistAccess updateUserData:uData];
                         
                         //OPEN AND SEND USER'S EMAIL TO REGISTER WITH MTAM
                         //NSString * fbemail = [result objectForKey:@"email"];
                         //NSString * fbgenpass = [result objectForKey:@"id"];
                         
                         NSString * fbemail = [user objectForKey:@"email"];
                         NSString * fbgenpass = user.id;
                         
                         
                         NSURL * url = [NSURL URLWithString:@"http://www.morethanamapp.org/request/registeruser_viafacebook.php"];
                         ASIFormDataRequest * req = [ASIFormDataRequest requestWithURL:url];
                         
                         [req setPostValue:fbemail forKey:@"email"];
                         [req setPostValue:fbgenpass forKey:@"pass"];
                         [req setDelegate:self];
                         [req startAsynchronous];
                         
                         //-----------------------------------------------------------------------------------------
                         //-----------------------------------------------------------------------------------------
                         //REMOVE FROM PRACTICE WILL NO LONGER SAVE FOR LATER IN THE CASE OF CONNECTION INTERRUPTION
                         //-----------------------------------------------------------------------------------------
     
                         //NSMutableDictionary * fbvars =   [NSMutableDictionary dictionaryWithCapacity:2];
                         //[fbvars setObject:fbemail forKey:@"fbemail"];
                         //[fbvars setObject:fbgenpass forKey:@"fbgenpass"];
                         
                         //[uData setObject:fbvars forKey:@"FBRegVars"];
                         //[UserDataPlistAccess updateUserData:uData];
                         
                         //-----------------------------------------------------------------------------------------
                         //-----------------------------------------------------------------------------------------
                         
                         MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                         hud.labelText = @"Finalizing...";
                         
                         //if([self.appDelegate currentView] != nil){
                          //MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[[self.appDelegate currentView] view] animated:YES];
                          //hud.labelText = @"Registering...";
                          //}
                         
                     }
                     
                 }
             }];
        }
    }*/
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	/*NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	if ([[defaults objectForKey:@"UserType"] isEqual:@"FbUser"]) {
		NSLog(@"SHKFacebook Graph");
		//[appDelegate.shkFacebook requestFacebookGraphMe];
	}*/
}

- (void)dealloc {
	[thetableView release];
	[sectionFooterView release];
	[sectionHeaderView release];
	[tableModel release];
    [super dealloc];
}


#pragma mark -
#pragma mark View Methods

- (IBAction) facebookClick:(id)sender {
	
	//NSLog(@"Facebook Click RegisterView");
	
    if(![FBSession.activeSession isOpen]){
        
        NSMutableDictionary * uData = [NSMutableDictionary dictionaryWithCapacity:1];
        
        FBSession *session =
        [[[FBSession alloc] initWithAppID:SHKCONFIG(facebookAppId)
                              permissions:SHKCONFIG(facebookReadPermissions)	// FB only wants read or publish so use default read, request publish when we need it
                          urlSchemeSuffix:SHKCONFIG(facebookLocalAppId)
                       tokenCacheStrategy:nil] autorelease];
        
        [FBSession setActiveSession:session];
        [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
				completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
					
                    switch (state) {
                        case FBSessionStateOpen:
                            
                            //NSLog(@"Session Opened");
                            
                            [uData setObject:@"FbUser" forKey:@"UserType"];
                            [UserDataPlistAccess updateUserData:uData];
                            
                            [[FBRequest requestForMe] startWithCompletionHandler:
                             ^(FBRequestConnection *connection,
                               NSDictionary<FBGraphUser> *user,
                               NSError *error) {
                                 if (!error) {
                                     //self.userNameLabel.text = user.name;
                                     //self.userProfileImage.profileID = user.id;
                                     
                                     //NSLog(@"UserData: %@",user);
                                     
                                     NSMutableDictionary * uData = [UserDataPlistAccess returnUserData];
                                     
                                     if ([[uData objectForKey:@"UserType"] isEqual:@"FbUser"]) {
                                         
                                         [uData setObject:user forKey:@"kSHKFacebookUserInfo"];
                                         [UserDataPlistAccess updateUserData:uData];
                                         
                                         //OPEN AND SEND USER'S EMAIL TO REGISTER WITH MTAM
                                         //NSString * fbemail = [result objectForKey:@"email"];
                                         //NSString * fbgenpass = [result objectForKey:@"id"];
                                         
                                         NSString * fbemail = [user objectForKey:@"email"];
                                         NSString * fbgenpass = user.id;
                                         
                                         
                                         NSURL * url = [NSURL URLWithString:@"http://www.morethanamapp.org/request/registeruser_viafacebook.php"];
                                         ASIFormDataRequest * req = [ASIFormDataRequest requestWithURL:url];
                                         
                                         [req setPostValue:fbemail forKey:@"email"];
                                         [req setPostValue:fbgenpass forKey:@"pass"];
                                         [req setDelegate:self];
                                         [req startAsynchronous];
                                         
                                         //-----------------------------------------------------------------------------------------
                                         //-----------------------------------------------------------------------------------------
                                         //REMOVE FROM PRACTICE WILL NO LONGER SAVE FOR LATER IN THE CASE OF CONNECTION INTERRUPTION
                                         //-----------------------------------------------------------------------------------------
                                         
                                         //NSMutableDictionary * fbvars =   [NSMutableDictionary dictionaryWithCapacity:2];
                                         //[fbvars setObject:fbemail forKey:@"fbemail"];
                                         //[fbvars setObject:fbgenpass forKey:@"fbgenpass"];
                                         
                                         //[uData setObject:fbvars forKey:@"FBRegVars"];
                                         //[UserDataPlistAccess updateUserData:uData];
                                         
                                         //-----------------------------------------------------------------------------------------
                                         //-----------------------------------------------------------------------------------------
                                         
                                         MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                         hud.labelText = @"Finalizing...";
                                         
                                         //if([self.appDelegate currentView] != nil){
                                         //MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[[self.appDelegate currentView] view] animated:YES];
                                         //hud.labelText = @"Registering...";
                                         //}
                                         
                                     }
                                     
                                 }
                             }];
                            
                            break;
                        case FBSessionStateClosed:
                            //[self fbSessionClosed];
                            
                            NSLog(@"Session Closed");
                            
                            break;
                        case FBSessionStateCreated:
                            //[self fbSessionCreated];
                            
                            NSLog(@"Session Created");
                            
                            break;
                        case FBSessionStateCreatedOpening:
                            //[self fbSessionOpening];
                            
                            NSLog(@"Session Created Opening");
                            
                            break;
                        case FBSessionStateClosedLoginFailed:
                            //[self fbSessionClosedLoginFailed];
                            
                            NSLog(@"Session Closed Login Failed");
                            NSLog(@"Error: %@",error);
                            break;
                        case FBSessionStateOpenTokenExtended:
                            //[self fbSessionOpenTokenExtended];
                            
                            NSLog(@"Session Opene Token Extended");
                            
                            break;
                        case FBSessionStateCreatedTokenLoaded:
                            //[self fbSessionCreatedTokenLoaded];
                            
                            NSLog(@"Session Created Token Loaded");
                            
                            break;
                    }
                    
				}];
        
    }else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Facbook Connect"
                                                          message:@"You have already been connected"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        [message release];
    }
    
    
	/*if (![appDelegate.shkFacebook isAuthorized]) {
		
		[appDelegate.shkFacebook promptAuthorization];
		appDelegate.currentView = self;
		
		NSMutableDictionary * uData = [NSMutableDictionary dictionaryWithCapacity:1];		
		[uData setObject:@"FbUser" forKey:@"UserType"];
		
		[UserDataPlistAccess updateUserData:uData];
		
	}else {
		
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Facbook Connect"
                                                          message:@"You have already been connected"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        [message release];
		
	}*/
	
}


- (IBAction) closeClick:(id)sender {
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void) closeOut {
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) registerClick:(id)sender {
	
	if(tableModel.valuesAreValid){
		
		[tableModel.activeCell resignFirstResponder];
		
		NSString * user = [tableModel.modelKeyValues valueForKey:@"username"];
		NSString * pass = [tableModel.modelKeyValues valueForKey:@"password"];
		NSString * email = [tableModel.modelKeyValues valueForKey:@"email"];
		
		NSURL * url = [NSURL URLWithString:@"http://www.morethanamapp.org/request/registeruser.php"];
		ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
		[request setPostValue:user forKey:@"user"];
		[request setPostValue:pass forKey:@"pass"];
		[request setPostValue:email forKey:@"email"];
		[request setDelegate:self];
		request.shouldPresentCredentialsBeforeChallenge = YES;
		[request addBasicAuthenticationHeaderWithUsername:@"user" andPassword:@"pass"];
		
		[request startAsynchronous];
		
		MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.labelText = @"Registering...";
		
	}else {
		
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Register"
														  message:@"Please Complete all fields"
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
		
		[message show];
		[message release];
		
	}

	
}

#pragma mark -
#pragma mark ASIFormDataRequest Delegate

- (void)requestFinished:(ASIHTTPRequest *) request {
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	if (request.responseStatusCode == 400) {
		
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Register"
														  message:@"Invalid Request"
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
		
		[message show];
		[message release];
		
	}else if (request.responseStatusCode == 401) {
		
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Register"
														  message:@"Username or Email already exist, please try again"
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
		
		[message show];
		[message release];
		
	}else if (request.responseStatusCode == 200) {
		
		NSString *responseString = [request responseString];
		NSDictionary * responseDict = [responseString JSONValue];
		
		
		NSMutableDictionary * uData = [UserDataPlistAccess returnUserData];
		
		if ([[uData objectForKey:@"UserType"] isEqual:@"FbUser"]) {
			
			NSString * user_id = [responseDict objectForKey:@"user_id"];
			appDelegate.loginOK = TRUE;
			appDelegate.userId = user_id;
			
            [uData setObject:user_id forKey:@"UserID"];
			NSDictionary * fbuserinfo = [uData objectForKey:@"kSHKFacebookUserInfo"];
			//appDelegate.username = [fbuserinfo objectForKey:@"username"];			
			
            appDelegate.username = [fbuserinfo objectForKey:@"name"];
            
            NSError * error;
            if (![[GANTracker sharedTracker] trackEvent:@"User_Actions"
                                                 action:@"Facebook_Register/Login"
                                                  label:@"Successful_Facebook_User_Login/Register"
                                                  value:-1
                                              withError:&error]) {
                //NSLog(@"GANTracker Error: %@");
            }
			
		}else {
			NSString * user_id = [responseDict objectForKey:@"user_id"];
			NSString * username = [responseDict objectForKey:@"username"]; 
			
			appDelegate.loginOK = TRUE;
			appDelegate.userId = user_id;
			appDelegate.username = username;
			
			NSMutableDictionary * temp = [NSMutableDictionary dictionaryWithCapacity:1];
			
			[temp setObject:@"MTAMDefUser" forKey:@"UserType"];
			[temp setObject:user_id forKey:@"UserID"];
			[temp setObject:username forKey:@"MtamUsername"];
			
			[UserDataPlistAccess updateUserData:temp];
            
            NSError * error;
            if (![[GANTracker sharedTracker] trackEvent:@"User_Actions"
                                                 action:@"Registration"
                                                  label:@"Successful_User_Registration"
                                                  value:-1
                                              withError:&error]) {
                //NSLog(@"GANTracker Error: %@");
            }
            
		}
		
		
		
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success"
														  message:@"Registration Successful" 
														 delegate:nil 
												cancelButtonTitle:@"OK" 
												otherButtonTitles:nil];
		
		[message show];
		[message release];
		
		//[self dismissModalViewControllerAnimated:YES];
        [self closeOut];
	}
	
}


- (void)requestFailed:(ASIHTTPRequest *)request {
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	NSError * error = [request error];
	NSLog(@"ERROR: %@",error.localizedDescription);
	
	NSMutableDictionary * uData = [UserDataPlistAccess returnUserData];    	
    
    if ([[uData objectForKey:@"UserType"] isEqual:@"FbUser"]) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Register"
                                                          message:@"Connection Timed Out, Try Again."
                                                          delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
         
         [message show];
         [message release];
        
    }else{
	
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Register"
                                                          message:@"Username or Email already exist, please try again"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
	
        [message show];
        [message release];
    }
}

#pragma mark -
#pragma mark SCTableViewModelDelegate Methods


- (void)tableViewModel:(SCTableViewModel *)tableViewModel didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	SCTableViewCell *cell = [tableViewModel cellAtIndexPath:indexPath];
	[cell setSelected:FALSE animated:YES];
}


@end
