//
//  RBInputExpressionView.h
//  RBInputView
//
//  Created by kieran on 2017/2/9.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBInputInterface.h"

@interface RBInputExpressionView : UIView<RBInputExpressInterface,UITableViewDelegate,UITableViewDataSource>{
    UITableView * _tableView;
}
@property (nonatomic,strong) NSArray * expressArray;

@end
