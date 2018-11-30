//
//  PDEnglishSongCell.h
//  Pudding
//
//  Created by baxiang on 16/7/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFeatureModle.h"
typedef void (^EnglishCollectBtnClickedBack)();
@interface PDEnglishSongCell : UITableViewCell
@property (strong, nonatomic) PDFeatureModle *model;

@property (nonatomic, assign,getter=isPlay) BOOL play;

@property (strong, nonatomic) EnglishCollectBtnClickedBack clickBack;
@end
