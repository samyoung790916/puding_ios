//
//  PDExpressionCell.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDExpressionCell.h"

@implementation PDExpressionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBounds:(CGSize) bounds{
    
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor clearColor] ;
        self.backgroundView = nil;
        float xspace = 10;
        float width = [UIScreen mainScreen].bounds.size.width;
        CGSize iconSize = CGSizeMake( (width - xspace * 3)/4, SX(84.f)) ;
        for(int i = 0 ; i < 6; i ++){
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
            btn.frame = CGRectMake(i * iconSize.width + xspace, 0, SX(38), SX(27)) ;
            btn.tag = [@"express" hash] + i;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            btn.backgroundColor = [UIColor clearColor] ;
            btn.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
            [btn addTarget:self action:@selector(expressAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn.hidden = YES;
            
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectZero] ;
            lable.font = [UIFont systemFontOfSize:14];
            lable.textAlignment = 1;
            lable.textColor = mRGBToColor(0x505a66);
            lable.tag = [@"lab" hash] + i;
            [self addSubview:lable];
            lable.text = @"";
            
        }
        
    }
    
    
    return self ;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews] ;
    
    int count =  4;
    
    float xspace = 20;
    CGSize iconSize = CGSizeMake( SX(60), self.height - 13) ;
    
    float betSpace = (self.width - 2 * xspace - iconSize.width * count)/(count - 1);
    
    for(int i = 0 ; i < count; i ++){
        
        
        for(int i = 0 ; i < count; i ++){
            UIButton * btn = (UIButton *)[self viewWithTag:[@"express" hash] + i] ;
            UILabel * lable = (UILabel *)[self viewWithTag:[@"lab" hash] + i] ;
            if(i < _expressArray.count){
                
                
                btn.hidden = NO;
                lable.hidden = NO;
                btn.frame = CGRectMake(i * (iconSize.width + betSpace) + xspace , 5, iconSize.width, iconSize.height) ;
                lable.frame = CGRectMake(i * (iconSize.width + betSpace) + xspace , 37.5 + 10, iconSize.width, 13) ;
            }else{
                btn.hidden = YES;
                lable.hidden = YES;
            }
            
        }
        
    }
}

- (void)expressAction:(UIButton *)sender{
    if(_ExpressionBlock){
        NSDictionary * data = [_expressArray objectAtIndex:sender.tag - [@"express" hash]];
        _ExpressionBlock(sender,data,[[data objectForKey:@"value"] intValue]);
    }
    
}


- (void)setExpressArray:(NSArray *)expressArray{
    
    _expressArray = [expressArray copy];
    int count =  4;
    
    for(int i = 0 ; i < count; i ++){
        
        
        UIButton * btn   = (UIButton *)[self viewWithTag:[@"express" hash] + i];
        UILabel * lable = (UILabel *)[self viewWithTag:[@"lab" hash] + i] ;
        
        if(i < expressArray.count){
            NSDictionary * modle = [expressArray objectAtIndex:i];
            [btn setImage:[UIImage imageNamed:[modle objectForKey:@"img"]] forState:UIControlStateNormal];
            lable.text = [modle objectForKey:@"title"];
            btn.hidden = NO;
            lable.hidden = NO;
            
        }else{
            btn.hidden = YES;
            lable.hidden = YES;
            
        }
        
    }
}



@end
