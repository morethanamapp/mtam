//
//  AnnotationPoint.m
//  MTAM
//
//  Created by Haldane Henry on 7/1/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import "AnnotationPoint.h"


@implementation AnnotationPoint

@synthesize coordinate, title, subtitle, pinColor, itemIndex;

+ (NSString *) resuableIdentifierforPinColor:(MKPinAnnotationColor)paramColor {
		
	NSString *result = nil;
	
	switch (paramColor) {
		case MKPinAnnotationColorRed:{
			result = REUSEABLE_PIN_RED;
			break;
		}
		case MKPinAnnotationColorGreen:{
			result = REUSEABLE_PIN_GREEN;
			break;
		}
		case MKPinAnnotationColorPurple:{
			result = REUSEABLE_PIN_PURPLE;
			break;
		}		
	}
	
	return(result);
	
}

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates 
					 title:(NSString *)paramTitle 
				  subTitle:(NSString *)paramSubTitle{

	self = [super init];
	
	if(self != nil){
		coordinate = paramCoordinates;
		title = [paramTitle copy];
		subtitle = [paramSubTitle copy];
		pinColor = MKPinAnnotationColorGreen;
			
	}
	
	return(self);
	
}

- (void) dealloc {
	
	[title release];
	[subtitle release];
	[super dealloc];
		
}

@end
