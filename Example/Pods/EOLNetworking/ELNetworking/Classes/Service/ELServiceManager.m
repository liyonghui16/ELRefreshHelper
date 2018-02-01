//
//  ELServiceManager.m
//  ELNetworking
//
//  Created by Ens Livan on 2017/12/22.
//

#import "ELServiceManager.h"

@interface ELServiceManager ()

@property (nonatomic, strong) id<ELAPIService> service;

@end

@implementation ELServiceManager

+ (ELServiceManager *)sharedManager {
    static ELServiceManager *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[ELServiceManager alloc] init];
    });
    return obj;
}

- (void)registerService:(id<ELAPIService>)service {
    _service = service;
}

@end
