//
//  ELNetwork.h
//  ELNetworking
//
//  Created by 李涌辉 on 16/8/5.
//  Copyright © 2016年 LiYonghui~. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELNetworkConfig.h"
#import "ELResponse.h"
#import "ELNetworkProtocol.h"

typedef void(^CompletionHandle)(id responseObject, NSInteger code);

@interface ELNetwork : NSObject

+ (ELNetwork *)sharedNetwork;
- (void)startRequestWithMethodType:(ELRequestType)type domain:(NSString *)domain methodName:(NSString *)name params:(NSDictionary *)params completionHandle:(CompletionHandle)completionHandle;


@end
