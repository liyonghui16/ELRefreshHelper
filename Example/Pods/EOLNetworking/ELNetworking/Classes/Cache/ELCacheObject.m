//
//  ELCacheObject.m
//  ELNetworking
//
//  Created by 李涌辉 on 2016/10/25.
//  Copyright © 2016年 Ens Livan. All rights reserved.
//

#import "ELCacheObject.h"

@implementation ELCacheObject

- (BOOL)isOutDateWithCachePolicy:(ELCachePolicy)cachePolicy {
    NSTimeInterval cacheTimeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    if (self.cacheTime != 0) {
        return cacheTimeInterval > self.cacheTime;
    }
    switch (cachePolicy) {
        case ELCachePolicyNone:
            return YES;
            break;
        case ELCachePolicyMemory:
            return cacheTimeInterval > kELResponseDiskCacheAge;
            break;
        case ELCachePolicyDisk:
            return cacheTimeInterval > kELResponseMemoryCacheAge;
            break;
    }
    return YES;
}

@end
