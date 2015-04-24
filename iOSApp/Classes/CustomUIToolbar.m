//
//  CustomUIToolbar.m
//  MTAM
//
//  Created by Haldane Henry on 6/15/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "CustomUIToolbar.h"


@implementation CustomUIToolbar


- (void) drawRect:(CGRect)rect {
	
	UIColor *glossColor = [[UIColor alloc] initWithRed:0.929 green:0.607 blue:0.141 alpha:1.0];
	UIImage *img = [UIImage imageNamed:@"navbar.png"];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];	
	self.backgroundColor = [UIColor clearColor];
	self.tintColor = glossColor;
	self.barStyle = UIBarStyleBlackTranslucent;
	
	[glossColor release];
	//[img release];
}

@end
