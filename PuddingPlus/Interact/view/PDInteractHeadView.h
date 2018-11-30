//
//  PDInteractHeadView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDInteractHeadView : UIView

@property (nonatomic,copy) void(^ButtonAction)(id);

@end
