//
//  PDAllMenuCell.h
//  Pudding
//
//  Created by baxiang on 16/9/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDModule.h"
#import "PDFilterMenus.h"
typedef NS_ENUM(NSInteger,PDFilterMenuType) {
    PDFilterMenuAge = 0,
    PDFilterMenuModule =1,
    
};

@interface PDFilterMenuCell : UICollectionViewCell
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) PDModule *module;
@property (nonatomic,strong) PDFilterAge *age;
@property (nonatomic,copy) void(^ageSelectBlock)(UIButton *btn,PDFilterAge *age);
@property (nonatomic,copy) void(^moduleSelectBlock)(UIButton *btn,PDModule *module);
@property (nonatomic,assign) PDFilterMenuType filterType;
@property (nonatomic,strong) UIButton *itemBtn;
@end
