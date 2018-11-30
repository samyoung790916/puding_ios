//
//  RBFeedBackAnimailView.h
//  TestRote
//
//  Created by kieran on 2017/6/6.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBFeedBackAnimailView : UIControl

@property(nonatomic,strong) UIImage * image;

@property(nonatomic,strong) UIImage * pinImage;

- (void)beginAnimail;

- (void)stopAnimail;


@end
