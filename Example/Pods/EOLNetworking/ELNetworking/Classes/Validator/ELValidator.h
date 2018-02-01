//
//  ELValidator.h
//  WWTCYW
//
//  Created by Ens Livan on 2017/12/8.
//  Copyright © 2017年 com.sxtw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELValidateItem : NSObject

@property (nonatomic, copy) NSString *regex;
@property (nonatomic, copy) NSString *targetObj;
@property (nonatomic, copy) NSString *errorMsg;

@end

/**
 对校验器进行扩展只需要写个Category增加相应方法即可
 */
@interface ELValidator : NSObject

@property (nonatomic, strong, readonly) NSMutableArray <ELValidateItem *> *validateItems;
@property (nonatomic, assign, readonly) BOOL result;
@property (nonatomic, copy, readonly) NSString *errorMsg;

- (ELValidator *)verify;

@end
/**ELValidator (ELNetworking)*/

@interface ELValidator (ELNetworking)

- (void)validateEmptyString:(NSString *)string;
- (void)validateEmptyString:(NSString *)string tip:(NSString *)tip;

- (void)validateEmail:(NSString *)email;
- (void)validateEmail:(NSString *)email tip:(NSString *)tip;

- (void)validatePhoneNumber:(NSString *)phoneNumber;
- (void)validatePhoneNumber:(NSString *)phoneNumber tip:(NSString *)tip;

- (void)validateIDCardNumber:(NSString *)IDCardNumber;
- (void)validateIDCardNumber:(NSString *)IDCardNumber tip:(NSString *)tip;

@end
