//
//  RBEnglishClassCell.h
//  PuddingPlus
//
//  Created by kieran on 2017/2/28.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBStudyEnglishClassCell : UITableViewCell
@property(nonatomic,strong) NSString * iconUrl;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * desString;

@property(nonatomic,assign) BOOL  locked;
@property(nonatomic,assign) float  progress;

@property(nonatomic,strong) NSString * leanPos;
@end
