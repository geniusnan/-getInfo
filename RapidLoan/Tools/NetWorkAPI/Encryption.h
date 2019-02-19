//
//  Encryption.h
//  SignLanguage
//
//  Created by Lim on 14/11/26.
//  Copyright (c) 2014年 Lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCryptor.h>
@interface Encryption : NSObject
/**
 *3des加解密
 */
+ (NSString*)tripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt;
/**
 *外部接口
 */
+ (NSDictionary *)encryptionWithDictionary:(NSDictionary *) dict;
@end
