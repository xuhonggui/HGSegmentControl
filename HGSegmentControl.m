//
//  HGSegmentControl.m
//  Test
//
//  Created by 许鸿桂 on 2017/7/22.
//  Copyright © 2017年 dlc. All rights reserved.
//

#import "HGSegmentControl.h"

#define kIndicatorWidth 60
#define kIndicatorHeight 2
#define kSeparateLineHeight 20
#define kAnimationTime 0.3f

@interface HGSegmentControlButton : UIButton

@property (nonatomic, strong) UIView *rightLine;

/**
 * 右边线条高度
 */
@property (nonatomic, assign) CGFloat rightLineHeight;

@end

@implementation HGSegmentControlButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    HGSegmentControlButton *btn = [super buttonWithType:buttonType];
    btn.rightLine = [[UIView alloc] init];
    btn.rightLine.backgroundColor = [UIColor lightGrayColor];
    [btn addSubview:btn.rightLine];
    return btn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _rightLine.frame = CGRectMake(CGRectGetWidth(self.frame) - 0.5, (CGRectGetHeight(self.frame) - _rightLineHeight)/2, 0.5, _rightLineHeight);
}

- (void)setRightLineHeight:(CGFloat)rightLineHeight {
    _rightLineHeight = rightLineHeight;
    [self layoutIfNeeded];
}

@end



@interface HGSegmentControl ()
{
    UIView *_indicator;//指示器
    CGFloat *_btnWidth;//按钮宽度
    NSMutableArray *_btnArray;//按钮数组
    NSArray *_titleArray;//标题数组
    UIView *_bottomLine;//底部线条
}


@end

@implementation HGSegmentControl

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)array{
    
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _titleArray = array;
        _btnArray = [NSMutableArray array];
        _indicatorWidth = kIndicatorWidth;
        _indicatorHeight = kIndicatorHeight;
        _separateLineHeight = kSeparateLineHeight;
        _animationTime = kAnimationTime;
        _normalColor = [UIColor lightGrayColor];
        _selectedColor = [UIColor blackColor];
        _indicatorColor = [UIColor lightGrayColor];
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    CGFloat btnW = CGRectGetWidth(self.frame)/_titleArray.count;
    
    for (int i = 0; i < _titleArray.count; i++) {
        [self createButton:_titleArray[i] index:i];
    }
    
    _indicator = [[UIView alloc] init];
    [_indicator setFrame:CGRectMake((btnW - _indicatorWidth)/2, CGRectGetHeight(self.frame) - _indicatorHeight, _indicatorWidth, _indicatorHeight)];
    [_indicator setBackgroundColor:_indicatorColor];
    [self addSubview:_indicator];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    _bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
    [self addSubview:_bottomLine];
}

- (void)createButton:(NSString*)title index:(NSInteger)index {
    
    CGFloat btnW = CGRectGetWidth(self.frame)/_titleArray.count;
    
    HGSegmentControlButton *btn = [HGSegmentControlButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:index];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:_normalColor forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(index * btnW, 0, btnW, CGRectGetHeight(self.frame) - 2)];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setRightLineHeight:_separateLineHeight];
    if (index == _titleArray.count - 1) {
        btn.rightLine.hidden = YES;
    }
    [self addSubview:btn];
    [_btnArray addObject:btn];
    [self updateButton:0];
}

- (void)buttonClick:(UIButton*)sender {
    
    [UIView animateWithDuration:_animationTime animations:^{
        [self updateIndicator:sender.tag];
        [self updateButton:sender.tag];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(HGSegmentControl:didSelectItemAtIndex:)]) {
        [_delegate HGSegmentControl:self didSelectItemAtIndex:sender.tag];
    }
}

- (void)updateIndicator:(NSInteger)index
{
    CGFloat btnW = CGRectGetWidth(self.frame)/_btnArray.count;
    _indicator.frame = CGRectMake((btnW - _indicatorWidth)/2 + index * btnW, CGRectGetHeight(self.frame) - _indicatorHeight, _indicatorWidth, _indicatorHeight);
}

- (void)updateButton:(NSInteger)index
{
    for (UIButton *btn in _btnArray) {
        if (btn.tag == index) {
            btn.selected = YES;
            [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
        }
        else {
            btn.selected = NO;
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setTitleColor:_normalColor forState:UIControlStateNormal];
        }
    }
}

#pragma mark - getter

- (NSInteger)selectedIndex {
    for (UIButton *btn in _btnArray) {
        if (btn.selected) {
            return btn.tag;
        }
    }
    return 0;
}

#pragma mark - setter

- (void)setIndicatorWidth:(CGFloat)indicatorWidth {
    _indicatorWidth = indicatorWidth;
    [self updateIndicator:0];
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight {
    _indicatorHeight = indicatorHeight;
    [self updateIndicator:0];
}

- (void)setSeparateLineHeight:(CGFloat)separateLineHeight {
    _separateLineHeight = separateLineHeight;
    for (HGSegmentControlButton *btn in _btnArray) {
        btn.rightLineHeight = _separateLineHeight;
    }
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    for (UIButton *btn in _btnArray) {
        [btn setTitleColor:_normalColor forState:UIControlStateNormal];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    for (UIButton *btn in _btnArray) {
        [btn setTitleColor:_selectedColor forState:UIControlStateSelected];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    _indicator.backgroundColor = _indicatorColor;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    _bottomLine.backgroundColor = _bottomLineColor;
}

- (void)setSelectItemAtIndex:(NSInteger)index {
    
    [UIView animateWithDuration:_animationTime animations:^{
        [self updateIndicator:index];
        [self updateButton:index];
    }];
}

- (void)setShowsIndicator:(BOOL)showsIndicator {
    _showsIndicator = showsIndicator;
    _indicator.hidden = !_showsIndicator;
}

- (void)setShowsBottomLine:(BOOL)showsBottomLine {
    _showsBottomLine = showsBottomLine;
    _bottomLine.hidden = !_showsBottomLine;
}

- (void)setShowsSeparateLine:(BOOL)showsSeparateLine {
    _showsSeparateLine = showsSeparateLine;
    for (HGSegmentControlButton *btn in _btnArray) {
        btn.rightLine.hidden = !_showsSeparateLine;
    }
}

- (void)setAnimationTime:(CGFloat)animationTime {
    _animationTime = animationTime;
}

@end
