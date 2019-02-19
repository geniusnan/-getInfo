//
//  UISearchBar+SearchEnable.h
//  QuickMeet
//
//  Created by Lim on 15/5/11.
//  Copyright (c) 2015年 Lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (SearchEnable)
- (void)alwaysShowSearch:(BOOL)value;
-(void)clearButtonHidden:(BOOL)value;
-(void)font:(UIFont *)fonts;
@end
