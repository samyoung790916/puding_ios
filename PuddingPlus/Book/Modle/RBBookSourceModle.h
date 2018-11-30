//
// Created by kieran on 2018/2/27.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBBookModle;


@interface RBBookSourceModle : NSObject
@property (nonatomic, strong) NSString * bid;//id
@property (nonatomic, strong) NSString * des;//description
@property (nonatomic, strong) NSString * isnew; //new

@property (nonatomic, strong) NSString * srcId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, strong) NSString * press;
@property (nonatomic, strong) NSString * pictureBig;
@property (nonatomic, strong) NSString * pictureSmall;
@property (nonatomic, strong) NSString * buyLink;
@property (nonatomic, strong) NSString * readNum;
@property (nonatomic, strong) NSString * selfReadNum;
@property (nonatomic, strong) NSString * babysNums;
@property (nonatomic, strong) NSString * isRead;
@property (nonatomic, strong) NSString * ableBuy;
@property (nonatomic, strong) NSString * hot;
@property (nonatomic, strong) NSArray<RBBookModle *> * lists;

@end
