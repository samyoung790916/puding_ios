//
//  RBEnglishStudyInfoCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/1.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishStudyInfoCell.h"
#import "NSString+YYAdd.h"

@interface RBEnglishStudyInfoCell()
@property (nonatomic,weak) UILabel * tipLable;
@property (nonatomic,weak) UILabel * desLable;
@property (nonatomic,weak) UIView  * tipBgView;

@property(nonatomic,strong) NSString * tipSting;
@property(nonatomic,strong) NSString * desString;

@property(nonatomic,assign)  RBStudyType studyType;
@end


@implementation RBEnglishStudyInfoCell


- (void)setInfo:(NSString *)tipString DesString:(NSString *)desString StudyType:(RBStudyType)type{
    self.tipSting = tipString;
    self.desString = desString;
    self.studyType = type;
    
    self.tipLable.text = tipString;
    self.desLable.text = desString;
  
    [self resetFrame];
}


- (void)resetFrame{
    
    self.tipBgView.hidden = ([self.tipSting length] == 0);
    self.tipLable.hidden = self.tipBgView.hidden;
    self.desLable.hidden = self.desString.length == 0;
    
    float maxWidth = SC_WIDTH  - 50;
    float maxHeight = 200;
    
    
    CGSize tipSize =  [self.tipLable sizeThatFits:CGSizeMake(maxWidth, maxHeight)];
    CGSize desSize =  CGSizeZero;
    if(self.desString.length > 0){
        desSize =  [self.desLable sizeThatFits:CGSizeMake(maxWidth, maxHeight)];
    }
    
    float tipLineHeight = [self.tipLable.font lineHeight] + 2;
    float desLineHeight = [self.tipLable.font lineHeight] + 2;
    
    float tipShouldWidth = tipSize.width + 20;
    float desShouldWidth = desSize.width == 0 ? 0 : desSize.width + 7;
    
    
    
    if(tipSize.height > tipLineHeight || (desSize.height > 0 &&  desSize.height > desLineHeight) || (tipShouldWidth + desShouldWidth) > maxWidth || self.studyType == RBStudyTypeSentence){
        self.tipLable.frame = CGRectMake(10,  (28 - tipLineHeight )/2, tipSize.width, tipSize.height);
        self.tipBgView.frame = CGRectMake(0, 0 , tipShouldWidth, tipSize.height + 28 -  tipLineHeight);
        self.desLable.frame = CGRectMake(5, self.tipBgView.bottom + 12, desSize.width, desSize.height);
    }else{
        self.tipLable.frame = CGRectMake(10, (28 - tipLineHeight )/2, tipSize.width, tipSize.height);
        self.tipBgView.frame = CGRectMake(0, 0, tipShouldWidth, tipSize.height + 28 -  tipLineHeight);
        self.desLable.frame = CGRectMake(self.tipBgView.right + 7,  (28 - tipLineHeight)/2, desSize.width, desSize.height);
    }
    
    
    
    switch (self.studyType) {
        case RBStudyTypeWord: {
            self.tipLable.textColor = UIColorHex(0x5c8800);
            self.tipBgView.backgroundColor = mRGBToColor(0xe6fbab);
            break;
        }
        case RBStudyTypeSentence: {
            self.tipBgView.backgroundColor = mRGBToColor(0xffeac6);
            self.tipLable.textColor = UIColorHex(0xf19600);
            break;
        }
        case RBStudyTypeListen: {
            self.tipLable.textColor = UIColorHex(0xe95f9d);
            self.tipBgView.backgroundColor = mRGBToColor(0xffd9ea);
            break;
        }
    }
}

- (UILabel *)tipLable{
    if(!_tipLable){
        UILabel *menuTitle = [UILabel new];
        menuTitle.numberOfLines = 0;
        [self.contentView addSubview:menuTitle];
        menuTitle.text = @"apple";
        menuTitle.font = [UIFont systemFontOfSize:13];
        menuTitle.textColor = UIColorHex(0x5c8800);
        _tipLable = menuTitle;
    }
    return _tipLable;
}

- (UILabel *)desLable{
    if(!_desLable){
        UILabel *menuTitle = [UILabel new];
        menuTitle.numberOfLines = 0;
        [self.contentView addSubview:menuTitle];
        menuTitle.text = @"apple";
        menuTitle.backgroundColor = [UIColor clearColor];
        menuTitle.font = [UIFont systemFontOfSize:13];
        menuTitle.textColor = UIColorHex(0x8590a0);
        _desLable = menuTitle;
    }
    return _desLable;
}

- (UIView *)tipBgView{
    if(!_tipBgView){
        UIView * v =  [UIView new];
        v.backgroundColor = mRGBToColor(0xe6fbab);
        [self.contentView insertSubview:v belowSubview:self.tipLable];
        v.layer.cornerRadius = 7;
        [v setClipsToBounds:YES];
        
        
        _tipBgView = v;
    }
    return _tipBgView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.tipLable.hidden = YES;
        self.desLable.hidden = YES;
        self.tipBgView.hidden = YES;
    }
    return self;
}




+ (CGSize)getCellWidth:(NSString *)tipString DesString:(NSString *)desString StudyType:(RBStudyType)type{
    
    float maxWidth = SC_WIDTH - 50;
    float maxHeight = 200;
    
    UIFont * font = [UIFont systemFontOfSize:13];
    
    CGSize tipSize =  [tipString sizeForFont:font size:CGSizeMake(maxWidth, maxHeight) mode:NSLineBreakByWordWrapping];
    CGSize desSize =  CGSizeZero;
    if(desString.length > 0){
        desSize =  [desString sizeForFont:font size:CGSizeMake(maxWidth, maxHeight) mode:NSLineBreakByWordWrapping];
    }
    
    float tipLineHeight = [font lineHeight] + 2;
    float desLineHeight = [font lineHeight] + 2;
    
    float tipShouldWidth = tipSize.width + 20;
    float desShouldWidth = desSize.width == 0 ? 0 : desSize.width + 7;
    
    
    float hegith = 0;
    float width = 0;
    
    
    
    if(tipSize.height > tipLineHeight || (desSize.height > 0 &&  desSize.height > desLineHeight) || (tipShouldWidth + desShouldWidth) > maxWidth || type == RBStudyTypeSentence){
        hegith =  tipSize.height  + (28 - tipLineHeight )+ 12 + desSize.height;
        width = maxWidth;
    }else{
        width = tipShouldWidth + desShouldWidth;
        hegith =  28  ;
    }
    return CGSizeMake(width, hegith);
    
}

@end
