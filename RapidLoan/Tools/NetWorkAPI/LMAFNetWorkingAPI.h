//
//  LMAFNetWorkingAPI.h
//  SignLanguage
//  Created by Lim on 14/11/26.
//  Copyright (c) 2014年 Lim. All rights reserved.

//测试地址
#define SERVERQUEST @"http://loan.nnq9.com/index.php/"
#define IMAGEUPLOADQUEST @"http://loan.nnq9.com/index.php"


#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CompleteType)
{
    CompleteType_Normal=0,//正常
    CompleteType_History,//历史
    CompleteType_Fail,//失败
};
/**
 * 网络请求回调
 */
typedef void(^AFNetWorkComplete)(id dataSource,enum CompleteType CompleteType,NSError * error);
/**
 * 下载文件 成功
 */
typedef void(^AFDownLoadComplete)(NSString *filepath,NSError * error);

/**
 * 下载文件 进度
 */
typedef void(^AFDownLoadProgress)(int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
@interface LMAFNetWorkingAPI : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData *recievedData;
    AFNetWorkComplete postBlock;
}
@property(nonatomic,assign) NSInteger timeoutInterval;
+(instancetype)shareInstance;
/**
 * 网络请求GET方法 delegate
 */
+(NSOperation *)AFNet_GETRequestWithDelegate:(NSDictionary *)params
                delegate:(id)delegates cache:(BOOL)isCache HUD:(BOOL)shows;
/**
 * 网络请求GET方法 block
 */
+(NSOperation *)AFNet_GETRequestWithBlock:(NSDictionary *)params WithMethod:(NSString *)method complete:(AFNetWorkComplete)completeBlock
                                    cache:(BOOL)isCache HUD:(BOOL)shows;
/**
 * 网络请求POST方法 block
 */
+(NSOperation *)AFNet_POSTRequestWithBlock:(NSDictionary *)params WithMethod:(NSString *)method Json:(id)JsonStr
                                  complete:(AFNetWorkComplete)completeBlock
                                     cache:(BOOL)isCache HUD:(BOOL)shows;
/**
 * SOAP请求
 */
+(NSOperation *)AFNet_SOAPRequestWithBlock:(NSDictionary *)params
                                 appendUrl:(NSString *)appendUrl
                                  complete:(AFNetWorkComplete)completeBlock
                                     cache:(BOOL)isCache
                                       HUD:(BOOL)shows;
/**
 * 网络请求POST方法 delegate
 */
+(NSOperation *)AFNet_POSTRequestWithDelegate:(NSDictionary *)params
                delegate:(id)delegates cache:(BOOL)isCache HUD:(BOOL)shows;

+(NSOperation *)AFNet_IMAGERequestWithBlock:(NSDictionary *)params
                ImageObjc:(id)Imageobjc complete:(AFNetWorkComplete)completeBlock
                cache:(BOOL)isCache HUD:(BOOL)shows;
#pragma mark---上传视频
+(void)AFNetWorkImageParams:(NSMutableDictionary *)dict video:(NSData *)data WithMethod:(NSString *)method complete:(AFNetWorkComplete)completeBlock HUD:(BOOL)shows;
#pragma mark---上传图片和图片数组
+(void)AFNetWorkImageParams:(NSMutableDictionary *)dict images:(id)imageObjc WithMethod:(NSString *)method complete:(AFNetWorkComplete)completeBlock HUD:(BOOL)shows;
/**
 *post请求*
 */
-(void)AFNetWorkPostParams:(NSMutableDictionary *)params appendUrl:(NSString *)appendUrl  strFile:(NSString *)strFile complete:(AFNetWorkComplete)completeBlock HUD:(BOOL)shows;
/**
 * 下载文件
 */
+(NSURLSessionDownloadTask *)AFNet_DownLoadFile:(NSString *)URLstring
                          complete:(AFDownLoadComplete)completeBlock progress:(AFDownLoadProgress)progressBlock;
/**
 * 上传文件
 */
+(void)AFNet_DownLoadFile:(NSString *)url
                 fileData:(NSData *)data
                 complete:(AFNetWorkComplete)completeBlock
                 progress:(AFDownLoadProgress)progressBlock;
/**
 * 网络请求关闭
 */
+ (void)cancelOperation:(NSOperation *) operation;
+ (void)cancelAll;

/**
 * 网络请求代理回调
 */
-(void)CallBackWithFinish:(id )result dataType:(CompleteType)dataType;

+(NSOperation *)AFNet_BlackDoorRequestWithBlock:(NSDictionary *)params  complete:(AFNetWorkComplete)completeBlock;
#pragma mark----3DES加密
+ (NSString*)tripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt;
#pragma mark----获取URL
+ (NSString *)URLStringWithParams:(NSDictionary *)params;
+ (NSString *)URLStringWithParams:(NSDictionary *)params andBaseURLString:(NSString *)baseURLString;
@end
