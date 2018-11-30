//
//  PDLaunchAdModel.h
//  Pudding
//
//  Created by baxiang on 16/9/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PDPicture : NSObject
 @property(nonatomic,strong) NSString *url;
 @property(nonatomic,assign) NSInteger size;
// @property(nonatomic,assign) NSInteger height;
// @property(nonatomic,assign) NSInteger width;
@end
@interface PDPictures : NSObject
@property(nonatomic,assign) NSInteger pict_id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSDate *start;
@property(nonatomic,strong) NSDate *end;
@property(nonatomic,assign) NSInteger duration;
@property(nonatomic,strong) NSString *weburl;
@property(nonatomic,strong) NSArray<PDPicture*> *imgs;
@end
@interface PDLaunchAdModel : NSObject
@property(nonatomic,assign) NSInteger result;
@property(nonatomic,strong) NSString *msg;
@property(nonatomic,strong) NSArray<PDPictures*> *pictures;
@end
