//
//  LMAFDownLoad.m
//  Love_SignLanguage
//
//  Created by Lim on 14/12/5.
//  Copyright (c) 2014年 Lim. All rights reserved.
//

#import "LMAFDownLoad.h"
@implementation LMAFDownLoad
static NSMutableArray *runningOperations = nil;
+(instancetype)shareInstance
{
    static LMAFDownLoad *api=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api=[[LMAFDownLoad alloc]init];
        runningOperations = [NSMutableArray array];
    });
    return api;
}
-(void)downloadWithUrl:(id)url
              imforDic:(NSDictionary *)vedioImfor
             cachePath:(NSString* (^) (void))cacheBlock
         progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead,NSDictionary *VedioImfor))progressBlock
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    self.cachePath = cacheBlock;
    //获取缓存的长度
    long long cacheLength = [[self class] cacheFileWithPath:self.cachePath()];
    
    NSLog(@"cacheLength = %llu",cacheLength);
    
    //获取请求
    NSMutableURLRequest* request = [[self class] requestWithUrl:url Range:cacheLength];
    
    self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [self.requestOperation setOutputStream:[NSOutputStream outputStreamToFileAtPath:self.cachePath() append:NO]];
    
    //处理流
    [self readCacheToOutStreamWithPath:self.cachePath()];
    
    //监听暂停
//    [self.requestOperation addObserver:self forKeyPath:@"isPaused" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //获取进度块
    self.progressBlock = progressBlock;
    
    
    //重组进度block
    [self.requestOperation setDownloadProgressBlock:[self getNewProgressBlockWithCacheLength:cacheLength ImforDic:vedioImfor]];
    
    //获取成功回调块
    void (^newSuccess)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseHead = %@",[operation.response allHeaderFields]);
        
        success(operation,responseObject);
        @synchronized (runningOperations) {
            [runningOperations removeObject:operation];
        }
    };
    
    
    [self.requestOperation setCompletionBlockWithSuccess:newSuccess
                                                 failure:failure];
    [self.requestOperation start];
    
    @synchronized (runningOperations) {
        [runningOperations addObject:self.requestOperation];
    }
}


#pragma mark - 获取本地缓存的字节
+(long long)cacheFileWithPath:(NSString*)path
{
    NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSData* contentData = [fh readDataToEndOfFile];
    return contentData ? contentData.length : 0;
    
}


#pragma mark - 重组进度块
-(void(^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))getNewProgressBlockWithCacheLength:(long long)cachLength ImforDic:(NSDictionary *)VedioImfor
{
    typeof(self)newSelf = self;
    void(^newProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
    {
        NSData* data = [NSData dataWithContentsOfFile:self.cachePath()];
        [self.requestOperation setValue:data forKey:@"responseData"];
        newSelf.progressBlock(bytesRead,totalBytesRead + cachLength,totalBytesExpectedToRead + cachLength,VedioImfor);
    };
    
    return newProgressBlock;
}


#pragma mark - 读取本地缓存入流
-(void)readCacheToOutStreamWithPath:(NSString*)path
{
    NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData* currentData = [fh readDataToEndOfFile];
    
    if (currentData.length) {
        //打开流，写入data ， 未打卡查看 streamCode = NSStreamStatusNotOpen
        [self.requestOperation.outputStream open];
        
        NSInteger       bytesWritten;
        NSInteger       bytesWrittenSoFar;
        
        NSInteger  dataLength = [currentData length];
        const uint8_t * dataBytes  = [currentData bytes];
        
        bytesWrittenSoFar = 0;
        do {
            bytesWritten = [self.requestOperation.outputStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
            assert(bytesWritten != 0);
            if (bytesWritten == -1) {
                break;
            } else {
                bytesWrittenSoFar += bytesWritten;
            }
        } while (bytesWrittenSoFar != dataLength);
        
        
    }
}

#pragma mark - 获取请求

+(NSMutableURLRequest*)requestWithUrl:(id)url Range:(long long)length
{
    NSURL* requestUrl = [url isKindOfClass:[NSURL class]] ? url : [NSURL URLWithString:url];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:5*60];
    
    
    if (length) {
        [request setValue:[NSString stringWithFormat:@"bytes=%lld-",length] forHTTPHeaderField:@"Range"];
    }
    
    NSLog(@"request.head = %@",request.allHTTPHeaderFields);
    
    return request;
    
}



#pragma mark - 监听暂停
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keypath = %@ changeDic = %@",keyPath,change);
    //暂停状态
    if ([keyPath isEqualToString:@"isPaused"] && [[change objectForKey:@"new"] intValue] == 1) {
        long long cacheLength = [[self class] cacheFileWithPath:self.cachePath()];
        //暂停读取data 从文件中获取到NSNumber
        cacheLength = [[self.requestOperation.outputStream propertyForKey:NSStreamFileCurrentOffsetKey] unsignedLongLongValue];
        NSLog(@"cacheLength = %lld",cacheLength);
        [self.requestOperation setValue:@"0" forKey:@"totalBytesRead"];
        //重组进度block
//        [self.requestOperation setDownloadProgressBlock:[self getNewProgressBlockWithCacheLength:cacheLength]];
    }
}

#pragma mark----外部接口
/**
 * 恢复
 */
+ (void)resume
{
    [[LMAFDownLoad shareInstance].requestOperation resume];
    
}
/**
 * 暂停
 */
+ (void)pasuse
{
    [[LMAFDownLoad shareInstance].requestOperation pause];
    
}

/**
 * 使用方法
 */
/*
[operation downloadWithUrl:URL
                 cachePath:^NSString *{
                     [self.imageView setImage:[UIImage imageWithContentsOfFile:path]];
                     return path;
                 } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                     NSLog(@"bytesRead = %lu ,totalBytesRead = %llu totalBytesExpectedToRead = %llu",(unsigned long)bytesRead,totalBytesRead,totalBytesExpectedToRead);
                     float progress = totalBytesRead / (float)totalBytesExpectedToRead;
                     
                     [self.progressView setProgress:progress animated:YES];
                     
                     [self.label setText:[NSString stringWithFormat:@"%.2f%%",progress*100]];
                     UIImage* image = [UIImage imageWithData:operation.requestOperation.responseData];
                     [self.imageView setImage:image];
                     
                 } success:^(AFHTTPRequestOperation *operations, id responseObject) {
                     
                     NSLog(@"success");
                     UIImage* image = [UIImage imageWithData:(NSData *)operations.responseData];
                     [self.imageView setImage:image];
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"error = %@",error);
                 }];
 */
@end
