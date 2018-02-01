//
//  ELCache.m
//  ELNetworking
//
//  Created by 李涌辉 on 2016/10/25.
//  Copyright © 2016年 Ens Livan. All rights reserved.
//

#import "ELCache.h"

@interface ELCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation ELCache

- (NSCache *)cache {
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kELMaxCacheCountLimit;
    }
    return _cache;
}

+ (ELCache *)sharedInstance {
    static ELCache *sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[ELCache alloc] init];
    });
    return sharedCache;
}

- (void)saveCacheWithResponse:(ELResponse *)response key:(NSString *)key params:(NSDictionary *)params {
    [self saveCacheWithResponse:response key:key params:params cachePolicy:ELCachePolicyMemory];
}

- (void)saveCacheWithResponse:(ELResponse *)response key:(NSString *)key params:(NSDictionary *)params cachePolicy:(ELCachePolicy)cachePolicy {
    [self saveCacheWithResponse:response key:key params:params cachePolicy:cachePolicy cacheTime:0];
}

- (void)saveCacheWithResponse:(ELResponse *)response key:(NSString *)key params:(NSDictionary *)params cachePolicy:(ELCachePolicy)cachePolicy cacheTime:(NSTimeInterval)cacheTime {
    if (cachePolicy == ELCachePolicyMemory) {
        ELCacheObject *cacheObj = [self.cache objectForKey:key];
        if (!cacheObj) {
            cacheObj = [[ELCacheObject alloc] init];
        }
        cacheObj.response = response;
        cacheObj.apiParams = params;
        cacheObj.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
        cacheObj.cacheTime = cacheTime;
        [self.cache setObject:cacheObj forKey:key];
    } else if (cachePolicy == ELCachePolicyDisk) {
        NSString *cachePath = [self networkCacheFilePath];
        __block NSMutableString *path = [NSMutableString stringWithString:@""];
        [path appendString:key];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [path appendString:[NSString stringWithFormat:@"%@%@", key, obj]];
        }];
        NSDictionary *data = @{@"response" : response,
                               @"params" : params};
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", cachePath, path];
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL isExist = [manager fileExistsAtPath:fullPath];
        if (isExist) {
            return;
        }
        BOOL result = [NSKeyedArchiver archiveRootObject:data toFile:fullPath];
        if (!result) {
            NSLog(@"归档失败！obj : %@ path : %@", data, fullPath);
        }
    } else if (cachePolicy == ELCachePolicyNone) {
        // do nothing.
    }
}

- (void)removeCacheWithKey:(NSString *)key {
    [self.cache removeObjectForKey:key];
}

- (void)removeAllCache {
    [self.cache removeAllObjects];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[self networkCacheFilePath] error:&error];
    if (error) {
        NSLog(@"removeCacheError. error: %@ errorDomain: %@", error.localizedDescription, error.domain);
    }
}

- (ELCacheObject *)fetchCacheWithKey:(NSString *)key params:(NSDictionary *)params cachePolicy:(ELCachePolicy)cachePolicy {
    if (cachePolicy == ELCachePolicyDisk) {
        NSString *cachePath = [self networkCacheFilePath];
        __block NSMutableString *path = [NSMutableString stringWithString:@""];
        [path appendString:key];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [path appendString:[NSString stringWithFormat:@"%@%@", key, obj]];
        }];
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", cachePath, path];
        NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
        if (!data) {
            NSLog(@"解档失败或数据不存在!");
            return nil;
        }
        ELCacheObject *cacheObj = [ELCacheObject new];
        cacheObj.response = [data objectForKey:@"response"];
        cacheObj.apiParams = [data objectForKey:@"params"];
        return cacheObj;
    } else if (cachePolicy == ELCachePolicyMemory) {
        ELCacheObject *cacheObj = [self.cache objectForKey:key];
        if (cacheObj) {
            if ([cacheObj.apiParams isEqualToDictionary:params]) {
                return cacheObj;
            } else {
                [self.cache removeObjectForKey:key];
                return nil;
            }
        }
        return nil;
    } else {
        return nil;
    }
}

- (NSString *)networkCacheFilePath {
     NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/com.elnetwork.data", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return filePath;
}

@end
