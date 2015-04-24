//
//  XMLSubParser.m
//  MTAM
//
//  Created by Haldane Henry on 7/27/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "XMLSubParser.h"
#import "MTAMAppDelegate.h"
#import "landmark.h"
#import "MyPhoto.h"

@implementation XMLSubParser


- (XMLSubParser *) initXMLParser {
	
	self = [super init];
	
    if (self) {
        appDelegate = (MTAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
	
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"feed"]) {
		//Initialize the array.
		if(appDelegate.resetResults){
			appDelegate.subEntries = nil;
			appDelegate.subEntries = [[[NSMutableArray alloc] init] autorelease];
		}else {
			appDelegate.subEntries = [[[NSMutableArray alloc] init] autorelease];
		}
		
		
		//Extract the attribute here.
		appDelegate.layerResultCount = [[attributeDict objectForKey:@"count"] integerValue];
		
	}
	else if([elementName isEqualToString:@"landmark"]) {
		
		//Initialize the entry.
		alandmark = [[landmark alloc] init];
		
		//Extract the attribute here.
		//aBook.bookID = [[attributeDict objectForKey:@"id"] integerValue];
		
		//NSLog(@"Reading id value :%i", aBook.bookID);
	}else if ([elementName isEqualToString:@"gallery"]) {
		
		lmkgallery = [[NSMutableArray alloc] init];
		
	}else if ([elementName isEqualToString:@"videos"]) {
		
		lmkvideos = [[NSMutableArray alloc] init];
		
	}else if ([elementName isEqualToString:@"audios"]) {
		
		lmkaudios = [[NSMutableArray alloc] init];
		
	}else if ([elementName isEqualToString:@"links"]) {
		
		lmklinks = [[NSMutableArray alloc] init];
	}
	
	
	
	
	//NSLog(@"Processing Element: %@", elementName);
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	
	//NSLog(@"Processing Value: %@", currentElementValue);
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"feed"])
		return;
	
	//There is nothing to do if we encounter the feed element here.
	//If we encounter the entry element however, we want to add the entry object to the array
	// and release the object.
	if([elementName isEqualToString:@"landmark"]) {
		[appDelegate.subEntries addObject:alandmark];
		
		[alandmark release];
		alandmark = nil;
	}
	else{
		
		if ([elementName isEqualToString:@"gallery"]) {
			
			[alandmark setGallery:lmkgallery];
			[lmkgallery release];
			lmkgallery = nil;
			
		}else if ([elementName isEqualToString:@"videos"]) {
			
			[alandmark setVideos:lmkvideos];
			[lmkvideos release];
			lmkvideos = nil;
			
		}else if ([elementName isEqualToString:@"audios"]) {
			
			[alandmark setAudios:lmkaudios];
			[lmkaudios release];
			lmkaudios = nil;
			
		}else if ([elementName isEqualToString:@"links"]) {
			
			[alandmark setLinks:lmklinks];
			[lmklinks release];
			lmklinks = nil;
			
		}else if ([elementName isEqualToString:@"image"]) {			
			
			//[lmkgallery addObject:[[[NSString alloc] initWithString:currentElementValue] autorelease]];
			[lmkgallery addObject:[[[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:currentElementValue] name:nil] autorelease]];
			
		}else if ([elementName isEqualToString:@"video"]) {
			
			[lmkvideos addObject:[[[NSString alloc] initWithString:currentElementValue] autorelease]];
			
		}else if ([elementName isEqualToString:@"audio"]) {
			
			[lmkaudios addObject:[[[NSString alloc] initWithString:currentElementValue] autorelease]];
			
		}else if ([elementName isEqualToString:@"link"]) {
			
			[lmklinks addObject:[[[NSString alloc] initWithString:currentElementValue] autorelease]];
			
		}else {
			
			[alandmark setValue:currentElementValue forKey:elementName];
			
		}
		
	}
	
	[currentElementValue release];
	currentElementValue = nil;
}


- (void) dealloc {
	
	[alandmark release];
	[currentElementValue release];
	[super dealloc];
}

@end
