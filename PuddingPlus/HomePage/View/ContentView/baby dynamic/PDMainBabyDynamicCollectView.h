//
//  PDMainBabyDynamicCollectView.h
//  PuddingPlus
//
//  Created by kieran on 2017/5/3.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDModule.h"
#import "PDFamilyMoment.h"

@interface PDMainBabyDynamicCollectView : UICollectionReusableView

@property(nonatomic,strong) void(^MoreContentBlock)();
@property(nonatomic,strong) void(^BabySettingBlock)();
@property (nonatomic,strong) PDModule *module;
@property(nonatomic,strong) void(^selectPhotoCategory)(NSArray * photo,NSInteger photoIndex,UIImageView * animView);
@property(nonatomic,strong) void(^selecrtVideoCategory)(PDFamilyMoment * videoModle,UIImageView * animView);

@end
