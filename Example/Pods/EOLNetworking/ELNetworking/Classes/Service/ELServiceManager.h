//
//  ELServiceManager.h
//  ELNetworking
//
//  Created by Ens Livan on 2017/12/22.
//

#import <Foundation/Foundation.h>
#import "ELNetworkProtocol.h"

@interface ELServiceManager : NSObject

@property (nonatomic, strong, readonly) id<ELAPIService> service;

+ (ELServiceManager *)sharedManager;

- (void)registerService:(id<ELAPIService>)service;

@end
