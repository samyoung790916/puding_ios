//
//  RBEnglistTypeReusableView.h
//  PuddingPlus
//
//  Created by kieran on 2017/3/1.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RBEnglishKnowledgeTypeModle.h"

@interface RBEnglistTypeReusableView : UICollectionReusableView

@property(nonatomic,strong) void(^moreContentBlock)(RBEnglistTypeReusableView * );

@property(nonatomic,strong) NSString * titleString;

@property(nonatomic,strong) NSString * iconName;

@property(nonatomic,assign) BOOL showMoreBtn;

@property(nonatomic,strong) NSIndexPath * indexPath;

- (void)setTitleString:(NSString *)titleString IsDisable:(BOOL)isDisable;


@end
