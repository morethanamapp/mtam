//
//  XMLParser.h
//  MTAM
//
//  Created by Haldane Henry on 6/22/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTAMAppDelegate, landmark;

@interface XMLParser : NSObject <NSXMLParserDelegate>{
	
	NSMutableString *currentElementValue;
	MTAMAppDelegate *appDelegate;
	landmark *alandmark;
	NSMutableArray *lmkgallery;
	NSMutableArray *lmkvideos;
	NSMutableArray *lmkaudios;
	NSMutableArray *lmklinks;
	
}

- (XMLParser *) initXMLParser;

@end
