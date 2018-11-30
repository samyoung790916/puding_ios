//
//  PDFeatureModle.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

@class PDInteractModle;

@interface PDFeatureModle : NSObject {
    @public
    CGFloat contentHeight;
}

@property (nonatomic,strong) NSString * mid;// 资源ID
@property (nonatomic,strong) NSString * pid;// 资源所属的分类ID
/**
 *  来判断model的类型，是否有下一级
 tag:    专辑
 cate:   大类专辑
 single：单曲（本地添加的状态）
 */
@property(nonatomic,strong) NSString * act;
@property(nonatomic,strong) NSString * title;// 资源ID
@property(nonatomic,strong) NSString * desc;
@property(nonatomic,strong) NSString * img;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * type;
@property(nonatomic,strong) NSArray  * childs;
@property(nonatomic,strong) NSData   * childsData;
@property(nonatomic,strong) NSString * content;
@property(nonatomic,strong) NSString * size;
@property(nonatomic,strong) NSString * length;
@property(nonatomic,strong) NSString * onlinetm;
@property(nonatomic,strong) NSString * score;
@property(nonatomic,strong) NSString * keywords;
@property(nonatomic,strong) NSString * srcname;
@property(nonatomic,strong) NSString * thumb;
@property(nonatomic,strong) NSString * pic;//搜索thumb返回的是pic  收藏列表中的图片 */
@property(nonatomic,strong) NSString * source;
@property(nonatomic,strong) NSString * srcurl;
@property(nonatomic,strong) NSString * updated_at;
@property(nonatomic,strong) NSString * created_at;
@property(nonatomic,strong) NSString * deleted_at;
@property(nonatomic,strong) NSString * play_pudding_id;


//适应最小年纪
@property(nonatomic,strong) NSNumber * min_age;

//适应最大年纪
@property(nonatomic,strong) NSNumber * max_age;


//互动内容
@property(nonatomic,strong) NSString * keyword_str;

//宝宝参与度
@property(nonatomic,strong) NSNumber * inter_degree;

//故事时长
@property(nonatomic,strong) NSNumber * duration;

//故事图片
@property(nonatomic,strong) NSString * story_img;

//关键词
@property(nonatomic,strong) NSArray * inter_type;

/** 当前用户id */
@property (nonatomic, strong) NSString * user_id;
/** 当前主控 id */
@property (nonatomic, strong) NSString * current_mcid;

/** 当前年龄 */
@property (nonatomic, strong) NSString *currentAge;
/** 是否过期 */
@property (nonatomic, strong) NSString *isOutDate;

/** 是否是收藏界面进入 */
@property (nonatomic, assign) bool isCollection;


- (void)setContentHeightWithTitle:(NSString *)title;
// 资源收藏收藏id （>0就表示已收藏）
@property (nonatomic, strong) NSNumber *fid;


/* 是否失效（收藏列表中的歌曲有可能下架） */
@property (nonatomic, strong) NSNumber *available;// 是否失效(0失效 1有效)

@property (nonatomic, strong) NSNumber *historyId;//历史记录id
@property (nonatomic, strong) NSString *src;//资源来源（若不为空，播放和收藏时需传到后台）
@property (nonatomic, strong) NSNumber *favAble;// (历史记录中的数据)能否收藏
@property (nonatomic, assign) BOOL isBabyPlan; // 是否是成长计划
@property (nonatomic,strong) NSString * resourcesKey;// 搜索ID

@end
