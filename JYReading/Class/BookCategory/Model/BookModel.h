//
//  BookModel.h
//  JYReading
//
//  Created by JourneyYoung on 16/8/31.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject

@property(nonatomic,copy) NSString *author;

@property(nonatomic,copy) NSString *id;

@property(nonatomic,copy) NSString *name;

@property(nonatomic,copy) NSString *newchapter;

@property(nonatomic,copy) NSString *size;

@property(nonatomic,copy) NSString *type;

@property(nonatomic,copy) NSString *typeName;

@property(nonatomic,copy) NSString *updateTime;

+(BookModel *)initWithDictionary:(NSDictionary *)dict;

@end
