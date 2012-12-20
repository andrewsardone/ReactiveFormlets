//
//  Formlet.m
//  Formlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFFormlet.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation RFPrimitiveFormlet

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [self.class new];
}

#pragma mark - RFSignalSource

- (id<RACSignal>)rf_signal {
	@throw [NSException exceptionWithName:NSGenericException
								   reason:@"Subclasses of RFPrimitiveFormlet must override -rf_signal"
								 userInfo:nil];
	return nil;
}

#pragma mark - RFLens

- (NSString *)keyPathForLens {
	@throw [NSException exceptionWithName:NSGenericException
								   reason:@"Subclasses of RFPrimitiveFormlet must override -keyPathForLens"
								 userInfo:nil];
	return nil;
}

#pragma mark - Message Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [(id)self.rf_signal methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	[anInvocation invokeWithTarget:self.rf_signal];
}

@end

@interface RFCompoundFormlet ()
@property (strong) id compoundValue;
@end

@implementation RFCompoundFormlet {
	id<RACSignal> _signal;
}

@dynamic compoundValue;

- (id)compoundValue {
	RFReifiedProtocol *modelData = [[RFReifiedProtocol model:self.class.model] new];
	return [modelData modify:^(id<RFMutableOrderedDictionary> dict) {
		for (id key in dict) {
			id data = [self[key] read];
			if (data) dict[key] = data;
		}
	}];
}

- (void)setCompoundValue:(id)value {
	for (id key in value) {
		[self[key] updateInPlace:value[key]];
	}
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	id copy = [super copyWithZone:zone];
	[copy updateInPlace:self.read];
	return copy;
}

#pragma mark - RFSignalSource

- (id<RACSignal>)rf_signal {
	if (!_signal) {
		_signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			NSMutableSet *disposables = [NSMutableSet setWithCapacity:self.count];
			NSMutableSet *extantSignals = [NSMutableSet setWithArray:self.allValues];

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
					[extantSignals removeObject:signal];
					if (!extantSignals.count) {
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
		}];
	}
	return _signal;
}

#pragma mark - RFLens

- (NSString *)keyPathForLens {
	return @keypath(self.compoundValue);
}

#pragma mark - Message Forwarding

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
