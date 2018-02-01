//
//  ELNetworkProtocol.h
//  ELNetworking
//
//  Created by 李涌辉 on 2016/10/23.
//  Copyright © 2016年 LiYonghui~. All rights reserved.
//

#import "ELNetworkProtocol.h"
#import "ELNetworkConfig.h"

@class ELBaseAPI;
@class ELResponse;
@class ELValidator;

@protocol APIConfig <NSObject>

- (NSString *)APIMethodName;

@optional
- (NSDictionary *)APIParams;
//
- (NSString *)APIDomain;
- (ELRequestType)requestType;

@end

@protocol ELCacheDelegate <NSObject>
- (ELCachePolicy)cachePolicy;

@optional
- (NSTimeInterval)cacheTime;
@end

@protocol ELAPIValidator <NSObject>
- (ELValidator *)validateAPI:(ELBaseAPI *)api requestParams:(NSDictionary *)reqP;
@end

@protocol ELAPIInterceptor <NSObject>

@optional
- (void)api:(ELBaseAPI *)api willCompletedRequestWithResponse:(ELResponse *)response;
- (void)api:(ELBaseAPI *)api didCompletedRequestWithResponse:(ELResponse *)response;
@end

@protocol ELAPIService <NSObject>

@property (nonatomic, copy, readonly) NSString *commonDomain;
@property (nonatomic, assign, readonly) ELRequestType commonRequestType;

- (BOOL)shouldCallApi:(ELBaseAPI *)api;

/**
 对获取到的数据进行重组

 @param api 当前接口对象
 @param responseObject 序列化后的数据
 @param code http code
 @return 重组后的response对象
 */
- (ELResponse *)recombineResponseWithApi:(ELBaseAPI *)api resposeObject:(id)responseObject code:(NSInteger)code;

@optional
/**
 接口公共参数
 */
@property (nonatomic, strong, readonly) NSDictionary *commonParams;
/**
 user相关参数
 */
@property (nonatomic, strong, readonly) NSDictionary *userAuthParams;
//page
@property (nonatomic, copy, readonly) NSString *pageIndexKey;
@property (nonatomic, copy, readonly) NSString *pageSizeKey;

@end

/**
 api遵循此协议，请求时候会把service提供的userAuthParams加入requestbody
 */
@protocol ELUserAuth <NSObject>
@end
/* ELNetworkProtocal_h */
