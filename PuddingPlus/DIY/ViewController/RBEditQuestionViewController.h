//
//  RBEditQuestionViewController.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/12/4.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModle.h"
#import "PDBaseViewController.h"

@interface RBEditQuestionViewModle : NSObject



/**
 *  @author 智奎宇, 15-12-07 17:12:37
 *
 *  是否是添加模式
 */
@property (nonatomic,assign) BOOL             isAddModle;
/**
 *  @author 智奎宇, 15-12-07 17:12:59
 *
 *  要修改的modle
 */
@property (nonatomic,strong)QuestionModle   * editModle;
/**
 *  @author 智奎宇, 15-12-07 17:12:11
 *
 *  要提交更新的modle
 */
@property (nonatomic,strong)QuestionModle   * currentModle;

/**
 *  @author 智奎宇, 15-12-07 21:12:20
 *
 *  更新回答列表
 *
 */
- (void)updateQuestionList:(void (^)(BOOL isSucess,id res)) endBlock;

/**
 *  @author 智奎宇, 15-12-07 20:12:29
 *
 *  提交更新的block modle 提交的modle
 *   
 *  isUpdate  : YES 为更新  NO 不是更新，为添加新数据
 *  isSuccess : YES 为成功  NO 失败
 */
@property (nonatomic,strong) BOOL (^CommitResultBlock)(QuestionModle * modle,BOOL isUpdate,BOOL isSuccess);
/**
 *  @author 智奎宇, 15-12-07 17:12:47
 *
 *  如果当前的modle和要修改的相同，不显示添加按钮
 *
 */
-(BOOL)checkbtnShow;
/**
 *  @author 智奎宇, 15-12-07 17:12:02
 *
 *  判断是否可以点击，如果信息不全不可以可以点击按钮
 *
 */
-(RACSignal *)canEditSignal;


/**
 *  @author 智奎宇, 15-12-07 18:12:00
 *
 *  提交问题修改
 */
- (void)commitUpdate;

@end
typedef NS_ENUM(NSUInteger, RBEditQuestionViewStyle) {
    RBEditQuestionViewStyleAdd,
    RBEditQuestionViewStyleEdit,
};

@interface RBEditQuestionViewController : PDBaseViewController
@property (nonatomic,strong) RBEditQuestionViewModle * viewModle;
/** 类型 */
@property (nonatomic, assign) RBEditQuestionViewStyle type;

@end
