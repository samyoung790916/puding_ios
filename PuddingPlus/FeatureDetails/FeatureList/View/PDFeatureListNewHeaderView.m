//
//  PDFeatureListNewHeaderView.m
//  PuddingPlus
//
//  Created by liyang on 2018/4/19.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDFeatureListNewHeaderView.h"
#import "RBClassTableViewController.h"

@implementation PDFeatureListNewHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    [self addBlurEffectView:_bgImageView];
}
- (void)setModel:(PDFeatureModle *)model{
    _model = model;
    _titleLabel.text = model.title;
    _detailLabel.text = model.desc;
    [_imageView setImageWithURL:[NSURL URLWithString:model.thumb] placeholder:[UIImage imageNamed:@"cover_play_default"]];
    [_bgImageView setImageWithURL:[NSURL URLWithString:model.thumb] placeholder:[UIImage imageNamed:@"cover_play_default"]];
    if ([RBDataHandle.currentDevice isPuddingPlus] && !model.isBabyPlan) {
        self.joinClassTableBtn.hidden = NO;
    }
    else{
        self.joinClassTableBtn.hidden = YES;
    }
}
- (void)setClassTableModel:(RBClassTableContentDetailModel*)classTableModel{
    _classTableModel = classTableModel;
    if (_classTableModel) {
        [_joinClassTableBtn setTitle:@"已加入" forState:(UIControlStateNormal)];
        self.isJoined = YES;
    }
}
- (void)setAudioNum:(NSUInteger)audioNum{
    _audioNumLabel.text = [NSString stringWithFormat:@"音频个数:%lu",(unsigned long)audioNum];
}
- (IBAction)joinClass:(id)sender {
    if (_isJoined) {
        return;
    }
    NSDictionary *dic =  RBDataHandle.classTableStoreDic;
    if (dic == nil) {
        [self toClassTable];
    }
    else{
        [self joinClassWith:dic];
    }
}
- (void)joinClassWith:(NSDictionary*)dic{
    [MitLoadingView showWithStatus:@"show"];
    @weakify(self)

        [RBNetworkHandle addCourseData:_model.mid type:@"0" menuId:dic[@"menuId"] dayIndex:[dic[@"dayIndex"] intValue] WithBlock:^(id res) {
            [MitLoadingView dismiss];
            @strongify(self)
            if(res && [[res objectForKey:@"result"] integerValue] == 0){
                [_joinClassTableBtn setTitle:@"已加入" forState:(UIControlStateNormal)];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshClassTable" object:nil];
                [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"success", nil) maskType:MitLoadingViewMaskTypeBlack];
                self.isJoined = YES;
                RBDataHandle.classTableStoreDic = nil;
                [self popBack];
            }
            else{
                [MitLoadingView showErrorWithStatus:RBErrorString(res)];
            }
        }];
}
- (void)popBack{
    UINavigationController *navVC = [self viewController].navigationController;
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (UIViewController *vc in [navVC viewControllers]) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[RBClassTableViewController class]]) {
            break;
        }
    }
    [navVC setViewControllers:viewControllers animated:YES];
}
- (void)toClassTable{
    RBClassTableViewController * v = [[RBClassTableViewController alloc] init];
    v.mid = _model.mid;
    [[self viewController].navigationController pushViewController:v animated:YES];
    
}
- (void)addBlurEffectView:(UIView*)view{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, SC_WIDTH, view.frame.size.height);
    [self insertSubview:effectView aboveSubview:view];
    UIView *blackView = [[UIView alloc] initWithFrame:effectView.frame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.25;
    [self insertSubview:blackView aboveSubview:effectView];
}
@end
