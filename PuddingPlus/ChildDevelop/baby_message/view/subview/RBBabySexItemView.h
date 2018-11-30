//
//  RBBabySexItemView.h
//  PuddingPlus
//
//  Created by kieran on 2018/3/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, RBSexType) {
    RBSexNone,
    RBSexBoy,
    RBSexGirl,
};

@interface RBBabySexItemView : UIView
@property(nonatomic,getter=isSelected) BOOL selected;
@property(nonatomic, assign, readonly ) RBSexType  sex;
@property(nonatomic, strong) void (^SexSelectBlock)(RBSexType);

- (id)initWithFrame:(CGRect)frame Sex:(RBSexType )sex;
@end
