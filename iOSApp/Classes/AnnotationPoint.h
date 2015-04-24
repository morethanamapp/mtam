//
//  AnnotationPoint.h
//  MTAM
//
//  Created by Haldane Henry on 7/1/11.
//  Copyright 2011 Ember Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define REUSEABLE_PIN_RED    @"Red"
#define REUSEABLE_PIN_GREEN  @"Green"
#define REUSEABLE_PIN_PURPLE @"Purple"


@interface AnnotationPoint : NSObject <MKAnnotation>{
@private
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	MKPinAnnotationColor pinColor;
	NSInteger itemIndex;
}

@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;
@property (nonatomic, assign) NSInteger itemIndex;

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates 
					 title:(NSString*)paramTitle
				  subTitle:(NSString*)paramSubTitle;

+ (NSString *) resuableIdentifierforPinColor:(MKPinAnnotationColor)paramColor;


@end
