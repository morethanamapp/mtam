//
//  MTAMAppDelegate.m
//  MTAM
//
//  Created by Haldane Henry on 6/13/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "MTAMAppDelegate.h"
#import "RootViewController.h"
#import "HJObjManager.h"
#import <objc/runtime.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "SHK.h"
#import "SHKConfiguration.h"
#import "MTAMSHKConfigurator.h"
#import "SHKFacebook.h"
#import "GANTracker.h"
#import "UserDataPlistAccess.h"
#import "FacebookSDK.h"

static const NSInteger kGANDispatchPeriodSec = 10;

@implementation MTAMAppDelegate

@synthesize window;
@synthesize navigationController, entries, subEntries, objMan, loginOK, userId, username, mtamWebSalt, mtamAuthKey, locationManager, mylocation, layerResultCount, nearMeCount,resetResults, firstRun, sAppDelegate;
@synthesize shkFacebook;
@synthesize currentView;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ///------------------------
    // Create SHK Configurator
    //-------------------------
    
    DefaultSHKConfigurator *shkconfig = [[MTAMSHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:shkconfig];
    [shkconfig release];
    
    //-----------------------
    
    userId = @"EMPTY";
    loginOK = FALSE;
    username = @"EMPTY";
    
    
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] synchronize];
	
	mtamWebSalt = @"4341hsdfmtamufha32i4fv4239taujawe";
	mtamAuthKey = @"mtam2011";
	
	layerResultCount = 0;
	nearMeCount = 0;
	resetResults = NO;
	firstRun = YES;
	
	shkFacebook = [[SHKFacebook alloc] init];
	//SHKSharer *fbservice = [[[SHKFacebook alloc] init] autorelease];
    
	currentView = nil;
	
	//FOR SIMULATOR ONLY
	
	//mylocation.latitude = 40.8716660;
	//mylocation.longitude = -73.8392810;
    
    
	///-------------------------
	// Create the object manager
	///-------------------------
	
	self.objMan = [[[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:20] autorelease];
	
	//if you are using for full screen images, you'll need a smaller memory cache than the defaults,
	//otherwise the cached images will get you out of memory quickly
	//objMan = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:1];
	
	// Create a file cache for the object manager to use
	// A real app might do this durring startup, allowing the object manager and cache to be shared by several screens
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/mtamapp/"];
	HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
	self.objMan.fileCache = fileCache;
	
	// Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
	fileCache.fileCountLimit = 100;
	fileCache.fileAgeLimit = 60*60*24*7; //1 week
	[fileCache trimCacheUsingBackgroundThread];
	
    //[cacheDirectory release];
    
	///-----------------------------------------------------------
	///-----------------------------------------------------------
	
	///----------------------------------
	///Check For Always Logged in
	///----------------------------------
	
    if ([UserDataPlistAccess dataStatus]) {
		//NSLog(@"Data Found");
		
		NSMutableDictionary * uData = [UserDataPlistAccess returnUserData];
		
		//NSLog(@"uData: %@",uData);
		//NSLog(@"uData UserType: %@",[uData objectForKey:@"UserType"]);
		
		//TEMP FLUSH
		//[SHKFacebook logout];
		//[defaults removeObjectForKey:@"UserType"];
		//[defaults synchronize];
		
		if ([[uData objectForKey:@"UserType"] isEqual:@"FbUser"]) {
			
			//NSLog(@"FBUser Resume");
						                
            self.loginOK = TRUE;
            self.userId = [uData objectForKey:@"UserID"];
            NSDictionary * fbuserinfo = [uData objectForKey:@"kSHKFacebookUserInfo"];
                
            //NSLog(@"UserData: %@",fbuserinfo);
            //self.username = [NSString stringWithFormat:@"%@",[fbuserinfo objectForKey:@"username"]];
                
            self.username = [NSString stringWithFormat:@"%@",[fbuserinfo objectForKey:@"name"]];
                
            //NSLog(@"FB Username: %@",self.username);
        
			
		}else if ([[uData objectForKey:@"UserType"] isEqual:@"MTAMDefUser"]) {
			
			self.loginOK = TRUE;
			self.userId = [uData objectForKey:@"UserID"];
			self.username = [uData objectForKey:@"MtamUsername"];
			
		}
	}
    
	//NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    /*if ([FBSession.activeSession isOpen]) {
        NSLog(@"FB Access Token: %@",[FBSession.activeSession accessToken]);
    }else{
        NSLog(@"WTF");
    }*/
    
    
    /*if(![fbservice authorize]) //This will prompt for login if token was not saved or if it got expired.
    {
        //fbservice.shareDelegate = self; //implement the delegate so that once after login you will get to know when to fetch token.
    }
    else
    {
        //Directly access the token with the key in NSUserdefaults and use this.
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"uData User: %@",[defaults objectForKey:@"kSHKFacebookUserInfo"]);
    }*/
	
	/*if ([UserDataPlistAccess dataStatus]) {
		//NSLog(@"Data Found");
		
		NSMutableDictionary * uData = [UserDataPlistAccess returnUserData];
		
		//NSLog(@"uData: %@",uData);
		//NSLog(@"uData UserType: %@",[uData objectForKey:@"UserType"]);
		
		//TEMP FLUSH
		//[SHKFacebook logout];
		//[defaults removeObjectForKey:@"UserType"];
		//[defaults synchronize];
		
		if ([[uData objectForKey:@"UserType"] isEqual:@"FbUser"]) {
			
			NSLog(@"FBUser Resume");
			
			if ([shkFacebook isAuthorized]) {
				
				NSLog(@"Facebook Authorized");
                
                self.loginOK = TRUE;
                self.userId = [uData objectForKey:@"UserID"];
                NSDictionary * fbuserinfo = [uData objectForKey:@"kSHKFacebookUserInfo"];
                
                //NSLog(@"UserData: %@",fbuserinfo);
                //self.username = [NSString stringWithFormat:@"%@",[fbuserinfo objectForKey:@"username"]];
                
                self.username = [NSString stringWithFormat:@"%@",[fbuserinfo objectForKey:@"name"]];
                
                NSLog(@"FB Username: %@",self.username);
				
			}
			
		}else if ([[uData objectForKey:@"UserType"] isEqual:@"MTAMDefUser"]) {
			
			self.loginOK = TRUE;
			self.userId = [uData objectForKey:@"UserID"];
			self.username = [uData objectForKey:@"MtamUsername"];
			
		}
	}*/		
	
	///----------------------
	///Start Goggle Analytics
	//-----------------------
	
	[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-28016161-1"
										   dispatchPeriod:kGANDispatchPeriodSec 
												 delegate:nil];
	
	
	///--------------------------
	//Create the location manager
	///--------------------------
	
	BOOL locationServicesAreEnabled = NO;
	
	Method requiredClassMethod = class_getClassMethod([CLLocationManager class], @selector(locationServicesEnabled));
	
	if (requiredClassMethod != nil) {
		locationServicesAreEnabled = [CLLocationManager locationServicesEnabled];
		
	}
    /*else {
		CLLocationManager * DummyManager = [[CLLocationManager alloc] init];
		locationServicesAreEnabled = [DummyManager locationServicesEnabled];
		[DummyManager release];
	}*/
	
	if(locationServicesAreEnabled == YES) {
		
		CLLocationManager *newLocationManager = [[CLLocationManager alloc] init];
		self.locationManager = newLocationManager;
		
		[newLocationManager release];
		
		self.locationManager.delegate = self;
		
		self.locationManager.purpose = NSLocalizedString(@"To Provide functionality based on user's current location.", nil);
		[self.locationManager startUpdatingLocation];
		
	}else {
		
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Location Services" 
														  message:@"Location Services Disabled, unable to use current location." 
														 delegate:nil 
												cancelButtonTitle:@"OK" 
												otherButtonTitles:nil];
		
		[message show];
		[message release];
		
	}
	
	
	///--------------------------
	
    //NSLog(@"Hey Loader");
    
    
    // Add the navigation controller's view to the window and display.
	[self.window setBackgroundColor:[UIColor blackColor]];
    //[self.window addSubview:navigationController.view];
    
    [self.window setRootViewController: navigationController];
    
    [self.window makeKeyAndVisible];
    
    [self customizeAppearance];
    
    return YES;
}


- (void) applicationDidFinishLaunching:(UIApplication *)application{
    sAppDelegate = self;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	//NSLog(@"I'm Back");
	/*if (currentView != nil) {
		if ([[currentView title] isEqual:@"LoginView"] || [[currentView title] isEqual:@"RegisterView"]) {
			[currentView closeOut];
		}
	}*/
	
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [SHKFacebook handleDidBecomeActive];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    
    [SHKFacebook handleWillTerminate];
	
	if(self.locationManager != nil){
		[self.locationManager stopUpdatingLocation];
	}
	
	self.locationManager = nil;
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark internal Methods

- (void) updateLoginOK:(BOOL)value {
    
    self.loginOK = value;
}

- (void) updateUserId:(NSString *)value {
    
    self.userId = value;
}

- (void) updateUsername:(NSString *)value {
    self.username = value;
}

- (void) updateCurrentView:(id)value {
    
    self.currentView = value;
    
}

- (id) getCurrrentView {
    
    return self.currentView;
    
}

- (void) closeCurrentView {
    
    //[self.currentView closeOut];
    
}

- (NSString *) currentViewTitle {
    
    return [self.currentView title];
    
}

- (void) customizeAppearance {

    UIColor *glossColor = [[UIColor alloc] initWithRed:0.929 green:0.607 blue:0.141 alpha:1.0];
    UIImage *img = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:glossColor];
    
    [glossColor release];
    //[img release];
    
}


//------------------------------
//ROTATION HANDLES -------------
//------------------------------

/*- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}*/


#pragma mark -
#pragma mark Location Delegate

- (void) locationManager:(CLLocationManager *)manager 
	 didUpdateToLocation:(CLLocation *)newLocation 
			fromLocation:(CLLocation *)oldLocation{
	
	mylocation.latitude = newLocation.coordinate.latitude;
	mylocation.longitude = newLocation.coordinate.longitude;
	
}


- (void) locationManager:(CLLocationManager *)manager 
		didFailWithError:(NSError *)errors{
	
	/*UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Location Failed" 
	 message:@"Unable to retrieve your current location." 
	 delegate:nil 
	 cancelButtonTitle:@"OK" 
	 otherButtonTitles:nil];
	 
	 [message show];
	 [message release];*/
}


#pragma mark -
#pragma mark Facebook Handles

- (BOOL)handleOpenURL:(NSURL *)url {
	
	NSString * scheme = [url scheme];
	NSString * prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
	if ([scheme hasPrefix:prefix]) {
		return [SHKFacebook handleOpenURL:url];
	}
	return YES;
}

//Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	return [self handleOpenURL:url];
	
}

//For 4.2+ support

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	
	return [self handleOpenURL:url];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[[GANTracker sharedTracker] stopTracker];
	[locationManager stopUpdatingLocation];
	[locationManager release];
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

