//
//  BookModel.m
//  JYReading
//
//  Created by JourneyYoung on 16/8/31.
//  Copyright © 2016年 Journey. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

+(BookModel *)initWithDictionary:(NSDictionary *)dict
{
    BookModel *model = [[BookModel alloc]init];
    model.author = dict[@"author"];
    model.id = dict[@"id"];
    model.name = dict[@"name"];
    model.newchapter = dict[@"newChapter"];
    model.size = dict[@"size"];
    model.type = dict[@"type"];
    model.typeName = dict[@"typeName"];
    model.updateTime = dict[@"updateTime"];
    return model;
}
@end
