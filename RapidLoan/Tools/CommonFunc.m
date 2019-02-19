//
//  CommonFunc.m
//  PRJ_base64
//
//  Created by wangzhipeng on 12-11-29.
//  Copyright (c) 2012年 com.comsoft. All rights reserved.
//

#import "CommonFunc.h"
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "sys/utsname.h"
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
#define PLACEHOLDER_NAME @"ios_talk_03pic"
#define PLACEHOLDER_COLOR COLORRGB(235.0, 237.0, 236.0)
#define     LocalStr_None           @""
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject]
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define XH_STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])
@implementation CommonFunc

static CommonFunc *comfunc;

+ (CommonFunc *)getSingled{
    @synchronized(self){
        if (!comfunc) {
            comfunc = [[CommonFunc alloc]init];
            comfunc.timesCount=0;
            comfunc.category=@"1";
        }
        return comfunc;
    }
}
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}
+(NSString *)Tojsonstring:(id)idss   //把字典和数组转换成json字符串
{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:idss
                                                      options:0 error:nil];
    NSString *strs=[[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    return strs;
}
+(id)Fromjsonstring:(NSString*)string
{
    NSLog(@"the string is%@",string);
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonArray =[CommonFunc jsonGetStrings :data];
    
    return jsonArray;
    
}

+ (id)jsonGetStrings:(NSData *)data
{
    NSError *error=nil;
    id str = nil;
    if (!data)
        return nil;
    str = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return str;
}
+ (CGSize)computeSizeWithString:(NSString *)aStr font:(UIFont *)font {
    
    if (!aStr || ![aStr isKindOfClass:[NSString class]] || !font) {
        return CGSizeZero;
    }
    CGSize size;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
     size= [aStr sizeWithAttributes:@{ NSFontAttributeName:font}];
    }
    return size;
}

+ (CGFloat)computeWidthWithString:(NSString *) aStr font:(UIFont *) font height:(CGFloat) height {
    
    if (!aStr || ![aStr isKindOfClass:[NSString class]] || !font) {
        return 0.0;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    CGRect frame = [aStr boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{ NSFontAttributeName: font }
                                      context:nil];
    
    CGFloat newHeight = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    
#endif
    if (height > newHeight) {
        NSInteger row = floor(height / newHeight);
        width = ceil(width / row) + 5.0;
    }
    return width;
}

+ (CGFloat)computeHeightWithString:(NSString *) aStr font:(UIFont *) font width:(CGFloat) width {
    
    if (!aStr || ![aStr isKindOfClass:[NSString class]] || !font) {
        return 0.0;
    }
    
    CGFloat height = CGRectGetHeight([aStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{ NSFontAttributeName: font }
                                                        context:nil]);
    height=height<25?25:height;
    return height;
}
+ (CGFloat)computeHeightWithAttriString:(NSString *) aStr font:(UIFont *) font width:(CGFloat) width lineSpace:(NSInteger)lineSpace {
    
    if (!aStr || ![aStr isKindOfClass:[NSString class]] || !font) {
        return 0.0;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    CGFloat height = CGRectGetHeight([aStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{ NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraphStyle}
                                                        context:nil]);
    height=height<25?25:height;
    return height;
}
//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:emailRegex
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:nil];
    
    
    NSInteger numer = [regular numberOfMatchesInString:email
                                               options:NSMatchingAnchored
                                                 range:NSMakeRange(0, email.length)];
    
    return numer==1;
}
#pragma mark  手机合法验证
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[57])|(15[^4\\D])|(17[0678])|(18[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark---验证网址
+(BOOL)isValidateUrl:(NSString *)urlString
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        
        if (firstMatch) {
            
            NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
            
            //从urlString当中截取数据
            
            NSString *result=[urlString substringWithRange:resultRange];
            
            //输出结果
            
            NSLog(@"%@",result);
            return YES;
        }else
        {
            return NO;
        }
    }
    return NO;
}
#pragma mark--身份证
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];
    
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(identityCard.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }
}
#pragma mark--银行卡
//银行卡
+ (BOOL)validateBankCardNumber: (NSString *)cardNo
{
        int oddsum = 0;     //奇数求和
        int evensum = 0;    //偶数求和
        int allsum = 0;
        int cardNoLength = (int)[cardNo length];
        int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
        
        cardNo = [cardNo substringToIndex:cardNoLength - 1];
        for (int i = cardNoLength -1 ; i>=1;i--) {
            NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
            int tmpVal = [tmpString intValue];
            if (cardNoLength % 2 ==1 ) {
                if((i % 2) == 0){
                    tmpVal *= 2;
                    if(tmpVal>=10)
                        tmpVal -= 9;
                    evensum += tmpVal;
                }else{
                    oddsum += tmpVal;
                }
            }else{
                if((i % 2) == 1){
                    tmpVal *= 2;
                    if(tmpVal>=10)
                        tmpVal -= 9;
                    evensum += tmpVal;
                }else{
                    oddsum += tmpVal;
                }
            }
        }
        
        allsum = oddsum + evensum;
        allsum += lastNum;  
        if((allsum % 10) == 0)  
            return YES;  
        else  
            return NO;  
//    BOOL flag;
//    if (bankCardNumber.length <= 0)
//    {
//        flag = NO;
//        return flag;
//    }
//    NSString *regex2 = @"^(\\d{15,30})";
//    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
#pragma mark---获取xib视图
+(UIView *)getXibViews:(NSString *)xibNames
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:xibNames owner:nil options:nil];
        return [nibView objectAtIndex:0];
}
/**
 * 数组筛选
 */
+(NSMutableArray *)getTableArry:(id)datas myArry:(NSMutableArray *)arrs  FirstRload:(BOOL)firstReload signString:(NSString *)ids
{
    if (firstReload) {
        NSMutableArray *tempsArry=[[NSMutableArray alloc]initWithArray:arrs];
        [arrs removeAllObjects];
        for (int i=0; i<[datas count]; i++) {
            [arrs addObject:[datas objectAtIndex:i]];
        }
        for (int i=0; i<[tempsArry count]; i++) {
            id tempa=[tempsArry     objectAtIndex:i];
            int ss=0;
            for (int m=0;m<[arrs count]; m++) {
                if ([[NSString stringWithFormat:@"%@",[tempa objectForKey:ids]] isEqualToString:[NSString stringWithFormat:@"%@",[[arrs objectAtIndex:m] objectForKey:ids]]]) {
                    ss=1;
                }
            }
            if (ss==0 && [[tempa objectForKey:ids] integerValue]>0) {
                [arrs addObject:tempa];
            }
        }
    }
    else
    {
        for (int i=0; i<[datas count]; i++) {
            id tempa=[datas objectAtIndex:i];
            int ss=0;
            for (int m=0;m<[arrs count]; m++) {
                if ([[NSString stringWithFormat:@"%@",[tempa objectForKey:ids] ]isEqualToString:[[arrs objectAtIndex:m] objectForKey:ids]]) {
                    [arrs replaceObjectAtIndex:m withObject:tempa];
                    ss=1;
                }
            }
            if (ss==0 && [[NSString stringWithFormat:@"%@",[tempa objectForKey:ids]] length]>0) {
                [arrs addObject:tempa];
            }
        }
    }
    return arrs;
}
+ (UIViewController *)currentRootViewController {
    
    UIViewController *result = nil;
    
    // Try to find the root view controller programmically
    
    // Find the top window (that is not an alert view or other window)
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for(topWindow in windows) {
            
            if (topWindow.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    UIView *rootView = [[topWindow subviews] firstObject];
    
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        
        result = nextResponder;
    }
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil) {
        
        result = topWindow.rootViewController;
    }
    else {
        
    }
    
    return result;
}




//计算汉子 字母 asciiLength
+(NSUInteger)AsciiLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    
    return unicodeLength;
}


/**
 * 获取网络视频第一帧
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / M_PI)


//NSURL *url = [[NSBundle mainBundle] URLForResource:nameOfVideo withExtension:@"MOV"];

+(AVPlayer*)rotateVideoPlayer:(AVPlayer*)player withDegrees:(float)degrees{
    
    NSURL* url = [(AVURLAsset *)player.currentItem.asset URL];
    
    AVMutableComposition *composition;
    AVMutableVideoComposition *videoComposition;
    AVMutableVideoCompositionInstruction * instruction;
    
    AVURLAsset* asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVMutableVideoCompositionLayerInstruction *layerInstruction = nil;
    CGAffineTransform t1;
    CGAffineTransform t2;
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    // Check if the asset contains video and audio tracks
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    }
    CMTime insertionPoint = kCMTimeInvalid;
    NSError *error = nil;
    
    
    // Step 1
    // Create a new composition
    composition = [AVMutableComposition composition];
    // Insert the video and audio tracks from AVAsset
    if (assetVideoTrack != nil) {
        AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetVideoTrack atTime:insertionPoint error:&error];
    }
    if (assetAudioTrack != nil) {
        AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetAudioTrack atTime:insertionPoint error:&error];
    }
    
    
    
    
    // Step 2
    // Calculate position and size of render video after rotating
    
    
    float width=assetVideoTrack.naturalSize.width;
    float height=assetVideoTrack.naturalSize.height;
    float toDiagonal=sqrt(width*width+height*height);
    float toDiagonalAngle=radiansToDegrees(acosf(width/toDiagonal));
    float toDiagonalAngle2=90-radiansToDegrees(acosf(width/toDiagonal));
    
    float toDiagonalAngleComple;
    float toDiagonalAngleComple2;
    float finalHeight;
    float finalWidth;
    
    
    if(degrees>=0&&degrees<=90){
        
        toDiagonalAngleComple=toDiagonalAngle+degrees;
        toDiagonalAngleComple2=toDiagonalAngle2+degrees;
        
        finalHeight=ABS(toDiagonal*sinf(degreesToRadians(toDiagonalAngleComple)));
        finalWidth=ABS(toDiagonal*sinf(degreesToRadians(toDiagonalAngleComple2)));
        
        t1 = CGAffineTransformMakeTranslation(height*sinf(degreesToRadians(degrees)), 0.0);
    }
    else if(degrees>90&&degrees<=180){
        
        
        float degrees2 = degrees-90;
        
        toDiagonalAngleComple=toDiagonalAngle+degrees2;
        toDiagonalAngleComple2=toDiagonalAngle2+degrees2;
        
        finalHeight=ABS(toDiagonal*sinf(degreesToRadians(toDiagonalAngleComple2)));
        finalWidth=ABS(toDiagonal*sinf(degreesToRadians(toDiagonalAngleComple)));
        
        t1 = CGAffineTransformMakeTranslation(width*sinf(degreesToRadians(degrees2))+height*cosf(degreesToRadians(degrees2)), height*sinf(degreesToRadians(degrees2)));
    }
    else if(degrees>=-90&&degrees<0){
        
        float degrees2 = degrees-90;
        float degreesabs = ABS(degrees);
        
        toDiagonalAngleComple=toDiagonalAngle+degrees2;
        toDiagonalAngleComple2=toDiagonalAngle2+degrees2;
        
        finalHeight=ABS(toDiagonal*sinf(degreesToRadians(toDiagonalAngleComple2)));
        finalWidth=ABS(toDiagonal*sinf(degreesToRadians(toDiagonalAngleComple)));
        
        t1 = CGAffineTransformMakeTranslation(0, width*sinf(degreesToRadians(degreesabs)));
        
    }
    else if(degrees>=-180&&degrees<-90){
        
        float degreesabs = ABS(degrees);
        float degreesplus = degreesabs-90;
        
        toDiagonalAngleComple=toDiagonalAngle+degrees;
        toDiagonalAngleComple2=toDiagonalAngle2+degrees;
        
        finalHeight=ABS(toDiagonal*sinf(degreesToRadians(toDiagonalAngleComple)));
        finalWidth=ABS(toDiagonal*sinf(degreesToRadians(toDiagonalAngleComple2)));
        
        t1 = CGAffineTransformMakeTranslation(width*sinf(degreesToRadians(degreesplus)), height*sinf(degreesToRadians(degreesplus))+width*cosf(degreesToRadians(degreesplus)));
        
    }
    
    
    // Rotate transformation
    t2 = CGAffineTransformRotate(t1, degreesToRadians(degrees));
    
    
    // Step 3
    // Set the appropriate render sizes and rotational transforms
    
    
    // Create a new video composition
    videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = CGSizeMake(finalWidth,finalHeight);
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    // The rotate transform is set on a layer instruction
    instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [composition duration]);
    
    layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[composition.tracks objectAtIndex:0]];
    [layerInstruction setTransform:t2 atTime:kCMTimeZero];
    
    
    
    // Step  4
    
    // Add the transform instructions to the video composition
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject:instruction];
    
    
    AVPlayerItem *playerItem_ = [[AVPlayerItem alloc] initWithAsset:composition];
    playerItem_.videoComposition = videoComposition;
    
    
    
    CMTime time;
    
    
    time=kCMTimeZero;
    [player replaceCurrentItemWithPlayerItem:playerItem_];
    
    
    [player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    
    //Export rotated video to the file
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality] ;
    exportSession.outputURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@_rotated",url]];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.videoComposition = videoComposition;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"Video exported");
    }];
    
    
    return  player;
    
}
+ (void) alignLabelWithTop:(UILabel *)label {
    CGSize maxSize = CGSizeMake(label.frame.size.width, 999);
    label.adjustsFontSizeToFitWidth = NO;
    
    CGRect textRect = [label.text boundingRectWithSize:maxSize
                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName:label.font}
                                             context:nil];
    
    // get actual height
    CGRect rect = label.frame;
    rect.size.height = textRect.size.height;
    label.frame = rect;
}
/**
 *视图随键盘移动
 */
+(void)MoveViewsWithKeyBoard:(UIView *)views rects:(CGRect)rects
{
    [UIView animateWithDuration:0.3 animations:^{
        views.frame=CGRectMake(views.frame.origin.x, (boundsHeight-rects.origin.y)-260, views.frame.size.width, views.frame.size.height);
 
    }];
}
+(BOOL)StringisEmpty:(NSString *) str {

    if(str ==nil)
    {
        return YES;
    }
    if([str isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if (!str || [str length]==0) {
        
        return YES;
        
    } else {
        
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        
        
        if ([trimedString length] == 0) {
            
            return YES;
            
        } else {
            
            return NO;
            
        }
        
    }
    
}
/**
 *视图还原
 */
+(void)ResetViewsWithKeyBoard:(UIView *)views {
    [UIView animateWithDuration:0.3 animations:^{
        views.frame=CGRectMake(views.frame.origin.x, 0, views.frame.size.width, views.frame.size.height);
        
    }];
}
//清空搜索框背景
+(void)SearchBarSettingBg:(UISearchBar *)mySearchBar
{
    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
    if ([ mySearchBar respondsToSelector : @selector (barTintColor)]) {
        float  iosversion7_1 = 7.1 ;
        
        if (version >= iosversion7_1)
            
        {
            mySearchBar.backgroundImage = [self imageWithColor:COLORRGB(232, 232, 232)];
        }
        
        else
            
        {
            //iOS7.0
            [ mySearchBar setBarTintColor :COLORRGB(232, 232, 232)];
            
            [ mySearchBar setBackgroundColor :COLORRGB(232, 232, 232)];
        }
    }
    else
    {
        //iOS7.0 以下
        [[ mySearchBar . subviews objectAtIndex : 0 ] removeFromSuperview ];
        [ mySearchBar setBackgroundColor :COLORRGB(232, 232, 232)];
        
    }
}
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(void)deleteDownDrawLine:(UITableViewCell *) cell
{
    UIView *downView = [cell viewWithTag:9999998];
    [downView removeFromSuperview];
}
+(void)deleteTopDrawLine:(UITableViewCell *) cell
{
    UIView *downView = [cell viewWithTag:9999999];
    [downView removeFromSuperview];
}
//绘制顶部线条
+ (void)drawUpLineWithView:(UIView *) view
         andSeparatorInset:(UIEdgeInsets) inset {
    
    [CommonFunc deleteTopDrawLine:(UITableViewCell*)view];
    
    UIView *lineView = [view viewWithTag:9999999];
    if (!lineView) {
        lineView = [[UIView alloc] init];
        lineView.tag = 9999999;
        [lineView removeFromSuperview];
        [view addSubview:lineView];
        
    }
    lineView.frame = CGRectMake(inset.left, inset.top, ScreenWidth - (inset.left + inset.right), 0.5);
    lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.08];
}
//绘制底部线条
+ (void)drawDownLineWithView:(UITableViewCell *) view
           andSeparatorInset:(UIEdgeInsets) inset withColor:(UIColor *)color {
    
    [CommonFunc deleteDownDrawLine:(UITableViewCell*)view];
    UIView *lineView = [view viewWithTag:9999998];
    if (!lineView) {
        lineView = [[UIView alloc] init];
        lineView.tag = 9999998;
        [lineView removeFromSuperview];
        
        [view addSubview:lineView];
    }
    
    lineView.frame = CGRectMake(inset.left,  inset.top, ScreenWidth - (inset.left + inset.right), 0.5);
    lineView.backgroundColor = color;
}
+ (void)drawDownLineWithView:(UITableViewCell *) view
           andSeparatorInset:(UIEdgeInsets) inset{
    [self drawDownLineWithView:view andSeparatorInset:inset withColor:[ColorObjc MainLineColor]];
 
}
//绘制底部线条
+ (void)drawDownLineWithView:(UITableViewCell *) view Row:(NSInteger)Rows
           andSeparatorInset:(UIEdgeInsets) inset {
    
    [CommonFunc deleteDownDrawLine:(UITableViewCell*)view];
    UIView *lineView = [view viewWithTag:9999998];
    if (!lineView) {
        lineView = [[UIView alloc] init];
        lineView.tag = 9999998;
        [lineView removeFromSuperview];
        
        [view addSubview:lineView];
    }
    if(Rows==0)
    {
        [CommonFunc drawUpLineWithView:view andSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    lineView.frame = CGRectMake(inset.left,  inset.top, view.width - (inset.left + inset.right), 0.5);
    lineView.backgroundColor = COLORRGB(37, 44, 54);
}
/**
 * 延迟返回
 */
-(void)ReturnPop:(UIViewController *)delegetes
{
    [self performSelector:@selector(returnPop:) withObject:delegetes afterDelay:0.5];

}
-(void)returnPop:(UIViewController *)controllers
{
    [UIViewController setBackRefresh:YES];
    [controllers.navigationController popViewControllerAnimated:YES];
}
#pragma mark 创建存储图片的路径
+ (NSString *)createImagePaths:(NSString *)FileName
{
    NSArray *segments = [NSArray arrayWithObjects:DocumentsDirectory, FileName, nil];
    
    NSString *imgfilePath =  [NSString pathWithComponents:segments];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    [fileManager createDirectoryAtPath:imgfilePath withIntermediateDirectories:YES attributes:nil error:&error];
    
    return imgfilePath;
}

+(NSString*) convertStringFromDate:(NSDate *)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[formatter stringFromDate:uiDate];
    return dateString;
}
+(NSString*) convertDateAndTimesFromDate:(NSDate *)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[formatter stringFromDate:uiDate];
    return dateString;
}
+(NSString*) convertStringToString:(NSString *)uiDate startFormat:(NSString *)startFormat endFormat:(NSString *)endFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:startFormat];
    NSDate *dates=[formatter dateFromString:uiDate];
    
    NSDateFormatter *Endformatter = [[NSDateFormatter alloc] init] ;
    [Endformatter setDateFormat:endFormat];
    
    NSString *dateString=[Endformatter stringFromDate:dates];
    
    return dateString;
}
+(NSString*) convertStringToWeek:(NSString *)uiDate startFormat:(NSString *)startFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:startFormat];
    NSDate *dates=[formatter dateFromString:uiDate];
    
    NSString *dateString=dates.weekString;
    
    return dateString;
}
/**
 *base64 转化
 */
+(NSString *)changeBase64:(NSString *)strFile
{
    NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                         (CFStringRef)strFile,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
    return baseString;
}
+(UIEdgeInsets)bubbleImageEdgeInsetsWithStyle{
    UIEdgeInsets edgeInsets;
    edgeInsets = UIEdgeInsetsMake(30, 28, 85, 28);
    return edgeInsets;
}
+(UIImage *)EdgedImage:(NSString *)imageName
{
    UIEdgeInsets bubbleImageEdgeInsets = [self bubbleImageEdgeInsetsWithStyle];
    UIImage *images = XH_STRETCH_IMAGE([UIImage imageNamed:imageName], bubbleImageEdgeInsets);
    return images;
}

+ (void)presentPopinController:(UIViewController *) popin
               presentingPopin:(UIViewController *) presentingPopin
                  popinOptions:(BKTPopinOption) popinOptions
                popinAlignment:(BKTPopinAlignementOption) popinAlignment
          popinTransitionStyle:(BKTPopinTransitionStyle) transitionStyle
      popinTransitionDirection:(BKTPopinTransitionDirection) transitionDirection
                   contentSize:(CGSize) contentSize
{
    
    //Create a blur parameters object to configure background blur
    BKTBlurParameters *blurParameters = [BKTBlurParameters new];
    blurParameters.alpha = 0.75f;
    blurParameters.radius = 8.0f;
    blurParameters.saturationDeltaFactor = 1.8f;
    blurParameters.tintColor = [COLORRGB(251,208,92) colorWithAlphaComponent:0.5];
    [popin setBlurParameters:blurParameters];
    
    [popin setPopinTransitionStyle:transitionStyle];
    
    //Set popin alignement according to value in segmented control
    [popin setPopinAlignment:popinAlignment];
    
    //Add option for a blurry background
    [popin setPopinOptions:popinOptions];
    
    [popin setPreferedPopinContentSize:contentSize];
    
    //Set popin transition direction
    [popin setPopinTransitionDirection:transitionDirection];
    [presentingPopin presentPopinController:popin animated:YES completion:NULL];
}

+ (void)presentPopinController:(UIViewController *)popin contentSize:(CGSize)contentSize
{
    [CommonFunc presentPopinController:popin
                       presentingPopin:[CommonFunc currentRootViewController]
                           contentSize:contentSize];
}
//左边弹出视图
+ (void)presentPopinController:(UIViewController *)popin presentingPopin:(UIViewController *)presentingPopin contentSize:(CGSize)contentSize {
    [CommonFunc presentPopinController:popin
                       presentingPopin:presentingPopin
                          popinOptions:BKTPopinDefault | BKTPopinBlurryDimmingView
                        popinAlignment:BKTPopinAlignementOptionLeft
                  popinTransitionStyle:BKTPopinTransitionStyleSlide
              popinTransitionDirection:BKTPopinTransitionDirectionLeft
                           contentSize:contentSize];
}

/**
 *底部弹出视图
 */
+ (void)presentPopinControllerBottom:(UIViewController *)popin contentSize:(CGSize)contentSize superController:(UIViewController *)viewControllers {
    [CommonFunc presentPopinController:popin
                       presentingPopin:viewControllers
                          popinOptions:BKTPopinDefault | BKTPopinBlurryDimmingView
                        popinAlignment:BKTPopinAlignementOptionDown
                  popinTransitionStyle:BKTPopinTransitionStyleSlide
              popinTransitionDirection:BKTPopinTransitionDirectionBottom
                           contentSize:contentSize];
}
/**
 *左边弹出视图
 */
+ (void)presentPopinControllerLeft:(UIViewController *)popin contentSize:(CGSize)contentSize superController:(UIViewController *)viewControllers {
    [CommonFunc presentPopinController:popin
                       presentingPopin:viewControllers
                          popinOptions:BKTPopinDefault | BKTPopinBlurryDimmingView
                        popinAlignment:BKTPopinAlignementOptionLeft
                  popinTransitionStyle:BKTPopinTransitionStyleSlide
              popinTransitionDirection:BKTPopinTransitionDirectionLeft
                           contentSize:contentSize];
}
/**
 *上面弹出视图
 */
+ (void)presentPopinControllerTop:(UIViewController *)popin contentSize:(CGSize)contentSize superController:(UIViewController *)viewControllers
{
    [CommonFunc presentPopinController:popin
                       presentingPopin:viewControllers
                          popinOptions:BKTPopinDefault | BKTPopinBlurryDimmingView
                        popinAlignment:BKTPopinAlignementOptionLeft
                  popinTransitionStyle:BKTPopinTransitionStyleSlide
              popinTransitionDirection:BKTPopinTransitionDirectionTop
                           contentSize:contentSize];
}
/**
 *右边弹出视图
 */
+ (void)presentPopinControllerRight:(UIViewController *)popin contentSize:(CGSize)contentSize superController:(UIViewController *)viewControllers
{
    [CommonFunc presentPopinController:popin
                       presentingPopin:viewControllers
                          popinOptions:BKTPopinDefault | BKTPopinBlurryDimmingView
                        popinAlignment:BKTPopinAlignementOptionRight
                  popinTransitionStyle:BKTPopinTransitionStyleSlide
              popinTransitionDirection:BKTPopinTransitionDirectionRight
                           contentSize:contentSize];
}
/**
 *中间弹出视图
 */
+ (void)presentPopinControllerCenter:(UIViewController *)popin contentSize:(CGSize)contentSize  superController:(UIViewController *)viewControllers{
    [CommonFunc presentPopinControllerCenter:popin
                             presentingPopin:viewControllers
                                 contentSize:contentSize];
}
+ (void)presentPopinControllerCenterDimming:(UIViewController *)popin contentSize:(CGSize)contentSize  superController:(UIViewController *)viewControllers
{
    [CommonFunc presentPopinController:popin
                       presentingPopin:viewControllers
                          popinOptions:BKTPopinDimmingViewStyleNone | BKTPopinDefault
                        popinAlignment:BKTPopinAlignementOptionCentered
                  popinTransitionStyle:BKTPopinTransitionStyleCrossDissolve
              popinTransitionDirection:BKTPopinTransitionDirectionTop
                           contentSize:contentSize];
}
+ (void)presentPopinControllerCenter:(UIViewController *)popin presentingPopin:(UIViewController *)presentingPopin contentSize:(CGSize)contentSize
{
    //  BKTPopinDimmingViewStyleNone 隐藏透明背景
    [CommonFunc presentPopinController:popin
                       presentingPopin:presentingPopin
                          popinOptions:BKTPopinBlurryDimmingView | BKTPopinDefault
                        popinAlignment:BKTPopinAlignementOptionCentered
                  popinTransitionStyle:BKTPopinTransitionStyleCrossDissolve
              popinTransitionDirection:BKTPopinTransitionDirectionTop
                           contentSize:contentSize];
}

/**
 * 视图淡入淡出
 */
+(void)restoreRootViewController:(UIViewController *)rootViewController
{
    typedef void (^Animation)(void);
    UIWindow* window = [UIApplication sharedApplication].delegate.window;
    if(window==nil)
    {
        window = [[UIWindow alloc] initWithFrame:SCREEN_BOUNDS];
        [window setBackgroundColor:[ColorObjc MainBgColor]];
    }
    [window makeKeyAndVisible];
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.4f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}
+(void)restoreCurrentViewController:(UIViewController *)currentViewController
{
    typedef void (^Animation)(void);
    
    currentViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIView setAnimationsEnabled:oldState];
    };
    [UIView transitionWithView:currentViewController.view
                      duration:0.6f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];

}
+ (void)animationRotateWithHalf:(UIView *) view {
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = @(0);
    shake.toValue = @(M_PI_4);
    shake.duration = 0.4;
    shake.autoreverses = NO;
    shake.repeatCount = 1;
    [view.layer addAnimation:shake forKey:@"rotationAnimation"];
}
+ (void)animationRotate:(UIView *) view {
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = @(0);
    shake.toValue = @(2*M_PI);
    shake.duration = 0.8;
    shake.autoreverses = NO;
    shake.repeatCount = HUGE_VALF;
    [view.layer addAnimation:shake forKey:@"rotationAnimation"];
}
+ (void)animationUpDown:(UIView *) view
{
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    shake.fromValue = @(30);
    shake.toValue = @(0);
    shake.duration = 1.2;
    shake.autoreverses = NO;
    shake.repeatCount = HUGE_VALF;
    [view.layer addAnimation:shake forKey:@"rotationAnimation"];
}
/**
 * 添加模糊背景
 */
+(void)addEffectBgImageV:(UIView *)views image:(UIImage *)images
{
    UIImageView *imageViews=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, views.width, views.height)];
    [views addSubview:imageViews];
    [imageViews setImage:[images applyExtraLightEffect]];
    
}

/**
 * 添加模糊背景
 */
+(void)addBgImageV:(UIView *)views
{
    NSString * imgStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"BGIMAGEVIEW"];
    NSString *urlString=HMSTR(@"%@/%@",APP_DOCUMENT,imgStr);
    UIImageView *imageViews=(UIImageView *)[views viewWithTag:998];
    
    if(imageViews==nil)
    {
        imageViews=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, views.width, views.height)];
        [views addSubview:imageViews];
        imageViews.contentMode=UIViewContentModeScaleAspectFill;
        imageViews.clipsToBounds=YES;
        [imageViews setTag:998];
        if(IOS8_AND_LATER)
        {
//            UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//            visualEfView.frame = CGRectMake(0, 0, views.width, views.height);
//            visualEfView.alpha = 1.0f;
//            [imageViews addSubview:visualEfView];
        }
    }
    

}
+(NSMutableAttributedString *)getAttributedString:(NSString *)contentString lineSpace:(NSInteger)lineSpace TextAlignMent:(NSTextAlignment)textAlignment
{
    NSMutableAttributedString *attris=[[NSMutableAttributedString alloc]initWithString:contentString];
    if(lineSpace)
    {
        NSMutableParagraphStyle *pagagra=[[NSMutableParagraphStyle alloc]init];
        pagagra.lineSpacing=lineSpace;
        pagagra.alignment=textAlignment;
        [attris addAttributes:@{NSParagraphStyleAttributeName:pagagra} range:NSMakeRange(0, [contentString length])];
    }
  
    return attris;
}
/**
 *渐变颜色
 */
+(CAGradientLayer *)shadowAsInverse:(CGRect)rects ColorArray:(NSArray *)colors
{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    CGRect newGradientLayerFrame = CGRectMake(0, 0, rects.size.width, rects.size.height);
    gradientLayer.frame = newGradientLayerFrame;
    
    //添加渐变的颜色组合
    gradientLayer.colors =colors;
    
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint = CGPointMake(rects.origin.x,rects.origin.y);
    return gradientLayer;
}

/**
 *获取内网IP地址
 */
+(NSString *)getInterIPAddress
{
    NSString *address = @"192.168.1.1";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
/**
 *获取公网IP
 */
- (void)getPublicIPAddress
{
//    NSURL *url = [NSURL URLWithString:@"http://automation.whatismyip.com/n09230945.asp"];
//    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setCompletionBlock:^{
//        NSString *responseString = [request responseString];
//        if (responseString) {
//            
//            NSString *ip = [NSString stringWithFormat:@"%@", responseString];
//            
//            NSLog(@"responseString = %@", ip);
//        };
//        
//    }];
//    
//    [request setFailedBlock:^{
//    }];
}
/**
 * 创建请求Model
 */
+(NSDictionary *)CeateRequestModel:(NSDictionary *)imforDic
{
   
    return  @{@"json":[CommonFunc Tojsonstring:imforDic]};
}

+(void)drawDashedBorder:(UIView *)views
{
    
    //border definitions
    
    CAShapeLayer*   _shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat cornerRadius=4;
    CGFloat borderWidth=3;
    UIColor *lineColor=[ColorObjc MainYellowColor];
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, views.bounds.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, views.bounds.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, views.bounds.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, views.bounds.size.width, views.bounds.size.height - cornerRadius);
    CGPathAddArc(path, NULL, views.bounds.size.width - cornerRadius, views.bounds.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, views.bounds.size.height);
    CGPathAddArc(path, NULL, cornerRadius, views.bounds.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = views.bounds;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:4], nil];
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
    [views.layer addSublayer:_shapeLayer];
    views.layer.cornerRadius = cornerRadius;
}
+ (void)animationEaseIn:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.28f];
    [animation setType:kCATransitionFade];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    [view.layer addAnimation:animation forKey:nil];
}
+ (void)animationEaseOut:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.28f];
    [animation setType:kCATransitionFade];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    [view.layer addAnimation:animation forKey:nil];
}
/**
 *判断接口状态
 */
+(BOOL)InterfaceStatus:(id )imforDic
{
    if(imforDic==nil)
    {
        return NO;
    }
    if([imforDic isKindOfClass:[NSArray class]])
    {
        imforDic=[imforDic firstObject];
    }
    if([imforDic isKindOfClass:[NSDictionary class]] && [imforDic objectForKey:@"Result"] !=nil && [[imforDic objectForKey:@"Result"] isEqualToString:@"false"])
    {
        return NO;
    }
    return YES;
}

+(NSArray *)getLocalPlist:(NSString *)plistname
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistname ofType:@"plist"];
    NSArray * temps= [[NSArray alloc] initWithContentsOfFile:plistPath];
    return temps;
}
#pragma mark--城市Plist 进行 省份分级
+(NSMutableArray *)SortCityFromPlist:(NSString *)plist
{
    NSMutableArray *_titleArray=[[NSMutableArray alloc]init];
    NSArray *allCityArray=[NSArray arrayWithArray:[CommonFunc getLocalPlist:plist]];
    //提取省
    NSMutableArray *proArray=[[NSMutableArray alloc]init];
    for(int i=0;i< [allCityArray count];i++)
    {
        NSDictionary *dic=[allCityArray objectAtIndex:i];
        if([[dic objectForKey:@"father_id"] integerValue]==0)
        {
            [proArray addObject:dic];
        }
    }
    
    NSArray *tempArray=[NSArray arrayWithArray:proArray];
    for(int i=0;i< [tempArray count];i++)
    {
        NSMutableArray *CityArray=[[NSMutableArray alloc]init];
        
        NSDictionary *Prodic=[tempArray objectAtIndex:i];
        for (NSDictionary *Alldic in allCityArray) {
            
            if([[Alldic objectForKey:@"father_id"] integerValue] ==[[Prodic objectForKey:@"region_code"] integerValue])
            {
                [CityArray addObject:Alldic];
            }
        }
        NSMutableDictionary *Citydic=[[NSMutableDictionary alloc]initWithDictionary:Prodic];
        [Citydic setObject:CityArray forKey:@"CityArray"];
        [_titleArray addObject:Citydic];
        
    }
    
    return _titleArray;
}
/**
 *翻转动画
 */
+(CATransition *)oglFlipRight
{
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"oglFlip";
    //过渡方向
    transition.subtype = kCATransitionFromRight;
    
    return transition;
}
/**
 *翻转动画
 */
+(CATransition *)oglFlipLeft
{
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"oglFlip";
    //过渡方向
    transition.subtype = kCATransitionFromLeft;
    
    return transition;
}
/**
 *翻转动画
 */
+(CATransition *)oglFlipBottom
{
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    //过渡方向
    transition.subtype = kCATransitionFromBottom;
    
    return transition;
}
/**
 *翻转动画
 */
+(CATransition *)oglFlipTop
{
    CATransition* transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    //过渡方向
    transition.subtype = kCATransitionFromTop;
    
    return transition;
}

/**
 * 清空消息提示
 */
+(void)clearBadgeBumber
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
#pragma mark--当前时间
+(NSString *)getDateTimeFromDate:(NSDate *)today
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:today];
    return destDateString;
}
#pragma mark--当前时间
+(NSString *)getCurrentDateTime{
    NSDate *today=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:today];
    return destDateString;
}
+(UIWebView *)callPhoneView:(NSString *)phone
{
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    return phoneCallWebView;
}
#pragma mark---根据具体地址获取经纬度
+ (void)getPostion:(NSString *)address complete:(void (^)(CLLocationCoordinate2D position))block
{
    
    __block CLLocationCoordinate2D position;
    position.latitude = 0.0;
    position.longitude = 0.0;
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"   请稍后...   ",nil)];
    if([address length]>2 )
    {
        NSString *subStrings=[address substringToIndex:2];
        if([[CommonFunc getZhixiaCity] containsObject:subStrings])
        {
            address=[address substringFromIndex:2];
        }
    }
    CLGeocoder* myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if([placemarks count]>0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            position= placemark.location.coordinate;
            block(position);
            [SVProgressHUD dismiss];
        }
    }];
}
#pragma mark----比较两个时间大小
+(int)compareDate:(NSString *)stringDate1 date:(NSString *)stringDate2 framatter:(NSString *)mattter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:mattter];
    NSDate *dateA = [dateFormatter dateFromString:stringDate1];
    NSDate *dateB = [dateFormatter dateFromString:stringDate2];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return 1; //date1 比 date2 晚
    }
    else if (result == NSOrderedAscending){
        return -1; //date1 比 date2 早
    }
    return 0; //在当前准确度下，两个时间一致
}
/**
 * 添加购物车动画
 */
+(void)AddCartAnimation:(CGPoint)startPoint
{
    CALayer     *layer;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    
    /**
     *  画二元曲线，一般和moveToPoint配合使用
     *
     *  @param endPoint     曲线的终点 - 购物车按钮的坐标
     *  @param controlPoint 画曲线的基准点
     */
    [path addQuadCurveToPoint:CGPointMake(ScreenWidth/3,SCREEN_HEIGHT+50) controlPoint:CGPointMake(100, 200)];
    if (!layer)
    {
        layer = [CALayer layer];
        layer.contents = (__bridge id)[UIImage imageNamed:@"ordering_0001_Vector_btn_add"].CGImage;
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer.bounds = CGRectMake(0, 0, 30, 30);
        [layer setCornerRadius:CGRectGetHeight([layer bounds]) / 2];
        layer.masksToBounds = YES;
        layer.position =CGPointMake(50, 150);
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:layer];
    }
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation];
    groups.duration = 0.5f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    [layer addAnimation:groups forKey:@"group"];
}

+ (NSString *)getLanguageCode
{
    NSString *Code=@"1";
    NSString *language=[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
   
    if([language isEqualToString:@"zh"])
    {
        if (!LocalizedSetted) {
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
        }
    }
    else
    {
        if (!LocalizedSetted) {
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:AppLanguage];
        }
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage] isEqualToString:@"en"])
    {
        Code=@"2";
    }else{
        Code=@"1";
    }
    return Code;
}
+(UIImage *)deafultImage
{
    UIImage *images=[UIImage imageNamed:@"meiyoutouxiang_light"];
    return images;
}
+ (void)showNoContent:(BOOL) flag
          displayView:(UIView *) view
       displayContent:(NSString *) content  {
    if (flag) {
        UILabel *label = (UILabel *)[view viewWithTag:1024];
        if (label == nil) {
            label = [[UILabel alloc] init];
            label.tag = 1024;
            label.font = [UIFont systemFontOfSize:18.0];
            label.textColor = [UIColor grayColor];
            label.numberOfLines=0;
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            [view addSubview:label];
            label.sd_layout
            .centerXEqualToView(view)
            .centerYEqualToView(view)
            .widthIs(boundsWidth-60)
            .autoHeightRatio(0);
        }
        label.text = content;
    } else {
        if ([view viewWithTag:1024]) {
            UILabel *label = (UILabel *)[view viewWithTag:1024];
            [label removeFromSuperview];
        }
    }
}

+(NSDate*) convertDateFromString:(NSString*)uiDate WithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    
    NSDate *date=[formatter dateFromString:uiDate];
    return  date;
}
+(NSArray *)getZhixiaCity
{
    return @[@"上海",@"北京",@"天津",@"重庆"];
}
#pragma mark---查看地图
+(void)LookInMap:(NSDictionary *)imforDic NavController:(UINavigationController *)navs
{

}
#pragma mark---年龄转出生日期
+(NSString *)getAgeFromBirthDay:(NSString *)birthDay
{
    if(birthDay ==nil || [CommonFunc StringisEmpty:birthDay])
    {
        return @"";
    }
    NSDate *date=[CommonFunc convertDateFromString:birthDay WithFormat:@"yyyy-MM-dd"];
    if(date==nil)
    {
        return @"";
    }
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    iAge=MAX(iAge, 1);
    
    return HMSTR(@"%ld 岁",(long)iAge);
}
+(void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
#pragma mark---适配浮点型显示数据
+(NSString *)AdaptiveFloats:(CGFloat)floatValue
{
    NSString* str = [NSString stringWithFormat:@"%.2f",floatValue];

    if (fmodf(floatValue, 1)==0)
    {
        str = [NSString stringWithFormat:@"%.0f",floatValue];
    }
    else if (fmodf(floatValue*10, 1)==0)
    {
        str = [NSString stringWithFormat:@"%.1f",floatValue];
    } else
    {
         str = [NSString stringWithFormat:@"%.2f",floatValue];
    }
    return str;
}
+ (UIImage *)drawPlaceholderWithSize:(CGSize)size
                          imageNamed:(NSString *)imageNamed
                             bgcolor:(UIColor *)color
{
    UIImage *oldImage = [UIImage imageNamed:imageNamed];
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    [color setFill];
    CGContextFillRect(contextRef, CGRectMake(0, 0, size.width, size.height));
    
    CGSize newSize;
    if (size.height > oldImage.size.height) {
        newSize = CGSizeMake(oldImage.size.height - 20, oldImage.size.height - 20);
    } else {
        newSize = CGSizeMake(size.height - 20, size.height - 20);
    }
    
    if (newSize.width >= size.width) {
        newSize = CGSizeMake(size.width - 20, size.width - 20);
    }
    
    CGContextTranslateCTM(contextRef, 0, size.height);
    CGContextScaleCTM(contextRef, 1, -1);
    CGContextDrawImage(contextRef,CGRectMake(
                                             size.width / 2 - newSize.width / 2,
                                             size.height / 2 - newSize.height / 2,
                                             newSize.width,
                                             newSize.height
                                             ), [oldImage CGImage]);
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(contextRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}
+ (UIImage *)drawPlaceholderWithSize:(CGSize)size
{
    return [CommonFunc drawPlaceholderWithSize:size bgcolor:PLACEHOLDER_COLOR];
}
+ (UIImage *)drawPlaceholderWithSize:(CGSize)size bgcolor:(UIColor *)color
{
    return [CommonFunc drawPlaceholderWithSize:size imageNamed:PLACEHOLDER_NAME bgcolor:color];
}
+(void)SaveClientID
{
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc]init];
    [tempDic setObject:@"saveClientId" forKey:@"a"];
    [tempDic setObject:@"User" forKey:@"c"];

}
+ (void)automaticCheckVersion:(void (^)(NSDictionary *))block url:(NSString *) url {
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    
    NSString *URL = url;
    __autoreleasing NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:
         ^ (NSURLResponse *response, NSData *data, NSError *error) {
             if (data) {
                 @try {
                     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
                     NSArray *infoArray = dict[@"results"];
                     if (infoArray && [infoArray count])
                     {
                         NSDictionary *releaseInfo = infoArray[0];
                         NSString *lastVersion = releaseInfo[@"version"];
                        NSString *trackViewURL = releaseInfo[@"trackViewUrl"];
                             if (block)
                             {
                                 block(@{
                                         @"trackViewUrl": trackViewURL,
                                         @"lastVersion": lastVersion,
                                         @"currentVersion": currentVersion
                                         });
                             }
                 
                     }else{
                         if (block)
                         {
                             block(@{
                                     @"trackViewUrl": @"url"
                                     });
                         }
                     }

                 }
                 @catch (NSException *exception)
                 {
                     
                 }
             }
             else {
                 
             }
         }];
   }
#pragma mark-----新增提示页面
+(UIView *)getRecomdAlertViewWithFrame:(CGRect)rects images:(NSString *)imageStr title:(NSString *)titleString content:(NSString *)contentStr
{
    
    UIView  *tableHeader=[[UIView alloc]initWithFrame:rects];
    
    UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
    [tableHeader addSubview:topImageView];
    [topImageView setImage:[UIImage imageNamed:imageStr]];
    topImageView.sd_layout
    .widthIs(320)
    .heightIs(222)
    .centerXEqualToView(tableHeader)
    .topSpaceToView(tableHeader,0);
    
    UILabel *titleLabel=[WidgetObjc WidgetLabel:CGRectZero font:[UIFont boldSystemFontOfSize:24] Alignment:NSTextAlignmentCenter textColor:COLORRGB(161, 167,187 )];
    [tableHeader addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(tableHeader,20)
    .heightIs(35)
    .topSpaceToView(topImageView,35)
    .rightSpaceToView(tableHeader,20);
    [titleLabel setText:titleString];
    
    UILabel *contentLabels=[WidgetObjc WidgetLabel:CGRectZero font:[UIFont systemFontOfSize:12] Alignment:NSTextAlignmentCenter textColor:[UIColor lightGrayColor]];
    contentLabels.numberOfLines=0;
    [tableHeader addSubview:contentLabels];
    contentLabels.sd_layout
    .centerXEqualToView(tableHeader)
    .topSpaceToView(titleLabel,12)
    .widthIs(rects.size.width-30)
    .heightIs(45);
    
    NSMutableAttributedString *attris=[CommonFunc getAttributedString:contentStr lineSpace:4 TextAlignMent:NSTextAlignmentCenter];
    [contentLabels setAttributedText:attris];
    [tableHeader setupAutoHeightWithBottomView:contentLabels bottomMargin:20];
    return tableHeader;
}
#pragma mark-----新增提示页面
+(UIView *)getsubRecomdAlertWithFrame:(CGRect)rects images:(NSString *)imageStr title:(NSString *)titleString content:(NSString *)contentStr
{
    
    UIView  *tableHeader=[[UIView alloc]initWithFrame:rects];
    
    UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
    [tableHeader addSubview:topImageView];
    [topImageView setImage:[UIImage imageNamed:imageStr]];
    topImageView.sd_layout
    .widthIs(168)
    .heightIs(153)
    .centerXEqualToView(tableHeader)
    .topSpaceToView(tableHeader,0);
    
    UILabel *titleLabel=[WidgetObjc WidgetLabel:CGRectZero font:[UIFont systemFontOfSize:16] Alignment:NSTextAlignmentCenter textColor:COLORRGB(213, 213,222)];
    [tableHeader addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(tableHeader,20)
    .heightIs(25)
    .topSpaceToView(topImageView,15)
    .rightSpaceToView(tableHeader,20);
    [titleLabel setText:titleString];
    
    UILabel *contentLabels=[WidgetObjc WidgetLabel:CGRectZero font:[UIFont systemFontOfSize:12] Alignment:NSTextAlignmentCenter textColor:COLORRGB(213, 213,222)];
    contentLabels.numberOfLines=0;
    [tableHeader addSubview:contentLabels];
    contentLabels.sd_layout
    .centerXEqualToView(tableHeader)
    .topSpaceToView(titleLabel,5)
    .widthIs(rects.size.width-30)
    .heightIs(25);
    
    NSMutableAttributedString *attris=[CommonFunc getAttributedString:contentStr lineSpace:4 TextAlignMent:NSTextAlignmentCenter];
    [contentLabels setAttributedText:attris];
    [tableHeader setupAutoHeightWithBottomView:contentLabels bottomMargin:20];
    return tableHeader;
}


+(NSDictionary *)getCardInfo:(NSString *)bankString
{
    NSArray *cardArray=[CommonFunc getLocalPlist:@"privilege"];
    __block NSDictionary *imforDic;
    [cardArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj[@"title"] isEqualToString:bankString])
        {
            imforDic=obj;
            
            *stop=YES;
        }
    }];
    return imforDic;
}
+(NSString *)getRecorderPath
{
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    //    dateFormatter.dateFormat = @"hh-mm-ss";
    dateFormatter.dateFormat = @"yyyy-MM-dd_hh_mm_ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@.caf", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

+(void)setAnimation:(UILabel *)views
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.35;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [transtion setType:kCATransitionPush];
    [transtion setSubtype:kCATransitionFromTop];
    [views.layer addAnimation:transtion forKey:@"transtionKey"];
}
#pragma mark---3des 解密替换
+(NSString *)encode3DesStr:(NSString *)desStr
{
   NSString  * encodeString=[desStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    encodeString=[encodeString stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSInteger model=(4-encodeString.length%4)%4;
    for (int i=0; i<model; i++)
    {
        encodeString=[encodeString stringByAppendingString:@"="];
    }
    return encodeString;
}
+(NSString *)replaceEncode3DesStr:(NSString *)desStr
{
    NSString  * encodeString=[desStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    encodeString=[encodeString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return encodeString;
}
-(void)showGameLoadingHUD
{
    
   UIImageView * _launchView =[[UIImageView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    UILabel *label =[WidgetObjc WidgetLabel:CGRectMake(0, _launchView.bottom-200, boundsWidth, 25) font:[UIFont systemFontOfSize:16] Alignment:NSTextAlignmentCenter textColor:[ColorObjc MainYellowDownColor]];
    label.text =NSLocalizedString(@"正在进入房间，请稍后...", nil) ;
    [_launchView addSubview:label];
    _launchView.image =[UIImage imageNamed:@"launchbg"];
    _launchView.backgroundColor =[UIColor clearColor];
    [_launchView setTag:10024];
    [[UIApplication sharedApplication].delegate.window addSubview:_launchView];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:_launchView];
    [self performSelector:@selector(hiddenGameLoadingHUD) withObject:nil afterDelay:1.5];
    _launchView.alpha=1.0f;
}
-(void)hiddenGameLoadingHUD
{
    UIImageView * _launchView=[[UIApplication sharedApplication].delegate.window viewWithTag:10024];
    if (_launchView)
    {
      [UIView animateWithDuration:0.25 animations:^{
          _launchView.alpha=0.0f;
      } completion:^(BOOL finished)
        {
          [_launchView removeFromSuperview];

      }];
    }
}
-(void)showWaitingHUD:(NSString *)titleStr
{
    [self showWaitingHUD:titleStr WithTime:1.5];
}
-(void)showWaitingHUD:(NSString *)titleStr WithTime:(CGFloat)times
{
    UIImageView * _launchView=[[UIApplication sharedApplication].delegate.window viewWithTag:10025];
    if (_launchView)
    {
        [_launchView removeFromSuperview];
    }
    _launchView =[[UIImageView alloc]initWithFrame:CGRectMake(boundsWidth/2-90, ScreenHeight/2-80, 180, 80)];
    _launchView.layer.masksToBounds =YES;
    _launchView.layer.cornerRadius =3;
    UILabel *label =[WidgetObjc WidgetLabel:CGRectMake(0, 0, _launchView.width, _launchView.height) font:[UIFont systemFontOfSize:13] Alignment:NSTextAlignmentCenter textColor:[UIColor whiteColor]];
    label.text =NSLocalizedString(titleStr, nil) ;
    label.numberOfLines=2;
    [_launchView addSubview:label];
    _launchView.backgroundColor =[COLORRGB(25, 26, 36) colorWithAlphaComponent:0.7];
    [_launchView setTag:10025];
    [[UIApplication sharedApplication].delegate.window addSubview:_launchView];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:_launchView];
    [self performSelector:@selector(hiddenWaitingHUD) withObject:nil afterDelay:times];
    _launchView.alpha=1.0f;
}
-(void)hiddenWaitingHUD
{
    UIImageView * _launchView=[[UIApplication sharedApplication].delegate.window viewWithTag:10025];
    if (_launchView)
    {
        [UIView animateWithDuration:0.25 animations:^{
            _launchView.alpha=0.0f;
        } completion:^(BOOL finished)
         {
             [_launchView removeFromSuperview];
             
         }];
    }
}
+(NSString *)getDeveiceUUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge NSString *)string;
}
+(void)showDanMuView:(NSString *)contentStr SuperView:(UIView *)superViews
{
    int point_x = boundsWidth;
    int point_y = (arc4random() % (int)FSFloat(20))*20 + (int)FSFloat(65);
    NSArray *colorArray=@[COLORRGB(98, 169, 229),COLORRGB(251, 207, 19),COLORRGB(209, 34, 90),COLORRGB(116, 191, 34)];
    UIColor *textColor=(UIColor*)[colorArray objectAtIndex:arc4random() % 4];
    UILabel *label =[WidgetObjc WidgetLabel:CGRectMake(point_x,point_y, ScreenWidth, 25) font:[UIFont systemFontOfSize:15] Alignment:NSTextAlignmentCenter textColor:textColor];
    label.text =contentStr ;
    label.numberOfLines=0;
    [superViews addSubview:label];
    [superViews bringSubviewToFront:label];
    [label setText:contentStr];
    [UIView animateWithDuration:8 animations:^{
        label.frame=CGRectMake(-ScreenWidth, label.top, label.width, label.height);
    } completion:^(BOOL finished)
     {
         [label removeFromSuperview];
    }];
}

// 获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
#warning 题主呕心沥血总结！！最全面！亲测！全网独此一份！！
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    DLog(@"%@",deviceString)

    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

@end
