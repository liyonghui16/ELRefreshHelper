//
//  ELPagingAPI.h
//  WatchMovie
//
//  Created by Ens Livan on 2017/10/28.
//  Copyright © 2017年 Ens Livan. All rights reserved.
//

#import "ELBaseAPI.h"

@interface ELPagingAPI : ELBaseAPI

@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) NSUInteger pageSize;

- (void)requestFirstPage;
- (void)requestNextPage;

@end
