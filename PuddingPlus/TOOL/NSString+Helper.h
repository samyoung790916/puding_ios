//
//  NSString+Helper.h
//  ZYAssist
//
//  Created by Zhi Kuiyu on 15/2/5.
//  Copyright (c) 2015年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


@interface NSString (Helper)

#pragma mark - Base64

#define __BASE64( text )        [CommonFunc base64StringFromText:text]
#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]
/**
 *  @author 智奎宇, 15-12-01 15:12:14
 *
 *  去掉收尾空格
 *
 */
+ (void)removeSpace:(NSString *)string;
/**
 * @brief  将文本转换为base64格式字符串
 * @param  text 文本
 * @return base64格式字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text;


/**
 * @brief  将base64格式字符串转换为文本
 * @param  base64 base64格式字符串
 * @return 文本
 */
+ (NSString *)textFromBase64String:(NSString *)base64;


#pragma mark - AES 加密
/**
 * @brief  文本数据进行AES加密 此函数不可用于过长文本
 */
+ (NSData *)AESEncrypt:(NSData *)data WithKey:(NSString *)key ;
/**
 * @brief  文本数据进行DES解密 (此函数不可用于过长文本)
 */
+ (NSData *)AESDecrypt:(NSData *)data WithKey:(NSString *)key  ;


#pragma mark - MD5
/**
 * @brief  MD5 加密
 */
- (NSString *)MD5String ;
- (NSString *)md5HexDigest;

#pragma mark - SHA1 
/**
 * @brief  SHA1 加密
 */
- (NSString *)SHA1String ;

@end
