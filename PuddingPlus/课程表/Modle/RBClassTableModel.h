//
//  RBClassTableModel.h
//  PuddingPlus
//
//  Created by liyang on 2018/4/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBClassTableContentDetailModel;
@class RBClassTableContentDetailListModel;

@interface RBClassTableModel : NSObject
@property(nonatomic, strong) NSArray *menu;
@property(nonatomic, strong) NSArray *module;
@end

@interface RBClassTableMenuModel : NSObject
@property(nonatomic,strong) NSString * type;
@property(nonatomic,assign) int  _id;
@property(nonatomic,strong) NSString * name;
@end

@interface RBClassTableContentModel : NSObject
@property(nonatomic,strong) NSArray * content;
@end

@interface RBClassTableContentDetailModel : NSObject
@property(nonatomic,assign) int  _id;
@property(nonatomic,assign) int  menuId;
@property(nonatomic,assign) NSTimeInterval  date;
@property(nonatomic,strong) NSString * groupId;
@property(nonatomic,assign) int  type;
@property(nonatomic, strong) RBClassTableContentDetailListModel *content;
@end

@interface RBClassTableContentDetailListModel : NSObject
@property(nonatomic,assign) int  _id;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * imgSmall;
@property(nonatomic,strong) NSString * imgLarge;
@property(nonatomic,strong) NSString * desc;
@property(nonatomic, strong) NSArray *list;
@property(nonatomic,assign) int  duration;
@end

@interface RBClassTableContentDetailListInfoModel : NSObject
@property(nonatomic,assign) int  _id;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,assign) int  length;
@property(nonatomic,assign) int  size;
@property(nonatomic,strong) NSString * content;
@property(nonatomic,assign) int  type;

@end

@interface RBClassTableContainerModel : NSObject
@property(nonatomic,assign) int  result;
@property(nonatomic,strong) NSString * msg;
@property(nonatomic, strong) RBClassTableModel *data;

@end
