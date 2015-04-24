//
//  UserDataPlistAccess.m
//  MTAM
//
//  Created by Haldane Henry on 1/18/12.
//  Copyright 2012 Ember Media. All rights reserved.
//

#import "UserDataPlistAccess.h"


@implementation UserDataPlistAccess


+ (void) updateUserData:(NSMutableDictionary *)usrDict {
	
	NSString * errorDesc = nil;
	NSPropertyListFormat format;
	NSString * plistPath;
	NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	plistPath = [rootPath stringByAppendingPathComponent:@"mtamUserAccData.plist"];
	
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		
		if ([[usrDict objectForKey:@"FBRegVars"] isEqual:@"removed"]) {
			[usrDict removeObjectForKey:@"FBRegVars"];
		}
		
		NSDictionary * convertedTemp = [[usrDict copy] autorelease];
		
		
		NSDictionary * rootDict = [NSDictionary dictionaryWithObject:convertedTemp forKey:@"UserData"];
		
		NSData * plistData = [NSPropertyListSerialization dataFromPropertyList:rootDict 
																		format:NSPropertyListXMLFormat_v1_0 
															  errorDescription:&errorDesc];
		
		if (plistData) {
			[plistData writeToFile:plistPath atomically:YES];
			
		}else {
			//NSLog(@"UpdateData Error: %@",errorDesc);
			[errorDesc release];
		}
		
	}else {
		NSData * plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
		NSDictionary * tempRoot = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML 
																				   mutabilityOption:NSPropertyListMutableContainersAndLeaves 
																							 format:&format 
																				   errorDescription:&errorDesc];
	
		
		
		NSMutableDictionary * temp = [NSMutableDictionary dictionaryWithDictionary:[tempRoot objectForKey:@"UserData"]];		
		NSDictionary * convertedTemp = [[usrDict copy] autorelease];		
		[temp addEntriesFromDictionary:convertedTemp];
		
		if ([[convertedTemp objectForKey:@"FBRegVars"] isEqual:@"removed"]) {
			[temp removeObjectForKey:@"FBRegVars"];
		}
		
		
		NSDictionary * convertedTemp2 = [[temp copy] autorelease];
		
		NSDictionary * rootDict = [NSDictionary dictionaryWithObject:convertedTemp2 forKey:@"UserData"];
		
		NSData * plistData = [NSPropertyListSerialization dataFromPropertyList:rootDict 
																		format:NSPropertyListXMLFormat_v1_0 
															  errorDescription:&errorDesc];
		
		if (plistData) {
			[plistData writeToFile:plistPath atomically:YES];
			
		}else {
			//NSLog(@"UpdateData Error: %@",errorDesc);
			[errorDesc release];
		}
	}
	
}

+ (void) removeUserData {
		
	NSString * errorDesc = nil;
	NSPropertyListFormat format;
	NSString * plistPath;
	NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	plistPath = [rootPath stringByAppendingPathComponent:@"mtamUserAccData.plist"];
	
	NSData * plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary * tempRoot = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML 
																						 mutabilityOption:NSPropertyListMutableContainersAndLeaves 
																								   format:&format 
																						 errorDescription:&errorDesc];

	NSMutableDictionary * temp = [NSMutableDictionary dictionaryWithDictionary:[tempRoot objectForKey:@"UserData"]];
	
	if ([[temp objectForKey:@"UserType"] isEqual:@"FbUser"]) {
		
		[temp removeObjectForKey:@"UserType"];
		[temp removeObjectForKey:@"UserID"];
		[temp removeObjectForKey:@"kSHKFacebookUserInfo"];
		
		if ([temp objectForKey:@"FBRegVars"]) {
			[temp removeObjectForKey:@"FBRegVars"];
		}
		
		NSDictionary * convertedTemp = [[temp copy] autorelease];
		
		NSDictionary * rootDict = [NSDictionary dictionaryWithObject:convertedTemp forKey:@"UserData"];
		
		NSData * plistData = [NSPropertyListSerialization dataFromPropertyList:rootDict
																		format:NSPropertyListXMLFormat_v1_0 
															  errorDescription:&errorDesc];
		
		if (plistData) {
			[plistData writeToFile:plistPath atomically:YES];
			
		}else {
			//NSLog(@"RemoveData Error: %@",errorDesc);
			[errorDesc release];
		}
		
	}else {
		
		[temp removeObjectForKey:@"UserType"];
		[temp removeObjectForKey:@"UserID"];
		[temp removeObjectForKey:@"MtamUsername"];
		
		NSDictionary * convertedTemp = [[temp copy] autorelease];
		
		NSDictionary * rootDict = [NSDictionary dictionaryWithObject:convertedTemp forKey:@"UserData"];
		
		NSData * plistData = [NSPropertyListSerialization dataFromPropertyList:rootDict
																		format:NSPropertyListXMLFormat_v1_0 
															  errorDescription:&errorDesc];
		
		if (plistData) {
			[plistData writeToFile:plistPath atomically:YES];
			
		}else {
			//NSLog(@"RemoveData Error: %@",errorDesc);
			[errorDesc release];
		}
		
	}
	
}


+ (NSMutableDictionary *) returnUserData {
	
	NSString * errorDesc = nil;
	NSPropertyListFormat format;
	NSString * plistPath;
	NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	plistPath = [rootPath stringByAppendingPathComponent:@"mtamUserAccData.plist"];
	
	
	NSData * plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary * tempRoot = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML 
																			   mutabilityOption:NSPropertyListMutableContainersAndLeaves 
																						 format:&format 
																			   errorDescription:&errorDesc];
	
	NSMutableDictionary * temp = [NSMutableDictionary dictionaryWithDictionary:[tempRoot objectForKey:@"UserData"]];
	
	return temp;
}

+ (BOOL) dataStatus {
	
	//NSString * errorDesc = nil;
	//NSPropertyListFormat format;
	NSString * plistPath;
	NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	plistPath = [rootPath stringByAppendingPathComponent:@"mtamUserAccData.plist"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		
		return FALSE;
		
	}else {
		
		return TRUE;
	}
	
}

@end
