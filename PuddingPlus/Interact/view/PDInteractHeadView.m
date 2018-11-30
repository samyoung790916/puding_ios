//
//  PDInteractHeadView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDInteractHeadView.h"

@implementation PDInteractHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = mRGBToColor(0xfafafa);
        
        UIFont * font =[UIFont systemFontOfSize:SX(13)];
        UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(SX(15), SX(9.4), SX(300), font.lineHeight)];
        titleLable.font = font;
        titleLable.textColor = mRGBToColor(0xb1b1b1);
        titleLable.text = NSLocalizedString( @"every_story_needs_the_baby's_participation_and_interaction", nil);
        [self addSubview:titleLable];
        
        font =[UIFont systemFontOfSize:SX(11)];
        UILabel * desLable = [[UILabel alloc] initWithFrame:CGRectMake(SX(15), titleLable.bottom + SX(5), SX(300), font.lineHeight)];
        desLable.font = font;
        desLable.textColor = mRGBToColor(0xb1b1b1);
        desLable.text = NSLocalizedString( @"let_the_baby_be_more_focused_and_make_the_story_more_intererting", nil);
        [self addSubview:desLable];
        
        
        UIButton * exampleBtn = [UIButton buttonWithType:0];
        [exampleBtn setTitle:NSLocalizedString( @"see_examp", nil) forState:0];
        exampleBtn.titleLabel.font = [UIFont systemFontOfSize:SX(13)];
        float width = [exampleBtn.titleLabel sizeThatFits:CGSizeMake(10000, 100)].width;
        
        [exampleBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [exampleBtn setTitleColor:mRGBToColor(0x26bef5) forState:0];
        [exampleBtn setImage:[UIImage imageNamed:@"story_icon_back"] forState:0];
        [exampleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [exampleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, SX(-5), 0, 0)];
        [exampleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, width + SX(8), 0, 0)];
        exampleBtn.frame = CGRectMake(SC_WIDTH - SX(90), 0, SX(100), self.height);
        [self addSubview:exampleBtn];
    }
    
    return self;
}


- (void)buttonAction:(id)sender{
    if(_ButtonAction){
        _ButtonAction(sender);
    }
}

@end
