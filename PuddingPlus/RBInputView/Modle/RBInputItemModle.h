//
//  RBInputItemModle.h
//  RBInputView
//
//  Created by kieran on 2017/2/8.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBInputItemModle : NSObject

@property(nonatomic,strong) NSString * normailIcon;

@property(nonatomic,strong) NSString * selectIcon;

@property(nonatomic,strong) NSString * itemClass;

@property(nonatomic,assign) BOOL       isSelect;

@property(nonatomic, assign) BOOL       shouldShowNew;

@end
