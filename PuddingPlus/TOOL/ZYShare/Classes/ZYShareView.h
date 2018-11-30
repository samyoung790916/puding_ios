//
//  ZYShareView.h
//  Pods
//
//  Created by Zhi Kuiyu on 16/7/22.
//
//

#import <UIKit/UIKit.h>
#import "ZYShareContentView.h"
#import "ZYShareModle.h"
#define sc(v) (MIN([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)/375.f * v)



@interface ZYShareView : UIView{
    NSArray * shareTags;
}
@property(nonatomic,strong) ZYShareModle * shareInfo;

@property(nonatomic,weak) id<ZYShareItemDelegate> delegate;

@property (nonatomic,copy) void(^HiddenBlock)(ZYShareView *);

- (void)showAnimails;


- (void)hiddenAnimails;


- (void)showShareView:(NSArray *)itemNames ItemIcon:(NSArray *)icons Tags:(NSArray *)tags;
@end
