//
//  PDFamilyDynaPopView.m
//  Pudding
//
//  Created by baxiang on 16/7/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyDynaPopView.h"

@implementation PDFamilyDynaPopView

-(instancetype)initWithFrame:(CGRect)frame withFamilyMoment:(PDFamilyMoment*)moment
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        UIView *popToolView = [UIView new];
        [self addSubview:popToolView];
        popToolView.layer.cornerRadius = 5;
        popToolView.layer.masksToBounds = YES;
        popToolView.backgroundColor = [UIColor whiteColor];
        
        if (moment.type != PDFamilyMomentMess) {
            [popToolView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.left.mas_equalTo(40);
                make.right.mas_equalTo(-40);
                make.height.mas_equalTo(45 * 2);
            }];
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [popToolView addSubview:shareBtn];
            shareBtn.tag = 1003;
            [shareBtn addTarget:self action:@selector(btnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [shareBtn setTitle:NSLocalizedString( @"share", nil) forState:UIControlStateNormal];
            [shareBtn setTitleColor:mRGBToColor(0x505a66) forState:UIControlStateNormal];
            shareBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(45);
                make.top.mas_equalTo(0);
            }];
            
            UIView * sepeView = [UIView new];
            sepeView.backgroundColor = mRGBToColor(0xeaebee);
            [popToolView addSubview:sepeView];
            [sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(shareBtn.mas_bottom);
                make.height.mas_equalTo(1);
            }];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [popToolView addSubview:deleteBtn];
            deleteBtn.tag = 1002;
            [deleteBtn addTarget:self action:@selector(btnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setTitle:NSLocalizedString( @"delete_", nil) forState:UIControlStateNormal];
            [deleteBtn setTitleColor:mRGBToColor(0x505a66) forState:UIControlStateNormal];
            deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(45);
                make.bottom.mas_equalTo(0);
            }];
            
        }else{
            [popToolView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.left.mas_equalTo(40);
                make.right.mas_equalTo(-40);
                make.height.mas_equalTo(45 );
            }];
            //            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            [popToolView addSubview:shareBtn];
            //            shareBtn.tag = 1003;
            //            [shareBtn addTarget:self action:@selector(btnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            //            [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
            //            [shareBtn setTitleColor:mRGBToColor(0x505a66) forState:UIControlStateNormal];
            //            shareBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            //            [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.left.mas_equalTo(0);
            //                make.right.mas_equalTo(0);
            //                make.height.mas_equalTo(45);
            //                make.top.mas_equalTo(0);
            //            }];
            //
            //            UIView * sepeView = [UIView new];
            //            sepeView.backgroundColor = mRGBToColor(0xeaebee);
            //            [popToolView addSubview:sepeView];
            //            [sepeView mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.left.mas_equalTo(0);
            //                make.right.mas_equalTo(0);
            //                make.top.mas_equalTo(shareBtn.mas_bottom);
            //                make.height.mas_equalTo(1);
            //            }];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [popToolView addSubview:deleteBtn];
            deleteBtn.tag = 1002;
            [deleteBtn addTarget:self action:@selector(btnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setTitle:NSLocalizedString( @"delete_", nil) forState:UIControlStateNormal];
            [deleteBtn setTitleColor:mRGBToColor(0x505a66) forState:UIControlStateNormal];
            deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(45);
                make.bottom.mas_equalTo(0);
            }];
            
            
        }
        
    }
    return self;
}


-(void)hideView{
    [self removeFromSuperview];
}
-(void)btnClickHandle:(UIButton*)btn{
    if (_currSelect) {
        _currSelect(self,btn.tag);
    }
}
@end
