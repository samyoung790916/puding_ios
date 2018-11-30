//
//  RBBabyDateCell.h
//  PuddingPlus
//
//  Created by kieran on 2018/3/30.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBBabyDateCell : UITableViewCell
@property(nonatomic, strong) NSString *birthday;
@property(nonatomic, strong) void (^SelectBabyBirthday)(NSString *birthday);
@end
