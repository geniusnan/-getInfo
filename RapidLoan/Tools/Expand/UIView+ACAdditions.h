//
//  UIView+ACAdditions.h
//  ACCommon
//
//  Created by 曉星 on 14-5-2.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ACAdditions)

#pragma mark - Frame Simplify

@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint origin;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
#pragma mark - View Snapshot

- (UIImage *)snapshot;
- (void)saveSnapshotToPhotosAlbum;

@end
