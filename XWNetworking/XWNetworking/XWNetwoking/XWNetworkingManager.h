//
//  XWNetworkingManager.h
//  XWNetworking
//
//  Created by xinwang2 on 2017/12/19.
//  Copyright © 2017年 xinwang2. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "XWAfnGlobeConst.h"

typedef void(^XWHUDBlock)(UIViewController *hudViewController);
//请求成功的block
typedef void(^XWSuccessBlock)(id resposeObject);
//请求失败的block
typedef void(^XWFailBlock)(NSError *error);
//请求进度的block（上传进度与下载进度）
typedef void(^XWProgress)(float progress);
/**
 请求方式
 */
typedef NS_ENUM(NSUInteger,XWHttpRequestType){
    
    XWHttpRequestTypeGet = 0,
    XWHttpRqquestTypePost,
    XWHttpRequestTypePut,
    XWHttpRequestTypeDelete,
    XWHttpRequestTypeUploadImage,
    XWHttpRequestTypeUploadVideo,
    XWHttpRequestTypeDownloadFile
    
};

//返回类型
typedef NS_ENUM(NSUInteger,XWHttpResponseType){
    
    XWHttpResponseTypeHttp=0,
    XWHttpResponseTypeJson
};

@interface XWNetworkingManager : NSObject
//赋值uuid
@property(nonatomic,strong)NSString *uuid;
//赋值token
@property(nonatomic,strong)NSString *token;

/**
 单例方法

 @return 实例化对象
 */
+ (AFHTTPSessionManager *)shareManger;


/**
 总的网络请求方式，不带进度的

 @param type 网络请求类型
 @param urlString URL
 @param paraments paraments
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)xw_requestWithType:(XWHttpRequestType)type  withUrlString:(NSString *)urlString withParaments:(id)paraments successBlock:(XWSuccessBlock)successBlock failureBlock:(XWFailBlock)failureBlock;


/**
 总的网络请求方式，是否带动画

 @param type type
 @param urlString urlString
 @param paraments paraments
 @param showHUDBlock showHUDBlock
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)xw_requestWithType:(XWHttpRequestType)type withUrlString:(NSString *)urlString withParaments:(id)paraments showHUDBlock:(XWHUDBlock)showHUDBlock successBlock:(XWSuccessBlock)successBlock failureBlock:(XWFailBlock)failureBlock;
/**
 总的网络请求方式，带进度参数的

 @param type 网络请求类型
 @param urlString URL
 @param paraments paraments
 @param progress progress
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)xw_requestWithType:(XWHttpRequestType)type withUrlString:(NSString *)urlString withParaments:(id)paraments progress:(XWProgress)progress successBlock:(XWSuccessBlock)successBlock failureBlock:(XWFailBlock)failureBlock;


/**
 总的网络请求方式，带返回类型（二进制，或者json）

 @param type type
 @param responseType responseType
 @param urlString urlString
 @param paraments paraments
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)xw_requestWithType:(XWHttpRequestType)type withResponseType:(XWHttpResponseType)responseType withUrlString:(NSString *)urlString withParaments:(id)paraments successBlock:(XWSuccessBlock)successBlock failureBlock:(XWFailBlock)failureBlock;

/**
 GET请求方式

 @param urlString  urlString
 @param parameters parameters
 @param progress progress
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)xw_getWithUrlString:(NSString *)urlString  parameters:(id)parameters  progress:(XWProgress)progress  success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock;



/**
 Post请求方式

 @param urlString urlString
 @param parameters parameters
 @param progress progress
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)xw_postWithUrlString:(NSString *)urlString parameters:(id)parameters  progress:(XWProgress)progress success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock;


/**
 PUT请求方式

 @param urlString urlString
 @param parameters parameters
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)xw_putWithUrlString:(NSString *)urlString parameters:(id)parameters  success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock;


/**
 DELETE请求方式

 @param urlString URLString
 @param parameters parameters
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)xw_deleteWithUrlString:(NSString *)urlString parameters:(id)parameters success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock;


/**
 上传图片

 @param urlString URL
 @param parameters parameters
 @param imageArray iamgeArray
 @param progress progress
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)xw_uploadImageWithUrlString:(NSString *)urlString parameters:(id)parameters withImageArray:(NSArray<UIImage *> *)imageArray  progress:(XWProgress)progress success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock;


/**
 上传视频(带压缩功能)

 @param urlString URL
 @param parameters parameters
 @param videoPath 本地视频地址
 @param progress progress
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)xw_uploadVideoWithUrlString:(NSString *)urlString parameters:(id)parameters withVideoPath:(NSString *)videoPath  progress:(XWProgress)progress success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock;

/**
 文件下载

 @param urlString url
 @param parameters parameters
 @param savePath 下载的文件保存路径
 @param progress progress
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+(void)XW_downLoadFileWithUrlString:(NSString *)urlString parameters:(id)parameters withSavaPath:(NSString *)savePath rogress:(XWProgress)progress success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock;



/**
 *  取消所有的网络请求
 */
+(void)cancelAllRequest;

/**
 *  取消指定的url请求
 *
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的url
 */

+(void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string;

@end
