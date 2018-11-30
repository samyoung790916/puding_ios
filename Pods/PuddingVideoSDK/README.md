# PuddingVideoSDK

[![CI Status](http://img.shields.io/travis/zhiyu330691038/PuddingVideoSDK.svg?style=flat)](https://travis-ci.org/zhiyu330691038/PuddingVideoSDK)
[![Version](https://img.shields.io/cocoapods/v/PuddingVideoSDK.svg?style=flat)](http://cocoapods.org/pods/PuddingVideoSDK)
[![License](https://img.shields.io/cocoapods/l/PuddingVideoSDK.svg?style=flat)](http://cocoapods.org/pods/PuddingVideoSDK)
[![Platform](https://img.shields.io/cocoapods/p/PuddingVideoSDK.svg?style=flat)](http://cocoapods.org/pods/PuddingVideoSDK)


## Author

zhikuiyu, kieran.zhi@foxmail.com


# iOS手机端视频SDK概要设计

------
|      日期  | 修订版本 | 修改描述 |  作者 | 联系邮箱 |
| :--------: | :-----:  | :----: | :----: |  :----: |
| 2016-11-23 | v 1.0.0  |   初稿 | 智奎宇，邱斌，刘东强| zhikuiyu@roo.bo|
| 2017-03-22 | v 1.2.0  | 双向视频，视频呼叫功能，bug修改 |智奎宇，邱斌，刘东强| zhikuiyu@roo.bo|

![TOC]

------

#  简介
##  1 文档目的和范围
本文是Roobo定制开发的ios 手机端视频sdk的概要设计文档。说明ios 端如何实现视频定制化开发。

##  2 读者范围
本文档预期的读者对象是外部合作公司布丁s手机端定制开发人员、项目管理人员、产品经理、质量管理人员，以及正式版本开发、质量管理等人员

##  3 术语定义

|     术语  | 解释 | 
| :-------- | :-----  |
| 视频sdk    |   当前sdk | 
| RooboSDK   | Roobo 提供账号注册，登录，布丁控制等相关服务的sdk （PuddingSDK） |
| 设备     |   Roobo旗下智能硬件的设备id（布丁，布丁s，布丁豆等） | 

##	4 参考文献
《布丁S机器人软件定制开发概要设计》

# SDK 概述
## SDK依赖条件
SDK 依赖RooboSDK 登录模块，登录完成后方可正常使用sdk。
二  连接视频 

- [x] 项目配置麦克风，相机等选项，来保证正常对话和录制视频，截屏存放
- [x] 如果需要后台连接视频，配置后台播放音乐选项
- [x] 账号绑定设备，并保证设备连接wifi
- [x] 支持布丁S 以上设备

## SDK 主要功能
- 视频连接
- 视频截图
- 录制视频
- 视频控制  


# SDK 导入

> 视频sdk 由于配置和其他方面原因，仅支持cocoapod

## cocoapod 使用

Cocoapod 配置文件podfile 里面添加

新增cocoapod Source

```
source 'https://git.oschina.net/roobospecs/roobospecs.git'

```
添加库
```
 pod 'PuddingVideoSDK'
```

示例Podfile 文件

```
platform :ios, "7.0"
source 'https://git.oschina.net/roobospecs/roobospecs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'TextProject' do
    pod 'ReactiveCocoa'
    pod 'Masonry'
    pod 'CocoaLumberjack', '~> 3.0.0'
    pod 'PuddingVideoSDK' 
    pod 'YYKit'
end

```



执行 `pod update`更新或者`pod install` 添加


# SDK 使用

 - 登录RooboSDK
 > 布丁S机器人软件定制开发iOS手机端SDK概要设计 https://github.com/rooboios/PuddingSDK
 - 实例化视频SDK

```
/**
 获取视频实例
 *  @param appkey     roobo 账号 AppKey(暂时填空)
 *  @param appId      roobo 账号 AppKey(暂时填空)
 *  @param clientType 产品类型（需要申请，布丁s，布丁豆 类型，请联系开发组）
 *  @return 视频实例
 */
+ (RBLiveVideoClient *)getInstanse:(NSString *)appkey AppID:(NSString *)appId Client:(NSString *)clientType;
```
### 连接视频服务器
登录完成，获取实例后，调用连接服务方法

```
/**
 *  连接视频服务器
 */
- (void)connect;
```

### 断开视频服务器

```
/**
 *  断开视频服务器
 */
- (void)disConnect;
```
### 连接视频
clientID 为布丁设备的设备id

```
/**
 *  呼叫
 *  @param clientID 呼叫端id
 */
- (void)call:(NSString *)clientID;

```
### 断开视频

```
/**
 *  断开视频连接
 */
- (void)hangup;
```
### 视频截图
获取当前连接视频的截图

```
/**
  截屏
 */
- (void)captureImage;
```
### 视频录制
- 开始录制视频

```
/**
 *  开始录制视频
 */
- (void)recordVideo;
```
- 结束录制视频

```
/**
 *  停止录制视频
 */
- (void)stopRecord;
```

### 事件回调（代理）
视频回调

`@property(nonatomic,weak) id <RBLiveVideoDelegate> delegate;
`
判断视频是否连接成功

`@property(nonatomic,assign) BOOL   connected;`

- 连接视频的进度 progress 为1的时候代表连接成功。
- connected 为YES 的时候代表连接成功

```
/**
 *  视频连接进度
 *  @param progress 连接进度（0 - 1）
 */
- (void)connectProgress:(float)progress;
```
#### 呼叫失败的错误回调

```
/**
 *  视频连接出错错误
 *  @param error 错误码
 */
- (void)connectVideoStateError:(RB_CALL_ERROR)error;

```
RB_CALL_ERROR 错误类型

- `RB_NO_LOGIN`    视频服务器连接错误-> **视频登录视频服务器失败**
- `RB_CLOSE`       视频服务器连接错误-> **服务器连接断开**，需要检测当前网络是否正常
- `RB_ERROR`       视频服务器连接错误-> **服务器连接异常**，服务器主动断开连接
- `RB_NOLOGIN`     视频服务器连接错误-> **SDK 返回登录视频服务器成功，服务端显示登录异常**
- `RB_OFFLINE`     视频连接视频错误-> **设备不在线**
- `RB_HALLON`      视频连接视频错误-> **设备贴上了休眠**
- `RB_BUSY`        视频连接视频错误-> **设备正在连接视频，无法连接**
- `RB_USER_INVALID`视频服务器连接错误-> **用户RooboSDK SDK 的登录信息过期**
- `RB_TIMEOUT`     视频连接视频错误-> **连接视频超时**
- `RB_UNKNOW`      视频连接视频错误-> **其他错误**


#### 视频截屏回调
img 为空，代表视频截图失败，在没有连接成功视频，调用截屏会返回空

```
/**
 *  视频截图
 *  @param img 图片
 */
- (void)onCaptureImage:(UIImage *)img;
```
#### 视频录制回调

```
/**
 *  视频录制状态回调
 *  @param event 视频状态
 *  @param error 错误码
 *  @param videoOutPutPath 视频要输出的路径
 */
- (void)onRecored:(RB_RECORD)event ERROR:(RECORD_ERROR)error OutPutPath:(NSString *)videoOutPutPath;
```
视频状态 event

- `RB_RECORD_STARTED`   开始录制视频
- `RB_RECORD_STOPED`    结束录制视频
- `RB_RECORD_ERROR`     录制视频错误

错误码  error

- `RB_RECORD_NONE`           视频状态正常
- `RB_RECORD_INIT_ERROR`     录制视频初始化错误
- `RB_RECORD_OUTPUT_ERROR`   录制视频输出文件错误
- `RB_RECORD_CREATE_ERROR`   录制创建文件错误
- `RB_RECORD_TIMEOUT_ERROR`  录制视频超时

#### 视频连接成功 
sid 对方视频id
view 对方视频画面的view

```
/**
 *  有端人加入视频会话
 *  @param sid  对方会话的id
 *  @param view 对方数据的view
 */
- (void)onVideoRendering:(uint64_t )sid View:(UIView *)view;
```
#### 视频连接断开 
sid 对方视频id
view 对方视频画面的view，需要移除

```
/**
 *  有端离开会话
 *  @param sid  对方会话的id
 *  @param view 对方数据的view
 */
- (void)onVideoDismiss:(uint64_t )sid View:(UIView *)view;
```



