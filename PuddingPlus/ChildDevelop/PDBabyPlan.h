//
//  PDBabyPlan.h
//  Pudding
//
//  Created by baxiang on 16/11/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PDBabyPlanResources: NSObject
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *cid;
@property(nonatomic,strong) NSString *rid;
@property(nonatomic,strong) NSString *img;
@property(nonatomic,strong) NSString *thumb;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,strong) NSString * weekage;
@property(nonatomic,strong) NSString * nickname;
@property(nonatomic,strong) NSString * field;

@property(nonatomic,strong) NSArray<NSString*> *tags;
@end

@interface PDBabyPlanTags: NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) NSInteger val;
@end
@interface PDBabyPlanMod : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) float score;
@property(nonatomic,strong) NSString *features;
@property(nonatomic,strong) NSArray<PDBabyPlanTags*>*tags;
@property(nonatomic,strong) NSArray<PDBabyPlanResources*>*resources;
@end


@interface PDBabyPlan : NSObject
@property(nonatomic,assign) NSInteger code;
@property(nonatomic,strong) NSString *msg;
@property(nonatomic,strong) NSString *des;
@property(nonatomic,strong) NSString *tips;
@property(nonatomic,assign) NSInteger result;
@property(nonatomic,strong) NSArray<PDBabyPlanMod*>*mod;
@end
