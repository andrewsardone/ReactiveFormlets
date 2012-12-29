//
//  Formlet.m
//  Formlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFFormlet.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation RAFPrimitiveFormlet

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [self.class new];
}

#pragma mark - RAFSignalSource

- (RACSignal *)rf_signal {
	@throw [NSException exceptionWithName:NSGenericException
								   reason:@"Subclasses of RAFPrimitiveFormlet must override -rf_signal"
								 userInfo:nil];
	return nil;
}

#pragma mark - RAFLens

- (NSString *)keyPathForLens {
	@throw [NSException exceptionWithName:NSGenericException
								   reason:@"Subclasses of RAFPrimitiveFormlet must override -keyPathForLens"
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

@interface RAFCompoundFormlet ()
@property (strong) id compoundValue;
@end

@implementation RAFCompoundFormlet {
	RACSignal *_signal;
}

@dynamic compoundValue;

- (id)compoundValue {
	RAFReifiedProtocol *modelData = [[RAFReifiedProtocol model:self.class.model] new];
	return [modelData modify:^(id<RAFMutableOrderedDictionary> dict) {
		for (id key in dict) {
			id data = self[key].read;
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
	return [self deepCopyWithZone:zone];
}

- (instancetype)deepCopyWithZone:(NSZone *)zone {
	id copy = [super deepCopyWithZone:zone];
	[copy updateInPlace:self.read];
	return copy;
}

#pragma mark - RAFSignalSource

- (RACSignal *)rf_signal {
	if (!_signal) {
		_signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			NSMutableSet *disposables = [NSMutableSet setWithCapacity:self.count];
			NSMutableSet *extantSignals = [NSMutableSet setWithArray:self.allValues];

			id<RAFMutableOrderedDictionary> modelData = [[[RAFReifiedProtocol model:self.class.model] new] mutableCopy];

			for (id key in self) {
				RACSignal *signal = self[key];
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

#pragma mark - RAFLens

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
