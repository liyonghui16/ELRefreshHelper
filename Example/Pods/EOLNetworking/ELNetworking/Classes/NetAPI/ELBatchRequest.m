//
//  ELBatchRequest.m
//  WatchMovie
//
//  Created by Ens Livan on 2017/11/8.
//  Copyright © 2017年 Ens Livan. All rights reserved.
//

#import "ELBatchRequest.h"

@interface ELBatchRequest () <ELBaseAPIDelegate>

@property (nonatomic, strong) dispatch_group_t group;

@end

@implementation ELBatchRequest

- (instancetype)initWithBatchAPIs:(NSArray<ELBaseAPI *> *)batchAPIs {
    self = [super init];
    if (self) {
        _batchAPIs = batchAPIs;
        _group = dispatch_group_create();
    }
    return self;
}

- (void)requestData {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (ELBaseAPI *api in _batchAPIs) {
        dispatch_group_enter(_group);
        dispatch_group_async(_group, queue, ^{
            api.dataReceiver = self;
            [api requestData];
        });
    }
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        [self.delegate batchRequestFinished];
    });
}

#pragma mark -

- (void)api:(ELBaseAPI *)api finishedWithResponse:(ELResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate api:api finishedWithResponse:response];
    });
    dispatch_group_leave(_group);
}

@end
