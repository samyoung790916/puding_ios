//
//  PDManageCornerButton.m
//  Pudding
//
//  Created by william on 16/3/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDManageCornerButton.h"


@interface PDManageCornerButton()
/** 主要按钮 */
@property (nonatomic, weak) UIButton *mainBtn;

@end
@implementation PDManageCornerButton

#pragma mark - 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    self.mainBtn.center = CGPointMake(self.width*0.5, self.height*0.5);

}

#pragma mark - 创建 -> 主要按钮
static const CGFloat kEdge = 13;
- (UIButton *)mainBtn{
    if (!_mainBtn) {
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, self.width - SX(kEdge), self.height - SX(kEdge));
        [btn setBackgroundImage:[UIImage imageNamed:@"avatar_member"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = btn.height *0.5;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor clearColor];
        [self addSubview:btn];
        _mainBtn = btn;
    }
    return _mainBtn;
}





-(UIImageView *)tagImgV{
    if (!_tagImgV) {
        UIImageView *vi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_me"]];
        vi.center = CGPointMake(self.mainBtn.width*0.5, self.mainBtn.height*0.9);
        [self.mainBtn addSubview:vi];
        _tagImgV = vi;
    }
    return _tagImgV;
}

#pragma mark - action: 点击回调
- (void)btnClick{
    if (self.clickBack) {
        self.clickBack();
    }
}

#pragma mark - action: 设置图片
-(void)setMainImg:(UIImage *)mainImg{
    _mainImg = mainImg;
    [self.mainBtn setBackgroundImage:mainImg forState:UIControlStateNormal];
}

-(void)setMainImg:(UIImage *)mainImg state:(UIControlState)state{
    
    [self.mainBtn setBackgroundImage:mainImg forState:state];
}



@end
