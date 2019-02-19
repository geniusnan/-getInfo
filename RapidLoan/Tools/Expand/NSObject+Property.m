//
//  NSObject+Property.m
//  NewHMUtil
//
//  Created by iyun on 13-12-8.
//  Copyright (c) 2013年 iSmallStar. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

- (NSDictionary *)propertyDictionary{
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionary];
    
    //属性个数
    unsigned int outCount;
    
    //属性数组
    objc_property_t *property = class_copyPropertyList([self class], &outCount);
    
    //循环取出属性并存在字典中
    for (int i = 0; i < outCount; i++) {
        objc_property_t property_t = property[i];
        
        //获得属性的名称
        NSString *propertyName = [NSString stringWithCString:property_getName(property_t) encoding:NSUTF8StringEncoding];
        
        //从对象中获得指定属性名的属性值
        id propertyValue = [self valueForKey:propertyName];
        
        //属性值不为空时，就封装进字典中
        if (propertyValue) {
            [propertyDic setObject:propertyValue forKey:propertyName];
        }
    }
    
    //释放掉属性数组
    free(property);
    return propertyDic;
}

- (instancetype)excludeNull {
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return self;
}


@end
