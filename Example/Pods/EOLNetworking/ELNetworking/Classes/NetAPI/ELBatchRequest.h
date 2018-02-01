//
//  ELBatchRequest.h
//  WatchMovie
//
//  Created by Ens Livan on 2017/11/8.
//  Copyright © 2017年 Ens Livan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELBaseAPI.h"

@protocol ELBatchRequestDelegate <ELBaseAPIDelegate>
- (void)batchRequestFinished;
@end

/**
 批量请求
 */
@interface ELBatchRequest : NSObject

@property (nonatomic, weak) id<ELBatchRequestDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray <ELBaseAPI *>*batchAPIs;

- (instancetype)initWithBatchAPIs:(NSArray <ELBaseAPI *>*)batchAPIs;

- (void)requestData;

@end
