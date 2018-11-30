//
//  RBVideoMessageView.h
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/9/24.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFunnyResouseModle.h"
#import "PDVideoTTSPublicView.h"

@interface RBVideoMessageCell : UIControl


@property (nonatomic,strong) PDFunnyResouseModle * dataSource;
@end

@interface RBVideoMessageView : PDVideoTTSPublicView


@property (nonatomic,strong) NSMutableArray  * messageArray;

@property (nonatomic,strong) void (^SendTTSBlock)(UIView * view, NSString *);

@end
