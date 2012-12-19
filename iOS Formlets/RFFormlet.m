//
//  Formlet.m
//  Formlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFFormlet.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@concreteprotocol(RFFormlet)
@dynamic pureValue;

- (id<RACSignal>)rf_signal { return nil; }

#pragma mark - Concrete

- (id)initWithPureValue:(id)pureValue {
    if (self = [self init]) {
        self.pureValue = pureValue;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self.class alloc] initWithPureValue:self.pureValue];
}

- (instancetype)withPureValue:(id)pureValue {
    id copy = [self copy];
    [copy setPureValue:pureValue];
    return copy;
}

@end

@implementation RFPrimitiveFormlet
@dynamic pureValue;

- (id<RACSignal>)rf_signal {
    @throw [NSException exceptionWithName:NSGenericException
                                   reason:@"Subclasses of RFPrimitiveFormlet must override -rf_signal"
                                 userInfo:nil];
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [(id)self.rf_signal methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.rf_signal];
}

@end

@implementation RFCompoundFormlet {
    id<RACSignal> _signal;
}

- (id)pureValue {
    RFReifiedProtocol *modelData = [[RFReifiedProtocol model:self.class.model] new];
    return [modelData modify:^(id<RFMutableOrderedDictionary> dict) {
        for (id key in dict) {
            id data = [self[key] pureValue];
            if (data) dict[key] = data;
        }
    }];
}

- (void)setPureValue:(id)pureValue {
	for (id key in pureValue) {
        [self[key] setPureValue:pureValue[key]];
	}
}

- (id<RACSignal>)rf_signal {
	if (!_signal) {
		_signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			NSMutableSet *disposables = [NSMutableSet setWithCapacity:self.count];
			NSMutableSet *completedSignals = [NSMutableSet setWithCapacity:self.count];

			id modelData = [[RFReifiedProtocol model:self.class.model] new];

			for (id key in self)
			{
				id<RACSignal> signal = self[key];
				RACDisposable *disposable = [signal subscribeNext:^(id value) {
					if (value) modelData[key] = value;
					[subscriber sendNext:modelData];
				} error:^(NSError *error) {
					[subscriber sendError:error];
				} completed:^{
					[completedSignals addObject:signal];
					if(completedSignals.count == self.count) {
						[subscriber sendCompleted];
					}
				}];

				if(disposable != nil)
					[disposables addObject:disposable];
			}

			return [RACDisposable disposableWithBlock:^{
				for(RACDisposable *disposable in disposables) {
					[disposable dispose];
				}
			}];
		}];
	}
	return _signal;
}

#pragma mark - Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [super methodSignatureForSelector:aSelector] ?: [(id)self.rf_signal methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	if ([self respondsToSelector:anInvocation.selector]) {
		[super forwardInvocation:anInvocation];
    } else {
		[anInvocation invokeWithTarget:self.rf_signal];
    }
}

@end
