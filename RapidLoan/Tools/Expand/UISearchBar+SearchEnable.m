//
//  UISearchBar+SearchEnable.m
//  QuickMeet
//
//  Created by Lim on 15/5/11.
//  Copyright (c) 2015年 Lim. All rights reserved.
//

#import "UISearchBar+SearchEnable.h"

@implementation UISearchBar (SearchEnable)
- (void) alwaysShowSearch:(BOOL)value
{
    UITextField *textField = [self valueForKey:@"_searchField"];
    [textField setEnablesReturnKeyAutomatically:!value];
}
-(void)clearButtonHidden:(BOOL)value
{
    UITextField *textField = [self valueForKey:@"_searchField"];
    if(value)
    {
        textField.clearButtonMode = UITextFieldViewModeNever;
    }
    else
    {
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
}
-(void)font:(UIFont *)fonts
{
    UITextField *textField = [self valueForKey:@"_searchField"];
    textField.font=fonts;
}
@end
