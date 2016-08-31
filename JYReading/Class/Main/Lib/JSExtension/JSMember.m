//
//  JSMember.m
//  JSExtension
//
//  Created by JS on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "JSMember.h"
#import "JSExtension.h"
#import "JSFoundation.h"
#import "JSConst.h"

@implementation JSMember


/**
 *  初始化
 *
 *  @param srcObject 来源于哪个对象
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithSrcObject:(id)srcObject
{
    if (self = [super init]) {
        _srcObject = srcObject;
    }
    return self;
}

- (void)setSrcClass:(Class)srcClass
{
    _srcClass = srcClass;
    
    JSAssertParamNotNil(srcClass);
    
    _srcClassFromFoundation = [JSFoundation isClassFromFoundation:srcClass];
}

JSLogAllIvrs
@end
