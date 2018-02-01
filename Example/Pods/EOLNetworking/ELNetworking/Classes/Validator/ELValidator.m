//
//  ELValidator.m
//  WWTCYW
//
//  Created by Ens Livan on 2017/12/8.
//  Copyright © 2017年 com.sxtw. All rights reserved.
//

#import "ELValidator.h"

@implementation ELValidateItem

@end

@interface ELValidator ()

@property (nonatomic, strong, readwrite) NSMutableArray <ELValidateItem *> *validateItems;
@property (nonatomic, assign, readwrite) BOOL result;
@property (nonatomic, copy) NSString *errorMsg;

@end

@implementation ELValidator

- (instancetype)init {
    self = [super init];
    if (self) {
        _result = YES;
        _errorMsg = @"";
    }
    return self;
}

- (ELValidator *)verify {
    [self.validateItems enumerateObjectsUsingBlock:^(ELValidateItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.regex) {
            self.result = NO;
            self.errorMsg = obj.errorMsg;
            *stop = YES;
            return;
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", obj.regex];
        BOOL result = [predicate evaluateWithObject:obj.targetObj];
        self.result = result;
        if (!result) {
            self.errorMsg = obj.errorMsg;
            *stop = YES;
        }
    }];
    return self;
}

#pragma mark - getter

- (NSMutableArray <ELValidateItem *>*)validateItems {
    if (!_validateItems) {
        _validateItems = [NSMutableArray array];
    }
    return _validateItems;
}

@end

@implementation ELValidator (ELNetworking)

- (void)validateEmptyString:(NSString *)string {
    [self validateEmptyString:string tip:@"请不要输入空字符！"];
}

- (void)validateEmptyString:(NSString *)string tip:(NSString *)tip {
    if ([string isEqualToString:@""] || !string || [string isEqual:[NSNull null]]) {
        ELValidateItem *validateItem = [[ELValidateItem alloc] init];
        validateItem.regex = nil;
        validateItem.targetObj = string;
        validateItem.errorMsg = tip;
        [self.validateItems addObject:validateItem];
    }
}

- (void)validateEmail:(NSString *)email {
    [self validateEmail:email tip:@"请输入正确格式的邮箱！"];
}

- (void)validateEmail:(NSString *)email tip:(NSString *)tip {
    ELValidateItem *validateItem = [[ELValidateItem alloc] init];
    validateItem.regex = @"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?";
    validateItem.targetObj = email;
    validateItem.errorMsg = tip;
    [self.validateItems addObject:validateItem];
}

- (void)validatePhoneNumber:(NSString *)phoneNumber {
    [self validatePhoneNumber:phoneNumber tip:@"请输入正确格式的手机号！"];
}

- (void)validatePhoneNumber:(NSString *)phoneNumber tip:(NSString *)tip {
    ELValidateItem *validateItem = [[ELValidateItem alloc] init];
    validateItem.regex = @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
    validateItem.targetObj = phoneNumber;
    validateItem.errorMsg = tip;
    [self.validateItems addObject:validateItem];
}

- (void)validateIDCardNumber:(NSString *)IDCardNumber {
    [self validateIDCardNumber:IDCardNumber tip:@"请输入正确格式的身份证号！"];
}

- (void)validateIDCardNumber:(NSString *)IDCardNumber tip:(NSString *)tip {
    ELValidateItem *validateItem = [[ELValidateItem alloc] init];
    validateItem.regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    validateItem.targetObj = IDCardNumber;
    validateItem.errorMsg = tip;
    [self.validateItems addObject:validateItem];
}

@end
