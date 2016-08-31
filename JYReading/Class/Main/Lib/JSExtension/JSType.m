//
//  JSType.m
//  JSExtension
//
//  Created by JS on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "JSType.h"
#import "JSExtension.h"
#import "JSFoundation.h"
#import "JSConst.h"

@implementation JSType

- (instancetype)initWithCode:(NSString *)code
{
    if (self = [super init]) {
        self.code = code;
    }
    return self;
}

/** 类型标识符 */
- (void)setCode:(NSString *)code
{
    _code = code;
    
    JSAssertParamNotNil(code);
    
    if (code.length == 0 || [code isEqualToString:JSTypeSEL] ||
        [code isEqualToString:JSTypeIvar] ||
        [code isEqualToString:JSTypeMethod]) {
        _KVCDisabled = YES;
    } else if ([code hasPrefix:@"@"] && code.length > 3) {
        // 去掉@"和"，截取中间的类型名称
        _code = [code substringFromIndex:2];
        _code = [_code substringToIndex:_code.length - 1];
        _typeClass = NSClassFromString(_code);
        
        _fromFoundation = [JSFoundation isClassFromFoundation:_typeClass];
    }
}

JSLogAllIvrs
@end
