//
//  LMAFDownLoad.h
//  Love_SignLanguage
//
//  Created by Lim on 14/12/5.
//  Copyright (c) 2014年 Lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface LMAFDownLoad : NSObject

@property(nonatomic , strong) NSURL* url;
@property(nonatomic , copy) NSString* (^cachePath)(void);
@property(nonatomic , strong) AFHTTPRequestOperation* requestOperation;
@property(nonatomic , copy) void(^progressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead,NSDictionary *VedioImfor);

-(void)downloadWithUrl:(id)url
              imforDic:(NSDictionary *)vedioImfor
             cachePath:(NSString* (^) (void))cacheBlock
         progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead,NSDictionary *VedioImfor))progressBlock
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark----外部接口
+(instancetype)shareInstance;
/**
 * 恢复
 */
+ (void)resume;
/**
 * 暂停
 */
+ (void)pasuse;

@end
