//
//  ELRefreshHelper.h
//  ELRefreshHelper
//
//  Created by Ens Livan on 2018/2/1.
//

#import <Foundation/Foundation.h>
#import <EOLNetworking/EOLNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ELRefreshDelegate <NSObject>

- (ELPagingAPI *)paginationAPI;
- (NSArray *)dataListFromResponse:(ELResponse *)response;

@optional
- (NSArray<ELBaseAPI *> *)extraAPIs;
- (void)api:(ELBaseAPI *)api response:(ELResponse *)response;
// 列表页无记录视图
@property (nonatomic, strong, readonly) UIView *noRecordView;

@end

@interface ELRefreshHelper : NSObject <ELBaseAPIDelegate>

@property (nonatomic, weak) id<ELRefreshDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

- (void)addRefreshHeaderForScrollView:(UIScrollView *)scrollView delegate:(id<ELRefreshDelegate>)delegate;
- (void)addRefreshFooterForScrollView:(UIScrollView *)scrollView delegate:(id<ELRefreshDelegate>)delegate;
- (void)addRefreshHeaderAndFooterForScrollView:(UIScrollView *)scrollView delegate:(id<ELRefreshDelegate>)delegate;

- (void)loadFirstPage;

- (void)preloadPageWithCurrentIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
