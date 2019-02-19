//
//  NSString+RemoveEmoji.h
//  NiuNiuCircle
//
//  Created by admin on 2017/6/17.
//  Copyright © 2017年 wjcLimText11Lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RemoveEmoji)
- (BOOL)isIncludingEmoji;

- (instancetype)removedEmojiString;
@end
