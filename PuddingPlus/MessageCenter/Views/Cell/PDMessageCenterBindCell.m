//
//  PDMessageCenterBindCell.m
//  Pudding
//
//  Created by william on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterBindCell.h"
#import "TimedataFactory.h"
#import "UIImage+TintColor.h"


@interface PDMessageCenterBindCell ()
/** 下面图片的尺寸 */
//@property (nonatomic, assign) CGRect bottomBackFrame;

/** 背景 */
@property (nonatomic, weak) UIImageView *imageBg;
/** 拒绝按钮 */
@property (nonatomic, weak) UIButton *rejectBtn;
/** 允许按钮 */
@property (nonatomic, weak) UIButton *allowBtn;

@end


@implementation PDMessageCenterBindCell

static const CGFloat kContentLabTopEdge = 20;//文本内容距离背景图片的上方的留白
static const CGFloat kDialogLeftEdge = 10;//对话背景图距离左边Icon 的留白
static const CGFloat kDialogHeight = 45;//对话背景图的高度
static const CGFloat kTimeEdge = 30;//时间视图距离左边的距离
static const CGFloat kTimeLabHeight = 20;//时间视图的高度
#pragma mark ------------------- 初始化 ------------------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        /** 对话背景 */
        self.dialogBackV.hidden = NO;
#warning 之后根据数据选择是否隐藏，默认隐藏
        /** 背景视图 */
        self.imageBg.hidden = NO;
        
        /** Icon */
        self.iconImgV.center = CGPointMake(kIconImgCenterX, kIconImgCenterY);
        /** 文本背景的 frame */
        self.backImgRect = CGRectMake(self.iconImgV.right + kDialogLeftEdge , kTimeLabHeight+ 10, self.dialogBackWidth, SX(kDialogHeight));
        self.dialogBackV.hidden = NO;

        
        /** 文本 */
        self.contentLab.textColor = self.contentTxtColor;

        self.rejectBtn.hidden = NO;
        self.allowBtn.hidden = NO;
        
    }
    return self;
}

#pragma mark - action: 布局
-(void)layoutSubviews{
    [super layoutSubviews];
    self.iconImgV.center = CGPointMake(kIconImgCenterX, kIconImgCenterY);
    self.editBtn.center = CGPointMake(self.width -SX(40) , 10);
    self.dialogBackV.frame = self.backImgRect;
    self.contentLab.frame = self.contentRect;

}


#pragma mark - 创建 -> 背景视图
-(UIImageView *)imageBg{
    if (!_imageBg) {
        UIImageView*vi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SX(272), 50)];
        vi.image = [[UIImage imageNamed:@"bg_message_bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 10, 10, 10)];
        vi.userInteractionEnabled = YES;
        [self addSubview:vi];
        _imageBg = vi;
    }
    return _imageBg;
}

#pragma mark - 创建 -> 拒绝按钮
-(UIButton *)rejectBtn{
    if (!_rejectBtn) {
        float space = (self.imageBg.width - SX(88) * 2)/3;
        UIButton * rejectBtn = [[UIButton alloc] initWithFrame:CGRectMake(space, 10, SX(88), 30)];
        rejectBtn.layer.cornerRadius = 30/2.f;
        rejectBtn.clipsToBounds = YES;
        rejectBtn.tag = 2;
        [rejectBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        rejectBtn.layer.borderColor = [UIColor colorWithRed:0.792 green:0.808 blue:0.820 alpha:1.000].CGColor;
        rejectBtn.layer.borderWidth = .5;
        [rejectBtn setTitle:NSLocalizedString( @"reject", nil) forState:UIControlStateNormal];
        rejectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.imageBg addSubview:rejectBtn];
        _rejectBtn = rejectBtn;

    }
    return _rejectBtn;
}

#pragma mark - 创建 -> 允许按钮
-(UIButton *)allowBtn{
    if (!_allowBtn) {
        float space = (self.imageBg.width - SX(88) * 2)/3;
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(space * 2 + SX(88), 10, SX(88), 30)];
        btn.layer.cornerRadius = 30/2.f;
        btn.clipsToBounds = YES;
        btn.tag = 4;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString( @"agree", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0.247 green:0.612 blue:1.000 alpha:1.000]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0.220 green:0.533 blue:0.878 alpha:1.000]] forState:UIControlStateHighlighted];
        [self.imageBg addSubview:btn];
        _allowBtn = btn;
    }
    return _allowBtn;
}


#pragma mark - action: 允许，拒绝按钮点击
- (void)buttonAction:(UIButton*)btn{
    BOOL allowBind = NO;;
    if (btn ==self.allowBtn) {
        allowBind = YES;
    }
    /** 绑定回调 */
    if (self.bindCallBack&&!self.model.isEdit) {
        self.bindCallBack(self.indexPath,allowBind);
    }
}


#pragma mark - action: 画
-(void)drawRect:(CGRect)rect{
    
    
    /** 画时间 */
    [getTimeWithTimeInterval(self.model.timestamp)drawInRect:CGRectMake(self.iconImgV.right + kTimeEdge, 0, 200, kTimeLabHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FontSize - 3] ,NSForegroundColorAttributeName:mRGBToColor(0x505a66)}];
}

#pragma mark - action: 设置数据
-(void)setModel:(PDMessageCenterModel *)model{
    [super setModel:model];
    self.content = model.content;
    if(![model.content length]){
        model.content = @"";
    }
    /** 新的文本的 frame */
    self.contentRect = CGRectMake(self.iconImgV.right +2.5*kDialogLeftEdge, kTimeLabHeight + SX(kContentLabTopEdge) , self.dialogBackWidth - 2.5*kDialogLeftEdge, model.titleHeight);
    
    /** 新的背景图片的 frame */
    self.backImgRect = CGRectMake(self.backImgRect.origin.x, self.backImgRect.origin.y, self.backImgRect.size.width, model.titleHeight + SX(22));
    
    /** 获取未读数量 */
    int read = [model.unread intValue];
    self.imageBg.hidden = YES;
    if(read < 0x01){
        self.imageBg.hidden = NO;
        self.backImgRect = CGRectMake(self.backImgRect.origin.x, self.backImgRect.origin.y, self.backImgRect.size.width, model.titleHeight + SX(25) + 30);

        self.imageBg.frame = CGRectMake(self.iconImgV.right + kDialogLeftEdge+SX(6) ,self.backImgRect.origin.y+self.model.titleHeight +kTimeEdge, SX(264), 50);
    }else{
        self.backImgRect = CGRectMake(self.backImgRect.origin.x, self.backImgRect.origin.y, self.backImgRect.size.width, model.titleHeight + SX(22));
    }
    
    /** 设置编辑按钮 */
    self.editBtn.hidden = !model.isEdit;
    self.editBtn.selected = model.selected;

    /** 设置文本内容 */
    self.contentLab.text = self.content;
    self.contentLab.textColor = self.contentTxtColor;
    [self setNeedsDisplay];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
