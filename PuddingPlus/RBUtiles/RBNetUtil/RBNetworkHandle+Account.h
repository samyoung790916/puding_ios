//
//  RBNetworkHandle+Account.h
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (Account)

#pragma mark ------------------- 用户相关 ------------------------
#pragma mark 用户：- 登陆
+ (RBNetworkHandle *)userloginWithPhone:(NSString *)phone PsdNumber:(NSString *)psdNumber pcode:(NSString*)pcode WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 注册
+ (RBNetworkHandle *)registerWithPhone:(NSString *)phone  PsdNumber:(NSString *)psdNumber IdenCode:(NSString *)code NickName:(NSString *)nickName pcode:(NSString*)pcode WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 修改密码
+ (RBNetworkHandle *)changeUserPsd:(NSString *)oldPsd newPsd:(NSString *)newPsd WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 重置密码
+ (RBNetworkHandle *)resetPsd:(NSString *)phone :(NSString *)checkCode NewPsdWord:(NSString *)newPsd pcode:(NSString*)pcode  WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 获取验证码
+ (RBNetworkHandle *)sendIdenCodeWithPhone:(NSString *)phone SendType:(RBSendCodeType )type pcode:(NSString*)pcode WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 根据旧密码修改新密码
+ (RBNetworkHandle *)resetUserPsdWithOldPsd:(NSString *)oldPsd NewPsd:(NSString *)newPsd WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 修改手机号
+ (RBNetworkHandle *)updateUserPhoeWithPhoneNum:(NSString *)phone checkCode:(NSString *)checkCode Pwd:(NSString *)pwd  pcode:(NSString*)pcode WithBlock:(void (^)(id res)) block;
#pragma mark 用户：- 检测用户密码是否正确
+ (RBNetworkHandle *)checkUserPsdIsRight :(NSString *)phone IsSendCode:(BOOL)isSend WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 用户登出
+ (RBNetworkHandle *)userLoginOut:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 上传头像url 路径
+ (RBNetworkHandle *)updateUserHeaderWithHeaderPath:(NSString *)headerPath WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 上传照片返回 URL 路径
+ (RBNetworkHandle *)uploadImage:(UIImage *)image withBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 上传 PushID
+ (RBNetworkHandle *)updatePushID:(NSString *)pushID;
#pragma mark 用户：- 用户反馈
+ (RBNetworkHandle *)userFeedBackWithContact:(NSString *)contact description:(NSString *)description WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 修改用户名
+ (RBNetworkHandle *)updateUserName:(NSString *)name :(RBNetworkHandleBlock) block;
#pragma mark 用户：- 检查手机号是否注册过
/**
 *  验证手机号是否注册过
 */
+ (RBNetworkHandle *)checkPhoneIsRegist:(NSString *)phone pcode:(NSString*)pcode WithBlock:(void (^)(id res)) block;

#pragma mark -   获取用户本地信息
+ (RBNetworkHandle *)getUserCustomDataWith:(void (^)(id res)) block;

#pragma mark -   通用升级检查
+ (RBNetworkHandle *)checkAppUpdateWithIdentifier:(NSString *)iden Vname:(NSString*)vname VersionCode:(int)vcode production:(NSString *)production Block:(void(^)(id res))block;
@end
