//
//  PDMessageCenterSystemModel.m
//  Pudding
//
//  Created by william on 16/2/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDMessageCenterModel.h"
#import "RBMessageHandle.h"
#import "NSObject+YYAdd.h"

@implementation PDMessageCenterModel


- (id)initWithDictionary:(NSDictionary *)dict{
    NSDictionary * data = [dict mObjectForKey:@"data"];
    if(data){
        NSMutableDictionary * result = [[NSMutableDictionary alloc] initWithDictionary:data];
        [result mSetObject:[dict mObjectForKey:@"id"] forKey:@"mid"];
        [result mSetObject:[dict mObjectForKey:@"mt"] forKey:@"mt"];
        [result mSetObject:[dict mObjectForKey:@"mt"] forKey:@"no"];
        if([[result mObjectForKey:@"category"] intValue] == CATEGORY_ALARM_MEMBER_BIND_REQ){
            NSString * head = [[result mObjectForKey:@"images"] objectAtIndexOrNil:0];
            [result mSetObject:head forKey:@"headimage"];
            [result mSetObject:@[] forKey:@"images"];
        }
        
        if ([[result mObjectForKey:@"category"] intValue] == CATEGORY_MC_START_VIDEO) {
            NSDictionary *data1 = [result objectForKey:@"data"];
            NSString *val = [data1 mObjectForKey:@"content"];
            [result mSetObject:val forKey:@"videoContent"];
        }
        return [PDMessageCenterModel modelWithDictionary:result];
        
    }
    NSMutableDictionary * result = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [result mSetObject:[dict mObjectForKey:@"id"] forKey:@"mid"];
    NSDictionary * apsData = [dict mObjectForKey:@"aps"];
    if(apsData){
        [result mSetObject:[apsData mObjectForKey:@"alert"] forKey:@"content"];
        return [PDMessageCenterModel modelWithDictionary:result];
        
    }
    
    return [PDMessageCenterModel modelWithDictionary:result];
    
}

- (void)setImages:(NSArray *)images{
    NSMutableArray * ar = [NSMutableArray new];
    
    for(NSString * na in images){
        if(na.length > 0){
            [ar addObject:na];
        }
    }
    _images = ar;
    
}



static const CGFloat kTableRowHeight = 90;


-(CGFloat)cellHeight{
    
    if (_cellHeight>0) {
        return _cellHeight;
    }
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    NSString *titleStr = self.content;
    if ([self.category intValue] == CATEGORY_MC_START_VIDEO) {
        titleStr = (self.videoContent == nil || [self.videoContent isEqualToString:@""]) ? self.content : self.videoContent;
        
        
    } else if ([self.category intValue] == CATEGORY_MESSAGECENTER_VIDEO){
        if (self.videos.count > 0) {
            NSDictionary *dict = [self.videos firstObject];
            NSString *title = [dict objectForKey:@"title"];
            if (title == nil || [title isEqualToString:@""]) {
                title = [dict objectForKey:@"content"];
            }
            titleStr = title;
        }
    } else if ([self.category intValue] == CATEGORY_MESSAGECENTER_ACTIVITY){
        NSDictionary *dict = [self.urls firstObject];
        NSString *content = [dict objectForKey:@"content"];
        titleStr = content;
    }
    CGRect rect = [titleStr boundingRectWithSize:CGSizeMake(SX(260), CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SX(FontSize +2) ]} context:nil];
    rect.size.height = MAX(CGRectGetHeight(rect), SX(20));
    self.titleHeight = CGRectGetHeight(rect);
    switch ([self.category intValue]) {
        case CATEGORY_MOTION_DTECTED:
        {
            if(self.images.count > 0){
                _cellHeight = MAX( rect.size.height + SX(56) + SX(187), SX(kTableRowHeight) + SX(187));
            }else{
                _cellHeight = MAX( rect.size.height + SX(56), SX(kTableRowHeight));
            }
        }
            break;
//        case CATEGORY_ALARM_MEMBER_BIND_REQ:
//        {
//            int read = [self.unread intValue];
//            if(read < 0x01){
//                height += 50 ;
//                //后加
//                _cellHeight = MAX( rect.size.height + SX(60) + 50, kTableRowHeight + 50);
//            }
//        }
//            break;
        case CATEGORY_NEWS:
            // 需要计算大标题小标题的高度

        {
            NSArray *myarticles = self.articles;
            NSDictionary *mainTitle = [myarticles firstObject];
            NSString *titleStr = [mainTitle objectForKey:@"title"];
            NSString *subTitle = [mainTitle objectForKey:@"content"];
            CGRect rectTitle = [titleStr boundingRectWithSize:CGSizeMake(SC_WIDTH - SX(126), CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SX(17)]} context:nil];
            rectTitle.size.height = MAX(CGRectGetHeight(rectTitle), SX(20));
            CGRect rectSubTitle = [subTitle boundingRectWithSize:CGSizeMake(SC_WIDTH - SX(126) - 18, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SX(14)]} context:nil];
            rectSubTitle.size.height = MAX(CGRectGetHeight(rectSubTitle), SX(18));
            CGFloat timeLabelBottom = SX(30);
            CGFloat gapHeight = SX(67);
            CGFloat detailViewHeight = SX(50);
            CGFloat centerImageHeight = SX(167);
            CGFloat cellH = timeLabelBottom + gapHeight + detailViewHeight + centerImageHeight + rectTitle.size.height + rectSubTitle.size.height;
            _cellHeight = cellH;
        }
            
            break;
            case CATEGORY_MESSAGECENTER_VIDEO:
        {
            _cellHeight = _titleHeight + SX(45) + SX(187);
        }
            break;

        default:
        {
            _cellHeight = MAX( rect.size.height + SX(45), kTableRowHeight);
        }
            break;
    }
    
    return _cellHeight;
}


@end
