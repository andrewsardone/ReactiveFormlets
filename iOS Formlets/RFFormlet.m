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
@property (strong, nonatomic) RACSignal *signal;
@end

@implementation RFFormlet
@dynamic currentValue;

- (instancetype)withValue:(id)value {
	RFFormlet *copy = [self copy];
	copy.currentValue = value;
	return copy;
}

- (id)currentValue {
	RFOrderedDictionary *modelData = [[RFReifiedProtocol model:self.class.model] new];
	return [modelData modify:^void(id<RFMutableOrderedDictionary> dict) {
		for (id key in self) {
			id currentValue = [self[key] currentValue];
			if (currentValue) dict[key] = currentValue;
		}
	}];

	return modelData;
}

- (void)setCurrentValue:(id)value {
	for (id key in value) {
		[self[key] setCurrentValue:value[key]];
	}
}

#pragma mark -

- (RACSignal *)signal {
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

#pragma mark -

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [super methodSignatureForSelector:aSelector] ?: [self.signal methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
	if ([self respondsToSelector:anInvocation.selector]) {
		[super forwardInvocation:anInvocation];
    } else {
		[anInvocation invokeWithTarget:self.signal];
    }
}

@end
