//
//  Encryption.m
//  SignLanguage
//
//  Created by Lim on 14/11/26.
//  Copyright (c) 2014年 Lim. All rights reserved.
//

#define DESKEY @"keyst2014.KJHutys29SHANXUN5858@.CTM"

#import "Encryption.h"
#import "GTMBase64.h"
@implementation Encryption
//3des加解密
+ (NSString*)tripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *encryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [encryptData length];
        vplainText = [encryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *)[DESKEY UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSLog(@"%d", ccStatus);
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    free(bufferPtr);
    return result;
}

+ (NSDictionary *)encryptionWithDictionary:(NSDictionary *) dict {
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *newMuDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        if (muDict[@"a"]) {
            newMuDict[@"a"] = muDict[@"a"];
            [muDict removeObjectForKey:@"a"];
        }
        if (muDict[@"m"]) {
            newMuDict[@"m"] = muDict[@"m"];
            [muDict removeObjectForKey:@"m"];
        }
        if (muDict[@"v"]) {
            newMuDict[@"v"] = muDict[@"v"];
            [muDict removeObjectForKey:@"v"];
        }
        else {
            newMuDict[@"v"] = @"v1";
        }
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:muDict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *encodeString = [Encryption tripleDES:jsonString encryptOrDecrypt:kCCEncrypt];
        newMuDict[@"inputparam"] = encodeString;
        return newMuDict;
    }
    return nil;
}


@end
