//
//  ELRefreshHelper.m
//  ELRefreshHelper
//
//  Created by Ens Livan on 2018/2/1.
//

#import "ELRefreshHelper.h"
#import "MJRefresh.h"
#import "ELBatchRequest.h"

@interface ELRefreshHelper () <ELBatchRequestDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray <ELBaseAPI *> *apis;
@property (nonatomic, strong) UIView *noRecordView;

@end

@implementation ELRefreshHelper {
    BOOL _isPreloading;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _page = 1;
        _apis = [NSMutableArray array];
        _isPreloading = NO;
    }
    return self;
}

- (void)addRefreshHeaderForScrollView:(UIScrollView *)scrollView delegate:(id<ELRefreshDelegate>)delegate {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    scrollView.mj_header = header;
    self.scrollView = scrollView;
    self.delegate = delegate;
}

- (void)addRefreshFooterForScrollView:(UIScrollView *)scrollView delegate:(id<ELRefreshDelegate>)delegate {
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    scrollView.mj_footer = footer;
    self.scrollView = scrollView;
    self.delegate = delegate;
}

- (void)addRefreshHeaderAndFooterForScrollView:(UIScrollView *)scrollView delegate:(id<ELRefreshDelegate>)delegate {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    scrollView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    scrollView.mj_footer = footer;
    self.scrollView = scrollView;
    self.delegate = delegate;
}

- (void)loadFirstPage {
    if ([self.delegate respondsToSelector:@selector(paginationAPI)]) {
        ELPagingAPI *api = [self.delegate paginationAPI];
        api.dataReceiver = self;
        self.page = 1;
        api.pageIndex = self.page;
        if ([self.delegate respondsToSelector:@selector(extraAPIs)]) {
            [self.apis addObjectsFromArray:[self.delegate extraAPIs]];
            [self.apis addObject:api];
            ELBatchRequest *batchReq = [[ELBatchRequest alloc] initWithBatchAPIs:self.apis];
            batchReq.delegate = self;
            [batchReq requestData];
        } else {
            [api requestData];
        }
    }
}

- (void)preloadPageWithCurrentIndex:(NSInteger)index {
    if (index == lround(self.dataList.count * 0.8) && !_isPreloading) {
        _isPreloading = YES;
        [self footerRefresh];
    }
}

#pragma mark -

- (void)headerRefresh {
    if ([self.delegate respondsToSelector:@selector(paginationAPI)]) {
        ELPagingAPI *api = [self.delegate paginationAPI];
        api.dataReceiver = self;
        self.page = 1;
        api.pageIndex = self.page;
        if ([self.delegate respondsToSelector:@selector(extraAPIs)]) {
            [self.apis addObjectsFromArray:[self.delegate extraAPIs]];
            [self.apis addObject:api];
            ELBatchRequest *batchReq = [[ELBatchRequest alloc] initWithBatchAPIs:self.apis];
            api.dataReceiver = nil;
            batchReq.delegate = self;
            for (ELBaseAPI *cacheApi in self.apis) {
                [[ELCache sharedInstance] removeCacheWithKey:NSStringFromClass([cacheApi class])];
            }
            [batchReq requestData];
        } else {
            [[ELCache sharedInstance] removeCacheWithKey:NSStringFromClass([api class])];
            [api requestData];
        }
    }
}

- (void)footerRefresh {
    if ([self.delegate respondsToSelector:@selector(paginationAPI)]) {
        ELPagingAPI *api = [self.delegate paginationAPI];
        api.dataReceiver = self;
        api.pageIndex = ++self.page;
        [api requestData];
    }
}

#pragma mark - ELBatchRequestDelegate

- (void)batchRequestFinished {
    [self reload];
    [self.apis removeAllObjects];
}

#pragma mark - ELBaseAPIDelegate

- (void)api:(ELBaseAPI *)api finishedWithResponse:(ELResponse *)response {
    if (!response.success) {
        NSLog(@"%@", api.rawData);
    }
    
    if ([self.delegate respondsToSelector:@selector(dataListFromResponse:)] && [api isKindOfClass:[ELPagingAPI class]]) {
        ELPagingAPI *pagingAPI = (ELPagingAPI *)api;
        if (pagingAPI.pageIndex == 1) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:[self.delegate dataListFromResponse:response]];
            [self.scrollView.mj_header endRefreshing];
            if (self.dataList.count == 0 && [self.delegate respondsToSelector:@selector(noRecordView)]) {
                // 添加无数据视图
                if (!self.noRecordView.superview) {
                    self.noRecordView = [self.delegate noRecordView];
                    self.noRecordView.frame = self.scrollView.frame;
                    [self.scrollView addSubview:self.noRecordView];
                }
            } else {
                [self.noRecordView removeFromSuperview];
            }
        } else {
            _isPreloading = NO;
            NSArray *newDataList = [self.delegate dataListFromResponse:response];
            //判断列表是否加载完毕
            if (newDataList.count == 0) {
                [self.scrollView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.dataList addObjectsFromArray:newDataList];
                [self.scrollView.mj_footer endRefreshing];
            }
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(api:response:)]) {
            [self.delegate api:api response:response];
        }
    }
    
    if (self.apis.count == 0) {
        [self reload];
    }
}

- (void)reload {
    [self.scrollView performSelector:@selector(reload)];
}

#pragma mark -

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
