//
//  PDMainFooderView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMainFooderCellView.h"

@interface PDMainFooderView : UIView
@property (nonatomic,copy) void(^MenuClickBlock)(ButtonType);
- (void)updateRedPoint;
- (void)updateButtonImage;

/**
 切换布丁时,需要重新刷新一下按钮
 */
- (void)resetBottomBtn;
@end
