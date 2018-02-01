//
//  ELNetwork.m
//  ELNetworking
//
//  Created by 李涌辉 on 16/8/5.
//  Copyright © 2016年 LiYonghui~. All rights reserved.
//

#import "ELNetwork.h"
#import "AFNetworking.h"
#import "ELServiceManager.h"

@interface ELNetwork ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation ELNetwork

+ (ELNetwork *)sharedNetwork {
    static ELNetwork *network;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[ELNetwork alloc] init];
        network.manager = [AFHTTPSessionManager manager];
        network.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/plain", @"text/javascript", nil];
        network.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        network.manager.requestSerializer.timeoutInterval = 30.f;
    });
    return network;
}

- (void)startRequestWithMethodType:(ELRequestType)type domain:(NSString *)domain methodName:(NSString *)name params:(NSDictionary *)params completionHandle:(CompletionHandle)completionHandle {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", domain, name];
    ELLog(@"RequestUrl : %@", requestUrl);
    
    requestUrl = [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    switch (type) {
        case ELRequestTypeGET:
            [self startGETRequestWithRequestUrl:requestUrl params:params completionHandle:completionHandle];
            break;
        case ELRequestTypePOST:
            [self startPOSTRequestWithRequestUrl:requestUrl params:params completionHandle:completionHandle];
            break;
        default:
            break;
    }
}

- (void)startGETRequestWithRequestUrl:(NSString *)requestUrl params:(NSDictionary *)params completionHandle:(CompletionHandle)completionHandle {
    [[ELNetwork sharedNetwork].manager GET:requestUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
       
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSHTTPURLResponse *rawResponse = (NSHTTPURLResponse *)task.response;
       completionHandle(responseObject, rawResponse.statusCode);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSHTTPURLResponse *rawResponse = (NSHTTPURLResponse *)task.response;
       NSDictionary *errorData = @{@"errorCode" : @(error.code),
                                   @"message" : error.localizedDescription};
       
       completionHandle(errorData, rawResponse.statusCode);
   }];
}

- (void)startPOSTRequestWithRequestUrl:(NSString *)requestUrl params:(NSDictionary *)params completionHandle:(CompletionHandle)completionHandle {
    
    [[ELNetwork sharedNetwork].manager POST:requestUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *rawResponse = (NSHTTPURLResponse *)task.response;
        completionHandle(responseObject, rawResponse.statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *rawResponse = (NSHTTPURLResponse *)task.response;
        NSDictionary *errorData = @{@"errorCode" : @(error.code),
                                    @"message" : error.localizedDescription};
        
        completionHandle(errorData, rawResponse.statusCode);
    }];
}

@end
