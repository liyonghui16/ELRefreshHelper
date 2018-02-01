//
//  ELCache.h
//  ELNetworking
//
//  Created by 李涌辉 on 2016/10/25.
//  Copyright © 2016年 Ens Livan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELCacheObject.h"

@interface ELCache : NSObject

+ (ELCache *)sharedInstance;

- (void)saveCacheWithResponse:(ELResponse *)response key:(NSString *)key params:(NSDictionary *)params;
- (void)saveCacheWithResponse:(ELResponse *)response key:(NSString *)key params:(NSDictionary *)params cachePolicy:(ELCachePolicy)cachePolicy;
- (void)saveCacheWithResponse:(ELResponse *)response key:(NSString *)key params:(NSDictionary *)params cachePolicy:(ELCachePolicy)cachePolicy cacheTime:(NSTimeInterval)cacheTime;

- (void)removeCacheWithKey:(NSString *)key;

- (void)removeAllCache;

- (ELCacheObject *)fetchCacheWithKey:(NSString *)key params:(NSDictionary *)params cachePolicy:(ELCachePolicy)cachePolicy;

@end
