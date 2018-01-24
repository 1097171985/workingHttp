//
//  XWNetworkingManager.m
//  XWNetworking
//
//  Created by xinwang2 on 2017/12/19.
//  Copyright © 2017年 xinwang2. All rights reserved.
//

#import "XWNetworkingManager.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>
#import <UIKit/UIKit.h>

//const NSMutableString *HSCoder = [NSMutableString alloc]initWithFormat:@"Hello"];

@interface XWNetworkingManager()
//返回类型
@property(nonatomic,assign)XWHttpResponseType responseType;

@end

@implementation XWNetworkingManager

static AFHTTPSessionManager * _manager = nil;
/**
 实例化部分

 @param uuid <#uuid description#>
 */
-(void)setUuid:(NSString *)uuid{
    
    self.uuid = uuid;
}

-(void)setToken:(NSString *)token{
    
    self.token = token;
}
// manager配置
+ (AFHTTPSessionManager *)shareManger{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer  = [AFJSONRequestSerializer serializer];//
        manager.requestSerializer.timeoutInterval = 20;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;//缓存策略
        manager.securityPolicy.allowInvalidCertificates = YES;//安全策略
        manager.securityPolicy.validatesDomainName      = NO;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", @"text/javascript", @"image/jpeg", nil];
        _manager = manager;

    });

//    //Header
    [_manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",XWNetworkingHeaderUuid]  forHTTPHeaderField:@"Gs-Authorization-ID"];
    [_manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",XWNetworkingHeaderToken] forHTTPHeaderField:@"Gs-Authorization-Token"];
    if (![XWNetworkingHeaderUserAgent isEqualToString:@"请设置userAgent"]) {
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",XWNetworkingHeaderUserAgent] forHTTPHeaderField:@"User-Agent"];
    }
    NSLog(@"HTTPRequestHeaders==%@",_manager.requestSerializer.HTTPRequestHeaders);
    //NSLog(@"ID: %@ Token: %@", [ShareSingle shareSingle].uuid, [ShareSingle shareSingle].userToken);

//  [self newRequestId];
    return _manager;
}

// 刷新requestID
+ (void)newRequestId {
//    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
//    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
//    int requestIdTemp = (arc4random() % 50000)+10000;
//    [XWNetworkingManager shareSingle].requestId = [NSString stringWithFormat:@"%llu%d",theTime,requestIdTemp];
}


//MARK:网络请求部分
//带进度
+(void)xw_requestWithType:(XWHttpRequestType)type withUrlString:(NSString *)urlString withParaments:(id)paraments progress:(XWProgress)progress successBlock:(XWSuccessBlock)successBlock failureBlock:(XWFailBlock)failureBlock{
    
    switch (type) {
        case XWHttpRequestTypeGet:
            [XWNetworkingManager xw_getWithUrlString:urlString parameters:paraments progress:progress success:successBlock failure:failureBlock];
            break;
        case XWHttpRqquestTypePost:
            [XWNetworkingManager xw_postWithUrlString:urlString parameters:paraments progress:progress success:successBlock failure:failureBlock];
            break;
        case XWHttpRequestTypePut:
            [XWNetworkingManager xw_putWithUrlString:urlString parameters:paraments success:successBlock failure:failureBlock];
             break;
        case XWHttpRequestTypeDelete:
            [XWNetworkingManager xw_deleteWithUrlString:urlString parameters:paraments success:successBlock failure:failureBlock];
             break;
        default:
            break;
    }
    
}

+(void)xw_requestWithType:(XWHttpRequestType)type withUrlString:(NSString *)urlString withParaments:(id)paraments showHUDBlock:(XWHUDBlock)showHUDBlock successBlock:(XWSuccessBlock)successBlock failureBlock:(XWFailBlock)failureBlock{
    
    showHUDBlock([self getCurrentVC]);
    [self xw_requestWithType:type withUrlString:urlString withParaments:paraments progress:nil successBlock:successBlock failureBlock:failureBlock];
   
}

//无进度
+(void)xw_requestWithType:(XWHttpRequestType)type withUrlString:(NSString *)urlString withParaments:(id)paraments successBlock:(XWSuccessBlock)successBlock failureBlock:(XWFailBlock)failureBlock{
    
    [self xw_requestWithType:type withUrlString:urlString withParaments:paraments progress:nil successBlock:successBlock failureBlock:failureBlock];
    
}

// 二进制 get,post
+(void)xw_requestWithType:(XWHttpRequestType)type withResponseType:(XWHttpResponseType)responseType withUrlString:(NSString *)urlString withParaments:(id)paraments successBlock:(XWSuccessBlock)successBlock failureBlock:(XWFailBlock)failureBlock{
    
    switch (responseType) {
        case XWHttpResponseTypeHttp:
            [XWNetworkingManager shareManger].responseSerializer =  [AFHTTPResponseSerializer serializer];
            break;
        case XWHttpResponseTypeJson:{
            [XWNetworkingManager shareManger].responseSerializer =  [AFJSONResponseSerializer serializer];
            [XWNetworkingManager shareManger].responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", @"text/javascript", @"image/jpeg", nil];
            break;
        }
        default:
            break;
    }
    
    switch (type) {
        case XWHttpRequestTypeGet:
            [XWNetworkingManager xw_getWithUrlString:urlString parameters:paraments progress:nil success:successBlock failure:failureBlock];
            break;
        case XWHttpRqquestTypePost:
            [XWNetworkingManager xw_postWithUrlString:urlString parameters:paraments progress:nil success:successBlock failure:failureBlock];
            break;
        case XWHttpRequestTypePut:
            [XWNetworkingManager xw_putWithUrlString:urlString parameters:paraments success:successBlock failure:failureBlock];
             break;
        case XWHttpRequestTypeDelete:
            [XWNetworkingManager xw_deleteWithUrlString:urlString parameters:paraments success:successBlock failure:failureBlock];
             break;
        default:
            break;
    }
}

//get
+(void)xw_getWithUrlString:(NSString *)urlString parameters:(id)parameters  progress:(XWProgress)progress success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock{
    
    NSString *urlStr=[NSURL URLWithString:urlString]?urlString:[self strUTF8Encoding:urlString];
 
    [[XWNetworkingManager shareManger]GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress != nil) {
          progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
}


//post
+(void)xw_postWithUrlString:(NSString *)urlString parameters:(id)parameters  progress:(XWProgress)progress success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock{
    
    NSString *urlStr=[NSURL URLWithString:urlString]?urlString:[self strUTF8Encoding:urlString];
    [[XWNetworkingManager shareManger]POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress != nil) {
            progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
}

//put
+(void)xw_putWithUrlString:(NSString *)urlString parameters:(id)parameters  success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock{
    
    NSString *urlStr=[NSURL URLWithString:urlString]?urlString:[self strUTF8Encoding:urlString];
    [[XWNetworkingManager shareManger]PUT:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}


//delete
+(void)xw_deleteWithUrlString:(NSString *)urlString parameters:(id)parameters success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock{
    
    NSString *urlStr=[NSURL URLWithString:urlString]?urlString:[self strUTF8Encoding:urlString];
    [[XWNetworkingManager shareManger]DELETE:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

//上传图片
+(void)xw_uploadImageWithUrlString:(NSString *)urlString parameters:(id)parameters withImageArray:(NSArray<UIImage *> *)imageArray  progress:(XWProgress)progress success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock{
    
    NSString *urlStr=[NSURL URLWithString:urlString]?urlString:[self strUTF8Encoding:urlString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger i = 0 ;
        /**出于性能考虑,将上传图片进行压缩*/
        for (UIImage * image in imageArray) {
            NSData * imgData = UIImageJPEGRepresentation(image, .5);
            //拼接data
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
            
            i++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error);
        
    }];
}

//上传视频
+(void)xw_uploadVideoWithUrlString:(NSString *)urlString parameters:(id)parameters withVideoPath:(NSString *)videoPath progress:(XWProgress)progress success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock{
    
    NSString *urlStr=[NSURL URLWithString:urlString]?urlString:[self strUTF8Encoding:urlString];
    /**获得视频资源*/
    AVURLAsset * avAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath]];
    /**压缩*/
    AVAssetExportSession  *  avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
    /**创建日期格式化器*/
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    /**转化后直接写入Library---caches*/
    NSString *  videoWritePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/output-%@.mp4",[formatter stringFromDate:[NSDate date]]]];
    avAssetExport.outputURL = [NSURL URLWithString:videoWritePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([avAssetExport status]) {
                
            case AVAssetExportSessionStatusCompleted:
            {
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    //获得沙盒中的视频内容
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:videoWritePath] name:@"write you want to writre" fileName:videoWritePath mimeType:@"video/mpeg4" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    successBlock(responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failureBlock(error);
                }];
                break;
            }
            default:
                break;
        }
    }];
    
}


//下载文件
+(void)XW_downLoadFileWithUrlString:(NSString *)urlString parameters:(id)parameters withSavaPath:(NSString *)savePath rogress:(XWProgress)progress success:(XWSuccessBlock)successBlock failure:(XWFailBlock)failureBlock{
    
    NSString *urlStr=[NSURL URLWithString:urlString]?urlString:[self strUTF8Encoding:urlString];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return  [NSURL URLWithString:savePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        failureBlock(error);
    }];
}




//MARK:取消请求
//取消所有请求
+(void)cancelAllRequest{
    
    [[XWNetworkingManager shareManger].operationQueue cancelAllOperations];
    
}

//取消特定的URL请求
+(void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string{
    
    NSString *urlStr=[NSURL URLWithString:string]?string:[self strUTF8Encoding:string];

    NSError * error;
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    NSString * urlToPeCanced = [[[[XWNetworkingManager  shareManger].requestSerializer requestWithMethod:requestType URLString:urlStr parameters:nil error:&error] URL] path];
    
    for (NSOperation * operation in [XWNetworkingManager shareManger].operationQueue.operations) {
        
        //如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            //请求的类型匹配
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            //请求的url匹配
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            //两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                [operation cancel];
            }
        }
    }
}

//MARK:中文转义
+ (NSString *)strUTF8Encoding:(NSString *)str{
    
    if (([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)) {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}


#pragma mark 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    // 定义一个变量存放当前屏幕显示的viewcontroller
    UIViewController *result = nil;
    
    // 得到当前应用程序的主要窗口
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    // windowLevel是在 Z轴 方向上的窗口位置，默认值为UIWindowLevelNormal
    if (window.windowLevel != UIWindowLevelNormal)
    {
        // 获取应用程序所有的窗口
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            // 找到程序的默认窗口（正在显示的窗口）
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                // 将关键窗口赋值为默认窗口
                window = tmpWin;
                break;
            }
        }
    }
    
    // 获取窗口的当前显示视图
    UIView *frontView = [[window subviews] objectAtIndex:0];
    // 获取视图的下一个响应者，UIView视图调用这个方法的返回值为UIViewController或它的父视图
    id nextResponder = [frontView nextResponder];
    
    // 判断显示视图的下一个响应者是否为一个UIViewController的类对象
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

@end
