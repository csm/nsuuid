//
//  CMUUID.m
//  WODCoach
//
//  Created by Casey Marshall on 6/14/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "CMUUID.h"


@implementation CMUUID

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

+ (CMUUID *) uuidWithString: (NSString *) uuidStr
{
    return [[[CMUUID alloc] initWithString: uuidStr] autorelease];
}

+ (CMUUID *) uuidWithUUIDRef: (CFUUIDRef) uuid
{
    return [[[CMUUID alloc] initWithUUIDRef: uuid] autorelease];
}

+ (CMUUID *) uuidWithUUIDBytes: (CFUUIDBytes) uuidBytes
{
    return [[[CMUUID alloc] initWithUUIDBytes: uuidBytes] autorelease];
}

+ (CMUUID *) uuidWithData: (NSData *) data
{
    return [[[CMUUID alloc] initWithData: data] autorelease];
}

+ (CMUUID *) randomUuid
{
    CFUUIDBytes bytes;
    SecRandomCopyBytes(kSecRandomDefault, sizeof(bytes), (UInt8 *) &bytes);
    return [CMUUID uuidWithUUIDBytes: bytes];
}

+ (CMUUID *) nullUuid
{
    CFUUIDBytes bytes;
    memset(&bytes, 0, sizeof(bytes));
    return [CMUUID uuidWithUUIDBytes: bytes];
}

- (NSString *) stringValue
{
    return [NSString stringWithFormat: @"%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
            bytes.byte0,  bytes.byte1,  bytes.byte2,  bytes.byte3,
            bytes.byte4,  bytes.byte5,  bytes.byte6,  bytes.byte7,
            bytes.byte8,  bytes.byte9,  bytes.byte10, bytes.byte11,
            bytes.byte12, bytes.byte13, bytes.byte14, bytes.byte15];
            
}

- (NSComparisonResult) compareTo: (CMUUID *) that
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
    if (object == nil || ![object isKindOfClass: [CMUUID class]])
        return NO;
    
    CMUUID *that = (CMUUID *) object;
    CFUUIDBytes thatbytes = [that bytes];
    return memcmp(&bytes, &thatbytes, sizeof(bytes)) == 0;
}

- (NSString *) description
{
    return [self stringValue];
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

- (BOOL) isNullUuid
{
    return (bytes.byte0 == 0
            && bytes.byte1 == 0
            && bytes.byte2 == 0
            && bytes.byte3 == 0
            && bytes.byte4 == 0
            && bytes.byte5 == 0
            && bytes.byte6 == 0
            && bytes.byte7 == 0
            && bytes.byte8 == 0
            && bytes.byte9 == 0
            && bytes.byte10 == 0
            && bytes.byte11 == 0
            && bytes.byte12 == 0
            && bytes.byte13 == 0
            && bytes.byte14 == 0
            && bytes.byte15 == 0);
}

@end
