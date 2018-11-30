//
//  UIViewController+PDFeedResult.m
//  PuddingPlus
//
//  Created by kieran on 2017/9/12.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "UIViewController+PDFeedResult.h"
#import "PDFeedBackScuessView.h"

@implementation UIViewController (PDFeedResult)

- (void)showFeedBackScuess{
    PDFeedBackScuessView * view = [[PDFeedBackScuessView alloc] init];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    
    [view showAnimail];

}

@end
