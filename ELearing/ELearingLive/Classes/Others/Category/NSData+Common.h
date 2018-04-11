//
//  NSData+Common.h
//  wwface
//
//  Created by leo on 2016/10/13.
//  Copyright © 2016年 fo. All rights reserved.
//
#if kSupportNSDataCommon
#import <Foundation/Foundation.h>


void *NewBase64Decode(const char *inputBuffer, size_t length, size_t *outputLength);

char *NewBase64Encode(const void *inputBuffer, size_t length, bool separateLines, size_t *outputLength);

@interface NSData (Common)

@property (nonatomic, readonly) NSString* md5Hash;

@property (nonatomic, readonly) NSString* sha1Hash;

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;
- (NSString *)md5Hash;
- (NSString *)sha1Hash;

@end
#endif
