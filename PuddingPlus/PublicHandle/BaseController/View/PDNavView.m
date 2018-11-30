//
//  PDLoginNavView.m
//  Pudding
//
//  Created by william on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDNavView.h"

typedef NS_ENUM(NSUInteger, PDNavBarButtonType) {
    PDNavBarButtonTypeLeft,
    PDNavBarButtonTypeRight,
};


@interface PDNavView()


@end

@implementation PDNavView

#pragma mark ------------------- 初始化 ------------------------
+(instancetype)viewWithFrame:(CGRect)frame leftItem:(PDNavItem *)leftItem rightItem:(PDNavItem *)rightItem{
    return [[self alloc]initWithFrame:frame leftItem:leftItem rightItem:rightItem];
}
-(instancetype)initWithFrame:(CGRect)frame leftItem:(PDNavItem *)leftItem rightItem:(PDNavItem *)rightItem{
    if (self = [super initWithFrame:frame]) {
        if (leftItem!=nil) {
            self.leftItem = leftItem;
        }
        if (rightItem!=nil) {
            self.rightItem = rightItem;
        }
        self.lineView.hidden = NO;
    }
    return self;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.lineView.frame  =CGRectMake(0, self.height - 1, self.width, 1);
    
}

#pragma mark ------------------- LazyLoad ------------------------
/** 按钮宽度 */
static const CGFloat kBtnWidth = 55;
#pragma mark - 创建 -> 左边按钮
-(PDNavBarButton *)leftBtn{
    if (!_leftBtn) {
        PDNavBarButton * btn = [PDNavBarButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _leftBtn = btn;
    }
    _leftBtn.frame = CGRectMake(0, STATE_HEIGHT, kBtnWidth, self.height - STATE_HEIGHT);
    return _leftBtn;
}

#pragma mark - 创建 -> 右边按钮
-(PDNavBarButton *)rightBtn{
    if (!_rightBtn) {
        PDNavBarButton*btn = [PDNavBarButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _rightBtn = btn;
    }
    _rightBtn.frame = CGRectMake(self.width - kBtnWidth, STATE_HEIGHT,kBtnWidth, self.height - STATE_HEIGHT);

    return _rightBtn;
}


//static const CGFloat kTop = (IS_IPHONE_X==YES)?44.0f: 20.0f;
#pragma mark - 创建 -> 标题文本
-(UILabel *)titleLab{
    if (!_titleLab) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.width*0.25, STATE_HEIGHT, self.width*0.5, self.height - STATE_HEIGHT)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont boldSystemFontOfSize:18];
        lab.textColor = [UIColor blackColor];
        [self addSubview:lab];
        _titleLab = lab;
    }
    return _titleLab;
}

#pragma mark - 创1建 -> 底部的线
-(UIView *)lineView{
    if (!_lineView) {
        UIView *vi  =[[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        vi.backgroundColor = mRGBColor(208, 210, 213);
        [self addSubview:vi];
        _lineView = vi;
    }
    return _lineView;
}

#pragma mark ------------------- Action ------------------------
#pragma mark - action: 设置左按钮的数据
-(void)setLeftItem:(PDNavItem *)leftItem{
    _leftItem = leftItem;
    if (_leftItem ==nil&&_leftBtn) {
        self.leftBtn.hidden = YES;
    }else{
        self.leftBtn.item = leftItem;
    }
}

#pragma mark - action: 设置右按钮的数据
-(void)setRightItem:(PDNavItem *)rightItem{
    _rightItem = rightItem;
    self.rightBtn.item = rightItem;
    if (_rightItem ==nil&&_rightBtn) {
        self.rightBtn.hidden = YES;
    }else{
        self.rightBtn.item = _rightItem;
    }
}
#pragma mark - action: 左边点击回调
- (void)leftBarButtonClick{
    self.leftBtn.selected = !self.leftBtn.selected;
    
    if (self.leftCallBack) {
        self.leftCallBack(self.leftBtn.selected);
    }
}
#pragma mark - action: 右边点击回调
- (void)rightBarButtonClick{
    self.rightBtn.selected = !self.rightBtn.selected;
    if (self.rightCallBack) {
        self.rightCallBack(self.rightBtn.selected);
    }
}
#pragma mark - action: 设置标题
-(void)setTitle:(NSString *)title{
    _title = title;
    if (title&&title.length>0) {
        self.titleLab.hidden = NO;
        self.titleLab.text = title;
    }else{
        self.titleLab.hidden = YES;
    }
}
#pragma mark - action: 隐藏左按钮
-(void)hideLeftBtn{
    self.leftItem = nil;
}
#pragma mark - action: 隐藏右按钮
-(void)hideRightBtn{
    self.rightItem = nil;
}

@end
