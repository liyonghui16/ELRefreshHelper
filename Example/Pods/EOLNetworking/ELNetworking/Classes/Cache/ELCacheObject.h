//
//  ELCacheObject.h
//  ELNetworking
//
//  Created by 李涌辉 on 2016/10/25.
//  Copyright © 2016年 Ens Livan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELResponse.h"
#import "ELNetworkConfig.h"

@interface ELCacheObject : NSObject

/**
 缓存的响应数据
 */
@property (nonatomic, strong) ELResponse *response;

/**
 缓存数据对应的参数
 */
@property (nonatomic, strong) NSDictionary *apiParams;

/**
 缓存最后更新时间
 */
@property (nonatomic, strong) NSDate *lastUpdateTime;

/**
 自定义缓存时间
 */
@property (nonatomic, assign) NSTimeInterval cacheTime;

/**
 缓存是否过期
 @param cachePolicy 缓存策略
 */
- (BOOL)isOutDateWithCachePolicy:(ELCachePolicy)cachePolicy;

@end
