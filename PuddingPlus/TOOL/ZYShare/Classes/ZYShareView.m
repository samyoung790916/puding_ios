//
//  ZYShareView.m
//  Pods
//
//  Created by Zhi Kuiyu on 16/7/22.
//
//

#import "ZYShareView.h"
#import "ZYShareContentView.h"



@implementation ZYShareView{
    ZYShareContentView * shareView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
    }
    
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hiddenAnimails];
}


- (void)showShareView:(NSArray *)itemNames ItemIcon:(NSArray *)icons Tags:(NSArray *)tags{
    shareTags = tags;
    
    shareView = [[ZYShareContentView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - sc(187), CGRectGetWidth(self.frame), sc(187) + SC_FOODER_BOTTON)];
    shareView.userInteractionEnabled = YES;
    shareView.delegate = self.delegate;
    [self addSubview:shareView];
    
    [shareView addItems:itemNames ItemIcon:icons Tags:shareTags];
    
    
}

- (void)showAnimails{
    shareView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), sc(187) + SC_FOODER_BOTTON);
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:.3 animations:^{
        shareView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - sc(187) -  SC_FOODER_BOTTON , CGRectGetWidth(self.frame), sc(187) + SC_FOODER_BOTTON);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];

    }];

}


- (void)hiddenAnimails{
    shareView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - sc(187), CGRectGetWidth(self.frame), sc(187) + SC_FOODER_BOTTON);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];

    __weak ZYShareView * weakself = self;
    
    [UIView animateWithDuration:.3 animations:^{
        shareView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), sc(187) + SC_FOODER_BOTTON);
        self.backgroundColor = [UIColor clearColor];
        
    }completion:^(BOOL finished) {
        
        
        if(weakself.HiddenBlock){
            weakself.HiddenBlock (weakself);
        }
        [weakself removeFromSuperview];

    }];
}

- (void)dealloc{
    NSLog(@"%@ delloc",[self class]);
}
@end
