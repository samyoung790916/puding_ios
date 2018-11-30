//
//  RBAPublic.h
//  RBCAlterView
//
//  Created by kieran on 2017/1/14.
//  Copyright © 2017年 kieran. All rights reserved.
//

#ifndef RBAPublic_h
#define RBAPublic_h

#import <UIKit/UIKit.h>

#endif /* RBAPublic_h */
#define aRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

#define ASX(v) (MIN([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)/375.f * v)
#define ASY(v) (MAX([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)/667.f * v)

#define aRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define RBContentColor aRGBToColor(0x61d4ff)
#define RBTimerColor aRGBToColor(0x4a4a4a)

#define RBLocalizedString(key) [NSBundle rb_localizedStringForKey:(key)]

@interface RBAPublic : NSObject
+ (UIImage*) rbcreateImageWithColor: (UIColor*) color;
CGAffineTransform rbtransform(NSInteger orientation);
@end
