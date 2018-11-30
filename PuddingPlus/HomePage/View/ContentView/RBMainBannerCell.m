//
//  RBMainBannerCell.m
//  PuddingPlus
//
//  Created by kieran on 2017/10/31.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBMainBannerCell.h"
@interface RBMainBannerCell()
@property(nonatomic,strong) UIImageView * imageView;
@end
@implementation RBMainBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = (UIImageView *)^(){
            UIImageView * view = [[UIImageView alloc] init];
            view.layer.cornerRadius = 15;
            view.clipsToBounds = YES;
            view.backgroundColor = [UIColor clearColor];
            return view;
        }();
        self.imageView.frame = self.bounds;
        [self addSubview:self.imageView];
    }
    return self;
}


- (void)setImageURL:(NSString *)imageURL{
    [self.imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholder:[UIImage imageNamed:@"img_zwt"]];
    
}
@end
