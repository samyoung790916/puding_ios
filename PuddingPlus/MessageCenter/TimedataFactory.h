//
//  TimedataFactory.h
//  365Locator
//
//  Created by Zhi-Kuiyu on 14-11-29.
//  Copyright (c) 2014年 Zhi-Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimedataFactory : NSObject
+ (NSDateFormatter *)tcNormalFormat;
+ (NSDateFormatter *)tcAllInfoFormat;



NSString * getDayTimeWithTimeInterval(NSString * timestr);
NSString * getTimeWithTimeInterval(NSString * timestr);
NSString * getNormailDataString(NSDate * data) ;
NSString * getNormaillastDay(NSString * string);
NSString * getDayTimeWithString(NSString * timestr);
NSString * getMapContentTimeWithString(NSString * timestr);
NSString * getMapContentTimeWithNSTimeInterval(NSTimeInterval timestr);


NSString * getAllInfoTime();
@end
