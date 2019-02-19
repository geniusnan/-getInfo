//
//  AFNetWorkingAPI.m
//  SignLanguage
//
//  Created by Lim on 14/11/26.
//  Copyright (c) 2014年 Lim. All rights reserved.
//
#define DESKEY @"sudaiscow2016siese.jiuhyHYU.Ui@yy10@.COM.20188"
#import "LMAFNetWorkingAPI.h"
#import "GTMBase64.h"
@implementation LMAFNetWorkingAPI
static NSDictionary *methods = nil;
static NSMutableArray *runningOperations = nil;
static BOOL        HUDshows=NO;
static NSMutableSet *DelegatesSet=nil;
static AFHTTPRequestOperationManager *shareClient=nil;
+(instancetype)shareInstance
{
    static LMAFNetWorkingAPI *api=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api=[[LMAFNetWorkingAPI alloc]init];
    });
    return api;
}
+(void)initialize
{
    if (self == [LMAFNetWorkingAPI class]) {
        [LMAFNetWorkingAPI shareInstance].timeoutInterval=0;
        shareClient=[[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
       shareClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [shareClient.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        methods = @{@"GET": @"GET",
                    @"PUT": @"PUT",
                    @"POST": @"POST",
                    @"HEAD": @"HEAD",
                    @"DELETE": @"DELETE",
                    @"OPTIONS": @"OPTIONS"};
        DelegatesSet=[NSMutableSet new];
        runningOperations = [NSMutableArray array];
        HUDshows=NO;
    }
}
/**
 *添加代理
 */
-(void)AddDelegate:(id)delegates HUD:(BOOL)show
{
    [DelegatesSet addObject:delegates];
    
    HUDshows=show;
    if(HUDshows)
    {
        
        [SVProgressHUD showWithStatus:@"   请稍后...   " maskType:SVProgressHUDMaskTypeBlack];
    }
}
#pragma mark-----网络请求-------
/**
 *锁
 */
+(void)Locking:(NSOperation*)operation
{
    //加锁
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [shareClient.operationQueue addOperation:operation];
    //解锁
    dispatch_semaphore_signal(semaphore);
    
}
#pragma mark----外部接口-----
/**
 * 网络请求GET方法 block
 */
+(NSOperation *)AFNet_GETRequestWithBlock:(NSDictionary *)params WithMethod:(NSString *)method complete:(AFNetWorkComplete)completeBlock
                                    cache:(BOOL)isCache HUD:(BOOL)shows
{
    HUDshows=shows;
    if(HUDshows)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"   请稍后...   ",nil)];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    }else
    {
        ShowNetworkActivityIndicator();

    }
    

    
    if ([LMAFNetWorkingAPI shareInstance].timeoutInterval != 0) {
        shareClient.requestSerializer.timeoutInterval = [LMAFNetWorkingAPI shareInstance].timeoutInterval;
    }
    
    params=[LMAFNetWorkingAPI encryptionWithDictionary:params];
    
    NSOperation *operation = [shareClient GET:[NSString stringWithFormat:@"%@%@", SERVERQUEST,method] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HideNetworkActivityIndicator();
        @synchronized (runningOperations)
        {
            [runningOperations removeObject:operation];
        }
        if(completeBlock)
        {
            completeBlock(responseObject,CompleteType_Normal,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"请求异常,请检查网络设置"];
        completeBlock(nil,CompleteType_Fail,nil);

        @synchronized (runningOperations)
        {
            [runningOperations removeObject:operation];
        }
    }];
    @synchronized (runningOperations)
    {
        [runningOperations addObject:operation];
    }
    //    [AFNetWorkingAPI Locking:operation];
    
    return operation;
    
}
/**
 * 网络请求GET方法 delegate
 */
+(NSOperation *)AFNet_GETRequestWithDelegate:(NSDictionary *)params
                                    delegate:(id)delegates cache:(BOOL)isCache HUD:(BOOL)shows
{
    [[LMAFNetWorkingAPI shareInstance] AddDelegate:delegates HUD:shows];
    
    NSMutableURLRequest *request = [shareClient.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:SERVERQUEST relativeToURL:shareClient.baseURL] absoluteString] parameters:params error:nil];
    NSLog(@"the request URL is\n....URL:%@",[request.URL absoluteString]);
    /**
     * 缓存数据
     */
    if(isCache)
    {
     NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse != nil &&
        [[cachedResponse data] length] > 0)
    {
        id result = [NSJSONSerialization JSONObjectWithData:[cachedResponse data] options:NSJSONReadingAllowFragments error:nil];
        [[LMAFNetWorkingAPI shareInstance] CallBackWithFinish:result dataType:CompleteType_History];
    }

    }
    
    AFHTTPRequestOperation *operation = [shareClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"the responseObjectis%@",responseObject);
        [[LMAFNetWorkingAPI shareInstance] CallBackWithFinish:responseObject dataType:CompleteType_Normal];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@
        "The request timed out."])
        {
            NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
            if (cachedResponse != nil &&
                [[cachedResponse data] length] > 0)
            {
                id result = [NSJSONSerialization JSONObjectWithData:[cachedResponse data] options:NSJSONReadingAllowFragments error:nil];
                
                [[LMAFNetWorkingAPI shareInstance] CallBackWithFinish:result dataType:CompleteType_History];
            }
            else {
                SVProgressWithImfor(@"网络连接失败");
            }
            return ;
        }
        [[LMAFNetWorkingAPI shareInstance] CallBackWithFinish:nil dataType:CompleteType_Fail];
    }];
    [shareClient.operationQueue addOperation:operation];
    return operation;
    
}
/**
 * SOAP请求
 */
+(NSOperation *)AFNet_SOAPRequestWithBlock:(NSDictionary *)params
                                 appendUrl:(NSString *)appendUrl
                                  complete:(AFNetWorkComplete)completeBlock
                                     cache:(BOOL)isCache
                                       HUD:(BOOL)shows
{
//    @"http://www.virtualdemos.com.ar/RPSistemas/InformeDiario/WsInformeDiario/Services.asmx?op=GetEmpresasJson"
    NSURL *baseURL = [NSURL URLWithString:HMSTR(@"%@?op=%@",SERVERQUEST,appendUrl)];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetEmpresasJson xmlns=\"http://tempuri.org/\"><empresaRequestJson>%@</empresaRequestJson></GetEmpresasJson></soap:Body></soap:Envelope>", @"0035" ];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request addValue:SERVERQUEST forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //如果后台返回的数据不是JSON
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", string);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
    }];
    
    [operation start];
    
    return operation;
}
/**
 * 网络请求POST方法 block回调
 */
+(NSOperation *)AFNet_POSTRequestWithBlock:(NSDictionary *)params WithMethod:(NSString *)method Json:(id)JsonStr
                                  complete:(AFNetWorkComplete)completeBlock
                                     cache:(BOOL)isCache HUD:(BOOL)shows
{
    HUDshows=shows;
    
    if ([LMAFNetWorkingAPI shareInstance].timeoutInterval != 0) {
        shareClient.requestSerializer.timeoutInterval = [LMAFNetWorkingAPI shareInstance].timeoutInterval;
    }
    HUDshows=shows;
    if(HUDshows)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"   请稍后...   ",nil) maskType:SVProgressHUDMaskTypeBlack];
        
    }
    
    AFHTTPRequestOperation *Operation = nil;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSArray *keyArray = [params allKeys];
    NSString *urlString=@"?";
    for(NSString *key in keyArray)
    {
        id value = [params objectForKey:key];
        urlString=[NSString stringWithFormat:@"%@%@=%@&",urlString,key,value];
    }
    urlString=[urlString substringToIndex:urlString.length-1];
    NSString *strsUrl=[NSString stringWithFormat:@"%@%@%@",SERVERQUEST,method,urlString];
    
    strsUrl= [strsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
   NSString *base64Str=[[JsonStr dataUsingEncoding:NSUTF8StringEncoding]  base64Encoding];
    
    Operation =[shareClient POST:strsUrl parameters:@{params[@"arrayName"]:base64Str} constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        
        
    }  success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"Success: %@", responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock)
            {
             @synchronized (runningOperations)
             {
                 [runningOperations removeObject:Operation];
             }
             HideNetworkActivityIndicator();
             if(completeBlock)
             {
                 completeBlock(responseObject,CompleteType_Normal,nil);
             }
            }
        });
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (completeBlock) {
                          completeBlock(nil,CompleteType_Fail,error);
                      }
                  });
              }];
    [Operation start];
    
    return Operation;


    
}
/**
 * 网络请求POST方法 delegate回调
 */
+(NSOperation *)AFNet_POSTRequestWithDelegate:(NSDictionary *)params
                                     delegate:(id)delegates
                                        cache:(BOOL)isCache
                                          HUD:(BOOL)shows
{
    
    [[LMAFNetWorkingAPI shareInstance] AddDelegate:delegates HUD:shows];
    if ([LMAFNetWorkingAPI shareInstance].timeoutInterval != 0) {
        shareClient.requestSerializer.timeoutInterval = [LMAFNetWorkingAPI shareInstance].timeoutInterval;
    }
    
    HUDshows=shows;
    if(HUDshows)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"   请稍后...   ",nil) maskType:SVProgressHUDMaskTypeBlack];

    }
    NSOperation *operation= [shareClient POST:SERVERQUEST parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        @synchronized (runningOperations) {
            [runningOperations removeObject:operation];
        }
        [[LMAFNetWorkingAPI shareInstance] CallBackWithFinish:responseObject dataType:CompleteType_Normal];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        @synchronized (runningOperations) {
            [runningOperations removeObject:operation];
        }
        [[LMAFNetWorkingAPI shareInstance] CallBackWithFinish:nil dataType:CompleteType_Fail];
        
    }];
    @synchronized (runningOperations) {
        [runningOperations addObject:operation];
    }
//    [LMAFNetWorkingAPI Locking:operation];
    return operation;
    
}
/**
 * 网络请求POST图片方法 block回调 cocoa error 3840
 */
+(NSOperation *)AFNet_IMAGERequestWithBlock:(NSDictionary *)params
                                  ImageObjc:(id)Imageobjc complete:(AFNetWorkComplete)completeBlock
                                      cache:(BOOL)isCache HUD:(BOOL)shows
{
    if ([LMAFNetWorkingAPI shareInstance].timeoutInterval != 0) {
        shareClient.requestSerializer.timeoutInterval = [LMAFNetWorkingAPI shareInstance].timeoutInterval;
    }
    params=[LMAFNetWorkingAPI encryptionWithDictionary:params];

    NSOperation *operation =[shareClient POST:IMAGEUPLOADQUEST parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data;
        if([Imageobjc isKindOfClass:[UIImage class]])
        {
            data = UIImageJPEGRepresentation(Imageobjc, 1.0);
            [formData appendPartWithFileData:data name:@"image" fileName:@"s.jpg" mimeType:@"image/jpg"];
        }else
            if([Imageobjc isKindOfClass:[NSArray class]])//数组
            {
                for (int i=0; i<[Imageobjc count]; i++) {
                    NSData *imageData;
                    UIImage *image=[Imageobjc objectAtIndex:i];
                    imageData = UIImageJPEGRepresentation(image, 1);
                    NSInteger ImageSize=imageData.length/1024;
                    if(ImageSize>1024)
                    {
                        imageData = UIImageJPEGRepresentation(image, 0.5);
                    }
                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image%d",i+1] fileName:@"s.jpg" mimeType:@"image/jpg"];
                    
                    
                }
            }
    }  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSLog(@"Success: %@", responseObject);
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if (completeBlock) {
                                                  NSMutableDictionary *dataResponse =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                                  completeBlock(dataResponse,CompleteType_Normal,nil);
                                              }
                                          });
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"Error: %@", error);
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if (completeBlock) {
                                                  completeBlock(nil,CompleteType_Fail,error);
                                              }
                                          });
                                      }];
    
    return operation;
}

#pragma mark---上传视频
+(void)AFNetWorkImageParams:(NSMutableDictionary *)dict video:(NSData *)data WithMethod:(NSString *)method complete:(AFNetWorkComplete)completeBlock HUD:(BOOL)shows{
    if ([LMAFNetWorkingAPI shareInstance].timeoutInterval != 0) {
        shareClient.requestSerializer.timeoutInterval = [LMAFNetWorkingAPI shareInstance].timeoutInterval;
    }
        HUDshows=shows;
    if(HUDshows)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"   请稍后...   ",nil) maskType:SVProgressHUDMaskTypeBlack];
        
    }
    
    
    NSArray *keyArray = [dict allKeys];
    NSString *urlString=@"?";
    for(NSString *key in keyArray)
    {
        id value = [dict objectForKey:key];
        urlString=[NSString stringWithFormat:@"%@%@=%@&",urlString,key,value];
    }
    urlString=[urlString substringToIndex:urlString.length-1];
    NSString *strsUrl=[NSString stringWithFormat:@"%@%@%@",SERVERQUEST,method,urlString];
    DLog(@"%@",strsUrl);
    strsUrl= [strsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[shareClient.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:strsUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

            NSInteger ImageSize=data.length/1024;
//            if(ImageSize>1024*5)
//            {
//                data = UIImageJPEGRepresentation(imageObjc, 0.3);
//            }
            [formData appendPartWithFileData:data name:@"image" fileName:@"video.mp4" mimeType:@"video/mp4"];
        }
        
     error:nil];
    
    AFHTTPRequestOperation *Operation = nil;
    Operation= [shareClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @synchronized (runningOperations) {
            [runningOperations removeObject:Operation];
        }
        HideNetworkActivityIndicator();
        if(completeBlock)
        {
            completeBlock(responseObject,CompleteType_Normal,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                {
                    [SVProgressHUD dismiss];
                    
                    @synchronized (runningOperations)
                    {
                        [runningOperations removeObject:Operation];
                    }
                    if (completeBlock)
                    {
                        completeBlock(nil,CompleteType_Fail,error);
                    }
                    
                }];
    [Operation start];
}

#pragma mark---上传图片和图片数组
+(void)AFNetWorkImageParams:(NSMutableDictionary *)dict images:(id)imageObjc WithMethod:(NSString *)method complete:(AFNetWorkComplete)completeBlock HUD:(BOOL)shows
{
    
    if ([LMAFNetWorkingAPI shareInstance].timeoutInterval != 0) {
        shareClient.requestSerializer.timeoutInterval = [LMAFNetWorkingAPI shareInstance].timeoutInterval;
    }

   
    HUDshows=shows;
    if(HUDshows)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"   请稍后...   ",nil) maskType:SVProgressHUDMaskTypeBlack];

    }
    
    NSArray *keyArray = [dict allKeys];
    NSString *urlString=@"?";
    for(NSString *key in keyArray)
    {
        id value = [dict objectForKey:key];
        urlString=[NSString stringWithFormat:@"%@%@=%@&",urlString,key,value];
    }
    urlString=[urlString substringToIndex:urlString.length-1];
    NSString *strsUrl=[NSString stringWithFormat:@"%@%@%@",SERVERQUEST,method,urlString];
    DLog(@"%@",strsUrl);
    strsUrl= [strsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
   NSMutableURLRequest *request=[shareClient.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:strsUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(imageObjc && [imageObjc isKindOfClass:[UIImage class] ])
            {
                NSData *imageData;
                imageData = UIImageJPEGRepresentation(imageObjc, 1);
                NSInteger ImageSize=imageData.length/1024;
                if(ImageSize>1024)
                {
                    imageData = UIImageJPEGRepresentation(imageObjc, 0.3);
                }
                [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
            }
            else if([imageObjc isKindOfClass:[NSArray class]])//图片数组
            {
           for (int i=0; i<[imageObjc count]; i++)
           {
               NSData *imageData;
               UIImage *image=[imageObjc objectAtIndex:i];
               if([image  isKindOfClass:[UIImage class] ])
               {
                   imageData = UIImageJPEGRepresentation(image, 1);
                   NSInteger ImageSize=imageData.length/1024;
                   if(ImageSize>1024)
                   {
                       imageData = UIImageJPEGRepresentation(image, 0.5);
                   }
                   [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image%d",i] fileName:@"image.jpg" mimeType:@"image/jpg"];
               }
           }
       }
    } error:nil];
    
    AFHTTPRequestOperation *Operation = nil;
    Operation= [shareClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {        
        @synchronized (runningOperations) {
            [runningOperations removeObject:Operation];
        }
        HideNetworkActivityIndicator();
        if(completeBlock)
        {
            completeBlock(responseObject,CompleteType_Normal,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD dismiss];
        
        @synchronized (runningOperations)
        {
            [runningOperations removeObject:Operation];
        }
        if (completeBlock)
        {
            completeBlock(nil,CompleteType_Fail,error);
        }
 
    }];
    [Operation start];
}
-(void)AFNetWorkPostParams:(NSMutableDictionary *)params appendUrl:(NSString *)appendUrl  strFile:(NSString *)strFile complete:(AFNetWorkComplete)completeBlock HUD:(BOOL)shows
{
    if(HUDshows)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"   请稍后...   ",nil) maskType:SVProgressHUDMaskTypeBlack];
        
    }
    postBlock=completeBlock;
    if([strFile length]>0)
    {
    NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                         (CFStringRef)strFile,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
    [params setValue:baseString forKey:@"strFile"];
    }else
    {
        [params setValue:@"" forKey:@"strFile"];
    }
    NSURL *url=[NSURL URLWithString:HMSTR(@"%@/%@?",SERVERQUEST,appendUrl)];
    NSArray *keyArray = [params allKeys];
    NSString *urlString=@"";
    for(NSString *key in keyArray){
        id value = [params objectForKey:key];
        urlString=[NSString stringWithFormat:@"%@%@=%@&",urlString,key,value];
    }
    urlString=[urlString substringToIndex:urlString.length-1];
    
    [self createUrlConnectionForPost:url post:urlString];
}

-(void)createUrlConnectionForPost:(NSURL *)url post:(NSString *)post
{
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
//UTF-8
//    NSData *data=[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//GB2312
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data=[post dataUsingEncoding:enc];
    
    [request setHTTPBody:data];
    
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [urlConnection start];
    if (urlConnection)
    {
        recievedData=[NSMutableData new];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [recievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [SVProgressHUD dismiss];
    NSString * jsonStr = [[NSString alloc] initWithData:recievedData encoding:NSUTF8StringEncoding];
    
    NSRange headRange = [jsonStr rangeOfString:@"string xmlns="];
    if (headRange.location != NSNotFound)
    {
        jsonStr = [jsonStr substringFromIndex:80];
    }
    NSRange range = [jsonStr rangeOfString:@"</string>"];
    if (range.location != NSNotFound)
    {
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"</string>" withString:@""];
    }
    NSDictionary *resultDic=[CommonFunc Fromjsonstring:jsonStr];
    if (postBlock) {
        postBlock(resultDic,CompleteType_Normal,nil);
    }
    NSLog(@"the reuslut DIC is%@",resultDic );
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*) error {
    //    DebugLog(@"didFailWithError:%@",error);
}

#pragma mark-----关闭-------
/**
 * 网络请求关闭
 */
+ (void)cancelOperation:(NSOperation *) operation
{
    if (operation) {
        [operation cancel];
    }
}
+ (void)cancelAll
{
    @synchronized (runningOperations) {
        [runningOperations makeObjectsPerformSelector:@selector(cancel)];
        [runningOperations removeAllObjects];
    }
}

#pragma mark-----代理回调-------
/**
 * 网络请求代理回调
 */
-(void)CallBackWithFinish:(id )result dataType:(CompleteType)dataType
{
//    if([SVProgressHUD sharedView].fadeOutTimer==nil)
//    {
//     [SVProgressHUD dismiss];
//    }
    __block BOOL NetWorkConnects=YES;
        [shareClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    break;

                case AFNetworkReachabilityStatusReachableViaWiFi:

                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    NetWorkConnects=NO;
                }
                break;
                    default:
                    break;
                    
            }
        }];
    
    SEL seltor = NSSelectorFromString(@"finishWithData:dataType:");
    NSSet * set = [[NSSet alloc] initWithSet:DelegatesSet];
    for (id del in set) {
        if ([del respondsToSelector:seltor])   {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [del performSelector:seltor withObject:result withObject:@(dataType)];
#pragma clang diagnostic pop
        }
    }
}
/**
 * 网络请求代理回调
 */
-(void)CallBackFail:(id )result dataType:(CompleteType)dataType
{
//    if([SVProgressHUD sharedView].fadeOutTimer==nil)
//    {
//        [SVProgressHUD dismiss];
//    }
    SEL seltor = NSSelectorFromString(@"finishWithData:dataType:");
    NSSet * set = [[NSSet alloc] initWithSet:DelegatesSet];
    for (id del in set) {
        if ([del respondsToSelector:seltor])   {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [del performSelector:seltor withObject:result withObject:@(dataType)];
#pragma clang diagnostic pop
        }
    }
      NSLog(@"the fail Result is\n.....dataSource:%@",result);
}

/**
 * 下载文件
 */
+(NSURLSessionDownloadTask *)AFNet_DownLoadFile:(NSString *)    URLstring   complete:(AFDownLoadComplete)completeBlock
                                       progress:(AFDownLoadProgress)progressBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if ([LMAFNetWorkingAPI shareInstance].timeoutInterval != 0) {
        configuration.timeoutIntervalForRequest = [LMAFNetWorkingAPI shareInstance].timeoutInterval;
    }
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //@"https://github.com/AFNetworking/AFNetworking/archive/master.zip"
    NSURL *URL = [NSURL URLWithString:URLstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask =
    [sessionManager downloadTaskWithRequest:request
                                   progress:nil
                                destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                }
                          completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (completeBlock) {
                                      NSString *file = [NSString stringWithFormat:@"%@",filePath];
                                      file = [file stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                                      file = [file stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
                                      completeBlock(file,error);
                                      [SVProgressHUD dismiss];
                                  }
                              });
                              
                              
                          }];
    
    //记录进度
//    UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    [progress setProgressWithDownloadProgressOfTask:downloadTask animated:YES];
    
    [sessionManager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        if(progressBlock)
        {
            progressBlock(totalBytesWritten,totalBytesExpectedToWrite);
        }
        NSLog(@"totalBytesWritten = %lld  totalBytesExpectedToWrite = %lld", totalBytesWritten,totalBytesExpectedToWrite);
    }];
    
    [downloadTask resume];
    
    return downloadTask;
}
/**
 * 上传 文件
 */
+(void)AFNet_DownLoadFile:(NSString *)url
            fileData:(NSData *)data
                 complete:(AFNetWorkComplete)completeBlock
                 progress:(AFDownLoadProgress)progressBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if ([LMAFNetWorkingAPI shareInstance].timeoutInterval != 0) {
        configuration.timeoutIntervalForRequest = [LMAFNetWorkingAPI shareInstance].timeoutInterval;
    }
    AFURLSessionManager* sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionUploadTask *uploadTask = [sessionManager uploadTaskWithRequest:request
                                                                      fromData:data
                                                                      progress:nil
                                                             completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                 if (error) {
                                                                     NSLog(@"Error: %@", error);
                                                                 } else {
                                                                     NSLog(@"Success: %@ %@", response, responseObject);
                                                                 }
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     NSMutableDictionary *dataResponse =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                                                                     completeBlock(dataResponse,CompleteType_Normal,nil);
                                                                 });
                                                             }];
    

    //记录进度
//    UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    [progress setProgressWithUploadProgressOfTask:uploadTask animated:YES];

    [uploadTask resume];
}

/************************************/
+(NSOperation *)AFNet_BlackDoorRequestWithBlock:(NSDictionary *)params  complete:(AFNetWorkComplete)completeBlock

{
    if ([LMAFNetWorkingAPI shareInstance].timeoutInterval != 0) {
        shareClient.requestSerializer.timeoutInterval = [LMAFNetWorkingAPI shareInstance].timeoutInterval;
    }
    NSOperation *operation = [shareClient GET:@"http://114.215.140.174/ios/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic;
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            resultDic=[responseObject copy];
        }
        else
        {
            NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonStr);
            resultDic=[CommonFunc Fromjsonstring:jsonStr];
        }
        @synchronized (runningOperations) {
            [runningOperations removeObject:operation];
        }
        if(completeBlock)
        {
            completeBlock(resultDic,CompleteType_Normal,nil);
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @synchronized (runningOperations) {
            [runningOperations removeObject:operation];
        }
        if(completeBlock)
        {
            completeBlock(nil,CompleteType_Fail,error);
        }
    }];
    @synchronized (runningOperations) {
        [runningOperations addObject:operation];
    }
    //    [AFNetWorkingAPI Locking:operation];
    
    return operation;
    
}
#pragma mark----3DES加密
+ (NSString*)tripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        return [AA3DESManager getDecryptWithString:plainText keyString:DESKEY ivString:nil];

    }
    else //加密
    {
        return  [AA3DESManager getEncryptWithString:plainText keyString:DESKEY ivString:nil];
    }
}
+ (NSDictionary *)encryptionWithDictionary:(NSDictionary *) dict
{
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        
        NSMutableDictionary *newMuDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        if ([CommonFunc StringisEmpty:getDeviceToken])
        {
            setDeviceToken([CommonFunc getDeveiceUUID]);
        }
        [newMuDict setObject:getDeviceToken forKey:@"devicetoken"];
        [newMuDict setObject:@"3" forKey:@"from"];
        [newMuDict setObject:@"0" forKey:@"channel"];
        [muDict setObject:getLoginSecret forKey:@"sn"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:muDict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *encodeString = [LMAFNetWorkingAPI tripleDES:jsonString encryptOrDecrypt:kCCEncrypt];
        newMuDict[@"inputparam"] = encodeString;
        /**
         *接口通用部分 不加密
         */

        return newMuDict;
    }
    return nil;
}
+ (NSString *)URLStringWithParams:(NSDictionary *)params andBaseURLString:(NSString *)baseURLString {
    //分享的链接 为了防止过长 去除tokenDeveice
    NSMutableDictionary *newMuDict = [NSMutableDictionary dictionary];
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *encodeString = [LMAFNetWorkingAPI tripleDES:jsonString encryptOrDecrypt:kCCEncrypt];
    newMuDict[@"inputparam"] = encodeString;
    NSMutableURLRequest *request = [shareClient.requestSerializer requestWithMethod:@"HEAD" URLString:[[NSURL URLWithString:baseURLString relativeToURL:nil] absoluteString] parameters:newMuDict error:nil];
    return request.URL.absoluteString;
}

+ (NSString *)URLStringWithParams:(NSDictionary *)params {
    
 
    NSString *encodeString=[LMAFNetWorkingAPI URLStringWithParams:params andBaseURLString:SERVERQUEST];
    return encodeString;
}

@end
