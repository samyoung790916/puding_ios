//
//  RBBabySexItemView.m
//  PuddingPlus
//
//  Created by kieran on 2018/3/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBBabySexItemView.h"

@interface RBBabySexItemView()
@property(nonatomic, strong) UIImageView    *sexTipImage;
@property(nonatomic, strong) UIView         *sexBorderView;
@property(nonatomic, strong) UILabel        *sexTipLabel;
@end

@implementation RBBabySexItemView
@synthesize selected = _selected;

- (id)initWithFrame:(CGRect)frame Sex:(RBSexType )sex{
    if (self = [super initWithFrame:frame]){
        self.sex = sex;
        self.sexTipImage.hidden = NO;
        self.sexTipLabel.hidden = NO;

    }
    return self;
}

#pragma mark 懒加载 sexBorderView
- (UIView *)sexBorderView{
    if (!_sexBorderView){
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 60, 44)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = 22;
        view.layer.borderColor = [UIColor clearColor].CGColor;
        view.layer.borderWidth = 3;
        view.clipsToBounds = YES;
        [self addSubview:view];

        _sexBorderView = view;
    }
    return _sexBorderView;
}


#pragma mark 懒加载 sexTipImage
- (UIImageView *)sexTipImage{
    if (!_sexTipImage){
        UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 60, 40)];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        view.clipsToBounds = YES;
        _sexTipImage = view;
    }
    return _sexTipImage;
}

#pragma mark 懒加载 sexTipLabel
- (UILabel *)sexTipLabel{
    if (!_sexTipLabel){
        UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(self.sexTipImage.right + 12, 4, 35, 40)];
        view.backgroundColor = [UIColor clearColor];
        view.textColor = mRGBToColor(0x9b9b9b);
        view.font = [UIFont systemFontOfSize:14];
        [self addSubview:view];

        _sexTipLabel = view;
    }
    return _sexTipLabel;
}


- (void)setSex:(RBSexType)sex {
    _sex = sex;
    if (sex == RBSexBoy){
        [self.sexTipImage setImage:[UIImage imageNamed:@"ic_information_boy"]];
        self.sexTipLabel.text = NSLocalizedString(@"boy", @"男孩");
    }else if (sex == RBSexGirl){
        [self.sexTipImage setImage:[UIImage imageNamed:@"ic_information_gril"]];
        self.sexTipLabel.text = NSLocalizedString(@"girl", @"女孩");
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected){
        self.sexTipLabel.textColor = [RBCommonConfig getCommonColor];
        self.sexBorderView.layer.borderColor = [RBCommonConfig getCommonColor].CGColor;
    }else{
        self.sexTipLabel.textColor = mRGBToColor(0x9b9b9b);
        self.sexBorderView.layer.borderColor = [UIColor clearColor].CGColor;

    }
}


- (BOOL)isSelected {
    return _selected;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    self.selected = YES;
    if (self.SexSelectBlock){
        self.SexSelectBlock(self.sex);
    }
}
@end
