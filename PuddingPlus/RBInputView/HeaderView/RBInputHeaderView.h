//
//  RBInputHeaderView.h
//  RBInputView
//
//  Created by kieran on 2017/2/10.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBInputInterface.h"

@interface RBInputHeaderView : UIView<RBInputTextInterface,RBInputCmdInterface,RBInputHeaderInterface>
@property (nonatomic,weak) UICollectionView *recommendCollectView;
@end
