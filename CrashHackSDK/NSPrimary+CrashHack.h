//
//  NSDictionary+hack.h
//  Demo
//
//  Created by 董希成 on 16/6/16.
//  Copyright © 2016年 dongxicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

//release模式才开启
//#ifndef DEBUG

/**
 * 1. 构造 字典/数组 nil 不会crash
 * 2. 数组越界 访问不会crash
 * 3. 字典/数组/字符串/NSNumber 互换使用不会crash
 */

@interface NSNumber (CrashMessage)
@end

@interface NSString (CrashMessage)
@end

@interface NSNull (CrashMessage)
@end

@interface NSArray (CrashMessage)
@end

@interface NSDictionary (CrashMessage)
@end

@interface NSDictionary (CrashHack)
@end

//#endif

