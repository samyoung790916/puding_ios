//
//  PDMainMenuCell.h
//  Pudding
//
//  Created by baxiang on 16/9/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDModules.h"
@interface PDMainMenuCell : UICollectionViewCell
@property (nonatomic,strong) PDCategory *categoty;
@property (nonatomic,strong) PDModule *module;
@property (nonatomic,assign) NSInteger index;
@end
