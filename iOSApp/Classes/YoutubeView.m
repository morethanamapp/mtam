//
//  YoutubeView.m
//  MTAM
//
//  Created by Haldane Henry on 2/17/12.
//  Copyright 2012 Ember Media. All rights reserved.
//

#import "YoutubeView.h"
#import "MBProgressHUD.h"
#import "HCYoutubeParser.h"
#import <MediaPlayer/MediaPlayer.h>


@implementation YoutubeView

@synthesize ytLink, theWebView, ytVidImage, playButton;

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
    
    
    //OLD WebView Approach
	
	/*theWebView.opaque = NO;
	theWebView.backgroundColor = [UIColor clearColor];
	
	NSString *ytHTML = @"<html><head></head>\
	<body style='margin:0; padding:0; background:transparent none; font-family:Verdana, Helvetica, Arial;'>\
	<div style='padding:5px 10px 0px 10px;'>\
	<embed id='yt' src='%@' type='application/x-shockwave-flash' width='300' height='275'></embed>\
	</div>\
	</body></html>";
	
	NSString *html = [NSString stringWithFormat:ytHTML, ytLink];
	
	[theWebView loadHTMLString:html baseURL:nil];*/
    
    
    //New Approach
    
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"Loading Video...";
    
    self.playButton.hidden = YES;
    
    [HCYoutubeParser thumbnailForYoutubeURL:[NSURL URLWithString:ytLink ]
                              thumbnailSize:YouTubeThumbnailDefaultHighQuality
                              completeBlock:^(UIImage *image, NSError *error) {
                                  if (!error) {
                                      self.playButton.hidden = NO;
                                      self.ytVidImage.image = image;
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                  }
                                  else {
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                                      [alert show];
                                      [alert release];
                                  }
                              }];
    
}


#pragma mark -
#pragma mark Local Methods

- (IBAction)ytPlayVid:(id)sender {
    
    // Gets an dictionary with each available youtube url
    NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:ytLink]];
    //NSLog(@"videos: %@",videos);
    // Presents a MoviePlayerController with the youtube quality medium
    MPMoviePlayerViewController *mp = [[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[videos objectForKey:@"medium"]]] autorelease];
    
    mp.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:mp animated:YES];
    
}


//ROTATION METHODS

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"Loading...";
	
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
    [super dealloc];
}


@end
