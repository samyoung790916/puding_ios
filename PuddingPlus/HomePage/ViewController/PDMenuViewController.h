//
//  PDMenuViewController.h
//  Pudding
//
//  Created by baxiang on 16/9/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDModule.h"
#import "PDFeatureModle.h"
@interface PDMenuViewController : PDBaseViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong) PDModule *module;
@property(nonatomic,copy)void(^featureModleBlock) (PDMenuViewController *vc ,PDFeatureModle *modle);
@end
