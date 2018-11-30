//
//  RBResourceManager.m
//  PuddingPlus
//
//  Created by baxiang on 2017/2/16.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBResourceManager.h"

@interface RBPlayCollect : RBBaseModel
@property (nonatomic,strong) NSString * mid;// 资源ID
@property (nonatomic,strong) NSString * pid;// 资源所属的分类ID
@property (nonatomic,strong) NSNumber *fid; // 资源的收藏ID
@property(nonatomic,strong) NSString * act;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * desc;
@property(nonatomic,strong) NSString * img;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * type;

@end
@implementation RBPlayCollect

+(NSString *)getTableName
{
    return @"RBPlayCollect";
}
+(NSString *)getPrimaryKey
{
    return @"mid";
}

@end

@implementation RBResourceManager


+(RBPlayCollect*)transitionCellectModel:(PDFeatureModle*)modle{
    RBPlayCollect *collect = [RBPlayCollect new];
    collect.mid = modle.mid;
    collect.pid = modle.pid;
    collect.fid = modle.fid;
    collect.act = modle.act;
    collect.title = modle.title;
    collect.img = modle.img;
    collect.name = modle.name;
    collect.type = modle.type;
    return collect;
}

+(BOOL)saveFeatureModle:(PDFeatureModle*)modle{
//    RBPlayCollect *collect  = [RBResourceManager transitionCellectModel:modle];
//    if ([RBPlayCollect rowCountWithWhere:nil] >20 ) {
//        NSArray *deleteArray   =  [RBPlayCollect searchWithWhere:nil orderBy:nil offset:0 count:1];
//        if (deleteArray.count>0) {
//            [deleteArray.lastObject  deleteToDB];
//        }
//    }
//    return [collect saveToDB];
    return NO;
}
+(BOOL)deleteFeatureModle:(PDFeatureModle*)modle{
//    RBPlayCollect *collect  = [RBResourceManager transitionCellectModel:modle];
//    return [collect deleteToDB];
    
    return NO;
}
+(NSArray<PDFeatureModle*>*)fetchFeatureModle{
   // NSArray *collectArray  = [RBPlayCollect searchWithWhere:nil orderBy:nil offset:0 count:20];
    NSMutableArray *featureModles = [NSMutableArray new];
//    for (RBPlayCollect *modle in collectArray) {
//        PDFeatureModle *collect = [PDFeatureModle new];
//        collect.mid = modle.mid;
//        collect.pid = modle.pid;
//        collect.fid = modle.fid;
//        collect.act = modle.act;
//        collect.title = modle.title;
//        collect.img = modle.img;
//        collect.name = modle.name;
//        collect.type = modle.type;
//        [featureModles addObject:collect];
//    }
    return featureModles;

}



@end
