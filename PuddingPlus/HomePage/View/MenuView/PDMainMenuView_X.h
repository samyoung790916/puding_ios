//
//  PDMainMenuView_X.h
//  PuddingPlus
//
//  Created by liyang on 2018/6/13.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PDMainMenuView_XDelegate <NSObject>
- (void)scrollMenuViewDidScroll:(CGFloat)topOffset;
@end

@interface PDMainMenuView_X : UIView
@property(nonatomic,weak) id<PDMainMenuView_XDelegate>delegate;
@property(nonatomic,strong) UICollectionView *collectionView;
- (void )setContentTopOffset:(float )topoffset;

// loadNewData 是否必须强制请求新资源
-(void)refreshMainMenuView:(BOOL)loadNewData animation:(BOOL)loadAnimation switchDevice:(BOOL)switchDevice;
@end
