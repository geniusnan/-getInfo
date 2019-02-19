//
//  NSObject+Property.h
//  NewHMUtil
//
//  Created by iyun on 13-12-8.
//  Copyright (c) 2013年 iSmallStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

/*
 将对象中的属性封装到字典中
 */
- (NSDictionary *)propertyDictionary;

- (instancetype)excludeNull;
@end
