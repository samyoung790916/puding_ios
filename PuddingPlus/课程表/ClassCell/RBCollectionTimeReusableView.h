//
//  RBCollectionTimeReusableView.h
//  ClassView
//
//  Created by kieran on 2018/3/20.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, RBTimeLocationType) {
    RBTimeLocationNormail,
    RBTimeLocationStart,
    RBTimeLocationEnd,
};

@interface RBCollectionTimeReusableView : UICollectionReusableView
@property(nonatomic, strong) NSString *timeString;
@property(nonatomic, assign) RBTimeLocationType timeType;
@end
