//
//  SelectStateViewController.h
//  MTAM
//
//  Created by Haldane Henry on 8/31/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTAMAppDelegate;

@interface SelectStateViewController : UIViewController {
	IBOutlet UITableView* thetableView;
	NSMutableArray * statesARR;
	
}

@property (nonatomic, retain) IBOutlet UITableView * thetableView;
@property (nonatomic, retain) NSMutableArray * statesARR;

- (void) back:(id)sender;

@end
