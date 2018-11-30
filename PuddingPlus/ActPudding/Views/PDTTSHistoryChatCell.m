//
//  PDNearTTSCell.m
//  Pudding
//
//  Created by baxiang on 16/2/29.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSHistoryChatCell.h"

@interface PDTTSHistoryChatCell()
@property (nonatomic,strong)UIImageView *contentBackImage;
@property (nonatomic,strong)UILabel *contentLabel;
//@property (nonatomic,strong)UIView *cellbg;
@property (nonatomic,weak) UIImageView  *headIcon;
@end
@implementation PDTTSHistoryChatCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transform = CGAffineTransformMakeRotation(M_PI);
        self.backgroundColor = [UIColor clearColor];
        [self setupSubView];
    }
    return self;
}
-(void)setupSubView{
    _contentBackImage = [UIImageView new];
    [self.contentView addSubview:_contentBackImage];
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:15];
    [_contentBackImage addSubview:_contentLabel];
    
    UIImageView *headIcon = [UIImageView new];
    [self.contentView addSubview:headIcon];
    if(RBDataHandle.currentDevice.isPuddingPlus){
        headIcon.image = [UIImage imageNamed:@"avatar_beanq"];
    }else{
        headIcon.image = [UIImage imageNamed:@"habit_icon_head"];

    }
    
    self.headIcon = headIcon;
}

- (void)setFrameModel:(PDSpeechFrameModel *)frameModel{
    _frameModel = frameModel;
    [self setSubviewsData];
    [self setSubviewsFrame];
}

-(void)setSubviewsData{
    _contentLabel.text = self.frameModel.contentModel.text;
    UIImage *ttsBgImage= [UIImage imageNamed:@"habit_icon_dialogue"];
    _contentBackImage.image =[ttsBgImage stretchableImageWithLeftCapWidth:ttsBgImage.size.width/2.0 topCapHeight:ttsBgImage.size.height/2.0];
    _contentLabel.textColor = mRGBToColor(0xffffff);
}
-(void)setSubviewsFrame{
    _contentLabel.frame = self.frameModel.contentTextFrame;
    _contentBackImage.frame = self.frameModel.contentBackFrame;
    _headIcon.frame = self.frameModel.contentHeadFrame;
    //_cellbg.frame = CGRectMake(0, 0, SC_WIDTH, self.frameModel.cellHeight);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
