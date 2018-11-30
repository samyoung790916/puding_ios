//
//  PDFeatureListNewHeaderView.h
//  PuddingPlus
//
//  Created by liyang on 2018/4/19.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBClassTableModel.h"

@interface PDFeatureListNewHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinClassTableBtn;
@property (weak, nonatomic) IBOutlet UILabel *audioNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *learnNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLengthLabel;
@property (strong, nonatomic)PDFeatureModle *model;
@property (assign, nonatomic)NSUInteger audioNum;
@property (assign, nonatomic)BOOL isJoined;
@property (strong, nonatomic)RBClassTableContentDetailModel *classTableModel;

@end
