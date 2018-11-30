//
//  PDMorningGuideCell.m
//  Pudding
//
//  Created by baxiang on 16/7/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMorningGuideCell.h"
#import "NSObject+RBPuddingPlayer.h"


@interface PDMorningGuideCell()
@property (nonatomic,strong) NSArray *categoryArray;
@property (nonatomic,strong) NSArray *photoArray;
@property (nonatomic,strong) NSArray *desrArray;
@end
@implementation PDMorningGuideCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.categoryArray = @[NSLocalizedString( @"animal_wake_up_baby", nil),NSLocalizedString( @"english_song_everyday", nil),NSLocalizedString( @"two_songs_everyday", nil)];
        self.desrArray = @[NSLocalizedString( @"prompt_placeholder_muss", nil),NSLocalizedString( @"prompt_placeholder_muss_2", nil),NSLocalizedString( @"prompt_placeholder_muss_3", nil)];
        [self setupSubView];
    }
    return self;
}
-(void)setupSubView{

    UIView *containerView = [UIView new];
    [self addSubview:containerView];
    containerView.backgroundColor =[UIColor whiteColor];
    containerView.layer.cornerRadius = 10.0f;
    containerView.layer.masksToBounds = YES;
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    UIImageView *guideImageView =  [UIImageView new];
    [containerView addSubview:guideImageView];
    guideImageView.userInteractionEnabled = YES;
    guideImageView.clipsToBounds = YES;
    CGFloat height  = [UIScreen mainScreen].bounds.size.height;
    [guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        if (height<=480) {
            make.height.mas_equalTo(167);
        }
        if (height==568.0f) {
            make.height.mas_equalTo(237);
        }
    }];
    self.guideImageView = guideImageView;
    
    UILabel *titleLabel = [UILabel new];
    [containerView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = mRGBToColor(0x505050);;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(guideImageView.mas_bottom).offset(20);
    }];
    self.titleLabel = titleLabel;
    
    UILabel *descLabel = [UILabel new];
    [containerView addSubview:descLabel];
    descLabel.numberOfLines = 0;
    descLabel.font = [UIFont systemFontOfSize:13];
    descLabel.textColor = mRGBToColor(0x787878);
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
    }];
    self.descLabel = descLabel;
    
    UIButton *listenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [guideImageView addSubview:listenBtn];
    [listenBtn setTitleColor:mRGBToColor(0xffffff) forState:UIControlStateNormal];
    [listenBtn setImage:[UIImage imageNamed:@"baby_icon_play_blue"] forState:UIControlStateSelected];
    [listenBtn setImage:[UIImage imageNamed:@"baby_icon_play"] forState:UIControlStateNormal];
    [listenBtn setBackgroundImage:[UIImage imageNamed:@"baby_bg_play_blue"] forState:UIControlStateSelected];
    [listenBtn setBackgroundImage:[UIImage imageNamed:@"baby_bg_play"] forState:UIControlStateNormal];
    listenBtn.adjustsImageWhenHighlighted = NO;
    [listenBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    listenBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [listenBtn.titleLabel  sizeToFit];
    listenBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [listenBtn addTarget:self action:@selector(playMorningCallResource) forControlEvents:UIControlEventTouchUpInside];
    self.listenBtn = listenBtn;

    [listenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        if ([UIScreen mainScreen].bounds.size.height>568) {
            make.bottom.mas_equalTo(-15);
        }else{
            make.bottom.mas_equalTo(-3);
        }
        make.height.mas_equalTo(35);
    }];
    @weakify(self)
    [self rb_playStatus:^(RBPuddingPlayStatus status) {
        @strongify(self)
        if(status == RBPlayLoading){
            //[MitLoadingView showWithStatus:@"正在加载"];
           // [self.listenBtn setSelected:YES];
        }else if( status == RBPlayPlaying){
           // [self.listenBtn setSelected:YES];
            //[MitLoadingView dismiss];
        }else if(status == RBPlayNone  || status == RBPlayPause){
           // [self.listenBtn setSelected:NO];
        }
        
    }];

}
-(void)setResource:(PDEnglishResources *)resource{
    _resource = resource;
    if (_resource) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",resource.step_name];
        NSString *name = [NSString stringWithFormat:@"%@",resource.title];
        if (_order==0) {
            name = [NSString stringWithFormat:NSLocalizedString( @"listen_xx_music", nil),name];
        }else{
            name = [NSString stringWithFormat:NSLocalizedString( @"listen_xx", nil),name];
        }
        if (name.length>8) {
            name = [NSString stringWithFormat:@"%@...",[name substringToIndex:8]];
        }
        self.descLabel.text = resource.desc;
        [self.listenBtn setHidden:NO];
        [self.listenBtn setTitle:[NSString stringWithFormat:@"%@",name] forState:UIControlStateNormal];
        
      
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.categoryArray objectAtIndexOrNil:_order]];
        [self.listenBtn setHidden:YES];
        self.descLabel.text = [self.desrArray objectAtIndexOrNil:_order];
    }
   
}


-(void)playMorningCallResource{
    
    
    if (self.listenBtn.isSelected) {
        @weakify(self)
        [self.topViewController rb_f_stop:^(NSString *error) {
            @strongify(self)
            if(error){
                [MitLoadingView showNoticeWithStatus:error];
            }else{
                @strongify(self)
                //[self.listenBtn setSelected:NO];
                if (self.playStateBlock) {
                    self.playStateBlock(NO,self.order);
                }
            }
            
        }];
    }else{
        switch (_order) {
            case 0:
                [RBStat logEvent:PD_MORNING_ALARM_MUSIC message:nil];
                break;
            case 1:
                [RBStat logEvent:PD_MORNING_ALARM_SONG message:nil];
                break;
            case 2:
                [RBStat logEvent:PD_MORNING_ALARM_HABIT message:nil];
                break;
            default:
                break;
        }
        
        @weakify(self)
        [self rb_play_type:RBSourceMorning Catid:nil SourceId:[NSString stringWithFormat:@"%ld",(long)_resource.srcid] Error:^(NSString *error) {
            @strongify(self)
            if(error == nil){
                @strongify(self)
                [self.listenBtn setSelected:YES];
                if (self.playStateBlock) {
                    self.playStateBlock(YES,self.order);
                }
                [MitLoadingView showSuceedWithStatus:[NSString stringWithFormat:@"%@%@",R.start_play,_resource.title]];

            }else{
                [MitLoadingView showNoticeWithStatus:error];
            }
        }];
    }
}

- (void)dealloc
{
    NSLog(@"%@",self.class);
}
@end
