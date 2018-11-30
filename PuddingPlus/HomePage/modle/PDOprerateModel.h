//
//  PDOprerateModle.h
//  Pudding
//
//  Created by baxiang on 16/8/10.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PDOprerateNative : NSObject
@property(nonatomic,assign) NSInteger  type;
@property(nonatomic,strong) NSString  *nativeID;
@property(nonatomic,strong) NSString  *title;
@property(nonatomic,strong) NSString  *img;
@end

@interface PDOprerateImage : NSObject
@property(nonatomic,strong) NSString *pic;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) float  heigth;
@property(nonatomic,assign) float  width;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,assign) NSUInteger count;
@property(nonatomic,strong) PDOprerateNative *native;
@end
/**
 *  运营数据模型
 */


@interface PDOprerateModel : NSObject

@property(nonatomic,strong) NSString *opreateID;
@property(nonatomic,strong) NSString *start;
@property(nonatomic,strong) NSString *end;
@property(nonatomic,strong) NSString *production;
@property (nonatomic,strong) NSArray<PDOprerateImage*> *imgs;
@end
