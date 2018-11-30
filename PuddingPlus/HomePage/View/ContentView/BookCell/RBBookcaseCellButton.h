//
// Created by kieran on 2018/2/26.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RBBookcaseCellButton : UIView
@property(nonatomic, assign) CGSize imageSize;

- (void)setImage:(NSString *)plachImage ImageURL:(NSString *)imageURL;
@end