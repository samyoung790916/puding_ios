//
//  PDCollectScrollView.h
//  Pudding
//
//  Created by william on 16/6/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PDCollectionScrollViewNum)(NSInteger numOfsingle,NSInteger numOfAlbum);
@interface PDCollectScrollView : UIScrollView
@property (nonatomic,assign) BOOL isRefresh;// 是否正在刷新
/** 数量回调 */
@property (nonatomic, copy) PDCollectionScrollViewNum numCallBack;

- (void)refresh;
@end
