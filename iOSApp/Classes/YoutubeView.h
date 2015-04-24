//
//  YoutubeView.h
//  MTAM
//
//  Created by Haldane Henry on 2/17/12.
//  Copyright 2012 Ember Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YoutubeView : UIViewController <UIWebViewDelegate>{
	IBOutlet UIWebView * theWebView;
    IBOutlet UIImageView * ytVidImage;
    IBOutlet UIButton * playButton;
	NSString * ytLink;
}

@property (nonatomic, retain) UIWebView * theWebView;
@property (nonatomic, retain) UIImageView * ytVidImage;
@property (nonatomic, retain) UIButton * playButton;
@property (nonatomic, retain) NSString * ytLink;

-(IBAction)ytPlayVid:(id)sender;

@end
