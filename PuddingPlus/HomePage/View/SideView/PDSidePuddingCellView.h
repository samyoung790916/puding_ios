//
//  PDSidePuddingCellView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;
@end

typedef NS_ENUM(NSInteger,PDAddViewType){
    PDAddViewType_cell,
    PDAddViewType_addView,
};

@interface PDSidePuddingCellView : UIControl{
    UIImageView * headImage;
    InsetsLabel     * nameLabel;

}
@property (nonatomic,strong) RBDeviceModel *model;

@property (nonatomic,strong) NSString * title;
//@property (nonatomic,strong) NSString * imageURL;
@property (nonatomic,strong) NSString * imageNamed;

//@property (nonatomic, assign) PDAddViewType addviewType;
@end
