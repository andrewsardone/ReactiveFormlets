//
//  ValidatingFormlet.m
//  Formlets
//
//  Created by Jon Sterling on 6/2/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "ValidatingFormlet.h"

@interface ValidatingFormlet ()
- (void)registerValidations;
@end

@implementation ValidatingFormlet {
    NSMutableArray *_validations;
}

- (id)copyWithZone:(NSZone *)zone
{
    ValidatingFormlet *copy = [super copyWithZone:zone];
    copy->_validations = [_validations mutableCopyWithZone:zone];
    return copy;
}

- (id)init
{
    if ((self = [super init]))
    {
        _validations = [NSMutableArray new];
        [self registerValidations];
    }

    return self;
}

- (id)initWithOrderedDictionary:(JSOrderedDictionary *)dictionary
{
    if (self = [super initWithOrderedDictionary:dictionary])
    {
        _validations = [NSMutableArray new];
        [self registerValidations];
    }

    return self;
}

- (instancetype)initialData:(id)data
{
    assert([data conformsToProtocol:self.class.model]);

    ValidatingFormlet *copy = [self copy];
    for (id key in self)
    {
        copy[key] = data[key] ? [self[key] initialData:data[key]] : self[key];
    }

    copy->_validations = [_validations mutableCopy];

    return copy;
}

- (void)registerValidations
{
    __weak ValidatingFormlet *weakSelf = self;
    [self subscribeNext:^(id value) {
        BOOL isValid = YES;

        ValidatingFormlet *strongSelf = weakSelf;
        for (Validation validation in strongSelf->_validations)
        {
            if (!validation(value))
            {
                isValid = NO;
                break;
            }
        }

        [strongSelf displayValidation:isValid];
    }];
}

- (instancetype)satisfies:(Validation)validation
{
    ValidatingFormlet *copy = [self copy];
    [copy->_validations addObject:[validation copy]];
    return copy;
}

- (void)displayValidation:(BOOL)isValid
{

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

    JSOrderedDictionary *modelData = [[JSReifiedProtocol model:self.class.model] new];

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
