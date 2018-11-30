//
//  PDTTSTagCollectionCell.h
//  Pudding
//
//  Created by baxiang on 2016/12/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class PDTTSTagModel;
@class PDTTSListContent;
@interface PDTTSTagsCell : UICollectionViewCell

@property (nonatomic) PDTTSListContent *tagModel;
@property (nonatomic) UIEdgeInsets contentInsets;
@end
