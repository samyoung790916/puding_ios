//
//  ZYShareContentView.m
//  Pods
//
//  Created by Zhi Kuiyu on 16/7/22.
//
//

#import "ZYShareContentView.h"
#import "ZYShareView.h"

#define msscale 0.57 //左右边距相对2icon 间距的宽比
#define itemtop 26
#define itemwidth 61
#define itemheight 90

@implementation ZYShareContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        
        UIButton * cancle = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancle setBackgroundColor:[UIColor whiteColor]];
        [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancle.titleLabel.font = [UIFont systemFontOfSize:sc(17)];
        [cancle setTitleColor:[UIColor colorWithRed:80/255.0 green:90/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        [cancle setTitle:NSLocalizedString( @"g_cancel", nil) forState:0];
        [cancle addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
        cancle.frame = CGRectMake(0, CGRectGetHeight(frame) - sc(45) - SC_FOODER_BOTTON, CGRectGetWidth(frame), sc(45));
        [self addSubview:cancle];
        
//
//        //加阴影--任海丽编辑
//        cancle.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//        cancle.layer.shadowOffset = CGSizeMake(1,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        cancle.layer.shadowOpacity = 1;//阴影透明度，默认0
//        cancle.layer.shadowRadius = 1;//阴影半径，默认3
    }
    return self;
}


- (void)addItems:(NSArray *)itemNames ItemIcon:(NSArray *)icons Tags:(NSArray *)tags{
    NSAssert(itemNames.count != icons.count != tags.count, @"itemNames  icons  tags count must be same");
    int count = (int)itemNames.count;
    if(count == 0)
        return;
    float space;
    float left = sc(35);
    if(count == 1){
        left = (CGRectGetWidth(self.frame) - itemwidth)/2.f;
        space = 0;
    }else{
        space = (CGRectGetWidth(self.frame)  - sc(itemwidth) * count)/(count -1 + msscale * 2);
        left = space * msscale;
    }
    
    for(int i = 0 ; i < itemNames.count; i++){
        UIControl * control = [[UIControl alloc] initWithFrame:CGRectMake(left + i * sc(itemwidth + space), sc(itemtop), sc(itemwidth), itemheight)];
        
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sc(itemwidth), sc(itemwidth))];
        [img setImage:[icons objectAtIndex:i]];
        [control addSubview:img];
        
        
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame) + sc(10), sc(itemwidth), 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:sc(13)];
        lable.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
        lable.text = [itemNames objectAtIndex:i];
        [control addSubview:lable];

        control.tag = [[tags objectAtIndex:i] integerValue];
        [control addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:control];
    }
    
}


- (void)buttonAction:(UIButton *)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(shareItemSelect:)]){
        [_delegate shareItemSelect:(int)sender.tag];
    }
}

- (void)cancleAction:(UIButton *)sender{

    if(_delegate && [_delegate respondsToSelector:@selector(shareCancle)]){
        [_delegate shareCancle];
    }
}
@end
