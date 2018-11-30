//
//  RBThreeBtnCollectionReusableView.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/13.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBThreeBtnCollectionReusableView.h"
#import "PDFeatureListController.h"
#import "PDCollectionViewController.h"
#import "GrowthGuideViewController.h"

@implementation RBThreeBtnCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
- (IBAction)DIYMusicBtnAction:(id)sender {
    [self requestAlbum];
    [RBStat logEvent:PD_HOME_BABY_HISTORY_MORE message:nil];
}
- (IBAction)grownPlanBtnAction:(id)sender {
    GrowthGuideViewController *vc = [[GrowthGuideViewController alloc] initWithNibName:@"GrowthGuideViewController" bundle:nil];
    [self.topViewController.navigationController pushViewController:vc animated:YES];
}
- (IBAction)myCollectBtnActionn:(id)sender {
    PDCollectionViewController * vi =[[PDCollectionViewController alloc]init];
    vi.selectIndex = 1;
    [self.topViewController.navigationController pushViewController:vi animated:YES];
    [RBStat logEvent:PD_HOME_BABY_COLLECTION_MORE message:nil];
}
- (void)requestAlbum{
    [RBNetworkHandle getAlbumresourceAndBlock:^(id res) {
        if (res&&[[res objectForKey:@"result"] intValue]==0) {
            // 数据解析
            NSArray * arr = [[res objectForKey:@"data"] objectForKey:@"categories"];
            if (arr.count>0) {
                PDFeatureModle *model = [PDFeatureModle modelWithJSON:arr[0]];
                NSNumber *albID = [arr[0] objectForKey:@"id"];
                RBDeviceModel *device = RBDataHandle.currentDevice;
                device.albumId = albID;
                [RBDataHandle updateCurrentDevice:device];
                PDFeatureListController * contr = [[PDFeatureListController alloc] init];
                contr.modle = model;
                contr.isDIYAlbum = YES;
                [self.topViewController.navigationController pushViewController:contr animated:YES];
            }
        }
    }];
}
@end
