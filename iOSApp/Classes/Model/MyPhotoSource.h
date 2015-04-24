//
//  MyPhotoSource.h
//  EGOPhotoViewerDemo_iPad
//
//  Created by Devin Doty on 7/3/10July3.
//  Copyright 2010 Ember Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOPhotoGlobal.h"

@interface MyPhotoSource : NSObject <EGOPhotoSource> {
	
	NSArray *_photos;
	NSInteger _numberOfPhotos;

}

- (id)initWithPhotos:(NSArray*)photos;

@end
