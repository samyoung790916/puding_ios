//
//  RBBabyVoiceSelectView.m
//  PuddingPlus
//
//  Created by baxiang on 2017/6/23.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBBabyVoiceSelectView.h"
@interface RBBabyVoiceSelectView()
@property(nonatomic,weak)UIImageView *iconImageView;
@property(nonatomic,weak)UILabel *titleView;
@end

@implementation RBBabyVoiceSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

-(void)setupSubView{
    UIImageView *iconImageView = [UIImageView new];
    [self.contentView addSubview:iconImageView];
    iconImageView.userInteractionEnabled = YES;
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(70);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    iconImageView.layer.cornerRadius = 35.0f;
    iconImageView.layer.masksToBounds = YES;
    self.iconImageView = iconImageView;
    UILabel *titleView = [UILabel new];
    titleView.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
    }];
    titleView.font = [UIFont systemFontOfSize:13];
    titleView.textColor = UIColorHex(0x787878);
    self.titleView = titleView;
    
    UIButton *seletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:seletBtn];
    [seletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [seletBtn addTarget:self action:@selector(selectBellHandle) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectBellHandle{
    [self rb_play_type:RBSourceMorning Catid:nil SourceId:[NSString stringWithFormat:@"%@",_bell.srcid] Error:^(NSString *error) {
        if(error == nil){
          
//            [self.listenBtn setSelected:YES];
//            if (self.playStateBlock) {
//                self.playStateBlock(YES,self.order);
//            }
//            [MitLoadingView showSuceedWithStatus:[NSString stringWithFormat:@"%@%@",R.start_play,self.categoryArray[_order]]];
            
        }else{
            [MitLoadingView showNoticeWithStatus:error];
        }
    }];

    
    if (_selectBellBlock) {
        _selectBellBlock(_bell,_index);
    }
}


-(void)setBell:(PDAlarmbell *)bell{
    _bell = bell;
    if (bell.bellID==0&&[bell.title isEqualToString:NSLocalizedString( @"gentle_girl", nil)]) {
        self.iconImageView.image = [UIImage imageNamed:@"wenrounvsheng"];
    }else{
        [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bell.img]] placeholder:[UIImage imageNamed:@"baby_zhanwei"]];
    }
  
    self.titleView.text = bell.title;
    if (bell.selected) {
        self.titleView.textColor = UIColorHex(0x29c6ff);
        self.iconImageView.layer.borderWidth= 2;
        self.iconImageView.layer.borderColor = [UIColorHex(0x29c6ff) CGColor];
    }else{
        self.titleView.textColor = UIColorHex(0x787878);
        self.iconImageView.layer.borderWidth= 0;
        self.iconImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
}
@end
