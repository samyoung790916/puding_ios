//
//  RBMethodShot.h
//  PuddingPlus
//
//  Created by kieran on 2017/1/14.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#ifndef RBMethodShot_h
#define RBMethodShot_h

#define SC_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SC_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define PDUnabledColor mRGBToColor(0xc0c0c1)
#define PDMainColor mRGBToColor(0x2dc3ff)
#define PDBackColor  mRGBColor(244, 244, 244)
#define PDTextColor mRGBToColor(0x576166)
#define PDGreenColor mRGBToColor(0x00cd62)

#define IS_IPHONE_X ((SC_HEIGHT == 812.0f) ? YES : NO)
#define STATE_HEIGHT ((IS_IPHONE_X==YES)?44.0f: 20.0f)
#define SC_FOODER_BOTTON ((IS_IPHONE_X==YES)?36.0f: 0.0f)

#define px_font_size(fontsize) (fontsize*96)/72

#define FontSize 16
#define NAV_HEIGHT ((IS_IPHONE_X==YES)?88.0f: 64.0f)
#define NAV_BOTTOM ((IS_IPHONE_X==YES)?20.0f: 0.0f)

#define FontName @"LTHYSZK"
#define WeakSelf __weak typeof(self) weakSelf = self ;


//加载图片
#define mImageByName(name)        [UIImage imageNamed:name]
#define mImageByPath(name, ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:ext]]

//颜色转换
#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]
//rgb颜色转换（16进制->10进制）
#define mRGBAToColor(rgb,a) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:a]

#define SCREEN35 ([UIScreen mainScreen].bounds.size.height <= 480)


#endif /* RBMethodShot_h */
