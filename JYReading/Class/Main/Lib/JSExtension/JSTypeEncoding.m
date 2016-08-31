//
//  JSTypeEncoding.m
//  JSExtension
//
//  Created by JS on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//
#import <Foundation/Foundation.h>
/**
 *  成员变量类型（属性类型）
 */
NSString *const JSTypeInt = @"i";
NSString *const JSTypeFloat = @"f";
NSString *const JSTypeDouble = @"d";
NSString *const JSTypeLong = @"q";
NSString *const JSTypeLongLong = @"q";
NSString *const JSTypeChar = @"c";
NSString *const JSTypeBOOL = @"c";
NSString *const JSTypePointer = @"*";

NSString *const JSTypeIvar = @"^{objc_ivar=}";
NSString *const JSTypeMethod = @"^{objc_method=}";
NSString *const JSTypeBlock = @"@?";
NSString *const JSTypeClass = @"#";
NSString *const JSTypeSEL = @":";
NSString *const JSTypeId = @"@";

/**
 *  返回值类型(如果是unsigned，就是大写)
 */
NSString *const JSReturnTypeVoid = @"v";
NSString *const JSReturnTypeObject = @"@";



