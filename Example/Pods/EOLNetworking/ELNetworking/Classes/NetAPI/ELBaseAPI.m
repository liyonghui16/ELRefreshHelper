//
//  ELBaseAPI.m
//  ELNetworking
//
//  Created by 李涌辉 on 16/8/7.
//  Copyright © 2016年 LiYonghui~. All rights reserved.
//

#import "ELBaseAPI.h"
#import "ELCache.h"
#import "ELPagingAPI.h"
#import "ELServiceManager.h"

@interface ELBaseAPI ()

@property (nonatomic, weak) id<APIConfig> child;
@property (nonatomic, weak) id<ELAPIValidator> validator;
@property (nonatomic, weak) id<ELCacheDelegate> cacheDelegate;
@property (nonatomic, weak) id<ELAPIInterceptor> interceptor;
//
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong, readwrite) id rawData;

@end

@implementation ELBaseAPI

- (instancetype)init {
    self = [super init];
    if (self) {
        if (![self conformsToProtocol:@protocol(APIConfig)]) {
            NSAssert(NO, @"子类必须实现APIConfig协议");
        }
        self.child = (id<APIConfig>)self;
        if ([self conformsToProtocol:@protocol(ELAPIValidator)]) {
            self.validator = (id<ELAPIValidator>)self;
        }
        if ([self conformsToProtocol:@protocol(ELCacheDelegate)]) {
            self.cacheDelegate = (id<ELCacheDelegate>)self;
        }
        if ([self conformsToProtocol:@protocol(ELAPIInterceptor)]) {
            self.interceptor = (id<ELAPIInterceptor>)self;
        }
    }
    return self;
}

- (void)requestData {
    if (self.isLoading) return;
    self.isLoading = YES;
    id<ELAPIService> service = [ELServiceManager sharedManager].service;
    NSAssert(service, @"You must register a service for ELNetwork!");
    if (![service shouldCallApi:self]) {
        self.isLoading = NO;
        return;
    }
    
    NSString *domain = service.commonDomain;
    if ([self.child respondsToSelector:@selector(APIDomain)]) {
        domain = [self.child APIDomain];
    }
    ELRequestType reqType = service.commonRequestType;
    if ([self.child respondsToSelector:@selector(requestType)]) {
        reqType = [self.child requestType];
    }
    NSString *methodName = [self.child APIMethodName];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //分页api参数
    if ([self isKindOfClass:[ELPagingAPI class]]) {
        ELPagingAPI *pagingAPI = (ELPagingAPI *)self;
        [params setObject:@(pagingAPI.pageIndex) forKey:service.pageIndexKey ?: @"pageIndex"];
        [params setObject:@(pagingAPI.pageSize) forKey:service.pageSizeKey ?: @"pageSize"];
    }
    // api参数
    if ([self.child respondsToSelector:@selector(APIParams)]) {
        [params addEntriesFromDictionary:self.child.APIParams];
    }
    // common
    if ([service respondsToSelector:@selector(commonParams)]) {
        [params addEntriesFromDictionary:service.commonParams];
    }
    // user相关参数
    if ([self.child conformsToProtocol:@protocol(ELUserAuth)]) {
        [params addEntriesFromDictionary:service.userAuthParams];
    }
    
    // 参数验证 如果验证失败则不发起请求
    if ([self conformsToProtocol:@protocol(ELAPIValidator)]) {
        ELValidator *validator = [self.validator validateAPI:self requestParams:params];
        if (!validator.result) {
            ELResponse *response = [[ELResponse alloc] init];
            response.message = validator.errorMsg;
            response.code = ELResponseCodeCancle;
            response.success = NO;
            [self.dataReceiver api:self finishedWithResponse:response];
            response = nil;
            self.isLoading = NO;
            ELLog(@"参数校验失败！取消请求 API :%@\n 错误信息 : %@", self, validator.errorMsg);
            return;
        }
    }
    // 判断缓存
    ELCacheObject *cacheObj = [[ELCache sharedInstance] fetchCacheWithKey:NSStringFromClass([self class]) params:params cachePolicy:[self.cacheDelegate cachePolicy]];
    // 缓存存在并且没有失效 
    if (cacheObj && ![cacheObj isOutDateWithCachePolicy:[self.cacheDelegate cachePolicy]]) {
        self.isLoading = NO;
        [self.dataReceiver api:self finishedWithResponse:cacheObj.response];
        return;
    }
    // 请求前的log
    [self willRequestWithDomain:domain params:params];
    
    [[ELNetwork sharedNetwork] startRequestWithMethodType:reqType domain:domain methodName:methodName params:params completionHandle:^(id rawData, NSInteger code) {
        self.rawData = rawData;
        self.isLoading = NO;
        ELResponse *response = [service recombineResponseWithApi:self
                                                   resposeObject:rawData
                                                            code:code];
        // 拦截器
        if ([self.interceptor respondsToSelector:@selector(api:willCompletedRequestWithResponse:)]) {
            [self.interceptor api:self willCompletedRequestWithResponse:response];
        }
        //
        [self.dataReceiver api:self finishedWithResponse:response];
        //
        if ([self.interceptor respondsToSelector:@selector(api:didCompletedRequestWithResponse:)]) {
            [self.interceptor api:self didCompletedRequestWithResponse:response];
        }
        [self completeRequestWithResponse:response params:params];
    }];
}

/**
 请求前后的log 便于调试

 @param domain 接口域名
 */
- (void)willRequestWithDomain:(NSString *)domain params:(NSDictionary *)params {
    ELLog(@"%@开始请求", NSStringFromClass([self class]));
//    ELLog(@"请求域名 : %@", domain.length ? domain : @"--");
    ELLog(@"请求地址 : %@", [self.child APIMethodName]);
    if (params.count) {
        ELLog(@"请求参数 : %@", params);
    }
}

- (void)completeRequestWithResponse:(ELResponse *)response params:(NSDictionary *)params {
    if (response.success) {
        ELLog(@"%@请求成功!", NSStringFromClass([self class]));
        [[ELCache sharedInstance] saveCacheWithResponse:response key:NSStringFromClass([self class]) params:params cachePolicy:[self.cacheDelegate cachePolicy]];
    } else {
        ELLog(@"\n%@请求失败 \n 错误信息 : %@ \nhttp响应码 : %ld \nerrorCode : %ld", NSStringFromClass([self class]), response.message, (unsigned long)response.code, (long)response.errorCode);
    }
}

@end
