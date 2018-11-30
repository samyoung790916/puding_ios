//
//  PDBindPuddingSucessAnimailView.h
//  TestAnimail
//
//  Created by Zhi Kuiyu on 16/4/27.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDBindPuddingSucessAnimailView : UIView


@property (nonatomic,copy) void(^SendBindPuddingCmd)(id);
@property (nonatomic,copy) void(^DoneBlockAction)(id);

- (void)beginPlayAnimail;

@end
