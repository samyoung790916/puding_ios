//
//  PDNewQuestionCell.m
//  Pudding
//
//  Created by baxiang on 16/3/7.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDNewQuestionCell.h"
#import "PDTextView.h"
#import "UIImageView+YYWebImage.h"


#define maxLength 100
@interface PDNewQuestionCell()<UITextViewDelegate>
@property (nonatomic,strong) PDTextView  *inputTextView;
@property (nonatomic,strong) UIImageView *headIconView;
@property (nonatomic,strong) UIImageView *inputBubbleView;
@property (nonatomic,assign) CGFloat rightMargin;
/** 小的问视图 */
@property (nonatomic, weak) UIImageView * littleAskImg;
@property (nonatomic, weak) UIImageView * littleAnswerImg;

@end

@implementation PDNewQuestionCell



-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = YES;
        [self setupSubView];
    }
    return self;
}
-(UIImageView *)littleAskImg{
    if (!_littleAskImg) {
        UIImageView * vi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_diy_qq"]];
        if (RBDataHandle.currentDevice.isStorybox) {
            vi.image = [UIImage imageNamed:@"tip_q"];
        }
        vi.hidden = YES;
        [self.contentView addSubview:vi];
        _littleAskImg = vi;
    }
    return _littleAskImg;
}
-(UIImageView *)littleAnswerImg{
    if (!_littleAnswerImg) {
        UIImageView * vi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tip_a"]];
        if (RBDataHandle.currentDevice.isStorybox) {
            vi.image = [UIImage imageNamed:@"tip_a"];
        }
        vi.hidden = YES;
        [self.contentView addSubview:vi];
        _littleAnswerImg = vi;
    }
    return _littleAnswerImg;
}
- (void)setupSubView{
  
    self.headIconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar_diy_a"]];
    [self.contentView addSubview:_headIconView];
    UIImage *defaultHeadImage = [UIImage imageNamed:@"avatar_diy_a"];
    self.rightMargin = defaultHeadImage.size.width+20;

   
    [self.headIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];

//    self.headIconView.layer.masksToBounds = YES;
//    self.headIconView.layer.cornerRadius = 54*0.5;
    
    
    [self.littleAskImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headIconView.mas_bottom);
        make.left.mas_equalTo(self.headIconView.mas_right).offset(-self.littleAskImg.width+10);
    }];
    [self.littleAnswerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headIconView.mas_bottom);
        make.left.mas_equalTo(self.headIconView.mas_right).offset(-self.littleAnswerImg.width+10);
    }];
    self.inputBubbleView =[UIImageView new];
    self.inputBubbleView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.inputBubbleView];
    UIImage *qBubbleImgae = [UIImage imageNamed:@"bg_diy_q"];
    if (RBDataHandle.currentDevice.isStorybox) {
        qBubbleImgae = [UIImage imageNamed:@"bg_q_nor"];
    }
    self.inputBubbleView.image = [qBubbleImgae stretchableImageWithLeftCapWidth:qBubbleImgae.size.width/2.0 topCapHeight:qBubbleImgae.size.height/2.0];
    [self.inputBubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headIconView.mas_right).offset(10);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-_rightMargin);
        make.top.mas_equalTo(10);
    }];
    self.inputTextView = [PDTextView new];
    self.inputTextView.placeholder = NSLocalizedString( @"ps_enter_problem", nil);
    self.inputTextView.placeholderTextColor = mRGBToColor(0xffffff);
    self.inputTextView.textColor = mRGBToColor(0xffffff);
    self.inputTextView.font = [UIFont systemFontOfSize:15];
    self.inputTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.inputTextView.scrollEnabled = NO;
    self.inputTextView.backgroundColor = [UIColor clearColor];
    self.inputTextView.delegate = self;
    [self.contentView addSubview:_inputTextView];
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputBubbleView.mas_left).offset(10);
        make.bottom.mas_equalTo(self.inputBubbleView.mas_bottom).offset(-5);
        make.right.mas_equalTo(self.inputBubbleView.mas_right).offset(-10);
        make.top.mas_equalTo(self.inputBubbleView.mas_top).offset(5);
    }];
}

-(void)setIsAnswerView:(BOOL)isAnswerView{
    _isAnswerView = isAnswerView;
    if (isAnswerView) {
       
        UIImage *headImage;
        if ([RBDataHandle.currentDevice isPuddingPlus]) {
          headImage = [UIImage imageNamed:@"plus_avatar_diy_a"];
        }else if (RBDataHandle.currentDevice.isStorybox){
            headImage = [UIImage imageNamed:@"icon_touxiang"];
        }else{
          headImage = [UIImage imageNamed:@"avatar_diy_q"];
        }
        self.headIconView.image = headImage;
        //self.headIconView.layer.masksToBounds = NO;
       //self.headIconView.layer.cornerRadius = defaultHeadImage.size.height/2.0f;
       [self.headIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);;
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        UIImage *aBubbleImgae = [UIImage imageNamed:@"bg_diy_a"];
        if (RBDataHandle.currentDevice.isStorybox) {
            aBubbleImgae = [UIImage imageNamed:@"bg_a_nor"];
        }
        self.inputBubbleView.userInteractionEnabled = YES;
        self.inputBubbleView.image = [aBubbleImgae stretchableImageWithLeftCapWidth:aBubbleImgae.size.width/2.0 topCapHeight:aBubbleImgae.size.height/2.0];
        [self.inputBubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.headIconView.mas_left).offset(-10);
            make.bottom.mas_equalTo(-10);
            make.left.mas_equalTo(_rightMargin);
            make.top.mas_equalTo(10);
        }];
        self.inputTextView.placeholder = NSLocalizedString( @"ps_enter_answer", nil);
        _littleAnswerImg.hidden = NO;
    }else{
        UIImage *defaultHeadImage = [UIImage imageNamed:@"avatar_diy_a"];
        @weakify(self)
        [self.headIconView setImageWithURL:[NSURL URLWithString:RBDataHandle.loginData.headimg] placeholder:defaultHeadImage options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (!error) {
                @strongify(self)
                self.headIconView.layer.masksToBounds = YES;
                self.headIconView.layer.cornerRadius = 45*0.5f;
                if (image) {
                    self.littleAskImg.hidden = NO;
                }else{
                    self.littleAskImg.hidden = YES;
                }
            }
            
        }];
        
        
        [self.inputTextView becomeFirstResponder];
    }
}
-(void)setContentText:(NSString *)contentText{
    _contentText = contentText;
    // update the UI and the cell size with a delay to allow the cell to load
    self.inputTextView.text = contentText;
    [self performSelector:@selector(textViewDidChange:)
               withObject:self.inputTextView
               afterDelay:0.1];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= maxLength && text.length > range.length) {
        return NO;
    }
    
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView
{

    //self.content = self.textView.text;
    
    if (textView.markedTextRange == nil && textView.text.length >= maxLength)
    {
        textView.text = [textView.text substringToIndex:maxLength];
    }
     UITableView *tableView = [self tableView];
     NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tableView:updatedText:atIndexPath: )]) {
        [self.delegate tableView:tableView
                     updatedText:textView.text
                     atIndexPath:indexPath];
    }
      CGFloat oldHeight = self.inputTextView.height +30;
      CGFloat newHeight = [self cellHeight];
    if (fabs(newHeight - oldHeight) > 0.01) {
        if ([_delegate respondsToSelector:@selector(tableView:updatedHeight:atIndexPath:)]) {
            [_delegate tableView:[self tableView]
                  updatedHeight:newHeight
                    atIndexPath:indexPath];
     }
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    
    
}
- (CGFloat)cellHeight
{
    return [self.inputTextView sizeThatFits:CGSizeMake(self.inputTextView.frame.size.width, FLT_MAX)].height + 30;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    self.inputTextView.textColor = mRGBToColor(0xffffff);
    self.inputTextView.placeholderTextColor = mRGBToColor(0xffffff);
    if (_isAnswerView) {
        UIImage *aBubbleImage = [UIImage imageNamed:@"bg_diy_a"];
        if (RBDataHandle.currentDevice.isStorybox) {
            aBubbleImage = [UIImage imageNamed:@"bg_a_nor"];
        }
        self.inputBubbleView.image = [aBubbleImage stretchableImageWithLeftCapWidth:aBubbleImage.size.width/2.0 topCapHeight:aBubbleImage.size.height/2.0];
    }
    if (!_isAnswerView) {
        UIImage *qBubbleImgae = [UIImage imageNamed:@"bg_diy_q"];
        if (RBDataHandle.currentDevice.isStorybox) {
            qBubbleImgae = [UIImage imageNamed:@"bg_q_nor"];
        }
        self.inputBubbleView.image = [qBubbleImgae stretchableImageWithLeftCapWidth:qBubbleImgae.size.width/2.0 topCapHeight:qBubbleImgae.size.height/2.0];
    }
}

- (UITableView *)tableView{
    UIView *tabelView = self.superview;
    
    while (![tabelView isKindOfClass:[UITableView class]] && tabelView) {
        tabelView = tabelView.superview;
    }
    
    return (UITableView *)tabelView;
}

-(void) textViewDidBeginEditing:(UITextView *)textView{
    self.inputTextView.textColor = mRGBToColor(0x505a66);
    self.inputTextView.tintColor = mRGBToColor(0x505a66);
    self.inputTextView.placeholderTextColor = mRGBToColor(0xcccccc);
    if (_isAnswerView) {
        UIImage *aBubbleImage = [UIImage imageNamed:@"bg_diy_input_r"];
        if (RBDataHandle.currentDevice.isStorybox) {
            aBubbleImage = [UIImage imageNamed:@"bg_a_sel"];
        }
        self.inputBubbleView.image = [aBubbleImage stretchableImageWithLeftCapWidth:aBubbleImage.size.width/2.0 topCapHeight:aBubbleImage.size.height/2.0];

    }
    if (!_isAnswerView) {
        UIImage *qBubbleImgae = [UIImage imageNamed:@"bg_diy_input"];
        if (RBDataHandle.currentDevice.isStorybox) {
            qBubbleImgae = [UIImage imageNamed:@"bg_q_sel"];
        }
        self.inputBubbleView.image = [qBubbleImgae stretchableImageWithLeftCapWidth:qBubbleImgae.size.width/2.0 topCapHeight:qBubbleImgae.size.height/2.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
