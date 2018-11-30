//
//  PDDIYReplayCell.m
//  Pudding
//
//  Created by baxiang on 16/3/18.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDDIYReplayCell.h"

@interface PDDIYReplayCell()
@property (nonatomic,strong) UILabel *questionLabel;
@property (nonatomic,strong) UILabel *answerLabel;
@property (nonatomic,strong) UIImageView *questionIcon;
@end

@implementation PDDIYReplayCell



-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         // Fix the bug in iOS7 - initial constraints warning
         self.contentView.bounds = [UIScreen mainScreen].bounds;
        [self setupSubView];
    }
    return self;
}
-(void)setupSubView{
    
    _chatBackView = [UIImageView new];
    [self.contentView addSubview:_chatBackView];
    UIImage *cellImage = [UIImage imageNamed:@"bg_diy_card"];
    _chatBackView.image = [cellImage stretchableImageWithLeftCapWidth:cellImage.size.width/2.0 topCapHeight:cellImage.size.height/2.0];
    [_chatBackView sendSubviewToBack:self.contentView];
    [_chatBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
    
    self.questionIcon = [UIImageView new];
    _questionIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_chatBackView addSubview:_questionIcon];
    _questionIcon.image= [UIImage imageNamed:@"icon_diy_q"];
    
    
    UIImageView *answerIcon = [UIImageView new];
    answerIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_chatBackView addSubview:answerIcon];
     answerIcon.image= [UIImage imageNamed:@"icon_diy_a"];
    
    _answerLabel = [UILabel new];
    _answerLabel.font = [UIFont systemFontOfSize:17];
    _answerLabel.preferredMaxLayoutWidth = SC_WIDTH-85;
    _answerLabel.numberOfLines = 0;
    _questionLabel = [UILabel new];
    _questionLabel.preferredMaxLayoutWidth = SC_WIDTH-85;
    _questionLabel.numberOfLines = 0;
    _questionLabel.font = [UIFont systemFontOfSize:17];
    [_chatBackView addSubview:_answerLabel];
    [_chatBackView addSubview:_questionLabel];
    _questionLabel.textColor = mRGBToColor(0x505a66);
    _answerLabel.textColor = mRGBToColor(0x505a66);
    _questionLabel.font = [UIFont systemFontOfSize:15];
    _answerLabel.font = [UIFont systemFontOfSize:15];
    [_questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_questionIcon.mas_right).offset(8);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-5);
    }];
    [_questionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(8);
        make.centerY.mas_equalTo(_questionLabel.mas_centerY);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(_questionIcon.image.size);
    }];
    UIView *sepeLine = [UIView new];
    sepeLine.backgroundColor = mRGBToColor(0xe1e3e6);
    [_chatBackView addSubview:sepeLine];
    [sepeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_questionIcon.mas_left);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_questionLabel.mas_bottom).offset(15);
    }];
   
    
    [_answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_questionIcon.mas_right).offset(8);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(sepeLine.mas_bottom).offset(15);
        make.bottom.mas_equalTo(_chatBackView.mas_bottom).offset(-15);
       
    }];
    [answerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_answerLabel.mas_centerY);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(answerIcon.image.size);
    }];
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_deleteBtn];
    _deleteBtn.hidden = YES;
    [_deleteBtn setImage:[UIImage imageNamed:@"icon_message_unselected"] forState:UIControlStateNormal];
    [_deleteBtn setImage:[UIImage imageNamed:@"icon_message_selected"] forState:UIControlStateSelected];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(_deleteBtn.imageView.image.size);
    }];
    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setQuestionModle:(QuestionModle *)questionModle{

    _questionModle = questionModle;
    _questionLabel.text = questionModle.question;
    _answerLabel.text = questionModle.response;
   
}
- (void)setShouldDelete:(BOOL)shouldDelete{
    _shouldDelete = shouldDelete;
    _deleteBtn.selected = shouldDelete;
}

-(void)setEditModle:(BOOL)editModle{
    _editModle = editModle;
    if (editModle) {
        _deleteBtn.hidden = NO;
        [_chatBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(35);
            make.bottom.mas_equalTo(0);
        }];
    }else{
        _deleteBtn.hidden = YES;
        [_chatBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(0);
        }];
    }
}
- (void)deleteAction:(UIButton *)sender {
    self.shouldDelete = !sender.selected;
    if(self.didSelectDeleteBlock){
        self.didSelectDeleteBlock(sender.selected,self.cellIndex);
    }
}

@end
