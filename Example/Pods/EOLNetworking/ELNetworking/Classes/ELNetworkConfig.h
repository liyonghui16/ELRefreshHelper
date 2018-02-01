//
//  ELNetworkConfig.h
//  ELNetworking
//
//  Created by 李涌辉 on 2016/10/23.
//  Copyright © 2016年 LiYonghui~. All rights reserved.
//

#ifndef ELNetworkConfig_h
#define ELNetworkConfig_h

#ifdef DEBUG
#define ELLog(...) NSLog(__VA_ARGS__)
#else
#define ELLog(...) {}
#endif

static NSInteger kELMaxCacheCountLimit = 500;
static NSTimeInterval kELResponseDiskCacheAge = 60 * 60 * 24;
static NSTimeInterval kELResponseMemoryCacheAge = 60 * 5;

typedef NS_ENUM(NSUInteger, ELRequestType) {
    ELRequestTypeUnknow,
    ELRequestTypeGET,
    ELRequestTypePOST,
};

typedef NS_ENUM(NSUInteger, ELCachePolicy) {
    ELCachePolicyNone,
    /**内存缓存*/
    ELCachePolicyMemory,
    /**磁盘缓存*/
    ELCachePolicyDisk
};

#endif /* ELNetworkConfig_h */
