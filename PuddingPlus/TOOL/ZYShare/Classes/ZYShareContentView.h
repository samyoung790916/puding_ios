//
//  ZYShareContentView.h
//  Pods
//
//  Created by Zhi Kuiyu on 16/7/22.
//
//

#import <UIKit/UIKit.h>


@protocol ZYShareItemDelegate <NSObject>

- (void)shareItemSelect:(int)tag;

- (void)shareCancle;

@end

@interface ZYShareContentView : UIControl


@property(nonatomic,weak) id<ZYShareItemDelegate> delegate;

- (void)addItems:(NSArray *)itemNames ItemIcon:(NSArray *)icons Tags:(NSArray *)tags;
@end
