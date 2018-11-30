//
//  PDMessageCenterVideoCell.m
//  Pudding
//
//  Created by zyqiong on 16/8/25.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterVideoCell.h"
#import "UIButton+YYWebImage.h"
#import "TimedataFactory.h"
@interface PDMessageCenterVideoCell()
@property (nonatomic, weak) YYAnimatedImageView * imgButton;

@end

@implementation PDMessageCenterVideoCell
static const CGFloat kContentLabTopEdge = 13;//文本内容距离背景图片的上方的留白
static const CGFloat kDialogLeftEdge =  10;//对话背景图距离左边Icon 的留白
static const CGFloat kTimeEdge = 13;//时间视图距离左边的距离
static const CGFloat kTimeLabHeight = 20;//时间视图的高度

- (void)setModel:(PDMessageCenterModel *)model {
    [super setModel:model];
    if (model != nil) {
        NSArray *videos = model.videos;
        if (![videos isKindOfClass:[NSArray class]]) {
            return;
        }
        NSDictionary *videoDict = [videos firstObject];
        if (![videoDict isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSString *title = [videoDict objectForKey:@"title"];
        if (title == nil || [title isEqualToString:@""]) {
            title = [videoDict objectForKey:@"content"];
        }
        NSString *imgString = [videoDict objectForKey:@"img"];
        NSURL *imgUrl = [NSURL URLWithString:imgString];
        self.contentLab.text = title;
        [self.imgButton setImageWithURL:imgUrl placeholder:[UIImage imageNamed:@"img_message_pic"]];
        CGSize size = self.iconImgV.frame.size;
        if (model.isEdit) {
            if (!self.isEdit) {
                [UIView animateWithDuration:kAnimateDuration animations:^{
                    self.iconCenter = CGPointMake(kIconImgCenterX+SX(10), kIconImgCenterY);
                    [self.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                    }];
                    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(model.titleHeight);
                    }];
                }];
            } else {
                __weak typeof(self) weakself = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(self) strongSelf = weakself;
                    strongSelf.iconCenter = CGPointMake(kIconImgCenterX+SX(10), kIconImgCenterY);
                    [strongSelf.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                    }];
                    
                    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(model.titleHeight);
                    }];
                    
                });
            }
        } else {
            if (self.isEdit) {
                [UIView animateWithDuration:kAnimateDuration animations:^{
                    self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
                    [self.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                    }];
                    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(model.titleHeight);
                    }];
                    
                }];
            } else {
                __weak typeof(self) weakself = self;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(self) strongSelf = weakself;
                    strongSelf.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
                    [strongSelf.iconImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.iconCenter.x- size.width*.5);
                    }];
                    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(model.titleHeight);
                    }];
                    
                });
            }
        }
         self.edit = model.isEdit;
        /** 设置编辑按钮 */
        self.editBtn.hidden = !model.isEdit;
        self.editBtn.selected = model.selected;
       
        /** 时间文本 */
        self.timeLab.text = getTimeWithTimeInterval(model.timestamp);
        
        [self setNeedsDisplay];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundView = [UIView new];
        self.opaque = true;
        
        // 编辑状态
        self.edit = NO;
        
        // icon 的中心
        self.iconCenter = CGPointMake(kIconImgCenterX, kIconImgCenterY);
        CGSize size = self.iconImgV.frame.size;
        [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kIconImgCenterX- size.width*.5);
            make.top.mas_equalTo(kIconImgCenterY - size.height * .5);
            make.size.mas_equalTo(size);
        }];
        
        // 时间文本
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImgV.mas_right).offset(kTimeEdge);
            make.top.mas_equalTo(self.iconImgV.mas_top);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(kTimeLabHeight);
        }];
        
        /** 内容文本 */
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLab);
            make.top.mas_equalTo(self.timeLab.mas_bottom).offset(kContentLabTopEdge);
            make.width.mas_equalTo(self.dialogBackWidth - 0.8*kDialogLeftEdge);
        }];
        
        [self.imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentLab);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SX(250.0f), SX(187.5f)));
        }];
        
        UIImageView *playImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_center_video_enlarge"]];
        [self.imgButton addSubview:playImage];
        [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SX(8));
            make.bottom.mas_equalTo(-SX(8));
        }];
        self.linelayer.path = [UIBezierPath bezierPathWithRect:CGRectZero].CGPath;
    }
    return self;
}

- (void)imageClickAction {
    if (_callback) {
        _callback(self.model);
    }
}

-(YYAnimatedImageView *)imgButton{
    if (!_imgButton) {
        
        YYAnimatedImageView * btn = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(self.timeLab.left,self.contentRect.origin.y+self.contentRect.size.height +  kContentLabTopEdge, SX(250.f), SX(187.5))];
        btn.frame = CGRectMake(self.timeLab.left,self.contentRect.origin.y+self.contentRect.size.height +  kContentLabTopEdge,btn.width , btn.height);
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UIColor whiteColor];
        btn.alpha = 1;
        btn.layer.cornerRadius = SX(10);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 10;
        btn.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClickAction)];
        tap.numberOfTapsRequired  =1;
        tap.numberOfTouchesRequired = 1;
        [btn addGestureRecognizer:tap];
        [self addSubview:btn];
        _imgButton = btn;
    }
    return _imgButton;
}

#pragma mark - action: 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.getLineRect];
    self.linelayer.path = path.CGPath;
    
}
@end
