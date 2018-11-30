//
//  PDMainFooderPuddingView.m
//  PuddingPlus
//
//  Created by liyang on 2018/5/25.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDMainFooderPuddingView.h"
#import "RBMyRobotController.h"
#import "PDXNetConfigZeroController.h"

@implementation PDMainFooderPuddingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    @weakify(self)
    [self rb_puddingStatus:^(RBPuddingStatus status) {
        @strongify(self)
        NSLog(@"puddingState-----%lu",(unsigned long)status);
        if (RBDataHandle.currentDevice.isStorybox) {
            switch (self.puddingState) {
                case RBPuddingNone: {
                    [self.puddingBtn setImage:[UIImage imageNamed:@"changtai"] forState:(UIControlStateNormal)];
                    break;
                }
                case RBPuddingOffline: {
                    [self.puddingBtn setImage:[UIImage imageNamed:@"duanwang"] forState:(UIControlStateNormal)];
                    break;
                }
                case RBPuddingLocked:{
                    [self.puddingBtn setImage:[UIImage imageNamed:@"changtai"] forState:(UIControlStateNormal)];
                    break;
                }
                case RBPuddingPlaying: {
                    [self.puddingBtn setImage:[UIImage imageNamed:@"bofangyinyue"] forState:(UIControlStateNormal)];
                    break;
                }
                case RBPuddingMessage: {
                    [self.puddingBtn setImage:[UIImage imageNamed:@"changtai"] forState:(UIControlStateNormal)];
                    break;
                }
                case RBPuddingPause: {
                    [self.puddingBtn setImage:[UIImage imageNamed:@"changtai"] forState:(UIControlStateNormal)];
                    break;
                }
                case RBPuddingLowPower: {
                    [self.puddingBtn setImage:[UIImage imageNamed:@"meidian"] forState:(UIControlStateNormal)];
                    break;
                }
                case RBPuddingChildLockOn:{
                    [self.puddingBtn setImage:[UIImage imageNamed:@"lock_puddingX"] forState:(UIControlStateNormal)];
                    break;
                }
            }
        }
    }];
}
- (IBAction)pdBtnAction:(id)sender {
    if (self.puddingState == RBPuddingOffline) {
        if([RBDataHandle.currentDevice isPuddingPlus]){
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_check_net_state_2", nil)];
        }else{
            PDXNetConfigZeroController *vc = [[PDXNetConfigZeroController alloc] init];
            vc.addType = PDAddPuddingTypeUpdateData;
            [[self topViewController].navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        RBMyRobotController *vc = [[RBMyRobotController alloc] initWithNibName:@"RBMyRobotController" bundle:nil];
        vc.fromFooter = YES;
        [[self viewController].navigationController pushViewController:vc animated:true];
    }
}
@end
