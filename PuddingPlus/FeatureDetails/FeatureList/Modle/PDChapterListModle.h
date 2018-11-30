//
//  PDChapterListModle.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDChapterListModle : NSObject

/**
 *  @author 智奎宇, 16-02-05 14:02:46
 *
 *  章节列表
 */
@property (nonatomic,strong) NSArray    * chapterList;

/**
 *  @author 智奎宇, 16-02-05 14:02:09
 *
 *  章节列表头图的url
 */
@property (nonatomic,strong) NSString   * imageURL;


/**
 *  @author 智奎宇, 16-02-05 14:02:02
 *
 *  章节列表的标题
 */
@property (nonatomic,strong) NSString   * listTitle;

/**
 *  @author 智奎宇, 16-02-05 14:02:14
 *
 *  章节列表的描述
 */
@property (nonatomic,strong) NSString   * listDescribe;

@end
