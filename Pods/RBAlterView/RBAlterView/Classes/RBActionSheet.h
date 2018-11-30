//
//  RBActionSheet.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/3/19.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBActionSheet : UIView

@property (nonatomic,strong) void(^SelectActionIndexBlock)(int);

- (id)initWithFrame:(CGRect)frame WithItems:(NSArray *) array DestructiveItem:(NSString *)destructiveTitle CancleItem:(NSString *)cancleTitle;
- (id)initWithFrame:(CGRect)frame WithItems:(NSArray *) array Images:(NSArray *)images Title:(NSString *)title CancleItem:(NSString *)cancleTitle;
- (void)deallocBlockData;
@end
