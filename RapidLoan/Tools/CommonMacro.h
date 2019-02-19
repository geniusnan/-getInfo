//
//  CommonMacro.h
//  HZLWeiBo
//
//  Created by SDMac on 15/6/25.
//  Copyright (c) 2015年 SDMac. All rights reserved.
//

#ifdef DEBUG  // 调试状态,打开LOG功能

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else // 发布状态,关闭LOG功能

#define DLog(fmt, ...)

#endif

/** 弹出提醒视图 */
#define AlertViewShow(s)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提醒",nil) message:s  delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil]; [alert show];}

/** 判断系统版本是否大于ios7 */
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)

/** 是否为苹果5或5s */
#define FourInch ([UIScreen mainScreen].bounds.size.height == 568.0)

/** 物理屏幕的宽 */
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

/** 物理屏幕的高 */
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

/**  随机色(arc4random_uniform(255)获取255以内的无符号随机数) */
#define IWRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

/** 设置颜色 */
#define RGB_COLOR(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]

/** 设置字体大小*/
#define FONT_SIZE(s)  [UIFont ThonburiWithFontSize:(s)]
#define FONT_BoldSIZE(s)  [UIFont BoldThonburiWithFontSize:(s)]

/** 设置字体和字体大小 */
#define FONT_NAMESIZE(a,b)  [UIFont fontWithName:a size:b]

#define TitleFont       [UIFont systemFontOfSize:16]
#define ContentFont     [UIFont systemFontOfSize:14]
#define SmallFont       [UIFont systemFontOfSize:12]


