//
//  RBClassFirstLoadView.m
//  PuddingPlus
//
//  Created by liyang on 2018/4/19.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBClassFirstLoadView.h"

@implementation RBClassFirstLoadView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    @weakify(self)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RBClassFirstLoadViewShow"];
        @strongify(self)
        [self removeFromSuperview];
    }];
    [self addGestureRecognizer:tap];
    [_confirmBtn setTitle:NSLocalizedString(@"g_confirm", nil) forState:(UIControlStateNormal)];
    PDGrowplan *  growplan  = [RBDataHandle.currentDevice growplan];
    _titleLabel.text = [NSString stringWithFormat:@"根据五大领域为[%@]定制成长指南课程,每周更新,智能熏听",growplan.nickname];
}
- (IBAction)confirmBtnClick:(id)sender {
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RBClassFirstLoadViewShow"];
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
