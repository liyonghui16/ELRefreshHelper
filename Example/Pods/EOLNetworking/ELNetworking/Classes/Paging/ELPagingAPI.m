//
//  ELPagingAPI.m
//  WatchMovie
//
//  Created by Ens Livan on 2017/10/28.
//  Copyright © 2017年 Ens Livan. All rights reserved.
//

#import "ELPagingAPI.h"

@interface ELPagingAPI ()

@end

@implementation ELPagingAPI

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageIndex = 1;
        _pageSize = 10;
    }
    return self;
}

- (void)requestFirstPage {
    self.pageIndex = 1;
    [self requestData];
}

- (void)requestNextPage {
    self.pageIndex++;
    [self requestData];
}

@end
