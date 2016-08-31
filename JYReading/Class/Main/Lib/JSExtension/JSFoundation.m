//
//  JSFoundation.m
//  JSExtensionExample
//
//  Created by JS Lee on 14/7/16.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "JSFoundation.h"
#import "JSConst.h"

static NSArray *_foundationClasses;

@implementation JSFoundation

+ (void)initialize
{
    _foundationClasses = @[@"NSObject", @"NSNumber",@"NSArray", @"NSURL", @"NSMutableURL",@"NSMutableArray",@"NSData",@"NSMutableData",@"NSDate",@"NSDictionary",@"NSMutableDictionary",@"NSString",@"NSMutableString"];
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    JSAssertParamNotNil2(c, NO);
    return [_foundationClasses containsObject:NSStringFromClass(c)];
}
@end
