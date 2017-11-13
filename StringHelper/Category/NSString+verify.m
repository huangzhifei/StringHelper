//
//  NSString+verify.m
//  StringHelper
//
//  Created by eric on 2017/11/13.
//  Copyright © 2017年 huangzhifei. All rights reserved.
//

#import "NSString+verify.h"

@implementation NSString (verify)

// 姓名：含有汉字或·(少数民族)
- (BOOL)validateName:(NSError *__autoreleasing *)error {
    NSString *msg = @"";
    if (self.length <= 0) {
        msg = @"请填写姓名";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-2 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    } else if (self.length > 30) {
        msg = @"姓名最多30个字符";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-3 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
    NSString *nameRegex = @"^[\u4e00-\u9fa5]+(·[\u4e00-\u9fa5]+)*$";
    NSPredicate *checkPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    if ([checkPre evaluateWithObject:self]) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:0 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return YES;
    } else {
        msg = @"姓名只能包括汉字或·";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
}

// 手机号校验
- (BOOL)validatePhoneNumber:(NSError *__autoreleasing *)error {
    NSString *msg = @"";
    if (self.length <= 0) {
        msg = @"请填写手机号";
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-2 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
    NSString *regex = @"[1][3-9]\\d{9}$";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([mobilePredicate evaluateWithObject:self]) {
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:0 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return YES;
    } else {
        msg = @"请输入正确的手机号";
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
}

// 邮箱校验
- (BOOL)validateEmail:(NSError *__autoreleasing *)error {
    NSString *msg = @"";
    if (self.length <= 0) {
        msg = @"请填写邮箱";
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-2 userInfo:@{NSLocalizedDescriptionKey : msg}];
        }
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:self]) {
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:0 userInfo:@{NSLocalizedDescriptionKey : msg}];
        }
        return YES;
    } else {
        msg = @"请输入正确的邮箱";
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey : msg}];
        }
        return NO;
    }
}

// 身份证校验:弱检验
- (BOOL)validateIdentityWeak:(NSError *__autoreleasing *)error {
    NSString *msg = @"";
    if (self.length <= 0) {
        msg = @"请填写身份证号";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-3 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
    NSString *regex = @"^(\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([identityCardPredicate evaluateWithObject:self]) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:0 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return YES;
    } else {
        msg = @"请检查身份证格式是否正确";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
}

// 身份证校验(18位身份证):强检验
- (BOOL)validateIdentityStrong:(NSError *__autoreleasing *)error {
    NSString *msg = @"";
    if (self.length <= 0) {
        msg = @"请填写身份证号";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-3 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    } else if (![self validateIdentityWeak:error]) {
        return NO;
    }
    
    //计算最后一位余数
    NSArray *arrExp = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSArray *arrVaild = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    
    long sum = 0;
    for (int i = 0; i < (self.length - 1); i++) {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        sum += [str intValue] * [arrExp[i] intValue];
    }
    
    int idx = (sum % 11);
    if ([arrVaild[idx] isEqualToString:[self substringWithRange:NSMakeRange(self.length - 1, 1)]]) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:0 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return YES;
    } else {
        msg = @"请输入正确的身份证号码";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
    return YES;
}

// 护照校验
- (BOOL)validatePassport:(NSError *__autoreleasing *)error {
    NSString *msg = @"";
    const char *str = [self UTF8String];
    char first = str[0];
    NSInteger length = strlen(str);
    if (!(first == 'P' || first == 'G')) {
        msg = @"护照格式要以P或G开头";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
    
    if (first == 'P' && length != 8) {
        msg = @"护照格式不对";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
    
    if (first == 'G' && length != 9) {
        msg = @"护照格式不对";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
    
    BOOL result = YES;
    for (NSInteger i = 1; i < length; i++) {
        if (!(str[i] >= '0' && str[i] <= '9')) {
            msg = @"护照格式不对";
            result = NO;
            break;
        }
    }
    if (error) {
        *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey:msg}];
    }
    return result;
}

// 出生证(第一位是字母+9位数字)
- (BOOL)validateBirthCertificate:(NSError *__autoreleasing *)error {
    NSString *msg = @"";
    if (self.length <= 0) {
        msg = @"请填写出生证号";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-3 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
    NSString *regex = @"^[A-Za-z]\\d{9}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([identityCardPredicate evaluateWithObject:self]) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:0 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return YES;
    } else {
        msg = @"出生证格式不对";
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return NO;
    }
}

// 身份证算出生日期
- (NSString *)IdentityToBirthDay {
    if (![self validateIdentityStrong:nil]) {
        return nil;
    } else {
        NSMutableString *result = [NSMutableString stringWithCapacity:0];
        NSString *year = [self substringWithRange:NSMakeRange(6,4)];
        NSString *month = [self substringWithRange:NSMakeRange(10,2)];
        NSString *day = [self substringWithRange:NSMakeRange(12,2)];
        [result appendString:year];
        [result appendString:@"-"];
        [result appendString:month];
        [result appendString:@"-"];
        [result appendString:day];
        return result;
    }
}

// 身份证算出性别
- (NSInteger)IdentityToSex {
    if (![self validateIdentityStrong:nil]) {
        return 0;
    } else {
        int sexInt = [[self substringWithRange:NSMakeRange(16, 1)] intValue];
        if (sexInt % 2 != 0) {
            return 1;
        } else {
            return 2;
        }
    }
}

// 车牌号校验
- (BOOL)validateCarNum:(NSError *__autoreleasing *)error {
    NSString *msg = @"";
    if (self.length <= 0) {
        msg = @"请填写车牌号";
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-2 userInfo:@{NSLocalizedDescriptionKey : msg}];
        }
        return NO;
    }
    NSString *regex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9]{1,2}$";
    NSPredicate *carNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([carNumPredicate evaluateWithObject:self]) {
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:0 userInfo:@{NSLocalizedDescriptionKey : msg}];
        }
        return YES;
    } else {
        msg = @"请填写正确的车牌号";
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-1 userInfo:@{NSLocalizedDescriptionKey : msg}];
        }
        return NO;
    }
}

// 银行卡校验
- (BOOL)validateBankCardNumber:(NSError *__autoreleasing *)error {
    NSString *msg = @"";
    if (self.length <= 0) {
        msg = @"请填写银行卡号";
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-2 userInfo:@{NSLocalizedDescriptionKey : msg}];
        }
        return NO;
    }
    
    if (self.length < 13 || self.length > 20) {
        msg = @"银行卡长度不对";
        if (error != NULL && msg != nil) {
            *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-2 userInfo:@{NSLocalizedDescriptionKey : msg}];
        }
        return NO;
    } else {
        if ([self checkBankCard]) {
            msg = @"";
            if (error != NULL && msg != nil) {
                *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-2 userInfo:@{NSLocalizedDescriptionKey : msg}];
            }
            return YES;
        } else {
            msg = @"银行卡格式不对";
            if (error != NULL && msg != nil) {
                *error = [[NSError alloc] initWithDomain:@"com.hzf.sh" code:-2 userInfo:@{NSLocalizedDescriptionKey : msg}];
            }
            return NO;
        }
    }
}

- (BOOL)checkBankCard {
    int oddsum = 0;  //奇数求和
    int evensum = 0; //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[self length];
    int lastNum = [[self substringFromIndex:cardNoLength - 1] intValue];
    
    NSString *temp = [self substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength - 1; i >= 1; i--) {
        NSString *tmpString = [temp substringWithRange:NSMakeRange(i - 1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 == 1) {
            if ((i % 2) == 0) {
                tmpVal *= 2;
                if (tmpVal >= 10)
                    tmpVal -= 9;
                evensum += tmpVal;
            } else {
                oddsum += tmpVal;
            }
        } else {
            if ((i % 2) == 1) {
                tmpVal *= 2;
                if (tmpVal >= 10)
                    tmpVal -= 9;
                evensum += tmpVal;
            } else {
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if ((allsum % 10) == 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
