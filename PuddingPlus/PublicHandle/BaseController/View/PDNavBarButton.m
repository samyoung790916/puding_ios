//
//  PDNavBarButton.m
//  Pudding
//
//  Created by william on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDNavBarButton.h"
#import "PDNavItem.h"

@implementation PDNavBarButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setItem:(PDNavItem *)item{
    _item = item;
    UIImage * image;
    if([item.normalImg length]){
        image = [UIImage imageNamed:item.normalImg];
        if(image)
            [self setImage:image forState:UIControlStateNormal];
    }
    if([item.selectedImg length]){
        image = [UIImage imageNamed:item.selectedImg];
        if(image)
            [self setImage:image forState:UIControlStateSelected];
    }
    if([item.selectedImg length]){
        image = [UIImage imageNamed:item.highlightedImg];
        if(image)
            [self setImage:image forState:UIControlStateHighlighted];
    }
    
    [self setTitle:[item.title length] ? item.title : @"" forState:UIControlStateNormal];
    self.titleLabel.font = item.font ? item.font : [UIFont systemFontOfSize:SX(16)];
    [self setTitle:[item.selectedTitle length]? item.selectedTitle:@""  forState:UIControlStateSelected];
    [self setTitleColor:[item.titleColor isKindOfClass:[UIColor class]] ?item.titleColor : [UIColor whiteColor]  forState:UIControlStateNormal];
    [self setTitleColor:[item.selectedTitleColor isKindOfClass:[UIColor class]] ?item.selectedTitleColor : [UIColor blackColor]  forState:UIControlStateSelected];
    [self setTitleColor:[item.highlightedTitleColor isKindOfClass:[UIColor class]] ?item.highlightedTitleColor : [UIColor whiteColor]  forState:UIControlStateHighlighted];
    [self setBackgroundColor:[item.backgrooundColor isKindOfClass:[UIColor class]] ?item.backgrooundColor : [UIColor clearColor]];
    self.titleLabel.textAlignment = item.textAligment;
}

@end
