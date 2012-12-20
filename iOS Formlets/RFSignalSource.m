//
//  RFSignalSource.m
//  iOS Formlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFSignalSource.h"
#import <ReactiveCocoa/RACSignal.h>

@concreteprotocol(RFSignalSource)

- (RACSignal *)rf_signal {
	return [RACSignal return:self];
}

@end
