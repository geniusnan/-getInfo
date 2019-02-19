//
//  LMDefines.h
//  SignLanguage
//
//  Created by Lim on 14/12/3.
//  Copyright (c) 2014年 Lim. All rights reserved.
//

#ifndef SignLanguage_LMDefines_h
#define SignLanguage_LMDefines_h

/*
 单例的方法申明
 */
#undef HM_SINGLETON
#define HM_SINGLETON(__class) \
+ (__class *)shared##__class;

/*
 单例的实现方法
 */
#undef IMP_SINGLETON
#define IMP_SINGLETON(__class) \
+ (__class *)shared##__class{\
static dispatch_once_t onceToken;\
static __class *__singleton__ = nil;\
dispatch_once(&onceToken, ^{\
__singleton__ = [[__class alloc] init];\
});\
return __singleton__;\
}

/*
 只执行一次（这里是开始）
 */
#undef BEGIN_SINGLETON
#define BEGIN_SINGLETON(_token) \
static dispatch_once_t once##_token;\
dispatch_once(&once##_token, ^{\

/*
 只执行一次（这里是结束）
 */
#undef END_SINGLETON
#define END_SINGLETON });


#define APP_CACHES  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_LIBRARY [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define IOS7_AND_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#else
#define IOS7_AND_LATER (0)
#endif

//获取uid
#define getUserID [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]:@"0"
#define setUserID(x) [[NSUserDefaults standardUserDefaults] setObject:x forKey:@"uid"]

//获取unionid
#define getUserUnioni [[NSUserDefaults standardUserDefaults] stringForKey:@"unionid"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"unionid"]:@"0"
#define setUserUnionid(x) [[NSUserDefaults standardUserDefaults] setObject:x forKey:@"unionid"]

//获取DeviceToken
#define getDeviceToken [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"]:@""
#define setDeviceToken(x) [[NSUserDefaults standardUserDefaults] setObject:x forKey:@"DeviceToken"]

//获取loginSecret
#define getLoginSecret [[NSUserDefaults standardUserDefaults] stringForKey:@"loginSecret"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"loginSecret"]:@""
#define setLoginSecret(x) [[NSUserDefaults standardUserDefaults] setObject:x forKey:@"loginSecret"]



#define IOS8_AND_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS9_AND_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS10_AND_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

#define NAVIGATION_BAR_HEIGHT (44.0f)
#define STATUS_BAR_HEIGHT     (20.0f)
#define TOOL_BAR_HEIGHT       (44.0f)
#define TAB_BAR_HEIGHT        (49.0f)
#ifndef DEVICE_IS_IPHONE6
#define DEVICE_IS_IPHONE6 ([[UIScreen mainScreen] bounds].size.height == 667)
#endif

#define USER_APPID           @"5a68247e"

#ifndef DEVICE_IS_IPHONE6Plus
#define DEVICE_IS_IPHONE6Plus ([[UIScreen mainScreen] bounds].size.height == 736)
#endif

#ifndef boundsWidth
#define boundsWidth [UIScreen mainScreen].bounds.size.width
#endif
#ifndef boundsHeight
#define boundsHeight [UIScreen mainScreen].bounds.size.height-STATUS_BAR_HEIGHT
#endif
#ifndef ScreenHeight
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_HEIGHT CGRectGetHeight(SCREEN_BOUNDS)
#define SCREEN_WIDTH  CGRectGetWidth(SCREEN_BOUNDS)
#define SCREEN_SIZE   SCREEN_BOUNDS.size
//对象强转（可针对C、OC两种）
#define OBJ_CONVERT(_type,_name,_obj) _type _name = (_type)(_obj)
//OC对象强转（只针对OC对象）
#define OC_OBJ_CONVERT(_type,_name,_obj,_tag) OBJ_CONVERT(_type *,_name,[_obj viewWithTag:(_tag)])

#define HMSTR(fmt,...) [NSString stringWithFormat:(fmt),##__VA_ARGS__]
#define StringZero(_string) ((( _string ) != nil) && ![( _string ) isKindOfClass:[NSNull class]] && ![( _string ) isEqualToString:@""]) ? ( _string ) : @"0"
#define StringIsNull(_string) ((_string) && (![_string isKindOfClass:[NSNull class]])) ? [NSString stringWithFormat:@"%@",_string] : @""
#define StringNullToDefualt(_string) ((_string) && (![_string isKindOfClass:[NSNull class]])) &&([_string length]>0) ? (_string) : @"---"
#define StringIsNullAndNullMessage(_string,_nullMessage) [StringIsNull(_string) isEqualToString:@""] ? _nullMessage : _string
#define isEmptyList(_list) ({ !(( _list ) && ![( _list ) isKindOfClass:[NSNull class]] && ([( _list ) isKindOfClass:[NSArray class]] || [( _list ) isKindOfClass:[NSDictionary class]]) && [( _list ) count] > 0); })

#define COLORRGB_SAME(r) [UIColor colorWithRed:(r) / 255.0f \
green:(r) / 255.0f \
blue:(r) / 255.0f \
alpha:1.0]

#define COLORRGB(r,g,b) [UIColor colorWithRed:(r) / 255.0f                                 \
green:(g) / 255.0f                                 \
blue:(b) / 255.0f                                 \
alpha:1.0]

#define COLORHEX(hex) [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16)) / 255.0    \
green:((float)(((hex) & 0xFF00) >> 8)) / 255.0       \
blue:((float)((hex) & 0xFF)) / 255.0                \
alpha:1.0]


#define   FSFloat(f)        [FSSizeUtil sizeFloat:f]

#define  DeviceName    [CommonFunc getDeviceName]
//导航栏高度
#define getNavHeight [[[NSUserDefaults standardUserDefaults] objectForKey:@"NavHeight"]integerValue]
#define setNavHeight(x) [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",x] forKey:@"NavHeight"]

#define AC_FUNCTION_CALL(_obj, _fun, ...) \
do { \
if((_obj) && [_obj respondsToSelector:@selector(_fun)]) { \
((void(*)(id, SEL,id))objc_msgSend)(_obj, @selector(_fun), ##__VA_ARGS__); \
} \
} while(0);

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#ifndef DEVICE_IS_IPHONE5
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#endif
#define StringIsNull(_string) ((_string) && (![_string isKindOfClass:[NSNull class]])) ? [NSString stringWithFormat:@"%@",_string] : @""
//快速定义Weakself
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/*************多语言切换定义****************/
#define saveLocalized() [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"saveLocalized"]
#define LocalizedSetted [[NSUserDefaults standardUserDefaults] boolForKey:@"saveLocalized"]

#define AppLanguage @"appLanguage"
#define LocalizedWithKey(key) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]
/*************多语言切换定义****************/
#define HMLog(fmt, ...) NSLog((@"[Time %s] [Function %s] [Name iyun] [Line %d] " fmt),__TIME__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define XH_STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])
#define ContantsOfstring(string,substring) ([string rangeOfString:substring].location!=NSNotFound)


#define NetWorkConnect [[NSUserDefaults standardUserDefaults] stringForKey:@"NetWorkConnect"]
#define URLString(x) [NSURL URLWithString:x]
#define UserDefaultsSync [[NSUserDefaults standardUserDefaults] synchronize]

#define ISNSDictonary(dictionary) ((dictionary) && [dictionary isKindOfClass:[NSDictionary class]]) ? dictionary : @{}

#define SVProgressWithImfor(x) [SVProgressHUD showWithStatus:x]

#define SVProgressWithSuccess(x) [SVProgressHUD showSuccessWithStatus:x ]

#define  tabBarImage(take_image) [[UIImage imageNamed:take_image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]


//获取审核状态 0 表示审核的版本 1表示已经上线
#define getAppStoreStatus [[NSUserDefaults standardUserDefaults] stringForKey:@"AppStoreStatus"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"AppStoreStatus"]:@"0"
#define setAppStoreStatus(x) [[NSUserDefaults standardUserDefaults] setObject:x forKey:@"AppStoreStatus"]

#endif

