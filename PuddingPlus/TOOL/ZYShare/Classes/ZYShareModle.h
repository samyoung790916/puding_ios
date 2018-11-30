//
//  ZYShareModle.h
//  Pods
//
//  Created by Zhi Kuiyu on 16/7/25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZYShareModle : NSObject
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * shareDes;
@property(nonatomic,strong) NSString * videoURL;
@property(nonatomic,strong) NSURL    * videoPathURL;
@property(nonatomic,strong) NSNumber * videoLength;
@property(nonatomic,strong) NSString * imageURL;
@property(nonatomic,strong) UIImage  * image;
@property(nonatomic,strong) UIImage  * thumbImage;
@property(nonatomic,strong) NSString * thumbURL;
@property(nonatomic,strong) NSString * audioURL;
@property(nonatomic,strong) NSURL    * audioPathURL;
@property(nonatomic,strong) NSNumber * audioLength;
@end
