//
//  landmark.m
//  MTAM
//
//  Created by Haldane Henry on 6/21/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "landmark.h"


@implementation landmark

@synthesize landmarkid, title, details, excerpt, photo, address, longtitude, latitude, distance, gallery, videos, audios, links;

- (void) dealloc {
		
	[title release];
	[details release];
	[excerpt release];
	[photo release];
	[address release];
	[gallery release];
	[videos release];
	[audios release];
	[links release];
	
	[super dealloc];
}

@end
