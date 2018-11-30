//
//  AddDeviceOverView.h
//  365Locator
//
//  Created by Zhi-Kuiyu on 14-11-27.
//  Copyright (c) 2014年 Zhi-Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>


#define OVER_HEIGHT SX(196)
#define OVER_WIDTH SX(196)

#define OVER_RECT(Width,height) CGRectMake((Width - OVER_WIDTH)/2.f, (height - OVER_HEIGHT)/2.0f+ SX(10), OVER_WIDTH, OVER_HEIGHT)

@interface RBQRScanOverViewBg : UIView

@end
@interface RBQRScanOverView : UIView

@end