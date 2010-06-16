//
//  NSUUID.m
//  WODCoach
//
//  Created by Casey Marshall on 6/14/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "NSUUID.h"


@implementation NSUUID

- (id) initWithString: (NSString *) uuidStr
{
    if (self = [super init])
    {
        CFUUIDRef u = CFUUIDCreateFromString(NULL, (CFStringRef) uuidStr);
        bytes = CFUUIDGetUUIDBytes(u);
        CFRelease(u);
    }
    return self;
}

- (id) initWithUUIDRef: (CFUUIDRef) uuid
{
    if (self = [super init])
    {
        bytes = CFUUIDGetUUIDBytes(uuid);
    }
    return self;
}

- (id) initWithUUIDBytes: (CFUUIDBytes) uuidBytes
{
    if (self = [super init])
    {
        bytes = uuidBytes;
    }
    return self;
}

- (id) initWithData: (NSData *) data
{
    if (self = [super init])
    {
        if ([data length] < 16)
        {
            [self release];
            return nil;
        }
        [data getBytes: &bytes length: sizeof(bytes)];
    }
    return self;
}

+ (NSUUID *) uuidWithString: (NSString *) uuidStr
{
    return [[[NSUUID alloc] initWithString: uuidStr] autorelease];
}

+ (NSUUID *) uuidWithUUIDRef: (CFUUIDRef) uuid
{
    return [[[NSUUID alloc] initWithUUIDRef: uuid] autorelease];
}

+ (NSUUID *) uuidWithUUIDBytes: (CFUUIDBytes) uuidBytes
{
    return [[[NSUUID alloc] initWithUUIDBytes: uuidBytes] autorelease];
}

+ (NSUUID *) uuidWithData: (NSData *) data
{
    return [[[NSUUID alloc] initWithData: data] autorelease];
}

+ (NSUUID *) randomUuid
{
    CFUUIDBytes bytes;
    SecRandomCopyBytes(kSecRandomDefault, sizeof(bytes), (UInt8 *) &bytes);
    return [NSUUID uuidWithUUIDBytes: bytes];
}

- (NSString *) stringValue
{
    return [NSString stringWithFormat: @"%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
            bytes.byte0,  bytes.byte1,  bytes.byte2,  bytes.byte3,
            bytes.byte4,  bytes.byte5,  bytes.byte6,  bytes.byte7,
            bytes.byte8,  bytes.byte9,  bytes.byte10, bytes.byte11,
            bytes.byte12, bytes.byte13, bytes.byte14, bytes.byte15];
            
}

- (NSComparisonResult) compareTo: (NSUUID *) that
{
    CFUUIDBytes thatbytes = [that bytes];
    int result = memcmp(&bytes, &thatbytes, sizeof(bytes));
    if (result < 0)
        return NSOrderedAscending;
    if (result > 0)
        return NSOrderedDescending;
    return NSOrderedSame;
}

- (BOOL) isEqual: (id) object
{
    if (object == nil || ![object isKindOfClass: [NSUUID class]])
        return NO;
    
    NSUUID *that = (NSUUID *) object;
    CFUUIDBytes thatbytes = [that bytes];
    return memcmp(&bytes, &thatbytes, sizeof(bytes)) == 0;
}

- (CFUUIDRef) uuid
{
    return CFUUIDCreateWithBytes(NULL, bytes.byte0, bytes.byte1, bytes.byte2, bytes.byte3,
                                 bytes.byte4, bytes.byte5, bytes.byte6, bytes.byte7,
                                 bytes.byte8, bytes.byte9, bytes.byte10, bytes.byte11,
                                 bytes.byte12, bytes.byte13, bytes.byte14, bytes.byte15);
}

- (CFUUIDBytes) bytes
{
    CFUUIDBytes ret = bytes;
    return ret;
}

- (NSData *) data
{
    return [NSData dataWithBytes: (void *) &bytes
                          length: sizeof(bytes)];
}

@end
