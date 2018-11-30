//
//  PDInteractDetailViewController.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDInteractDetailViewController.h"
#import "PDInteractModle.h"
#import "NSObject+PDRootImageCache.h"
#import "NSObject+RBPuddingPlayer.h"



@interface PDInteractDetailViewController ()<RBUserHandleDelegate>{
    UIScrollView        * scView;
    PDInteractModle     * dataSource;
    NSArray             * question;
    NSString            * imageURL;
    UIButton            * playBtn;
}

@end

@implementation PDInteractDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialNav];
    [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
    @weakify(self);

    [RBNetworkHandle getStoryDemoMessage:^(id res) {
        @strongify(self);
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            dataSource = [PDInteractModle modelWithDictionary:[[res objectForKey:@"data"] objectForKey:@"demo"]];
            question = [[res objectForKey:@"data"] objectForKey:@"questions"];
            if(![question isKindOfClass:[NSArray class]]){
                question = nil;
            }
            imageURL = [[res objectForKey:@"data"] objectForKey:@"story"];
            [MitLoadingView dismiss];
            [self loadViewData];
            [self loadImageData];

        }else{
            [MitLoadingView dismiss];
        }
        [self isHide];

        NSLog(@"%@",res);
        
    }];
    
    __weak UIButton * weakBtn = playBtn;
    [self rb_playStatus:^(RBPuddingPlayStatus status) {
        if(status == RBPlayLoading){
            [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
            [weakBtn setSelected:YES];
        }else if( status == RBPlayPlaying){
            [weakBtn setSelected:YES];
            [MitLoadingView dismiss];
        }else if(status == RBPlayNone  || status == RBPlayPause){
            [weakBtn setSelected:NO];
        }
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sendStopAction{
    [self rb_f_stop:^(NSString *error) {
        [MitLoadingView showErrorWithStatus:error];
    }];
}

- (void)sendPlayAction:(UIButton *)playcon {
   
    [self rb_play_type:RBSourceStory Catid:dataSource.cid SourceId:[NSString stringWithFormat:@"%@",dataSource.ID] Error:^(NSString *error) {
        if(error){
            [MitLoadingView showErrorWithStatus:error];
            playcon.selected = NO;
        }
    }];

}


- (void)loadImageData{
    
    __weak typeof(scView) weakSc = scView;
    [self loadImage:imageURL PlaceImage:nil CompleBlock:^(UIImage * image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float width = SC_WIDTH - SX(16);
            CGSize size = image.size;
            if(size.width == 0 || size.height == 0)
                return ;
            float sc = size.height/size.width;
            float height = width * sc;
            
            UIImageView * imagev = [[UIImageView alloc] initWithFrame:CGRectMake(SX(8), scView.contentSize.height - SX(40) - SX(15), width, height )];
            imagev.image = image;
            [weakSc addSubview:imagev];
            
            [weakSc setContentSize:CGSizeMake(1, imagev.bottom + SX(40))];
        });
        
    }];
}

- (void)loadViewData{
    float top = [self loadMessageViews:SX(15) SampleArray:question];
    top = [self loadSampleview:top];
    [scView setContentSize:CGSizeMake(0, top + SX(40) )];
}


- (void)initialNav{
    self.title = R.pudding_story_online;
    self.navView.titleLab.textColor = mRGBToColor(0x505a66);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = mRGBToColor(0xf7f7f7);
    
    scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navView.height, SC_WIDTH, SC_HEIGHT - self.navView.height)];
    [self.view addSubview:scView];
    scView.showsVerticalScrollIndicator = NO;
    scView.showsHorizontalScrollIndicator = NO;

    self.nd_bg_disableCover = YES;
}

- (void)playStory:(UIButton *)sender{
    if(dataSource == nil){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"pull_data_failure", nil)];
        return;
    }
    sender.selected = !sender.selected;

    if(sender.selected){
        [self sendPlayAction:sender];
    }else{
        [self sendStopAction];
    }
    NSLog(@"playStory");
}


- (void)isHide {
    if (dataSource) {
        [self hiddenNoDataView];
    } else {
        [self showNoDataView];
    }
}

- (float) loadGeche:(float)top datas:(NSArray *)array{
    NSMutableAttributedString * string = [NSMutableAttributedString new];
    
    for(int i = 0 ; i < array.count ; i++){
        if(i % 2 == 0){
            NSMutableAttributedString * st;
            NSRange rang;
            if(i == 0){
                st = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString( @"story_content", nil),[array objectAtIndex:i]]];
                rang = [st.string rangeOfString:NSLocalizedString( @"story_content_", nil)];
            }else{
                st = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",[array objectAtIndex:i]]];
                rang =NSMakeRange(0, 0);
            }
            
            [st addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x9b9b9b) range:NSMakeRange(rang.length + rang.location, st.string.length - rang.length - rang.location)];
            [st addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x4a4a4a) range:rang];
            [st addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(20)] range:NSMakeRange(0, st.string.length)];
            [string appendAttributedString:st];
        }else{
        
            NSMutableAttributedString * st = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@\n",R.buding,[array objectAtIndex:i]]];
            NSRange rang = [st.string rangeOfString:[NSString stringWithFormat:@"%@：",R.buding]];
            [st addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0xff8440) range:NSMakeRange(rang.length + rang.location, st.string.length - rang.length - rang.location)];
            [st addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0xff8440) range:rang];
            [st addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(20)] range:NSMakeRange(0, st.string.length)];
            [string appendAttributedString:st];
        }
    
    }
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [paragraphStyle setParagraphSpacing:15];
    paragraphStyle.firstLineHeadIndent = SX(20);
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(6, [string length]- 6) ];

    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectZero];
    [scView addSubview:lable];
    lable.numberOfLines = 0;
    [lable setLineBreakMode:NSLineBreakByWordWrapping];
    lable.attributedText = string;
    CGSize size = [string boundingRectWithSize:CGSizeMake(SC_WIDTH - SX(16) * 2, NSUIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    lable.frame = CGRectMake(SX(16), top, size.width, size.height);

    return lable.bottom;
}

- (float)loadSampleview:(float)top{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgImage.userInteractionEnabled = YES;
    [bgImage setImage:[[UIImage imageNamed:@"bng"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 15, 15) ]];

    UIFont * font = [UIFont boldSystemFontOfSize:SX(17)];
    
    UILabel * stitlelable = [[UILabel alloc] initWithFrame:CGRectMake(SX(15), SX(20), SX(300), font.lineHeight)];
    stitlelable.text = NSLocalizedString( @"examp_story", nil);
    stitlelable.font = font;
    stitlelable.textColor = mRGBToColor(0X4a4a4a);
    [bgImage addSubview:stitlelable];
    
    UIImageView * iImage = [[UIImageView alloc] initWithFrame:CGRectMake(SX(15), stitlelable.bottom + SX(20), SC_WIDTH - SX(15 * 2) - SX(8 * 2), SX(184))];
    iImage.layer.cornerRadius = 4;
    iImage.image = [UIImage imageNamed:@"story_bng_fox"];
    iImage.contentMode = UIViewContentModeScaleAspectFill;
    [iImage setClipsToBounds:YES];
    [bgImage addSubview:iImage];
    
    UIFont * titleFont = [UIFont boldSystemFontOfSize:SX(17)];
    UIFont * contentFont= [UIFont systemFontOfSize:SX(13)];
    
    UILabel * titlelable = [[UILabel alloc] initWithFrame:CGRectMake(SX(40), iImage.bottom + SX(15), SC_WIDTH - SX(80), titleFont.lineHeight)];
    titlelable.text = NSLocalizedString( @"scoundrel_fox", nil);
    titlelable.textAlignment = NSTextAlignmentCenter;
    titlelable.font = titleFont;
    titlelable.textColor = mRGBToColor(0X4a4a4a);
    [bgImage addSubview:titlelable];
    
    UILabel * contentFistLable = [[UILabel alloc] initWithFrame:CGRectZero];
    contentFistLable.font = contentFont;
    contentFistLable.textColor = mRGBToColor(0X9b9b9b);
    contentFistLable.text = NSLocalizedString( @"interactive_story_", nil);
    [bgImage addSubview:contentFistLable];
    
    
    UILabel * babyInfoFistLable = [[UILabel alloc] initWithFrame:CGRectZero];
    babyInfoFistLable.font = contentFont;
    babyInfoFistLable.textColor = mRGBToColor(0X9b9b9b);
    babyInfoFistLable.text = NSLocalizedString( @"baby_participation", nil);
    [bgImage addSubview:babyInfoFistLable];
    
    UILabel *conentLable = [[UILabel alloc] initWithFrame:CGRectZero];
    conentLable.font = contentFont;
    conentLable.numberOfLines = 0;
    [conentLable setLineBreakMode:NSLineBreakByWordWrapping];
    conentLable.textColor = mRGBToColor(0X9b9b9b);
    [bgImage addSubview:conentLable];
    
    
    UILabel * babyInfo = [[UILabel alloc] initWithFrame:CGRectZero];
    babyInfo.font = contentFont;
    babyInfo.textColor = mRGBToColor(0X9b9b9b);
    [bgImage addSubview:babyInfo];

    UIImageView * voiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(SC_WIDTH - SX(86), SX(167), SX(25), SX(25))];
    [bgImage addSubview:voiceImage];
    voiceImage.image = [UIImage imageNamed:@"story_play"];
    
    UILabel * voiceInfo = [[UILabel alloc] initWithFrame:CGRectMake(SX(3), 0, 0, 0)];
    voiceInfo.font = [UIFont systemFontOfSize:12];
    voiceInfo.textColor = [UIColor whiteColor];
    [bgImage addSubview:voiceInfo];
    
    
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setFrame:CGRectMake((iImage.width - SX(100))/2, (iImage.height - SX(100))/2, SX(100), 100)];
    [playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playStory:) forControlEvents:UIControlEventTouchUpInside];
    [iImage addSubview:playBtn];
    iImage.userInteractionEnabled = YES;
    
    
    if([dataSource.ID intValue] == [RBDataHandle.currentDevice.playinfo.sid intValue] && RBDataHandle.currentDevice.playinfo.sid != nil){
        if([RBDataHandle.currentDevice.playinfo.status isEqualToString:@"start"] ){
            playBtn.selected = YES;
        }
    }
    
    [iImage setImageWithURL:[NSURL URLWithString:dataSource.story_img] placeholder:[UIImage imageNamed:@"story_fig_placeholder"]];
    titlelable.text = dataSource.title;
    babyInfo.text = [NSString stringWithFormat:@"%@%%",dataSource.inter_degree];
    
    [babyInfo sizeToFit];
    
    
    float maxWidth = SC_WIDTH - SX(15) * 2 - contentFont.pointSize * 5;
    conentLable.text = dataSource.keyword_str;
    [contentFistLable sizeToFit];
    CGSize size = [conentLable sizeThatFits:CGSizeMake(maxWidth, 2000)];
    float contentLeft = (contentFistLable.width/2) + ((SC_WIDTH - size.width)/2);
    conentLable.frame = CGRectMake(contentLeft, titlelable.bottom + SX(10), size.width, size.height);
    if([conentLable.text length] == 0){
        contentFistLable.frame = CGRectMake(SC_WIDTH/2 - contentFont.pointSize * 5/2 - babyInfo.width/2, conentLable.top, 0, contentFistLable.height);
    }else{
        contentFistLable.frame = CGRectMake(conentLable.left - contentFistLable.width, conentLable.top, contentFistLable.width, contentFistLable.height);
    }
    
    [babyInfoFistLable sizeToFit];
    babyInfoFistLable.frame = CGRectMake(contentFistLable.left, conentLable.bottom + SX(5), babyInfoFistLable.width, babyInfoFistLable.height);
    babyInfo.frame = CGRectMake(babyInfoFistLable.right, conentLable.bottom + SX(5), 100, babyInfoFistLable.height);
    
    
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
    
    bgImage.frame = CGRectMake(SX(8), top, SC_WIDTH - SX(16), babyInfo.bottom + SX(25));
    [scView addSubview:bgImage];

    return bgImage.bottom + SX(15);
}


- (float)loadMessageViews:(float)top SampleArray:(NSArray * )array{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [bgImage setImage:[[UIImage imageNamed:@"bng"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 15, 15) ]];
    [scView addSubview:bgImage];
    
    UIFont * font = [UIFont systemFontOfSize:SX(17)];
    
    float lastBotton = SX(20);
    
    for(int i = 0 ; i < array.count ; i++){
        NSDictionary * dict = [array objectAtIndex:i];
        
        NSString * tipString = [dict objectForKey:@"question"];
        NSString * answerString = [dict objectForKey:@"answer"];
        
        
        UILabel * titlelable = [[UILabel alloc] initWithFrame:CGRectMake(SX(32), lastBotton, SX(300), font.lineHeight)];
        titlelable.textColor = mRGBToColor(0x4a4a4a);
        [bgImage addSubview:titlelable];
        titlelable.font = font;
        titlelable.text = tipString;
        
        UIView * blueVie = [[UIView alloc] initWithFrame:CGRectMake(SX(15), titlelable.centerY - SX(4), SX(8), SX(8))];
        blueVie.backgroundColor = mRGBToColor(0x26bef5);
        blueVie.layer.cornerRadius = 3;
        [blueVie setClipsToBounds:YES];
        [bgImage addSubview:blueVie];
        
        
        UIFont * desFont = [UIFont systemFontOfSize:SX(15)];
        UILabel * desLable = [[UILabel alloc] initWithFrame:CGRectZero];
        desLable.numberOfLines = 0;
        desLable.lineBreakMode = NSLineBreakByWordWrapping;
        desLable.font = desFont;
        desLable.textColor = mRGBToColor(0x9b9b9b);
        [bgImage addSubview:desLable];
        
        desLable.text = answerString;
        
        CGSize size = [desLable sizeThatFits:CGSizeMake(SC_WIDTH - SX(14) * 2 - SX(8) * 2, NSUIntegerMax)];
        desLable.frame = CGRectMake(SX(15), titlelable.bottom + SX(13), size.width, size.height);
        
        if(array.count == i + 1){
           
            bgImage.frame = CGRectMake(SX(8), top, SC_WIDTH - SX(8) * 2, desLable.bottom + SX(20));

        }else{
            UIView * sepView = [[UIView alloc] initWithFrame:CGRectMake(0, desLable.bottom + SX(20), SC_WIDTH - SX(8) * 2, 1)];
            sepView.backgroundColor = mRGBToColor(0xf6f6f6);
            [bgImage addSubview:sepView];
        }
        
        lastBotton = desLable.bottom + SX(40);
    }
    return bgImage.bottom + SX(15);
}


@end
