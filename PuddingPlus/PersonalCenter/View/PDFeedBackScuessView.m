//
//  PDFeedBackScuessView.m
//  PuddingPlus
//
//  Created by kieran on 2017/9/12.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDFeedBackScuessView.h"

@interface PDFeedBackScuessView()
@property (nonatomic,weak) UIView       * bgView;
@property (nonatomic,weak) UIImageView  * iconView;
@property (nonatomic,weak) UILabel      * tipLable;
@end


@implementation PDFeedBackScuessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = mRGBAToColor(0x000000, 0);
        self.bgView.hidden = YES;
        self.iconView.hidden = NO;
        self.tipLable.hidden = NO;
    }
    return self;
}


- (void)showAnimail{
    self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
    self.bgView.hidden = NO;

    @weakify(self)
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        @strongify(self)
        self.backgroundColor = mRGBAToColor(0x000000, 0.4);
        self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hiddAnimail{
    @weakify(self)
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        @strongify(self)
        self.backgroundColor = mRGBAToColor(0x000000, 0);
        self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
    } completion:^(BOOL finished) {
        @strongify(self)

        [self removeFromSuperview];
    }];

}

- (UIView *)bgView{
    if(!_bgView){
        UIView * view = [[UIView alloc] init];
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = SX(10);
        view.clipsToBounds = YES;
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(-SX(20));
            make.left.equalTo(@(SX(65)));
            make.right.equalTo(self.mas_right).offset(-SX(65));
            make.height.equalTo(@(SX(280)));
        }];
        
        _bgView = view;
    }
    return _bgView;
}

- (UIImageView *)iconView{
    if(!_iconView){
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeCenter;
        if (RBDataHandle.currentDevice.isPuddingPlus) {
            imageView.image = [UIImage imageNamed:@"ic_buding_doudou"];
        }else if (RBDataHandle.currentDevice.isStorybox){
            imageView.image = [UIImage imageNamed:@"ic_buding_minidou"];
        }else{
            imageView.image = [UIImage imageNamed:@"ic_buding_s"];
        }
        [self.bgView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(SX(28));
            make.top.equalTo(self.bgView.mas_top).offset(SX(28));
            make.right.equalTo(self.bgView.mas_right).offset(-SX(28));
            make.height.equalTo(@(SX(132)));
        }];
        
        _iconView = imageView;
    }
    return  _iconView;
}

- (UILabel *)tipLable{
    if(!_tipLable){

        UILabel * lable = [UILabel new];
        lable.numberOfLines = 0;
        lable.lineBreakMode = NSLineBreakByWordWrapping;
        lable.font = [UIFont systemFontOfSize:SX(15)];
        lable.textColor = mRGBToColor(0x4a4a4a);
        
        NSMutableAttributedString * content = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString( @"your_feedback_received_we_will_deal_with_it_in_time", nil)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [paragraphStyle setLineSpacing:SX(8)];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,content.length)];
        [content addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x4a4a4a) range:NSMakeRange(0,content.length)];
        [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(15)] range:NSMakeRange(0,content.length)];
        
        lable.attributedText = content;
        [self.bgView addSubview:lable];

        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(SX(26));
            make.left.equalTo(self.bgView.mas_left).offset(SX(28));
            make.right.equalTo(self.bgView.mas_right).offset(-SX(28));
        }];
        
        _tipLable = lable;
    }
    return _tipLable;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddAnimail];
}

@end
