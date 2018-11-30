//
// Created by kieran on 2018/3/1.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookcaseHeaderCell.h"

@interface RBBookcaseHeaderCell ()

@property (nonatomic,weak) UILabel *contentLable;
@property (nonatomic,weak) UIImageView *iconView;

@end



@implementation RBBookcaseHeaderCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){

        self.backgroundColor =  [UIColor clearColor];
        self.contentLable.hidden = NO;
//        self.iconView.hidden = NO;
    }
    return self;
}

- (void)setContentString:(NSString *)contentString{
    self.contentLable.text = contentString;
}

#pragma mark iconVIew 创建

- (UIImageView *)iconView{
    if(!_iconView){
        UIImageView * imageView = [UIImageView new];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[UIImage imageNamed:@"pudding_english"]];
        [self addSubview:imageView];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@(155));
            make.height.equalTo(@(146));
        }];
        _iconView = imageView;
    }
    return _iconView;
}

- (UILabel *)contentLable{
    if(!_contentLable){
        UILabel * lable = [UILabel new];
        lable.font = [UIFont systemFontOfSize:13];
        lable.textColor = [UIColor whiteColor];
        [self addSubview:lable];
        lable.numberOfLines = 0 ;
        lable.text = @"智能识别海量纸质绘本，翻到哪页读哪页，播音级人声讲读，纯正的英语口语，让孩子回归纸质阅读。";
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(30));
            make.top.equalTo(@(70));
            make.right.equalTo(self.mas_right).offset(-144);
            make.height.mas_lessThanOrEqualTo(@(50));
        }];
        _contentLable = lable;
    }
    return _contentLable;
}


- (void)drawRect:(CGRect)rect{

//    UIBezierPath * beginPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(13, 23, SC_WIDTH - 26, rect.size.height - 46) cornerRadius:15];
//
//    [beginPath setLineWidth:5];
//    [beginPath setLineJoinStyle:kCGLineJoinRound];
//    [[UIColor colorWithWhite:1 alpha:0.5] setStroke];
//
//    [beginPath stroke];
    
    UIImage * image = [UIImage imageNamed:@"bg_picturebooks_introduce"];
    [image drawInRect:CGRectMake(0, 0, self.width, SX(160))];
    

    NSString * title = @"布丁绘本伴读";
    NSDictionary * attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
            NSForegroundColorAttributeName: [UIColor whiteColor]};
    [title drawInRect:CGRectMake(30, 46, 200, 17) withAttributes:attributes];


}
@end
