//
//  PDInteractCell.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDInteractCell.h"
#import "UIImageView+YYWebImage.h"

#define bgMarg  SX(8)

#define imageHeight SX(189) //图片高度
#define imageTop    SX(13)  //图片顶部
#define imageMarg   SX(23)  //图片两边距离

#define titleTop    SX(14)  //标题顶部
#define titleHeight SX(19)  //标题高度

#define contentTop  SX(8)   //内容顶部
#define babyinfoTop SX(8)   //宝宝参与度顶部
#define babyinfoHeight SX(15)  //内容高
#define babyinfoBotton SX(30)  //内容底部


#define titleFont   SX(17)  //标题字体
#define contentFont SX(13)  //内容字体


#define titleColor  0X4a4a4a //标题颜色
#define contentColor 0X9b9b9b //内容颜色


float firstViewWidth(int lentgh){

    return contentFont * lentgh;
}


@implementation PDInteractCell{
    UIImageView * bgImage; //背景图片
    UIImageView * iImage;  //故事图片
    UILabel     * titlelable; //标题
    UILabel     * conentLable;//互动故事
    UILabel     * babyInfo   ;//宝宝参与
    
    UILabel     * contentFistLable; //互动故事前缀view
    UILabel     * babyInfoFistLable; //宝宝参与前缀view
    
    UIImageView * maskAgeImage;//适应年纪背景
    UILabel     * mastLable;
    
    
    UIImageView * voiceImage;
    UILabel     * voiceInfo;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        bgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [bgImage setImage:[[UIImage imageNamed:@"story_card"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) ]];
        [self addSubview:bgImage];
        float maxWidth = SC_WIDTH - imageMarg * 2;

        iImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageMarg, imageTop, maxWidth, imageHeight)];
        iImage.layer.cornerRadius = 4;
        iImage.contentMode = UIViewContentModeScaleAspectFill;
        [iImage setClipsToBounds:YES];
        [self addSubview:iImage];
        
        titlelable = [[UILabel alloc] initWithFrame:CGRectMake(imageMarg, iImage.bottom + titleTop, maxWidth, titleHeight)];
        titlelable.text = @"title";
        titlelable.textAlignment = NSTextAlignmentCenter;
        titlelable.font = [UIFont boldSystemFontOfSize:titleFont];
        titlelable.textColor = mRGBToColor(titleColor);
        [self addSubview:titlelable];
        
        contentFistLable = [[UILabel alloc] initWithFrame:CGRectZero];
        contentFistLable.font = [UIFont systemFontOfSize:contentFont];
        contentFistLable.textColor = mRGBToColor(contentColor);
        contentFistLable.text = NSLocalizedString( @"interactive_story_", nil);
        [self addSubview:contentFistLable];
        

        babyInfoFistLable = [[UILabel alloc] initWithFrame:CGRectZero];
        babyInfoFistLable.font = [UIFont systemFontOfSize:contentFont];
        babyInfoFistLable.textColor = mRGBToColor(contentColor);
        babyInfoFistLable.text = NSLocalizedString( @"baby_participation", nil);
        [self addSubview:babyInfoFistLable];
        
        conentLable = [[UILabel alloc] initWithFrame:CGRectZero];
        conentLable.font = [UIFont systemFontOfSize:contentFont];
        conentLable.numberOfLines = 0;
        [conentLable setLineBreakMode:NSLineBreakByWordWrapping];
        conentLable.textColor = mRGBToColor(contentColor);
        [self addSubview:conentLable];
        
        
        babyInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        babyInfo.font = [UIFont systemFontOfSize:contentFont];
        babyInfo.textColor = mRGBToColor(contentColor);
        [self addSubview:babyInfo];
        
        maskAgeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:maskAgeImage];
        
        mastLable = [[UILabel alloc] initWithFrame:CGRectMake(SX(3), 0, 0, 0)];
        mastLable.textColor = [UIColor whiteColor];
        mastLable.font = [UIFont systemFontOfSize:SX(11)];
        [maskAgeImage addSubview:mastLable];
        
        
        voiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(SC_WIDTH - SX(86), SX(167), SX(25), SX(25))];
        [self addSubview:voiceImage];
        voiceImage.image = [UIImage imageNamed:@"story_play"];
        
        voiceInfo = [[UILabel alloc] initWithFrame:CGRectMake(SX(3), 0, 0, 0)];
        voiceInfo.font = [UIFont systemFontOfSize:12];
        voiceInfo.textColor = [UIColor whiteColor];
        [self addSubview:voiceInfo];
        
        NSMutableArray * playLoading = [NSMutableArray new];
        for(int i = 1 ; i <  14 ; i++){
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"story_list_playing_%02d",i]];
            if(image){
                [playLoading addObject:image];
            }
        }
        
        [voiceImage setAnimationImages:playLoading];
        [voiceImage setAnimationDuration:playLoading.count * (1/14)];
        [voiceImage setAnimationRepeatCount:-1];
        
    }
    return self;
}

-(void)setPlaying:(BOOL)playing{

    if(playing){
        if(![voiceImage isAnimating]){
            [voiceImage startAnimating];
        }
    }else{
        [voiceImage stopAnimating];
    }

}

- (void)setDataSource:(PDFeatureModle *)dataSource{
    _dataSource = [dataSource copy];
    [iImage setImageWithURL:[NSURL URLWithString:dataSource.story_img] placeholder:[UIImage imageNamed:@"story_fig_placeholder"]];
    titlelable.text = dataSource.name;
    babyInfo.text = [NSString stringWithFormat:@"%@%%",dataSource.inter_degree];

    [babyInfo sizeToFit];
    
    
    float maxWidth = SC_WIDTH - imageMarg * 2 - firstViewWidth(5);
    conentLable.text = dataSource.keyword_str;
    [contentFistLable sizeToFit];
    CGSize size = [conentLable sizeThatFits:CGSizeMake(maxWidth, 2000)];
    float contentLeft = (contentFistLable.width/2) + ((SC_WIDTH - size.width)/2);
    conentLable.frame = CGRectMake(contentLeft, titlelable.bottom + contentTop, size.width, size.height);
    if([conentLable.text length] == 0){
        contentFistLable.frame = CGRectMake(SC_WIDTH/2 - firstViewWidth(5)/2 - babyInfo.width/2, conentLable.top, 0, contentFistLable.height);
    }else{
        contentFistLable.frame = CGRectMake(conentLable.left - contentFistLable.width, conentLable.top, contentFistLable.width, contentFistLable.height);
    }
    
    [babyInfoFistLable sizeToFit];
    babyInfoFistLable.frame = CGRectMake(contentFistLable.left, conentLable.bottom + babyinfoTop, babyInfoFistLable.width, babyInfoFistLable.height);
    babyInfo.frame = CGRectMake(babyInfoFistLable.right, conentLable.bottom + babyinfoTop, 100, babyInfoFistLable.height);
    bgImage.frame = CGRectMake(bgMarg, 0, SC_WIDTH - bgMarg * 2, babyInfo.bottom + babyinfoBotton);
    
    
    NSString * mastString = @"";
    if([dataSource.min_age intValue] == [dataSource.max_age intValue]){
        mastString = [NSString stringWithFormat:NSLocalizedString( @"age", nil),dataSource.min_age];
    }else if([dataSource.min_age intValue] >= 4){
        mastString = [NSString stringWithFormat:NSLocalizedString( @"_above_xx_age", nil),dataSource.min_age];
    }else{
        mastString = [NSString stringWithFormat:NSLocalizedString( @"_xx-xx_age", nil),dataSource.min_age,dataSource.max_age];
        
        
    }
    mastLable.text =mastString;
    [mastLable sizeToFit];
    
    UIImage * maskImage = nil;
    if([dataSource.max_age intValue] > 4){
        maskImage = [UIImage imageNamed:@"blue"];
    }else{
        maskImage = [UIImage imageNamed:@"oranger"];
    }
    [maskAgeImage setImage:[maskImage resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 29)]];
    maskAgeImage.frame = CGRectMake(iImage.left, iImage.top + SX(5), mastLable.width + SX(14), SX(19.5));
    mastLable.frame = CGRectMake(4, 0, maskAgeImage.width, maskAgeImage.height);
    
    
    NSString * timeStr = @"00:00";
    NSInteger time = [dataSource.duration integerValue];
    if(time > 3600){
        timeStr = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",(int)floor(time/3600) ,(int)floor(time/60)%60,(int)time%60];
    }else{
        timeStr = [NSString stringWithFormat:@"%.2d:%.2d",(int)floor(time/60)%60,(int)time%60];
    }
    voiceInfo.text = timeStr;
    [voiceInfo sizeToFit];
    
    voiceInfo.frame = CGRectMake(iImage.right -  voiceInfo.width - SX(5), iImage.bottom - SX(5)- SX(25), voiceInfo.width, SX(25));
    voiceImage.frame = CGRectMake(voiceInfo.left - SX(5) - SX(25), voiceInfo.top, SX(25), SX(25));
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


+ (float)height:(PDInteractModle *)modle{

    float height = imageTop + imageHeight + titleTop + titleHeight ;
    
    height += contentTop;
    height += [self contentHeight:modle];
    
    height += babyinfoTop;
    height += babyinfoHeight;
    height += babyinfoBotton;
    
    return height;
}


+ (float)contentHeight:(PDInteractModle *)modle{
    if(modle.keyword_str){
        float maxWidth = SC_WIDTH - imageMarg * 2 - firstViewWidth(5);
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        return [modle.keyword_str boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentFont],NSParagraphStyleAttributeName:paragraphStyle}
                                  context:nil].size.height;
    }else{
        return 0;
    }

}
@end
