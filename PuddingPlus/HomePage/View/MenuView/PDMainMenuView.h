//
//  PDMainMenuView.h
//  Pudding
//
//  Created by baxiang on 16/9/24.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  布丁主界面功能分区
 */

@protocol PDMainMenuViewDelegate <NSObject>
- (void)scrollMenuViewDidScroll:(CGFloat)topOffset;
@end

@interface PDMainMenuView : UIView
@property(nonatomic,weak) id<PDMainMenuViewDelegate>delegate;
@property(nonatomic,strong) UICollectionView *collectionView;
- (void )setContentTopOffset:(float )topoffset;

// loadNewData 是否必须强制请求新资源 
-(void)refreshMainMenuView:(BOOL)loadNewData animation:(BOOL)loadAnimation switchDevice:(BOOL)switchDevice;
@end
