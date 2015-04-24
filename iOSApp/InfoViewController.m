//
//  InfoViewController.m
//  MTAM
//
//  Created by Haldane Henry on 6/15/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "InfoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "MyWebViewController.h"

@implementation InfoViewController
@synthesize webView, htmlfile, delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*NSString *imagePath = [[NSBundle mainBundle] resourcePath];
	imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
	imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:self.htmlfile ofType:@"html"];
	NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	
	//NSString *htmlString = @"<html><head></head><body style='color:#ffffff;'>Test</body></html>";
	NSString *htmlString = [[NSString alloc] initWithData:[readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
	
	webView.opaque = NO;
	webView.backgroundColor = [UIColor clearColor];
	//[self.webView loadHTMLString:htmlString baseURL:nil];
	[self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//",imagePath]]];
	[htmlString release];*/
	
	webView.opaque = NO;
	webView.backgroundColor = [UIColor clearColor];
	
	//NSLog(@"Info Section: %@",self.htmlfile);
	
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.morethanamapp.org/request/get-app-details.php?section=%@", self.htmlfile]];
	ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
	
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"Loading...";
	
}


- (IBAction) done:(id)sender {
	[self.delegate CurlUpViewControllerDidFinish:self];
}


//Rotation Controls

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webview shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	
	//CAPTURE USER LINK-CLICK
	
	if(navigationType == UIWebViewNavigationTypeLinkClicked){
		
		
		NSURL * url = [request URL];
		
		[webview stopLoading];
		[[UIApplication sharedApplication] openURL:url];
		
		return NO;
		
		/*if([[url scheme] isEqual:@"http"]){
			
			
			//NSString * link = [url absoluteString];
			
			UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
			
			MyWebViewController * wVC = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil];
			wVC.navigationItem.leftBarButtonItem = doneButton;
			wVC.navigationItem.hidesBackButton = YES;
			wVC.location = url;
			
			UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:wVC];	
			
			[self.delegate presentModalViewController:navCon animated:YES];
			
			//[navCon release];
			
			[doneButton release];
			[wVC release];
			
			return NO;
			
		}else {
			
			
		}*/
		
		
	}else {
		
		return YES;
		
	}
}

#pragma mark -
#pragma mark ASIFormDataRequest Delegate


- (void)requestFinished:(ASIHTTPRequest *) request {
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	if (request.responseStatusCode == 400) {
		
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Sorry" 
														  message:@"Invalid Request" 
														 delegate:nil 
												cancelButtonTitle:@"OK" 
												otherButtonTitles:nil];
		
		[message show];
		[message release];
		
	}else if (request.responseStatusCode == 200) {
			
		NSString *responseString = [request responseString];
		NSDictionary * responseDict = [responseString JSONValue];
		
		NSString * content = [responseDict objectForKey:@"content"];
		NSURL * url = [NSURL URLWithString:content];
		[self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10.0]];
		
	}
	
}


- (void)requestFailed:(ASIHTTPRequest *)request {
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	//NSError * error = [request error];
	//NSLog(@"ERROR: %@",error.localizedDescription);
	
	
	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Request" 
													  message:@"Connection Timed Out, Try Again." 
													 delegate:nil 
											cancelButtonTitle:@"OK" 
											otherButtonTitles:nil];
	
	[message show];
	[message release];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[htmlfile release];
    [super dealloc];
}


@end
