//
//  PDExpressionCell.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDExpressionCell : UITableViewCell
@property (nonatomic,strong) void(^ExpressionBlock)(UIButton * item ,NSObject * obj,int index);
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) NSArray * expressArray;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBounds:(CGSize) bounds;
@end
