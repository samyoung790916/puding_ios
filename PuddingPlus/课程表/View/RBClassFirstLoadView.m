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
    _titleLabel.text = [NSString stringWithFormat:@"5대 주요 영역을 베이스로 한 [%@]의 맞춤 성장 가이드 커리큘럼",growplan.nickname];
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
