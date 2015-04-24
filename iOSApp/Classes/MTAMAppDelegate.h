//
//  MTAMAppDelegate.h
//  MTAM
//
//  Created by Haldane Henry on 6/13/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJObjManager.h"
#import <CoreLocation/CoreLocation.h>
#import "SHKFacebook.h"
#import "CustomNavController.h"

@interface MTAMAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    
    UIWindow *window;
    CustomNavController *navigationController;
	NSMutableArray *entries;
	NSMutableArray *subEntries;
	BOOL loginOK;
	NSString * userId;
	NSString * username;
	NSInteger layerResultCount;
	NSInteger nearMeCount;
	BOOL resetResults;
	BOOL firstRun;
	
	NSString * mtamWebSalt;
	NSString * mtamAuthKey;
	
	CLLocationCoordinate2D mylocation;
	CLLocationManager *locationManager;
	
	HJObjManager* objMan;
	
	SHKFacebook * shkFacebook;
	
	id currentView;
    id sAppDelegate;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CustomNavController *navigationController;
@property (nonatomic, retain) NSMutableArray *entries;
@property (nonatomic, retain) NSMutableArray *subEntries;
@property (nonatomic, retain) HJObjManager *objMan;
@property (nonatomic, assign) BOOL loginOK;
@property (nonatomic, assign) BOOL resetResults;
@property (nonatomic, assign) BOOL firstRun;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, assign) NSInteger layerResultCount;
@property (nonatomic, assign) NSInteger nearMeCount;
@property (nonatomic, retain) NSString * mtamWebSalt;
@property (nonatomic, retain) NSString * mtamAuthKey;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D mylocation;
@property (nonatomic, retain) SHKFacebook * shkFacebook;
@property (nonatomic, assign) id currentView;
@property (nonatomic, assign) id sAppDelegate;

- (void) updateLoginOK:(BOOL)value;
- (void) updateUserId:(NSString *)value;
- (void) updateUsername:(NSString *)value;
- (void) updateCurrentView:(id)value;
- (id) getCurrrentView;

- (NSString *) currentViewTitle;
- (void) closeCurrentView;
- (void)customizeAppearance;

@end

