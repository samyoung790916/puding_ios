//
//  PDMainMenuHeader.m
//  PuddingPlus
//
//  Created by kieran on 2017/9/15.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainMenuHeader.h"
#import "RBHomeMessage.h"
@interface PDMainMenuHeader()

@property (nonatomic,weak) UIButton    * headViewButton;

@property (nonatomic,weak) UILabel     * babyNameLable;

@property (nonatomic,weak) UILabel     * babyAgeLable;

@property (nonatomic,weak) UILabel     * deviceInfoLable;

@property (nonatomic,weak) UIImageView * arrawImage;

@property (nonatomic,assign) BOOL hasBabyInfo;

@end

@implementation PDMainMenuHeader

#pragma mark - init view


- (UIButton *)headViewButton{
    if(!_headViewButton){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = SX(53)/2.f;
        button.userInteractionEnabled = NO;
        button.clipsToBounds = YES;
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SX(15));
            make.width.height.mas_equalTo(SX(53));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        _headViewButton = button;
    }
    return _headViewButton;
}


- (UILabel *)babyNameLable{
    if(!_babyNameLable){
        UILabel * lable = [UILabel new];
        lable.textColor = mRGBToColor(0x4a4a4a);
        lable.font = [UIFont systemFontOfSize:SX(17)];
        [self addSubview:lable];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(-SX(11));
            make.left.equalTo(self.headViewButton.mas_right).offset(SX(16));
        }];
        
        _babyNameLable = lable;
    }
    return _babyNameLable;
}



- (UILabel *)babyAgeLable{
    if(!_babyAgeLable){
        UILabel * lable = [UILabel new];
        lable.textColor = mRGBToColor(0x4a4a4a);
        lable.layer.cornerRadius = SX(9);
        lable.layer.borderColor = mRGBToColor(0x8ec61a).CGColor;
        lable.layer.borderWidth = 0.5;
        lable.clipsToBounds = YES;
        lable.font = [UIFont systemFontOfSize:SX(17)];
        [lable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:lable];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.babyNameLable.mas_right).offset(SX(8));
            make.height.equalTo(@(SX(18)));
            make.centerY.equalTo(self.babyNameLable.mas_centerY);
        }];
        
        _babyAgeLable = lable;
    }
    return _babyAgeLable;
}


- (UILabel *)deviceInfoLable{
    if(!_deviceInfoLable){
        UILabel * lable = [UILabel new];
        lable.font = [UIFont systemFontOfSize:SX(13)];
        lable.textColor = mRGBToColor(0x9b9b9b);
        [lable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:lable];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(SX(15));
            make.left.equalTo(self.babyNameLable.mas_left);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-SX(42));
        }] ;
        
        _deviceInfoLable = lable;
    }
    return _deviceInfoLable;
}

- (UIImageView *)arrawImage{
    if(!_arrawImage){
        UIImageView * image = [UIImageView new] ;
        image.image = [UIImage imageNamed:@"ic_home_message_more_green"];
        [self addSubview:image];
        
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-SX(15));
            make.width.equalTo(@(SX(6)));
            make.height.equalTo(@(SX(9.5)));
        }] ;
        
        _arrawImage = image;
    }
    return _arrawImage;
}

#pragma mark -
- (void)setBabyAge:(NSString *)age{
    NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",age]];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(10)] range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:SX(2)] range:NSMakeRange(0, 1)];
    [attributedStr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:SX(2)] range:NSMakeRange(attributedStr.length-1, 1)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x8ec61a) range:NSMakeRange(0, attributedStr.length)];
    self.babyAgeLable.attributedText = attributedStr;
}

#pragma mark -

- (void)updatebabyNameLableFrame{
    if([self.deviceInfoLable.text mStrLength] > 0){
        self.deviceInfoLable.text = self.deviceInfoLable.text;
    }else{
        self.deviceInfoLable.text = self.growplan.tips;
    }
}

- (void)setGrowplan:(PDGrowplan *)growplan{
    _growplan = growplan;
    self.backgroundColor = [UIColor whiteColor];

    
    self.headViewButton.hidden = NO;
    self.babyAgeLable.hidden = YES;
    self.arrawImage.hidden = YES;
    
    
    NSString * st = RBDataHandle.currentDevice.isPuddingPlus ? @"ic_home_message_more_green" : @"icon_home_message_more_blue";
    self.arrawImage.image = [UIImage imageNamed:st];

    [self updatebabyNameLableFrame];
    if([growplan.age mStrLength] > 0){
        self.hasBabyInfo = YES;
        self.babyAgeLable.hidden = NO;
        self.arrawImage.hidden = NO;
        [self setBabyAge:growplan.age];
        self.babyNameLable.text = growplan.nickname;
        if (growplan.img.length>0) {
            [self.headViewButton setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",growplan.img]] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"ic_home_head"]];
        }
        else{
            [self.headViewButton setImage:[UIImage imageNamed:@"btn_add_baby"] forState:UIControlStateNormal];
        }
    }else{
        self.hasBabyInfo = NO;
        self.babyNameLable.text = NSLocalizedString( @"go_to_fill_baby_info", nil);
        [self.headViewButton setImage:[UIImage imageNamed:@"btn_add_baby"] forState:UIControlStateNormal];
        self.deviceInfoLable.text = NSLocalizedString( @"let_pudding_select_best_content_for_baby", nil);
        
    }
}

- (void)setDeviceInfoModle:(RBHomeMessage *)deviceInfoModle{
    _deviceInfoModle = deviceInfoModle;
    if(deviceInfoModle.content)
    self.deviceInfoLable.text = deviceInfoModle.content;
    [self updatebabyNameLableFrame];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if(!self.hasBabyInfo || !self.deviceInfoModle || [self.deviceInfoModle.content length] == 0){
        if(self.babyInfoBlock){
            self.babyInfoBlock();
        }
        return;
    }
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    if(point.x < self.babyNameLable.left){
        if(self.babyInfoBlock){
            self.babyInfoBlock();
        }
    }else{
        
        if(self.deviceMessageBlock){
            [RBStat logEvent:PD_MAIN_MESS_ALTER message:nil];
            if([self.deviceInfoModle.act isEqualToString:@"lesson"]){
                self.deviceMessageBlock(PDMessageLesson,self.deviceInfoModle);
            }else if([self.deviceInfoModle.act isEqualToString:@"moment"]){
                self.deviceMessageBlock(PDMessageMoment,self.deviceInfoModle);
            }else{
                self.deviceMessageBlock(PDMessageUnknow,self.deviceInfoModle);
            }
        }
    }

}



@end
