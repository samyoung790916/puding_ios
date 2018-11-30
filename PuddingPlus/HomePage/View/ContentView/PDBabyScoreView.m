//
//  PDBabyScoreView.m
//  PuddingPlus
//
//  Created by kieran on 2017/9/21.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDBabyScoreView.h"

@interface PDBabyScoreView()
@property(nonatomic,weak) UILabel       *leveLable;
@property(nonatomic,weak) UILabel       *wordLable;
@property(nonatomic,weak) UILabel       *sentenceLable;
@property(nonatomic,weak) UILabel       *timeLable;
@property(nonatomic,weak) UIProgressView*progressView;
@property (nonatomic,weak) UIImageView * arrawImage;
@property(nonatomic,strong) CAShapeLayer *shapeLayer;

@end


@implementation PDBabyScoreView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.shapeLayer.hidden = NO;
        self.leveLable.hidden = NO;
        self.progressView.hidden = NO;
        self.wordLable.hidden = NO;
        self.sentenceLable.hidden = NO;
        self.timeLable.hidden = NO;
    }
    return self;
}

- (UIImageView *)arrawImage{
    if(!_arrawImage){
        UIImageView * image = [UIImageView new] ;
        image.image = [UIImage imageNamed:@"ic_home_message_more_green"];
        [self addSubview:image];
        
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-SX(10));
            make.width.equalTo(@(SX(6)));
            make.height.equalTo(@(SX(9.5)));
        }] ;
        
        _arrawImage = image;
    }
    return _arrawImage;
}

#pragma mark  progressView 进度条

- (UIProgressView *)progressView{
    if(!_progressView){
        UIProgressView * view = [[UIProgressView alloc] init];
        [view setProgressTintColor:mRGBToColor(0xb7d100)];
        [view setTrackTintColor:mRGBToColor(0xe9ecf0)];
        [self addSubview:view];
        view.userInteractionEnabled = NO;
        view.layer.cornerRadius = 5 ;
        view.clipsToBounds = YES;
        view.progress = 0.3;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SX(15)));
            make.right.equalTo(self.mas_right).offset(-SX(33));
            make.top.equalTo(self.leveLable.mas_bottom).offset(SX(11));
            make.height.equalTo(@(10));
        }];
        _progressView = view;
    }
    return _progressView;
}


#pragma mark  单词显示

- (UILabel *)wordLable{
    if(!_wordLable){
        UIImageView * imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"ic_home_bilingual_word"];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SX(15));
            make.top.equalTo(self.progressView.mas_bottom).offset(SX(12));
            make.width.equalTo(@(SX(17)));
            make.height.equalTo(@(SX(17)));
        }];
        
        
        UILabel *wordDesLable = [UILabel new];
        wordDesLable.backgroundColor = [UIColor clearColor];
        [self addSubview:wordDesLable];
        wordDesLable.textColor = mRGBToColor(0x4a4a4a);
        wordDesLable.text = NSLocalizedString( @"word_", nil);
        wordDesLable.textAlignment = NSTextAlignmentCenter;
        wordDesLable.font = [UIFont systemFontOfSize:SX(13)];
        [wordDesLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageView.mas_centerY);
            make.left.equalTo(imageView.mas_right).offset(SX(6));;
        }];
        wordDesLable.userInteractionEnabled = NO;
        UILabel *wordLable = [UILabel new];
        [self addSubview:wordLable];
        wordLable.textColor = mRGBToColor(0x4a4a4a);
        wordLable.text = @"100";
        wordLable.textAlignment = NSTextAlignmentCenter;
        wordLable.font = [UIFont systemFontOfSize:SX(13)];
        [wordLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageView.mas_centerY);
            make.left.equalTo(wordDesLable.mas_right).offset(SX(3));
        }];
        wordLable.userInteractionEnabled = NO;
        _wordLable = wordLable;
    }
    return _wordLable;
}

#pragma mark - 说句子

- (UILabel *)sentenceLable{
    if(!_sentenceLable){
        UIImageView * imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"ic_home_bilingual_sentence"];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wordLable.mas_right).offset(SX(20));
            make.top.equalTo(self.progressView.mas_bottom).offset(SX(12));
            make.width.equalTo(@(SX(19)));
            make.height.equalTo(@(SX(15)));
        }];
        
        
        UILabel *wordDesLable = [UILabel new];
        wordDesLable.backgroundColor = [UIColor clearColor];
        [self addSubview:wordDesLable];
        wordDesLable.textColor = mRGBToColor(0x4a4a4a);
        wordDesLable.text = NSLocalizedString( @"sentence_", nil);
        wordDesLable.textAlignment = NSTextAlignmentCenter;
        wordDesLable.font = [UIFont systemFontOfSize:SX(13)];
        [wordDesLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageView.mas_centerY);
            make.left.equalTo(imageView.mas_right).offset(SX(6));;
        }];
        wordDesLable.userInteractionEnabled = NO;
        UILabel *wordLable = [UILabel new];
        [self addSubview:wordLable];
        wordLable.textColor = mRGBToColor(0x4a4a4a);
        wordLable.text = @"100";
        wordLable.textAlignment = NSTextAlignmentCenter;
        wordLable.font = [UIFont systemFontOfSize:SX(13)];
        [wordLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageView.mas_centerY);
            make.left.equalTo(wordDesLable.mas_right).offset(SX(3));
        }];
        wordLable.userInteractionEnabled = NO;
        
        _sentenceLable = wordLable;
    }
    return _sentenceLable;
}


#pragma mark - 说句子

- (UILabel *)timeLable{
    if(!_timeLable){
        UIImageView * imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"ic_home_bilingual_ears"];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sentenceLable.mas_right).offset(SX(20));
            make.top.equalTo(self.progressView.mas_bottom).offset(SX(12));
            make.width.equalTo(@(SX(12)));
            make.height.equalTo(@(SX(17)));
        }];
        UILabel *wordLable = [UILabel new];
        [self addSubview:wordLable];
        wordLable.textColor = mRGBToColor(0x4a4a4a);
        wordLable.text = NSLocalizedString( @"hour_100_minute_50", nil);
        wordLable.textAlignment = NSTextAlignmentCenter;
        wordLable.font = [UIFont systemFontOfSize:SX(13)];
        [wordLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageView.mas_centerY);
            make.left.equalTo(imageView.mas_right).offset(SX(6));
        }];
        wordLable.userInteractionEnabled = NO;
        
        _timeLable = wordLable;
    }
    return _timeLable;
}

#pragma mark  等级信息

- (UILabel *)leveLable{
    if(!_leveLable){
        UILabel *desLabel = [UILabel new];
        [self addSubview:desLabel];
        desLabel.userInteractionEnabled = NO;
        desLabel.textColor = mRGBToColor(0x4a4a4a);
        desLabel.text = NSLocalizedString( @"value_of_ability_and_", nil);
        desLabel.font = [UIFont systemFontOfSize:SX(13)];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(SX(15)));
            make.top.equalTo(@(SX(14)));
            make.height.equalTo(@(15));
        }];
        
        
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.userInteractionEnabled = NO;
        titleLabel.textColor = mRGBToColor(0x8ec61a);
        titleLabel.text = @"Pre-starter A";
        titleLabel.font = [UIFont systemFontOfSize:SX(13)];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(desLabel.mas_right);
            make.centerY.equalTo(desLabel.mas_centerY);
            make.width.mas_equalTo(200);
            make.height.equalTo(desLabel.mas_height);
        }];
        _leveLable = titleLabel;
    }
    return _leveLable;
}


-(CAShapeLayer *)shapeLayer{
    
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.strokeColor = mRGBToColor(0xcfdfd9).CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 0.5;
        _shapeLayer.lineCap = @"square";
        _shapeLayer.lineDashPattern = @[@4, @4];
        [self.layer addSublayer:_shapeLayer];
    }
    
    return _shapeLayer;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:SX(15)];
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.path = path.CGPath;
}

- (void)setLevel:(NSString *)level{
    self.leveLable.text = level;
}

- (void)setWordNub:(NSString *)wordNub{
    self.wordLable.text = wordNub;
}

- (void)setSentenceCount:(NSString *)sentenceCount{
    self.sentenceLable.text = sentenceCount;
}

- (void)setProcess:(float)process{
    self.progressView.progress = process;
}

- (void)setStudyTime:(NSString *)studyTime{
    int time = [studyTime intValue];
    if(time < 60)
        self.timeLable.text = [NSString stringWithFormat:NSLocalizedString( @"percent_second_", nil),time];
    else if(time < 3600){
        if(time % 60 == 0){
            self.timeLable.text = [NSString stringWithFormat:NSLocalizedString( @"percent_minute_", nil),time/60];
        }else{
            self.timeLable.text = [NSString stringWithFormat:NSLocalizedString( @"percent_minute_percent_second", nil),time/60,time%60];
        }
    }else if(time >= 3600){
        NSString * str = nil;
        if(time / 60  % 60== 0){
            str = [NSString stringWithFormat:NSLocalizedString( @"percent_hour_", nil),time/3600];
        }else{
            str = [NSString stringWithFormat:NSLocalizedString( @"percent_hour_percent_second", nil),time/3600,time/60%60];
        }
        self.timeLable.text = str;
    }

}
@end
