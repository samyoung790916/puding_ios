//
//  RBBabyNameCell.h
//  PuddingPlus
//
//  Created by kieran on 2018/3/29.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDGrowplan.h"

@protocol BabyNameDelegate
- (void)nameChange:(NSString*)name;
- (void)photoChange;

@end

@interface RBBabyNameCell : UITableViewCell

@property(nonatomic, strong) NSString *babyName;
@property(weak, nonatomic) id <BabyNameDelegate> delegate;
@property(nonatomic, strong) PDGrowplan  * growplan;

@end
