//
//  PDTTSFlowLayout.h
//  Pudding
//
//  Created by baxiang on 2016/12/14.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDTTSTagsFlowLayout : UICollectionViewFlowLayout
@property (weak, nonatomic) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (assign,nonatomic) CGFloat contentHeight;
@end
