//
//  PDSelectMtuView.m
//  PuddingPlus
//
//  Created by kieran on 2017/9/13.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//
#import "RBUserDataCache.h"

#import "PDSelectMtuView.h"
@interface PDSelectMtuView(){
    NSArray * btnArray ;
    NSArray * mtuValueArray;
}
@end


@implementation PDSelectMtuView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame: frame]){
        self.backgroundColor = mRGBAToColor(0x000000, .6);
        [self loadViews];
        self.alpha = 0;
        self.isShow = NO;
        mtuValueArray = @[NSLocalizedString( @"video_format_smooth", nil),NSLocalizedString( @"video_format_standard", nil),NSLocalizedString( @"video_format_fast", nil),NSLocalizedString( @"video_format_speed", nil)];
    }
    return self;
}

+ (NSString *)getMtuValue{
     NSArray* mtuValueArray = @[NSLocalizedString( @"video_format_smooth", nil),NSLocalizedString( @"video_format_standard", nil),NSLocalizedString( @"video_format_fast", nil),NSLocalizedString( @"video_format_speed", nil)];
    return [mtuValueArray objectAtIndex: [PDSelectMtuView getCacheIndex]];
}
- (void)showSelectView{
    if(self.isShow)
        return;
    CGRect selfFrame = self.frame;
    CGRect newFrame = CGRectMake(selfFrame.origin.x + selfFrame.size.width, selfFrame.origin.y, selfFrame.size.width, selfFrame.size.height);
    self.frame = newFrame;
    self.alpha = 1;
    @weakify(self)
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.9 initialSpringVelocity:5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        @strongify(self)
        self.frame = selfFrame;
    } completion:^(BOOL finished) {
        @strongify(self)
        self.isShow = YES;
    }];
}

- (void)hiddenSelectView{
    if(!self.isShow)
        return;
    
    CGRect selfFrame = self.frame;
    CGRect newFrame = CGRectMake(selfFrame.origin.x + selfFrame.size.width, selfFrame.origin.y, selfFrame.size.width, selfFrame.size.height);
    @weakify(self)
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.9 initialSpringVelocity:5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        @strongify(self)
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        @strongify(self)
        self.alpha = 0;
        self.frame = selfFrame;
        self.isShow = NO;
    }];

}

- (void)loadViews{
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, SX(47), self.width, SX(17))];
    lable.font = [UIFont boldSystemFontOfSize:SX(16)];
    lable.textColor = mRGBToColor(0xffffff);
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = NSLocalizedString( @"video_smoothness", nil);
    [self addSubview:lable];
    
    
    float height = SX(40);
    float space = (self.height - lable.bottom - SX(48) - SX(45))/4 - height;
    
    float yValue = lable.bottom + SX(45);
    
    NSMutableArray * arrays = [NSMutableArray new];
    
    for (int i = 0; i < 4; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        btn.tag = [@"btn" hash] + i;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:mRGBToColor(0xffffff) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:SX(16)];
        btn.frame = CGRectMake(0, yValue, self.width, height);
        [btn setTitleColor:mRGBToColor(0x8ec31f) forState:UIControlStateSelected];
        [self addSubview:btn];
        
        [btn setTitle:[mtuValueArray objectAtIndex:i] forState:UIControlStateNormal];

        if(i == 2){
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(btn.width/2 + SX(19), SX(7), SX(25), SX(13))];
            lable.text = NSLocalizedString( @"recommended_", nil);
            lable.textAlignment = NSTextAlignmentCenter;
            lable.backgroundColor = [UIColor redColor];
            lable.font = [UIFont systemFontOfSize:SX(8)];
            lable.textColor = [UIColor whiteColor];
            lable.layer.cornerRadius = SX(6.5);
            lable.clipsToBounds = YES;
            [btn addSubview:lable];
        }
        yValue = btn.bottom + space;
        
        [arrays addObject:btn];
    }
    btnArray = arrays;
    [self selectIndex:[PDSelectMtuView getCacheIndex]];


}

- (void)setMtuValueChange:(void (^)(NSString *))MtuValueChange{
    _MtuValueChange = MtuValueChange;
//    if(_MtuValueChange){
//        if(self.MtuValueChange){
//            self.MtuValueChange([PDSelectMtuView getMtuValue]);
//        }
//    }
}

- (void)buttonAction:(UIButton *)sender{
    NSUInteger index = sender.tag - [@"btn" hash];
    if(index > 3)
        return;
    [self selectIndex:index];
    [PDSelectMtuView updateIndex:index];
    if(self.MtuValueChange){
        self.MtuValueChange([PDSelectMtuView getMtuValue]);
    }
    [self hiddenSelectView];
    
}


- (void)selectIndex:(NSUInteger)index{
    for(int i = 0 ; i < 4 ; i ++){
        UIButton * btn = [btnArray objectAtIndex:i];
        btn.selected = index == i;
    }
}

+ (NSUInteger)getCacheIndex{
    NSString * keyString = @"video_mtu_value";
    NSString * value = [RBUserDataCache cacheForKey:keyString];
    if([value mStrLength] == 0){
        NSInteger index = 2;
        [RBUserDataCache saveCache:[NSString stringWithFormat:@"%ld",(long)index] forKey:keyString];
        return index;
    }else{
        return [value integerValue];
    }
}

+ (void)updateIndex:(NSUInteger)index{
    NSString * keyString = @"video_mtu_value";
    [RBUserDataCache saveCache:[NSString stringWithFormat:@"%ld",(long)index] forKey:keyString];
}

- (void)dealloc{

}
@end
