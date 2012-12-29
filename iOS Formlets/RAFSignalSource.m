//
//  RAFSignalSource.m
//  ReactiveCocoa
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFSignalSource.h"
#import <ReactiveCocoa/RACSignal.h>

@concreteprotocol(RAFSignalSource)

- (RACSignal *)rf_signal {
	return [RACSignal return:self];
}

@end
