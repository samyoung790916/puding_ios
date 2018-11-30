//
//  PDFamilyDynaCell.m
//  Pudding
//
//  Created by baxiang on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFamilyDynaMainCell.h"
#import "PDAudioPlayer.h"
#import "AFURLSessionManager.h"
#import "NSString+RBExtension.h"
#import "UIKit+AFNetworking.h"

@interface PDFamilyVideoNavView : UIButton
@end
@implementation PDFamilyVideoNavView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.adjustsImageWhenHighlighted = NO;
        UIImageView *videoImage = [UIImageView new];
        [self addSubview:videoImage];
        videoImage.image = [UIImage imageNamed:@"fd_entre_icon_video"];
        videoImage.contentMode = UIViewContentModeScaleAspectFit;
        [videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(videoImage.image.size.width);
            make.height.mas_equalTo(self.mas_height);
        }];
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = mRGBToColor(0x505a66);
        [self addSubview:titleLabel];
        titleLabel.text = NSLocalizedString( @"come_in_video_call", nil);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(videoImage.mas_right).offset(10);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height);
        }];
        UIImageView *backImage = [UIImageView new];
        [self addSubview:backImage];
        backImage.contentMode = UIViewContentModeScaleAspectFit;
        backImage.image = [UIImage imageNamed:@"family_back"];
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(backImage.image.size.width);
            make.height.mas_equalTo(self.mas_height);
        }];
    }
    return self;
}
@end

@interface PDFamilyDynaMainCell(){
    UIView * shareView;
}
@property (nonatomic,strong) UIImageView *cameraImage;
@property (nonatomic,strong) UIView *verticalLine;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) PDFamilyVideoNavView *videoNavView;
@property (nonatomic,weak) UIView *photoView;
@property (nonatomic,weak) UIImageView *videoIcon;
@property (nonatomic,weak) UIImageView *audioImageView;
@property (nonatomic,weak) UILabel *audioLabel;
@property (nonatomic,weak) UIImageView *voiceChangeView;
@property (nonatomic,weak) UIView *audioView;
@property (nonatomic,weak) UIView *messageView;
@property (nonatomic,weak) UILabel *messLabel;
@end
@implementation PDFamilyDynaMainCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubView];
    }
    return self;
}
-(void)setupSubView{
    UIView *verticalLine = [UIView new];
    [self.contentView addSubview:verticalLine];
    verticalLine.backgroundColor = mRGBToColor(0xe4e4e4);
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SX(4));
        make.height.mas_equalTo(self.contentView.mas_height);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(SX(48));
    }];
    self.verticalLine = verticalLine;
    UIImageView *cameraImage = [UIImageView new];
    [self addSubview:cameraImage];
    [cameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(SX(35));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    self.cameraImage = cameraImage;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:selectBtn];
    [selectBtn setImage:[UIImage imageNamed:@"icon_message_unselected"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"icon_message_selected"] forState:UIControlStateSelected];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cameraImage.mas_left).offset(-20);
        make.centerY.mas_equalTo(self.cameraImage.mas_centerY);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    self.selectBtn = selectBtn;
    [self.selectBtn addTarget:self action:@selector(deleteFamilyMoment:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *timeLabel = [UILabel new];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cameraImage.mas_right).offset(SX(30));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    timeLabel.textColor = mRGBToColor(0x909091);
    timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel = timeLabel;
    
    UIView *audioView = [UIView new];
    audioView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:audioView];
    [audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(timeLabel.mas_left);
        make.right.mas_equalTo(-SX(52));
    }];
    self.audioView = audioView;
    
    
    UIImageView *audioImageView = [UIImageView new];
    [self.audioView addSubview:audioImageView];
    audioImageView.userInteractionEnabled = YES;
    audioImageView.image = [self resizeWithImage:[UIImage imageNamed:@"icon_dialogue"]];
    [audioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-SX(10));
        make.top.mas_equalTo(0);
    }];
    self.audioImageView = audioImageView;
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio)];
    [self.audioImageView addGestureRecognizer:playTap];
    
    UILabel *audioLabel = [UILabel new];
    [self.audioView addSubview:audioLabel];
    [audioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(audioImageView.mas_right).offset(SX(10));
        make.bottom.mas_equalTo(audioImageView.mas_bottom);
    }];
    audioLabel.textColor = mRGBToColor(0x909091);
    audioLabel.font = [UIFont systemFontOfSize:15];
    self.audioLabel = audioLabel;
    
    UIImageView *voiceChangeView = [UIImageView new];
    [self.audioImageView addSubview:voiceChangeView];
    voiceChangeView.image = [UIImage imageNamed:@"icon_message_voice3"];
    voiceChangeView.animationImages = @[[UIImage imageNamed:@"icon_message_voice1"],[UIImage imageNamed:@"icon_message_voice2"],[UIImage imageNamed:@"icon_message_voice3"]];
    voiceChangeView.animationDuration = 2.0/3;//设置动画时间
    voiceChangeView.animationRepeatCount = 0;
    [voiceChangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.audioImageView.mas_centerY);
    }];
    self.voiceChangeView = voiceChangeView;
    
    UIView *photoView = [UIView new];
    photoView.layer.masksToBounds = YES;
    photoView.layer.cornerRadius = 5;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(195);
        make.left.mas_equalTo(timeLabel.mas_left);
        make.right.mas_equalTo(-SX(52));
    }];
    self.photoView = photoView;
    
    PDFamilyVideoNavView *videoNavView = [PDFamilyVideoNavView buttonWithType:UIButtonTypeCustom];
    [videoNavView setBackgroundImage:[UIImage imageNamed:@"fd_video_list"] forState:UIControlStateNormal];
    [videoNavView addTarget:self action:@selector(videoViewHandle) forControlEvents:UIControlEventTouchUpInside];
    [photoView addSubview:videoNavView];
    [videoNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(0);
    }];
    self.videoNavView = videoNavView;
    
    UIImageView *photoImageView = [UIImageView new];
    photoImageView.userInteractionEnabled = YES;
    photoImageView.backgroundColor = [UIColor whiteColor];
    [photoImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    photoImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    photoImageView.clipsToBounds = YES;
    [photoView addSubview:photoImageView];
    [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(videoNavView.mas_bottom);
        make.height.mas_equalTo(155);
        make.right.mas_equalTo(0);
    }];
    
    UIView *messageView = [UIView new];
    messageView.layer.cornerRadius = 5;
    messageView.backgroundColor = UIColorHex(0xf4f7f8);
    [self.contentView addSubview:messageView];
    self.messageView = messageView;
    
    UILabel *messLabel = [UILabel new];
    messLabel.textColor = UIColorHex(0x4a4a4a);
    messLabel.font = [UIFont systemFontOfSize:14];
    [messageView addSubview:messLabel];
    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeLabel.mas_left);
        make.right.mas_equalTo(-SX(52));
        make.top.mas_equalTo(timeLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(messLabel.mas_bottom).offset(16);
    }];
    messLabel.numberOfLines = 0;
    [messLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-10);
    }];
    self.messLabel = messLabel;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageDetailView)];
    [photoImageView addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPressReger.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPressReger];
    self.photoImageView = photoImageView;
    UIImageView *videoIcon = [UIImageView new];
    videoIcon.image = [UIImage imageNamed:@"videoblack_start"];
    [photoImageView addSubview:videoIcon];
    videoIcon.contentMode = UIViewContentModeScaleAspectFit;
    [videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    self.videoIcon = videoIcon;
    
    [self initShareView];
}

- (void)initShareView{
    UIImageView * shareImageView = [UIImageView new];
    shareImageView.image = [UIImage imageNamed:@"bg_dynamic_picture"];
    [self.photoImageView addSubview:shareImageView];
    
    [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.photoImageView.mas_bottom);
        make.right.mas_equalTo(self.photoImageView.mas_right);
        make.width.mas_equalTo(87);
        make.height.mas_equalTo(28);
    }];
    
    UIImageView * iconView = [UIImageView new];
    iconView.image = [UIImage imageNamed:@"bg_dynamic_from"];
    [shareImageView addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.left.mas_equalTo(14);
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(11);
    }];
    
    UILabel * lable = [UILabel new];
    lable.font = [UIFont systemFontOfSize:10];
    lable.textColor = mRGBToColor(0x4a4a4a);
    lable.text = NSLocalizedString( @"come_form_lively_vlbum", nil);
    [shareImageView addSubview:lable];

    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView.mas_centerY);
        make.left.equalTo(iconView.mas_right).offset(3);
        make.width.lessThanOrEqualTo(@56);
    }];
    shareView.hidden = YES;
    
    shareView = shareImageView;
}


-(UIImage*)resizeWithImage:(UIImage*)image{
    
    CGFloat top = image.size.height/2.0;
    
    CGFloat left = image.size.width/2.0;
    
    CGFloat bottom = image.size.height/2.0;
    
    CGFloat right = image.size.width/2.0;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan&&_longPressHandle){
        self.longPressHandle();
    }
}

- (NSDateFormatter *)currTimeFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:@"HH:mm"];
        
    });
    return _shareyearFormat;
}


-(NSString *)timeDescriptionSinceTimeInt:(NSTimeInterval)anotherTimeInt {
    NSTimeInterval nowTimeInt = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval distanceTimeInt = nowTimeInt - anotherTimeInt;
    if(distanceTimeInt < 120) {
        return (NSLocalizedString( @"just_", nil));
    }
    NSDate *currDate  =[NSDate dateWithTimeIntervalSince1970:anotherTimeInt];
    return  [[self currTimeFormat] stringFromDate:currDate];
}

- (void)setFamilyMoment:(PDFamilyMoment *)familyMoment{

    _familyMoment = familyMoment;
    
    shareView.hidden = !familyMoment.isShare;
    

    NSString *timeString = [self timeDescriptionSinceTimeInt:[familyMoment.time doubleValue]/1000.0f];
    self.timeLabel.text = timeString;
    if ([_familyMoment isVideo]) {
        [self.videoIcon setHidden:NO];
        [self.photoView setHidden:NO];
        [self.audioView setHidden:YES];
        [self.messageView setHidden:YES];
        self.cameraImage.image = [UIImage imageNamed:@"fd_icon_video"];
    }else if (_familyMoment.type==PDFamilyMomentAudio){
//        self.timeLabel.text =[NSString stringWithFormat:@"%@ 宝宝精彩语录",timeString];
        self.timeLabel.text =[NSString stringWithFormat:NSLocalizedString( @"long_press_sharing_baby_wonderful_recording", nil),timeString];
        [self.photoView setHidden:YES];
        [self.audioView setHidden:NO];
        [self.messageView setHidden:YES];
        self.cameraImage.image = [UIImage imageNamed:@"icon_message_baby"];
        CGFloat rightMagin = -165;
        if ([familyMoment.length integerValue]>10) {
            rightMagin =-10;
        }else if ([familyMoment.length integerValue]<1){
            rightMagin = -165;
        }else{
            NSInteger lenth =[familyMoment.length integerValue]-1;
            rightMagin =lenth*155/9-165;
        }
        [self.audioImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(SX(rightMagin));
        }];
        self.audioLabel.text = [NSString stringWithFormat:@"%@''",_familyMoment.length];
    }else if (_familyMoment.type==PDFamilyMomentMess){
        [self.videoIcon setHidden:YES];
        [self.photoView setHidden:YES];
        [self.audioView setHidden:YES];
        [self.messageView setHidden:NO];
        self.messLabel.text = _familyMoment.content;
        self.cameraImage.image = [UIImage imageNamed:@"ic_information"];
    } else{
        [self.photoView setHidden:NO];
        [self.videoIcon setHidden:YES];
        [self.audioView setHidden:YES];
        [self.messageView setHidden:YES];
        self.cameraImage.image = [UIImage imageNamed:@"fd_icon_camera"];
    }
    UIImage *placeImage = [familyMoment isVideo]?[UIImage imageNamed:@"fd_video_fig_default"]:[UIImage imageNamed:@"fd_photo_fig_default"];
    [self.photoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",familyMoment.thumb]] placeholderImage:placeImage];
}

-(void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
    [self.selectBtn setSelected:_isDelete];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_isEditMode) {
        [self.cameraImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(65);
        }];
        [self.verticalLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(78);
        }];
        [self.selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.selectBtn.currentImage.size.width);
            make.height.mas_equalTo(self.selectBtn.currentImage.size.height);
        }];
        [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SX(22));
        }];
        
        [self.audioView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SX(22));
        }];
        [self.messageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SX(22));
        }];
        if (_isLoadAnimation) {
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
            }];
        }
    }else{
        [self.cameraImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(35);
        }];
        [self.verticalLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(48);
        }];
        [self.selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(0);
        }];
        [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SX(52));
        }];
        [self.audioView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SX(52));
        }];
        [self.messageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SX(52));
        }];
        if (_isLoadAnimation) {
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
            }];
        }
    }
    if (self.isFirstCell) {
        [self.videoNavView setHidden:NO];
        [self.videoNavView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
        [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(195);
        }];
    }else{
        [self.videoNavView setHidden:YES];
        [self.videoNavView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(155);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)videoViewHandle{
    if (self.showVideoView&&!_isEditMode) {
        self.showVideoView();
    }
}
-(void)showImageDetailView{
    if (self.isEditMode) {
        return;
    }
    if (self.showPhotoView&&[self.familyMoment isPhoto]) {
        self.showPhotoView();
    }else if (self.playVideoView&&[self.familyMoment isVideo]){
        self.playVideoView();
    }
}

-(void)deleteFamilyMoment:(UIButton*) btn{
    BOOL isSelect = btn.isSelected;
    [btn setSelected:!isSelect];
    if (_deleteCurrFamilyMoment) {
        _deleteCurrFamilyMoment(btn.isSelected,_familyMoment);
    }
}
-(void)dealloc{
    [_photoImageView cancelCurrentImageRequest];
}
-(void)playAudio{
    if (_isEditMode) {
        return;
    }
    if (self.playAudioHandle) {
        self.playAudioHandle(_voiceChangeView,_familyMoment);
    }
}
-(void)downloadAudioFile:(NSString*)downloadPath completionHandler:(void (^)(NSURL *filePath, NSError *error))completion{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *currFilePath = [[self fetchVideoFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",[downloadPath md5String]]];
    NSURL *currFileURL = [NSURL fileURLWithPath:currFilePath];
    if ([fileManager fileExistsAtPath:currFilePath]) {
        completion(currFileURL,nil);
        return;
    }
    NSURL *videoURL = [NSURL URLWithString:downloadPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:videoURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return currFileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        completion(filePath,error);
    }];
    [downloadTask resume];
}
-(NSString*)fetchVideoFolderPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folder = [document stringByAppendingPathComponent:@"PDFamilyAudio"];
    if (![fileManager fileExistsAtPath:folder]) {
        BOOL blCreateFolder= [fileManager createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:NULL];
        if (blCreateFolder) {
            NSLog(@" folder success");
        }else {
            NSLog(@" folder fial");
        }
    }else {
        NSLog(@"沙盒文件已经存在");
    }
    return folder;
}
@end
