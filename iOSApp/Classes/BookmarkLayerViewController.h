//
//  BookmarkLayerViewController.h
//  MTAM
//
//  Created by Haldane Henry on 7/27/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTAMAppDelegate;

@interface BookmarkLayerViewController : UIViewController {
	MTAMAppDelegate* appDelegate;
	IBOutlet UITableView * thetableView;
	
	NSMutableData *connectionData;
	NSURLConnection *connection;
	BOOL dataReceived;
	UIActivityIndicatorView *activityIndicator;
	
}

@property (nonatomic, retain) IBOutlet UITableView * thetableView;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *connectionData;
@property (nonatomic, assign) BOOL dataReceived;

- (void) getMapPoints;
- (void) back:(id)sender;

@end
