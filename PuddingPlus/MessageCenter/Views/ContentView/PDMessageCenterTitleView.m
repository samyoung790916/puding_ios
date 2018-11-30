//
//  PDMessageCenterTitleView.m
//  Pudding
//
//  Created by william on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterTitleView.h"

@interface PDMessageCenterTitleView()
/** 标题数组 */
@property (nonatomic, strong) NSArray * items;
/** 颜色 */
@property (nonatomic, strong) UIColor * color;
/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray * btnArr;
/** 底部线条 */
@property (nonatomic, weak) UIView *lineV;
@end

@implementation PDMessageCenterTitleView

#pragma mark ------------------- 初始化 ------------------------
+(instancetype)viewWithFrame:(CGRect)frame Items:(NSArray *)items Color:(UIColor *)color{
    return [[self alloc]initWithFrame:frame Items:items Color:color];
}
-(instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)items Color:(UIColor *)color{
    if (self = [super initWithFrame:frame]) {
        self.items = items;
        self.color = color;
        self.lineV.backgroundColor = self.color;
        [self createButtons];
    }
    return self;
}

#pragma mark - 创建 -> 按钮
- (void)createButtons{
    for (NSInteger i = 0; i<2; i++) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*self.width*0.5, 0, self.width*0.5, self.height - kLineHeight);
        [btn setTitle:self.items[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:self.color forState:UIControlStateSelected];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btnArr addObject:btn];
    }
}
#pragma mark - 创建 -> 按钮数组
-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        NSMutableArray * arr = [NSMutableArray array];

        _btnArr = arr;
    }
    return _btnArr;
}

static const CGFloat kLineHeight = 2;
#pragma mark - 创建 -> 线视图
-(UIView *)lineV{
    if (!_lineV) {
        UIView*vi = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width*0.5, kLineHeight)];
        [self addSubview:vi];
        _lineV = vi;
    }
    return _lineV;
}



#pragma mark - action: 按钮点击回调
- (void)btnClick:(UIButton*)btn{
    for (NSInteger i = 0; i<_btnArr.count; i++) {
        UIButton*button = self.btnArr[i];
        button.selected = NO;
        button.userInteractionEnabled = YES;
    }
    btn.selected = YES;
    btn.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineV.center = CGPointMake(btn.center.x, self.lineV.center.y);
    }];    
    
    if (btn ==[self.btnArr firstObject]) {
        if (self.callBack) {
            self.callBack(PDMessageCenterTitleTypeLeft);
        }
    }else{
        if (self.callBack) {
            self.callBack(PDMessageCenterTitleTypeRight);
        }
    }
}
#pragma mark - action: 点击第几个按钮
-(void)clickNumOfBtns:(NSInteger)num{
    [self btnClick:self.btnArr[num]];
}

@end
