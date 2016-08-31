//
//  JSExtension.h
//  JSExtension
//
//  Created by JS on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  代码地址:https://github.com/CoderJSLee/JSExtension
//  代码地址:http://code4app.com/ios/%E5%AD%97%E5%85%B8-JSON-%E4%B8%8E%E6%A8%A1%E5%9E%8B%E7%9A%84%E8%BD%AC%E6%8D%A2/5339992a933bf062608b4c57

#import "JSTypeEncoding.h"
#import "NSObject+JSCoding.h"
#import "NSObject+JSMember.h"
#import "NSObject+JSKeyValue.h"

#define JSLogAllIvrs \
- (NSString *)description \
{ \
    return [self keyValues].description; \
}
