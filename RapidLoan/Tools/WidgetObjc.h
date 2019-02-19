//
//  WidgetObjc.h
//  RapidLoan
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WidgetObjc : NSObject
+(UILabel *)WidgetLabel:(CGRect)rects font:(UIFont *)font Alignment:(NSTextAlignment)align textColor:(UIColor *)textColor;

+(UITextView *)WidgetTextView:(CGRect)rects font:(UIFont *)font  textColor:(UIColor *)textColor enable:(BOOL)editEnble;

+(UIImageView *)WidgetImageView:(CGRect)rects imageName:(NSString *)imageName  superViews:(id )superViews;

+(UITextField *)WidgetTextField:(CGRect)rects font:(UIFont *)font  textColor:(UIColor *)textColor;

+(UIButton *)WidgetButton:(CGRect)rects font:(UIFont *)font title:(NSString *)title textColor:(UIColor *)textColor superViews:(id)superViews;

+(UIButton *)WidgetButtonWithImage:(CGRect)rects imgage:(NSString  *)imagePath Heighted:(NSString *)HeightimagePath  superViews:(id)superViews;

+(UISearchBar *)WidgetSearchBar:(CGRect)rects placeholder:(char *)placeholder superViews:(id)superViews;

+(UIScrollView *)WidgetScrollView;
@end
