//
//  NSObject+JSMember.h
//  JSExtension
//
//  Created by JS on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSIvar.h"
#import "JSMethod.h"

/**
 *  遍历所有类的block（父类）
 */
typedef void (^JSClassesBlock)(Class c, BOOL *stop);

@interface NSObject (JSMember)

/**
 *  遍历所有的成员变量
 */
- (void)enumerateIvarsWithBlock:(JSIvarsBlock)block;

/**
 *  遍历所有的方法
 */
- (void)enumerateMethodsWithBlock:(JSMethodsBlock)block;

/**
 *  遍历所有的类
 */
- (void)enumerateClassesWithBlock:(JSClassesBlock)block;
@end
