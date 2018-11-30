//
//  PDFamilyPhoto.h
//  Pudding
//
//  Created by baxiang on 16/7/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PDFamilyAlbumPhoto = 0,
    PDFamilyAlbumVideo ,
} PDFamilyAlbumType;

@interface PDFamilyPhoto : NSObject
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) long long  ID;
@property (nonatomic,assign) long long  srcid;
@property (nonatomic,strong) NSNumber *length;
@property (nonatomic,strong) NSString *thumb;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,assign) PDFamilyAlbumType type;
@end
