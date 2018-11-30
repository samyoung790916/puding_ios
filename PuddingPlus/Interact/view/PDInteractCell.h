//
//  PDInteractCell.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDInteractModle.h"
#import "PDFeatureModle.h"

@interface PDInteractCell : UITableViewCell

@property(nonatomic,strong) PDFeatureModle * dataSource;

@property(nonatomic,assign) BOOL playing;


+ (float)height:(PDInteractModle *)modle;
@end
