//
//  RAFSignalSource.h
//  ReactiveCocoa
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/libextobjc/extobjc/EXTConcreteProtocol.h>

@class RACSignal;

// A concrete protocol representing an object which emits a signal.
@protocol RAFSignalSource <NSObject>
@concrete

// If no implementation is provided, returns a signal that immediately sends
// `self` and then completes.
- (RACSignal *)rf_signal;
@end
