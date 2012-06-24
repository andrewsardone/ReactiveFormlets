//
//  Formlet.m
//  Formlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "Formlet.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation Formlet
@dynamic currentValue;

- (instancetype)withValue:(id)value
{
    Formlet *copy = [self copy];
    copy.currentValue = value;
    return copy;
}

- (id)currentValue
{
    JSOrderedDictionary *modelData = [[JSReifiedProtocol model:self.class.model] new];
    for (id key in self)
    {
        id currentValue = [self[key] currentValue];
        if (currentValue)
            modelData[key] = currentValue;
    }

    return modelData;
}

- (void)setCurrentValue:(id)value
{
    for (id key in value)
    {
        [self[key] setCurrentValue:value[key]];
    }
}


#pragma mark -

- (void)setObject:(id)object forKey:(id<NSCopying>)key
{
    [super setObject:[object copy] forKey:key];
}

#pragma mark -

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber
{
    NSMutableSet *disposables = [NSMutableSet setWithCapacity:self.count];
    NSMutableSet *completedSubscribables = [NSMutableSet setWithCapacity:self.count];

    id modelData = [[JSReifiedProtocol model:self.class.model] new];

    for (id key in self)
    {
        RACSubscribable *subscribable = self[key];
        RACDisposable *disposable = [subscribable subscribeNext:^(id x) {
            if (x != nil)
                modelData[key] = x;
            [subscriber sendNext:modelData];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [completedSubscribables addObject:subscribable];
            if(completedSubscribables.count == self.count) {
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

@end

@implementation NSString (Text)

+ (instancetype)text
{
    return @"";
}

@end

@implementation NSNumber (Number)

+ (instancetype)number
{
    return [NSDecimalNumber zero];
}

@end
