//
//  landmark.h
//  MTAM
//
//  Created by Haldane Henry on 6/21/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface landmark : NSObject {
	NSInteger landmarkid;
	NSString *title;
	NSString *details;
	NSString *excerpt;
	NSString *photo;
	NSString *address;
	float longtitude;
	float latitude;
	float distance;
	NSMutableArray *gallery;
	NSMutableArray *videos;
	NSMutableArray *audios;
	NSMutableArray *links;
}

@property (nonatomic, assign) NSInteger landmarkid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSString *excerpt;
@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, assign) float longtitude;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float distance;
@property (nonatomic, retain) NSMutableArray *gallery;
@property (nonatomic, retain) NSMutableArray *videos;
@property (nonatomic, retain) NSMutableArray *audios;
@property (nonatomic, retain) NSMutableArray *links;

@end
