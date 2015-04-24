//
//  XMLSubParser.h
//  MTAM
//
//  Created by Haldane Henry on 7/27/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTAMAppDelegate, landmark;

@interface XMLSubParser : NSObject <NSXMLParserDelegate>{
	
	NSMutableString *currentElementValue;
	MTAMAppDelegate *appDelegate;
	landmark *alandmark;
	NSMutableArray *lmkgallery;
	NSMutableArray *lmkvideos;
	NSMutableArray *lmkaudios;
	NSMutableArray *lmklinks;
	NSInteger resultCount;
}

- (XMLSubParser *) initXMLParser;

@end
