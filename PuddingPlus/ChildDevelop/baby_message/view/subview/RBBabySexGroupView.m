//
//  RBBabySexGroupView.m
//  PuddingPlus
//
//  Created by kieran on 2018/3/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBBabySexGroupView.h"


@interface RBBabySexGroupView()
@property(nonatomic, strong) RBBabySexItemView *boyItemView;
@property(nonatomic, strong) RBBabySexItemView *girlItemView;
@end

@implementation RBBabySexGroupView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.boyItemView.hidden = NO;
        self.girlItemView.hidden = NO;
    }
    return self;
}

#pragma mark 懒加载 boyItemView
- (RBBabySexItemView *)boyItemView{
    if (!_boyItemView){
        RBBabySexItemView * view = [[RBBabySexItemView alloc] initWithFrame:CGRectMake(0, 0, 135, 44) Sex:RBSexBoy];
        view.backgroundColor = [UIColor clearColor];
        @weakify(self)
        [view setSexSelectBlock:^(RBSexType type) {
            @strongify(self);
            [self updateSex:type];
        }];
        [self addSubview:view];
        _boyItemView = view;
    }
    return _boyItemView;
}

#pragma mark 懒加载 girlItemView
- (RBBabySexItemView *)girlItemView{
    if (!_girlItemView){
        RBBabySexItemView * view = [[RBBabySexItemView alloc] initWithFrame:CGRectMake(self.boyItemView.right + 28, 0, 135, 44) Sex:RBSexGirl];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        @weakify(self)
        [view setSexSelectBlock:^(RBSexType type) {
            @strongify(self);
            [self updateSex:type];
        }];
        _girlItemView = view;
    }
    return _girlItemView;
}

- (void)updateSex:(RBSexType)sexType{
    self.sex = sexType;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setSex:(RBSexType)sex {
    _sex = sex;
    if (sex == RBSexGirl){
        self.boyItemView.selected = NO;
        self.girlItemView.selected = YES;
    }else if (sex == RBSexBoy){
        self.boyItemView.selected = YES;
        self.girlItemView.selected = NO;
    }
}

@end
