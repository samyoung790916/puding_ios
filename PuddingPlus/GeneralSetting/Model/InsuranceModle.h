//
//  InsuranceModle.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/6/12.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//


@interface InsuranceModle : NSObject
/**
 *  姓名
 */
@property (nonatomic,strong) NSString * name;

/**
 *  证件号码
 */
@property (nonatomic,strong) NSString * idno;

/**
 *  证件类型
 */
@property (nonatomic,strong) NSString * idtype;
/**
 *  手机号码
 */
@property (nonatomic,strong) NSString * phone;
/**
 *  保险财产坐落地址
 */
@property (nonatomic,strong) NSString * province;


/**
 * 
 */
@property (nonatomic,strong) NSString * city;
/**
 *  详细地址
 */
@property (nonatomic,strong) NSString * addr;
/**
 *  邮政编码
 */
@property (nonatomic,strong) NSString * zipcode;

/**
 *  保险开始期限
 */
@property (nonatomic,strong) NSNumber * start;
/**
 *  保险结束期限
 */
@property (nonatomic,strong) NSNumber * end;

/**
 *  保险单号
 */
@property (nonatomic,strong) NSString * orderid;

/**
 *  免赔额
 */
@property (nonatomic,strong) NSString * minlost;

/**
 *  保障项目
 */
@property (nonatomic,strong) NSString * project;
@end
