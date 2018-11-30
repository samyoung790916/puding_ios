//
//  BlockButton.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/3/19.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockButton : UIButton

@property (nonatomic,copy) void(^ButtonAction)(UIButton *);

@end
