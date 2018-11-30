//
//  PDFeatureListController.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFeatureModle.h"
#import "PDFeatureDetailsController.h"
#import "PDBaseViewController.h"
#import "RBClassTableModel.h"

@interface PDFeatureListController : PDBaseViewController
@property (nonatomic,strong) PDFeatureModle * modle; // 当前资源
@property (nonatomic,strong) RBClassTableContentDetailModel *classModel;
@property (nonatomic,assign) BOOL isDIYAlbum;
@end
