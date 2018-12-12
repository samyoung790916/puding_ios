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
        lable.text = @"방대한 그림책을 인공지능이 인식하여 읽고 싶은 페이지를 방송 수준의 성우가 읽어주고 수수한 영어 회화를 구현합니다.  아이들이 다시 책을 읽게 도와드려요!";
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
    

    NSString * title = @"푸딩그림책";
    NSDictionary * attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
            NSForegroundColorAttributeName: [UIColor whiteColor]};
    [title drawInRect:CGRectMake(30, 46, 200, 17) withAttributes:attributes];


}
@end
