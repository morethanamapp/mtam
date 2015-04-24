//
//  UserDataPlistAccess.h
//  MTAM
//
//  Created by Haldane Henry on 1/18/12.
//  Copyright 2012 Ember Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserDataPlistAccess : NSObject {
	
}

+ (void) updateUserData:(NSMutableDictionary *)usrDict;
+ (void) removeUserData;
+ (NSMutableDictionary *) returnUserData;
+ (BOOL) dataStatus;

@end