//
//  WidgetObjc.m
//  RapidLoan
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WidgetObjc.h"
#import "UISearchBar+SearchEnable.h"
@implementation WidgetObjc
+(UILabel *)WidgetLabel:(CGRect)rects font:(UIFont *)font Alignment:(NSTextAlignment)align textColor:(UIColor *)textColor
{
    UILabel *labels=[[UILabel alloc]initWithFrame:rects];
    labels.backgroundColor=[UIColor clearColor];
    labels.font=font;
    labels.frame=rects;
    labels.textAlignment=align;
    labels.textColor=textColor;
    return labels;
}
+(UIScrollView *)WidgetScrollView
{
    UIScrollView *scrolls=[[UIScrollView alloc]initWithFrame:CGRectZero];
    scrolls.backgroundColor=[UIColor clearColor];
    scrolls.showsHorizontalScrollIndicator=NO;
    scrolls.showsVerticalScrollIndicator=NO;
    scrolls.delaysContentTouches = NO;
    scrolls.canCancelContentTouches = YES;
    return scrolls;
}
+(UITextView *)WidgetTextView:(CGRect)rects font:(UIFont *)font  textColor:(UIColor *)textColor enable:(BOOL)editEnble
{
    UITextView *labels=[[UITextView alloc]initWithFrame:rects];
    labels.font=font;
    labels.frame=rects;
    labels.textColor=textColor;
    labels.userInteractionEnabled=editEnble;
    labels.backgroundColor=[UIColor clearColor];
    return labels;
}

+(UIImageView *)WidgetImageView:(CGRect)rects imageName:(NSString *)imageName  superViews:(id )superViews
{
    
    UIImageView*  imageV=[[UIImageView alloc] initWithFrame:rects];
    if(imageName)
    {
        [imageV setImage:[UIImage imageNamed:imageName]];
    }
    if(superViews)
    {
        [superViews addSubview:imageV];
    }
    return imageV;
}
+(UITextField *)WidgetTextField:(CGRect)rects font:(UIFont *)font  textColor:(UIColor *)textColor
{
    
    UITextField *labels=[[UITextField alloc]initWithFrame:rects];
    labels.font=font;
    labels.frame=rects;
    labels.textColor=textColor;
    labels.backgroundColor=[UIColor clearColor];
    return labels;
}
+(UISearchBar *)WidgetSearchBar:(CGRect)rects placeholder:(char *)placeholder superViews:(id)superViews
{
    UISearchBar* _searchBar=[[UISearchBar  alloc] initWithFrame:rects];
    _searchBar.tintColor=[UIColor clearColor];
    _searchBar.hidden=NO;
    _searchBar.showsScopeBar=NO;
    _searchBar.placeholder=[NSString stringWithCString:placeholder  encoding: NSUTF8StringEncoding];
    [CommonFunc SearchBarSettingBg:_searchBar];
    [superViews addSubview:_searchBar];
    
    [_searchBar alwaysShowSearch:YES];
    [_searchBar clearButtonHidden:YES];
    
    return _searchBar;
}

+(UIButton *)WidgetButton:(CGRect)rects font:(UIFont *)font title:(NSString *)title textColor:(UIColor *)textColor superViews:(id)superViews
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=rects;
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    if(textColor)
        [btn setTitleColor:textColor forState:UIControlStateNormal];
    if(title)
        [btn setTitle:title forState:UIControlStateNormal];
    if(font)
        btn.titleLabel.font=font;
    if(superViews)
    {
        [superViews addSubview:btn];
        
    }
    return btn;
}

+(UIButton *)WidgetButtonWithImage:(CGRect)rects imgage:(NSString  *)imagePath Heighted:(NSString *)HeightimagePath  superViews:(id)superViews
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=rects;
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    if(imagePath)
    {
        [btn setImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
    }
    if(HeightimagePath)
    {
        [btn setImage:[UIImage imageNamed:HeightimagePath] forState:UIControlStateSelected];
    }
    if(superViews)
    {
        [superViews addSubview:btn];
    }
    return btn;
}

@end

