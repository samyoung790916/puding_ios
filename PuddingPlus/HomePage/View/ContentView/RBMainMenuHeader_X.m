//
//  RBMainMenuHeader_X.m
//  PuddingPlus
//
//  Created by liyang on 2018/5/28.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBMainMenuHeader_X.h"
#import "RBHomeMessage.h"

@interface RBMainMenuHeader_X()
@property (nonatomic,assign) BOOL hasBabyInfo;
@property (weak, nonatomic) IBOutlet UILabel *babyNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *headViewButton;
@property (weak, nonatomic) IBOutlet UILabel *babyAgeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation RBMainMenuHeader_X

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setBabyAge:(NSString *)age{
//    NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",age]];
//    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(10)] range:NSMakeRange(0, attributedStr.length)];
//    [attributedStr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:SX(2)] range:NSMakeRange(0, 1)];
//    [attributedStr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:SX(2)] range:NSMakeRange(attributedStr.length-1, 1)];
//    [attributedStr addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x8ec61a) range:NSMakeRange(0, attributedStr.length)];
    self.babyAgeLabel.text = age;
}

#pragma mark -

- (void)updatebabyNameLableFrame{
//    if([self.deviceInfoLable.text mStrLength] > 0){
//        self.deviceInfoLable.text = self.deviceInfoLable.text;
//    }else{
//        self.deviceInfoLable.text = self.growplan.tips;
//    }
}

- (void)setGrowplan:(PDGrowplan *)growplan{
    _growplan = growplan;
        
    self.headViewButton.hidden = NO;
    self.babyAgeLabel.hidden = YES;
//    self.arrawImage.hidden = YES;
    
    
    [self updatebabyNameLableFrame];
    if([growplan.age mStrLength] > 0){
        self.hasBabyInfo = YES;
        self.babyAgeLabel.hidden = NO;
        [self setBabyAge:growplan.age];
        self.babyNameLabel.text = growplan.nickname;
        if (growplan.img.length>0) {
            [self.headImageView setImageWithURL:[NSURL URLWithString:_growplan.img] placeholder:[UIImage imageNamed:@"ic_home_head"]];
        }
        else{
            self.headImageView.image = [UIImage imageNamed:@"btn_add_baby"];
        }
    }else{
        self.hasBabyInfo = NO;
        self.babyNameLabel.text = NSLocalizedString( @"go_to_fill_baby_info", nil);
        self.headImageView.image = [UIImage imageNamed:@"btn_add_baby"];
//        self.deviceInfoLable.text = NSLocalizedString( @"let_pudding_select_best_content_for_baby", nil);
        
    }
}

- (void)setDeviceInfoModle:(RBHomeMessage *)deviceInfoModle{
    _deviceInfoModle = deviceInfoModle;
    if(deviceInfoModle.content)
//        self.deviceInfoLable.text = deviceInfoModle.content;
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

    if(point.x < self.babyNameLabel.left){
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
