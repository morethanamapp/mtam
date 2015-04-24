//
//  InfoViewController.h
//  MTAM
//
//  Created by Haldane Henry on 6/15/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurlUpViewControllerDelegate;

@interface InfoViewController : UIViewController <UIWebViewDelegate>{
	
	IBOutlet UIWebView* webView;
	id <CurlUpViewControllerDelegate> delegate;
	NSString *htmlfile;
}

@property (nonatomic, assign) id <CurlUpViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *htmlfile;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (IBAction)done:(id)sender;

@end


@protocol CurlUpViewControllerDelegate
- (void)CurlUpViewControllerDidFinish:(UIViewController *)controller;
@end