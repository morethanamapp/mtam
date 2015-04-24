//
//  AboutViewContoller.h
//  MTAM
//
//  Created by Haldane Henry on 6/13/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTAMAppDelegate;

@protocol FlipsideOneViewControllerDelegate;

@interface AboutViewController : UIViewController <UIWebViewDelegate>{
	
	IBOutlet UIButton* close;
	IBOutlet UIWebView* theWebView;
	id <FlipsideOneViewControllerDelegate> delegate;
	
}

@property (nonatomic, retain) UIButton * close;
@property (nonatomic, retain) UIWebView * theWebView;

@property (nonatomic, assign) id <FlipsideOneViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (void) back:(id)sender;
@end

@protocol FlipsideOneViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(UIViewController *)controller;
@end
