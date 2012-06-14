//
//  JSReifiedProtocol.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "JSReifiedProtocol.h"
#import "JSOrderedDictionary.h"
#import <ReactiveCocoa/RACBehaviorSubject.h>
#import <objc/runtime.h>

@interface JSReifiedProtocol ()
+ (NSArray *)keysFromConstructor:(SEL)selector;
@end

@implementation JSReifiedProtocol

+ (Class)model:(Protocol *)model
{
    NSString *className = [NSString stringWithFormat:@"%@_%s", self, protocol_getName(model)];
    Class modelClass = objc_getClass(className.UTF8String);
    if (modelClass != nil)
        return modelClass;

    modelClass = objc_allocateClassPair([self class], className.UTF8String, 0);
    objc_registerClassPair(modelClass);
    class_addProtocol(modelClass, model);

    Class metaclass = object_getClass(modelClass);

    Protocol *(^model_block)() = ^{ return model; };
    IMP model_imp = imp_implementationWithBlock((__bridge void *)(model_block));

    const char *typeEncoding = method_getTypeEncoding(class_getClassMethod(modelClass, @selector(model)));
    class_replaceMethod(metaclass, @selector(model), model_imp, typeEncoding);

    return modelClass;
}

+ (Protocol *)model
{
    return nil;
}

+ (NSArray *)keysFromConstructor:(SEL)selector
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *string, id _) {
        return string.length > 0;
    }];

    return [[NSStringFromSelector(selector) componentsSeparatedByString:@":"] filteredArrayUsingPredicate:predicate];
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    struct objc_method_description method = protocol_getMethodDescription(self.model, aSelector, YES, NO);
    return [NSMethodSignature signatureWithObjCTypes:method.types];
}

+ (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation retainArguments];
    NSArray *keys = [self keysFromConstructor:invocation.selector];

    JSOrderedDictionary *dictionary = [JSOrderedDictionary new];
    for (int i = 2; i < invocation.methodSignature.numberOfArguments; ++i)
    {
        __autoreleasing id outArgument = nil;
        [invocation getArgument:&outArgument atIndex:i];

        NSString *key = [keys objectAtIndex:i-2];
        dictionary[key] = outArgument;
    }

    __autoreleasing JSReifiedProtocol *modelObject = [[self alloc] initWithOrderedDictionary:dictionary];

    invocation.returnValue = (__autoreleasing id *)(&modelObject);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    struct objc_method_description method = protocol_getMethodDescription(self.class.model, aSelector, YES, YES);
    return [NSMethodSignature signatureWithObjCTypes:method.types];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *key = NSStringFromSelector(anInvocation.selector);
    id value = [self valueForKey:key];
    anInvocation.returnValue = (__strong id *)&value;
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return self[key];
}

- (NSString *)description
{
    NSMutableString *body = [NSMutableString new];
    for (id key in self)
    {
        [body appendFormat:@"%@: %@\n", key, self[key]];
    }

    return [NSString stringWithFormat:@"\n  %@",
            [[body componentsSeparatedByString:@"\n"] componentsJoinedByString:@"\n  "]];
}

@end
