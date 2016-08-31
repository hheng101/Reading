
#ifndef __JSConst__H__
#define __JSConst__H__
//
//#ifdef DEBUG  // 调试状态
//// 打开LOG功能
//#define JSLog(...) NSLog(__VA_ARGS__)
//#else // 发布状态
//// 关闭LOG功能
//#define JSLog(...)
//#endif

// 颜色
#define JSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define JSRandomColor JSColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 断言
#define JSAssert2(condition, desc, returnValue) \
if ((condition) == NO) { \
NSString *file = [NSString stringWithUTF8String:__FILE__]; \
JSLog(@"\n警告文件：%@\n警告行数：第%d行\n警告方法：%s\n警告描述：%@", file, __LINE__,  __FUNCTION__, desc); \
JSLog(@"\n如果不想看到警告信息，可以删掉JSConst.h中的第23、第24行"); \
return returnValue; \
}

#define JSAssert(condition, desc) JSAssert2(condition, desc, )

#define JSAssertParamNotNil2(param, returnValue) \
JSAssert2(param, [[NSString stringWithFormat:@#param] stringByAppendingString:@"参数不能为nil"], returnValue)

#define JSAssertParamNotNil(param) JSAssertParamNotNil2(param, )

#endif