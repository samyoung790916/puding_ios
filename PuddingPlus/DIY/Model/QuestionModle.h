//
//  QuestionModle.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/12/4.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//


@interface QuestionModle : NSObject

/**
 *  @author 智奎宇, 15-12-04 16:12:41
 *
 *  问题标题
 */
@property (nonatomic,strong) NSString * question;

/**
 *  @author 智奎宇, 15-12-04 16:12:53
 *
 *  问题回答
 */
@property (nonatomic,strong) NSString * response;

/**
 *  @author 智奎宇, 15-12-04 16:12:02
 *
 *  问题id
 */
@property (nonatomic,strong) NSNumber * qid;
@end
