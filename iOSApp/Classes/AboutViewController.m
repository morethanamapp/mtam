//
//  AboutViewContoller.m
//  MTAM
//
//  Created by Haldane Henry on 6/13/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "AboutViewController.h"
#import "MTAMAppDelegate.h"
#import "MyWebViewController.h"
#import "GANTracker.h"
#import "MBProgressHUD.h"

@implementation AboutViewController
@synthesize close, delegate, theWebView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*NSString *imagePath = [[NSBundle mainBundle] resourcePath];
	imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
	imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
	NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	
	//NSString *htmlString = @"<html><head></head><body style='color:#ffffff;'>Test</body></html>";
	NSString *htmlString = [[NSString alloc] initWithData:[readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];*/		
	
	/*[self.theWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//",imagePath]]];
	
	[htmlString release];*/
	
	theWebView.opaque = NO;
	theWebView.backgroundColor = [UIColor clearColor];
	
	NSString * aboutLink = @"http://www.morethanamapp.org/request/about.html";
	
	[self.theWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aboutLink] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10.0]];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"Loading...";
	
	NSError * error;
	
	if (![[GANTracker sharedTracker] trackPageview:@"/app_about_view" 
										 withError:&error]) {
		
		//NSLog(@"GANTracker Error: %@", error);
	}
		
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

- (IBAction) done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];
}

- (void) back:(id)sender {
	
	//[self.navigationController popViewControllerAnimated:YES];
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webview shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
		
	//CAPTURE USER LINK-CLICK
	
	if(navigationType == UIWebViewNavigationTypeLinkClicked){
				
		NSURL * url = [request URL];
		//NSLog(@"CLiked this: %@",[url absoluteString]);
								  
		
		/*UIImage *backImg = [UIImage imageNamed:@"icon_back.png"];
		UIBarButtonItem* backbutton = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
		backbutton.width = 65.0;*/
		
		UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
		
		MyWebViewController * wVC = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil];
		wVC.navigationItem.leftBarButtonItem = doneButton;
		wVC.navigationItem.hidesBackButton = YES;
		wVC.location = url;
		
		UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:wVC];	
		
		[self presentModalViewController:navCon animated:YES];
		
		//[navCon release];

		[doneButton release];
		[wVC release];
		[navCon release];
        
		return NO;
		
	}else {
		
		return YES;
		
	}

}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}



#pragma mark -
#pragma mark Memory Management


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[close release];
	[theWebView release];
    [super dealloc];
}


@end
