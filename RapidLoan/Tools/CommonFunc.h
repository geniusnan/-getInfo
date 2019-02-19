//
//  CommonFunc.h
//  PRJ_base64
//
//  Created by wangzhipeng on 12-11-29.
//  Copyright (c) 2012年 com.comsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonCryptor.h>
#define __BASE64( text )        [CommonFunc base64StringFromText:text]
#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]

@interface CommonFunc : NSObject<CLLocationManagerDelegate,MKMapViewDelegate>
{
    UIViewController *myselfs;
    
}
@property(nonatomic,retain)  NSDictionary *imforDic;
@property(nonatomic,assign) int timesCount;
@property(nonatomic,retain) NSString *category;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;
+ (CommonFunc *)getSingled;
+(NSString *)Tojsonstring:(id)idss ; //把字典和数组转换成json字符串
+(id)Fromjsonstring:(NSString*)string;
+ (CGSize)computeSizeWithString:(NSString *)aStr font:(UIFont *)font;

+ (CGFloat)computeWidthWithString:(NSString *) aStr font:(UIFont *) font height:(CGFloat) height;
+ (CGFloat)computeHeightWithString:(NSString *) aStr font:(UIFont *) font width:(CGFloat) width;
+ (CGFloat)computeHeightWithAttriString:(NSString *) aStr font:(UIFont *) font width:(CGFloat) width lineSpace:(NSInteger)lineSpace;
//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email;
#pragma mark  手机合法验证
+(BOOL) isValidateMobile:(NSString *)mobile;
#pragma mark---验证网址
+(BOOL)isValidateUrl:(NSString *)urlString;
#pragma mark--身份证
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
#pragma mark--银行卡
+ (BOOL)validateBankCardNumber: (NSString *)bankCardNumber;
#pragma mark---获取xib视图
+(UIView *)getXibViews:(NSString *)xibNames;
/**
 * 数组筛选
 */
+(NSMutableArray *)getTableArry:(id)datas myArry:(NSMutableArray *)arrs  FirstRload:(BOOL)firstReload signString:(NSString *)ids;
+(NSUInteger)AsciiLengthOfString: (NSString *) text;
+(void)MoveViewsWithKeyBoard:(UIView *)views rects:(CGRect)rects;
/**
 *视图还原
 */
+(void)ResetViewsWithKeyBoard:(UIView *)views;
+(BOOL)StringisEmpty:(NSString *) str;
+(void)SearchBarSettingBg:(UISearchBar *)mySearchBar;

+(void)deleteDownDrawLine:(UITableViewCell *) cell;
+(void)deleteTopDrawLine:(UITableViewCell *) cell;
//绘制顶部线条
+ (void)drawUpLineWithView:(UIView *) view
         andSeparatorInset:(UIEdgeInsets) inset;
//绘制底部线条
+ (void)drawDownLineWithView:(UITableViewCell *) view
           andSeparatorInset:(UIEdgeInsets) inset withColor:(UIColor *)color;
//绘制底部线条
+ (void)drawDownLineWithView:(UITableViewCell *) view
           andSeparatorInset:(UIEdgeInsets) inset;
//绘制底部线条
+ (void)drawDownLineWithView:(UITableViewCell *) view Row:(NSInteger)Rows andSeparatorInset:(UIEdgeInsets) inset;
/**
 * 延迟返回
 */
-(void)ReturnPop:(UIViewController *)delegetes;
+(NSString*) convertStringFromDate:(NSDate *)uiDate;
+(NSString*) convertDateAndTimesFromDate:(NSDate *)uiDate;
+(NSDate*) convertDateFromString:(NSString*)uiDate WithFormat:(NSString *)formate;
+ (NSString *)createImagePaths:(NSString *)FileName;
+(NSArray *)getLocalPlist:(NSString *)plistname;
/**
 *base64 转化
 */
+(NSString *)changeBase64:(NSString *)strFile;

+(UIImage *)EdgedImage:(NSString *)imageName;
/**
 *左边弹出视图
 */
+ (void)presentPopinControllerLeft:(UIViewController *)popin contentSize:(CGSize)contentSize superController:(UIViewController *)viewControllers;
/**
 *上面弹出视图
 */
+ (void)presentPopinControllerTop:(UIViewController *)popin contentSize:(CGSize)contentSize superController:(UIViewController *)viewControllers;
/**
 *右边弹出视图
 */
+ (void)presentPopinControllerRight:(UIViewController *)popin contentSize:(CGSize)contentSize superController:(UIViewController *)viewControllers;
/**
 *中间弹出视图
 */
+ (void)presentPopinControllerCenter:(UIViewController *)popin contentSize:(CGSize)contentSize superController:(UIViewController *)viewControllers;
+ (void)presentPopinControllerCenter:(UIViewController *)popin presentingPopin:(UIViewController *)presentingPopin contentSize:(CGSize)contentSize;
+ (void)presentPopinController:(UIViewController *)popin contentSize:(CGSize)contentSize;
+ (void)presentPopinControllerCenterDimming:(UIViewController *)popin contentSize:(CGSize)contentSize  superController:(UIViewController *)viewControllers;
/**
 *底部弹出视图
 */
+ (void)presentPopinControllerBottom:(UIViewController *)popin contentSize:(CGSize)contentSize superController:(UIViewController *)viewControllers ;
+ (UIViewController *)currentRootViewController;
/**
 * 视图淡入淡出
 */
+(void)restoreRootViewController:(UIViewController *)rootViewController;
+(void)restoreCurrentViewController:(UIViewController *)currentViewController;
+ (void)animationRotateWithHalf:(UIView *) view;
+ (void)animationRotate:(UIView *) view;
+ (void)animationUpDown:(UIView *) view;
/**
 * 添加模糊背景
 */
+(void)addEffectBgImageV:(UIView *)views image:(UIImage *)images;

+(void)addBgImageV:(UIView *)views;

/**
 *获取内网IP地址
 */
+(NSString *)getInterIPAddress;
/**
 *获取公网IP
 */
- (void)getPublicIPAddress;
/**
 * 创建请求Model
 */
+(NSDictionary *)CeateRequestModel:(NSDictionary *)imforDic;
+(void)drawDashedBorder:(UIView *)views;

+ (void)animationEaseIn:(UIView *)view;
+ (void)animationEaseOut:(UIView *)view;
/**
 *判断接口状态
 */
+(BOOL)InterfaceStatus:(NSDictionary *)imforDic;
#pragma mark--城市Plist 进行 省份分级
+(NSMutableArray *)SortCityFromPlist:(NSString *)plist;

/**
 *翻转动画
 */
+(CATransition *)oglFlipRight;
/**
 *翻转动画
 */
+(CATransition *)oglFlipLeft;
/**
 *翻转动画
 */
+(CATransition *)oglFlipBottom;
/**
 *翻转动画
 */
+(CATransition *)oglFlipTop;

#pragma mark--当前时间
+(NSString *)getCurrentDateTime;
+(UIWebView *)callPhoneView:(NSString *)phone;
#pragma mark---根据具体地址获取经纬度
+ (void)getPostion:(NSString *)address complete:(void (^)(CLLocationCoordinate2D position))block;
+(int)compareDate:(NSString *)stringDate1 date:(NSString *)stringDate2 framatter:(NSString *)mattter;
+(NSString*) convertStringToString:(NSString *)uiDate startFormat:(NSString *)startFormat endFormat:(NSString *)endFormat;
+(NSString*) convertStringToWeek:(NSString *)uiDate startFormat:(NSString *)startFormat;
/**
 * 添加购物车动画
 */
+(void)AddCartAnimation:(CGPoint)startPoint;
+ (NSString *)getLanguageCode;
+(UIImage *)deafultImage;
+ (void)showNoContent:(BOOL) flag
          displayView:(UIView *) view
       displayContent:(NSString *) content;
+(NSString *)getDateTimeFromDate:(NSDate *)today;

#pragma mark---查看地图
+(void)LookInMap:(NSDictionary *)imforDic NavController:(UINavigationController *)navs;
#pragma mark---年龄转出生日期
+(NSString *)getAgeFromBirthDay:(NSString *)birthDay;
+(void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
#pragma mark---适配浮点型显示数据
+(NSString *)AdaptiveFloats:(CGFloat)floatValue;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)drawPlaceholderWithSize:(CGSize)size
                          imageNamed:(NSString *)imageNamed
                             bgcolor:(UIColor *)color;
+ (UIImage *)drawPlaceholderWithSize:(CGSize)size;
+ (UIImage *)drawPlaceholderWithSize:(CGSize)size bgcolor:(UIColor *)color;
+(void)SaveClientID;
+ (void)automaticCheckVersion:(void (^)(NSDictionary *))block url:(NSString *) url;
+(NSMutableAttributedString *)getAttributedString:(NSString *)contentString lineSpace:(NSInteger)lineSpace TextAlignMent:(NSTextAlignment)textAlignment;
/**
 *渐变颜色
 */
+(CAGradientLayer *)shadowAsInverse:(CGRect)rects ColorArray:(NSArray *)colors;
#pragma mark-----新增提示页面
+(UIView *)getRecomdAlertViewWithFrame:(CGRect)rects images :(NSString *)imageStr title:(NSString *)titleString content:(NSString *)contentStr;
+(UIView *)getsubRecomdAlertWithFrame:(CGRect)rects images:(NSString *)imageStr title:(NSString *)titleString content:(NSString *)contentStr;

+(NSDictionary *)getCardInfo:(NSString *)bankString;
+(NSString *)getRecorderPath;
+(void)showCusomAlertViewWithTitle:(NSString *)title
                          btnTitle:(NSString *)btnTitles
                          delegate:(UIViewController *)controller
                       actionIndex:(void (^)(NSInteger index))blocks;
+(void)setAnimation:(UILabel *)views;
#pragma mark---3des 解密替换
+(NSString *)encode3DesStr:(NSString *)desStr;
+(NSString *)replaceEncode3DesStr:(NSString *)desStr;
-(void)showGameLoadingHUD;
-(void)hiddenGameLoadingHUD;
-(void)showWaitingHUD:(NSString *)titleStr;
-(void)showWaitingHUD:(NSString *)titleStr WithTime:(CGFloat)times;
+(NSString *)getDeveiceUUID;
+(void)showDanMuView:(NSString *)contentStr SuperView:(UIView *)superViews;
+ (NSString *)getDeviceName;
@end
