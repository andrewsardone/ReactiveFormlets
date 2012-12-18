//
//  Formlet.m
//  Formlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFFormlet.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RFFormlet ()
@property (strong, nonatomic) RFReifiedProtocol *reify;
@end

@implementation RFFormlet
@dynamic currentValue;

- (id)copyWithZone:(NSZone *)zone
{
    RFFormlet *copy = [[self class] new];
    copy.reify = [self.reify copyWithZone:zone];
    return copy;
}

- (instancetype)withValue:(id)value
{
    RFFormlet *copy = [self copy];
    copy.currentValue = value;
    return copy;
}

- (id)currentValue
{
    RFOrderedDictionary *modelData = [[RFReifiedProtocol model:self.class.model] new];
    return [modelData modify:^void(id<RFMutableOrderedDictionary> dict) {
        for (id key in self.reify)
        {
            id currentValue = [self.reify[key] currentValue];
            if (currentValue)
                dict[key] = currentValue;
        }
    }];

    return modelData;
}

- (void)setCurrentValue:(id)value
{
    for (id key in value)
    {
        [self.reify[key] setCurrentValue:value[key]];
    }
}

#pragma mark -

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber
{
    NSMutableSet *disposables = [NSMutableSet setWithCapacity:self.reify.count];
    NSMutableSet *completedSignals = [NSMutableSet setWithCapacity:self.reify.count];

    id modelData = [[RFReifiedProtocol model:self.class.model] new];

    for (id key in self.reify)
    {
        id<RACSignal> signal = self.reify[key];
        RACDisposable *disposable = [signal subscribeNext:^(id x) {
            if (x != nil)
                modelData[key] = x;
            [subscriber sendNext:modelData];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [completedSignals addObject:signal];
            if(completedSignals.count == self.reify.count) {
                [subscriber sendCompleted];
            }
        }];

        if(disposable != nil) {
            [disposables addObject:disposable];
        }
    }

    return [RACDisposable disposableWithBlock:^{
        for(RACDisposable *disposable in disposables) {
            [disposable dispose];
        }
    }];
}


#pragma mark - 

- (RFOrderedDictionary *)reify
{
    if (!_reify)
    {
        _reify = [[RFReifiedProtocol model:self.class.model] new];
    }

    return _reify;
}

- (instancetype)modify:(RFOrderedDictionaryModifyBlock)block
{
    RFFormlet *copy = [self copy];
    copy->_reify = [copy.reify modify:block];
    return copy;
}

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
    IMP model_imp = imp_implementationWithBlock(model_block);

    const char *typeEncoding = method_getTypeEncoding(class_getClassMethod(modelClass, @selector(model)));
    class_replaceMethod(metaclass, @selector(model), model_imp, typeEncoding);

    return modelClass;
}

+ (Protocol *)model
{
    return nil;
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [[RFReifiedProtocol model:self.model] methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation retainArguments];
    Class Reified = [RFReifiedProtocol model:self.class.model];

    [invocation invokeWithTarget:Reified];

    __autoreleasing RFReifiedProtocol *model = nil;
    __autoreleasing RFFormlet *formlet = [self new];

    [invocation getReturnValue:&model];
    formlet->_reify = model;

    invocation.returnValue = &formlet;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.reify;
}

- (NSString *)description
{
    return self.reify.description;
}

@end
