//
//  PDFamilyHiddenView.h
//  Pudding
//
//  Created by Zhi Kuiyu on 16/7/1.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFamilyHiddenView : UIView{
    UIImageView *img;
    CADisplayLink * link;
    float       pro;
    
}

@property(nonatomic,strong) UIImage * image;
- (void)start;
- (void)stop;
@end
