//
//  RBInputHabitsView.h
//  RBInputView
//
//  Created by kieran on 2017/2/8.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBInputInterface.h"

@class RBInputHabitsViewModle;

@interface RBInputHabitsView : UIView<RBInputTextInterface,UITableViewDelegate,UITableViewDataSource>{
    UITableView * _tableView;
    RBInputHabitsViewModle * viewModle;
}

@end
