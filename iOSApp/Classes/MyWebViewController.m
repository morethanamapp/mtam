//
//  MyWebViewController.m
//  MTAM
//
//  Created by Haldane Henry on 8/24/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "MyWebViewController.h"
#import "MBProgressHUD.h"


@implementation MyWebViewController

@synthesize location, theWebView, theTimer;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[theWebView loadRequest:[NSURLRequest requestWithURL:location cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10.0]];
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

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webview shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	
	return YES;
	
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"Loading...";
	
	self.theTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(doTimer:) userInfo:nil repeats:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	/*UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Sorry" 
													  message:@"Unable to open at this time" 
													 delegate:nil 
											cancelButtonTitle:@"OK" 
											otherButtonTitles:nil];
	
	[message show];
	[message release];*/
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) doTimer:(NSTimer *)paramTimer {
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	//[self setTheWebView:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[theWebView stopLoading];
	
	//NSLog(@"WillDisappear");
	
	
}

- (void)dealloc {
	//NSLog(@"Dellocating WebView");
	
	theWebView.delegate = nil;
	[theWebView stopLoading];
	[theWebView release];
	//[self setTheWebView:nil];
	//[theWebView setDelegate:nil];
	[location release];	
    [super dealloc];
}


@end
