//
//  CMUUID.h
//  WODCoach
//
//  Created by Casey Marshall on 6/14/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CMUUID : NSObject
{
    CFUUIDBytes bytes;
}

- (id) initWithString: (NSString *) uuidStr;
- (id) initWithUUIDRef: (CFUUIDRef) uuid;
- (id) initWithUUIDBytes: (CFUUIDBytes) uuidBytes;
- (id) initWithData: (NSData *) data;

+ (CMUUID *) uuidWithString: (NSString *) uuidStr;
+ (CMUUID *) uuidWithUUIDRef: (CFUUIDRef) uuid;
+ (CMUUID *) uuidWithUUIDBytes: (CFUUIDBytes) uuidBytes;
+ (CMUUID *) uuidWithData: (NSData *) data;
+ (CMUUID *) randomUuid;
+ (CMUUID *) nullUuid;

- (NSString *) stringValue;
- (CFUUIDRef) uuid;
- (CFUUIDBytes) bytes;
- (NSData *) data;
- (BOOL) isNullUuid;

@end
