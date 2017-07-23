//
//  HGSegmentControl.h
//  Test
//
//  Created by 许鸿桂 on 2017/7/22.
//  Copyright © 2017年 dlc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGSegmentControl;

@protocol HGSegmentControlDelegate <NSObject>

@optional
- (void)HGSegmentControl:(HGSegmentControl*)segmentControl didSelectItemAtIndex:(NSInteger)index;

@end

@interface HGSegmentControl : UIView

@property (nonatomic, weak) id<HGSegmentControlDelegate> delegate;

/**
 * 当前选中的索引
 */
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

/**
 * 指示器宽度
 */
@property (nonatomic, assign) CGFloat indicatorWidth;

/**
 * 指示器高度
 */
@property (nonatomic, assign) CGFloat indicatorHeight;

/**
 * 分割线高度
 */
@property (nonatomic, assign) CGFloat separateLineHeight;

/**
 * 普通状态字体颜色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 * 选中状态字体颜色
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 * 指示器颜色
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
 * 底部线条颜色
 */
@property (nonatomic, strong) UIColor *bottomLineColor;

/**
 * 是否显示指示器
 */
@property (nonatomic, assign) BOOL showsIndicator;

/**
 * 是否显示底部线条
 */
@property (nonatomic, assign) BOOL showsBottomLine;

/**
 * 是否显示分割线
 */
@property (nonatomic, assign) BOOL showsSeparateLine;

/**
 * 动画持续时间
 */
@property (nonatomic, assign) CGFloat animationTime;

/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)array;

/**
 * 设置选中的索引
 */
- (void)setSelectItemAtIndex:(NSInteger)index;

@end
