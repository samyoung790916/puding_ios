//
//  PDVideoPhotoButton.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/23.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDVideoPhotoButton : UIControl{
    UIImageView * imageView;
    UIView      * overBg;
}


@property(nonatomic,strong) UIImage * image;

- (void)setImage:(UIImage *)image ShouldBorder:(BOOL)should;
@end
