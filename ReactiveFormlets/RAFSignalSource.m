//
//  RAFSignalSource.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFSignalSource.h>
#import <ReactiveCocoa/RACSignal.h>

@concreteprotocol(RAFSignalSource)

- (RACSignal *)raf_signal {
	return [RACSignal return:self];
}

@end

@concreteprotocol(RAFValidatedSignalSource)

- (BOOL)raf_isValid:(id)value {
	return YES;
}

- (RACSignal *)raf_validation {
	__weak id<RAFValidatedSignalSource> weakSelf = self;
	return [self.raf_signal map:^id(id value) {
		id<RAFValidatedSignalSource> self = weakSelf;
		return @([self raf_isValid:value]);
	}];
}

@end
