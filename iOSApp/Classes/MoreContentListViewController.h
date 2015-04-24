//
//  MoreContentListViewController.h
//  MTAM
//
//  Created by Haldane Henry on 8/26/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTAMAppDelegate;

@interface MoreContentListViewController : UIViewController {
	MTAMAppDelegate* appDelegate;
	IBOutlet UITableView * thetableView;
	
	NSMutableArray * theList;
	NSString * moreType;
}

@property (nonatomic, retain) IBOutlet UITableView *thetableView;
@property (nonatomic, retain) NSMutableArray * theList;
@property (nonatomic, retain) NSString * moreType;


- (void) back:(id)sender;

@end
