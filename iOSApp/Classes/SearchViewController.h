//
//  SearchViewController.h
//  MTAM
//
//  Created by Haldane Henry on 9/9/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTAMAppDelegate;

@interface SearchViewController : UIViewController {
	MTAMAppDelegate* appDelegate;
	IBOutlet UITableView * thetableView;
	
	IBOutlet UISearchDisplayController * searchDisplayController;
	IBOutlet UISearchBar * searchBar;
	UIImageView * bgIMGView;
	
	NSMutableData *connectionData;
	NSURLConnection *connection;
	BOOL dataReceived;
	
	NSArray * searchResults;
	
}

@property (nonatomic, retain) IBOutlet UITableView * thetableView;
@property (nonatomic, retain) IBOutlet UISearchDisplayController * searchDisplayController;
@property (nonatomic, retain) IBOutlet UISearchBar * searchBar;
@property (nonatomic, retain) UIImageView * bgIMGView;
@property (nonatomic, retain) NSArray * searchResults;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *connectionData;
@property (nonatomic, assign) BOOL dataReceived;

- (void) back:(id)sender;

@end
