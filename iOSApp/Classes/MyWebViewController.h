//
//  MyWebViewController.h
//  MTAM
//
//  Created by Haldane Henry on 8/24/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyWebViewController : UIViewController <UIWebViewDelegate>{
	
	NSURL *location;
	IBOutlet UIWebView *theWebView;
	
	NSTimer *theTimer;
}

@property (retain) NSURL *location;
@property (nonatomic, retain) UIWebView *theWebView;
@property (retain) NSTimer *theTimer;

@end
