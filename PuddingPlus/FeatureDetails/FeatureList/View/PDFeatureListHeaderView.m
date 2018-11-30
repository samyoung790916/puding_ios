//
//  PDFeatureListHeaderView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFeatureListHeaderView.h"

extern float feature_header_height;


@implementation PDFeatureListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imageView];
        
        
        
        
    }
    return self;
}

@end
