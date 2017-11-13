//
//  NSString+verify.h
//  StringHelper
//
//  Created by eric on 2017/11/13.
//  Copyright © 2017年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (verify)

// 姓名：含有汉字或·(少数民族)
- (BOOL)validateName:(NSError **)error;

// 手机号校验
- (BOOL)validatePhoneNumber:(NSError **)error;

// 邮箱校验
- (BOOL)validateEmail:(NSError **)error;

// 身份证校验(18位身份证):弱检验
- (BOOL)validateIdentityWeak:(NSError **)error;

// 身份证校验(18位身份证):强检验
- (BOOL)validateIdentityStrong:(NSError **)error;

// 护照校验
- (BOOL)validatePassport:(NSError **)error;

// 出生证(第一位是字母+9位数字)
- (BOOL)validateBirthCertificate:(NSError **)error;

// 身份证算出生日期:根据身份证强检验结果
- (NSString *)IdentityToBirthDay;

// 身份证算出性别:根据身份证强检验结果, 0：未知, 1: 男, 2：女
- (NSInteger)IdentityToSex;

// 车牌号校验
- (BOOL)validateCarNum:(NSError **)error;

// 银行卡校验
- (BOOL)validateBankCardNumber:(NSError **)error;

@end
