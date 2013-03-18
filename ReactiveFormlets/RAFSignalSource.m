//
//  RAFSignalSource.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFSignalSource.h>
#import <ReactiveCocoa/RACSignal.h>
#import "EXTScope.h"

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
	@weakify(self);
	return [self.raf_signal map:^id(id value) {
		@strongify(self);
		return @([self raf_isValid:value]);
	}];
}

@end
