//
//  PDFeatureListCell.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDFeatureModle;
@interface PDFeatureListCell : UITableViewCell{

    UILabel *  titleLable;
    UILabel *  indexLable;
    UIImageView * stopImageView;
    
    UIButton *collectionBtn;
}
typedef void (^CollectBtnClickedBack)(PDFeatureModle *);
typedef void (^DeleteCallBack)(void);

@property (nonatomic,strong) NSString * title;

@property (nonatomic,assign) NSInteger  rowIndex;

@property (nonatomic,assign) BOOL isTag;
@property (nonatomic,assign) BOOL isPlaying;
/** 数据 */
@property (nonatomic, strong) PDFeatureModle *model;

@property (nonatomic, strong) CollectBtnClickedBack clickBack;
@property (nonatomic, strong) DeleteCallBack delCallBack;

@property (nonatomic,assign) BOOL isDIYAlbum;

@end
