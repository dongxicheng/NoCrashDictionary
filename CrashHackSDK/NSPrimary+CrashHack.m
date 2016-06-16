//
//  NSDictionary+hack.m
//  Demo
//
//  Created by 董希成 on 16/6/16.
//  Copyright © 2016年 dongxicheng. All rights reserved.
//

#import <objc/runtime.h>
#import "NSPrimary+CrashHack.h"

//#ifndef DEBUG

//-- NSObject
@implementation NSObject(CrashHack)
-(id) dxc_crashHack_method_nothing:(id) obj{
    NSLog(@"[%@] no method: ", [self class] );
    return nil;
}
@end

// c function - methodSignatureForSelector
static NSMethodSignature * methodSignatureForSelector(id self, SEL selector){
    Class class = [self class];
    NSMethodSignature* ms = nil;
    Method method = class_getInstanceMethod( class, selector );
    if ( method==NULL ){
        method = class_getInstanceMethod( class, @selector(dxc_crashHack_method_nothing:));
    }
    if ( method ) {
        struct objc_method_description * desc = method_getDescription( method );
        ms = [NSMethodSignature signatureWithObjCTypes:desc->types];
    }
    return ms;
}

// c function - forwardInvocation
static void forwardInvocation(id self, NSInvocation * anInvocation) {
    NSString* className = NSStringFromClass([self class]);
    NSString* methodName = NSStringFromSelector(anInvocation.selector);
    NSLog(@"[CrashHack][Error] No Method: %@.%@", className, methodName);
}


//-- NSNumber
@implementation NSNumber (CrashMessage)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return methodSignatureForSelector(self, selector);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    forwardInvocation(self, anInvocation);
}

@end


//-- NSString
@implementation NSString (CrashMessage)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return methodSignatureForSelector(self, selector);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    forwardInvocation(self, anInvocation);
}

@end


//-- NSNull
@implementation NSNull (CrashMessage)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return methodSignatureForSelector(self, selector);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    forwardInvocation(self, anInvocation);
}

@end



//-- NSArray
@implementation NSArray (CrashMessage)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return methodSignatureForSelector(self, selector);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    forwardInvocation(self, anInvocation);
}

@end

//-- NSArray
@implementation NSArray (CrashArrayIndexOutRange)

//--数组越界防止Crash
static id objectAtIndex_2hack(NSArray* self, SEL cmd, NSUInteger index) {
    if( index<self.count ) {
        return [self objectAtIndex_2hack:index];
    }
    return nil;
}

- (id)objectAtIndex_2hack:(NSUInteger)index{
    return nil;
}


static void changeArrayClassMethod(Class class ) {
    Method method = class_getInstanceMethod( class, @selector(objectAtIndex:) );
    struct objc_method_description * desc = method_getDescription( method );
    
    class_addMethod( class , @selector(objectAtIndex_2hack:), (IMP)objectAtIndex_2hack, desc->types);
    Method method1 = class_getInstanceMethod(class, @selector(objectAtIndex:));
    Method method2 = class_getInstanceMethod(class, @selector(objectAtIndex_2hack:));
    if( method1 && method2 ) {
        method_exchangeImplementations(method1, method2);
    }
}



// nil构造数组防止crash
+ (instancetype)arrayWithObjects_2hack:(const id [])objects count:(NSUInteger)cnt{
    id objs2[cnt];
    NSUInteger j = 0;
    for( int i=0; i<cnt; i++ ) {
        if( objects[i] ) {
            objs2[j] = objects[i];
            j++;
        }
    }
    return [self arrayWithObjects_2hack:objs2 count:j];
}

+ (void)load {
    Class oriClass1 = [@[@"1",@"22"] class];
    changeArrayClassMethod(oriClass1);
    
    Method method1 = class_getClassMethod([NSArray class], @selector(arrayWithObjects:count:));
    Method method2 = class_getClassMethod([NSArray class], @selector(arrayWithObjects_2hack:count:));
    if( method1 && method2 ) {
        method_exchangeImplementations(method1, method2);
    }
}
@end


@implementation NSMutableArray(CrashArrayIndexOutRange)

- (void)insertObject:(id)anObject atIndex_2hack:(NSUInteger)index{
}

static void changeMutableArrayClassMethod(Class class ) {
    Method method = class_getInstanceMethod( class, @selector(insertObject:atIndex:) );
    struct objc_method_description * desc = method_getDescription( method );
    
    class_addMethod( class , @selector(insertObject:atIndex_2hack:), (IMP)insertObjectAtIndex_2hack, desc->types);
    Method method1 = class_getInstanceMethod(class, @selector(insertObject:atIndex:));
    Method method2 = class_getInstanceMethod(class, @selector(insertObject:atIndex_2hack:));
    if( method1 && method2 ) {
        method_exchangeImplementations(method1, method2);
    }
}

static void insertObjectAtIndex_2hack(NSMutableArray* self, SEL cmd, id anObject, NSUInteger index) {
    if( anObject ) {
        [self insertObject:anObject atIndex_2hack:index];
    }
}

+ (void)load {
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    [temp addObject:@""];
    Class oriClass2 = [temp class];
    changeMutableArrayClassMethod(oriClass2);
}
@end



//-- NSDictionary
@implementation NSDictionary (CrashMessage)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return methodSignatureForSelector(self, selector);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    forwardInvocation(self, anInvocation);
}

@end



//-- NSDictionary
@implementation NSDictionary(CrashHack)

+ (instancetype)dictionaryWithObjects2:(const id [])objects forKeys:(const id [])keys count:(NSUInteger)cnt{
    id objs2[cnt];
    id keys2[cnt];
    NSUInteger j = 0;
    for( int i=0; i<cnt; i++ ) {
        if( objects[i] && keys[i] ) {
            objs2[j] = objects[i];
            keys2[j] = keys[i];
            j++;
        }
    }
    return [self dictionaryWithObjects2:objs2 forKeys:keys2 count:j];
}

+ (void)load {
    Method method1 = class_getClassMethod([NSDictionary class], @selector(dictionaryWithObjects:forKeys:count:));
    Method method2 = class_getClassMethod([NSDictionary class], @selector(dictionaryWithObjects2:forKeys:count:));
    if( method1 && method2 ) {
        method_exchangeImplementations(method1, method2);
    }
}



@end

//#endif


