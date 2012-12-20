//
//  RFSignalSource.h
//  iOS Formlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/libextobjc/extobjc/EXTConcreteProtocol.h>

@protocol RACSignal;

// A concrete protocol representing an object which emits a signal.
@protocol RFSignalSource <NSObject>
@concrete

// If no implementation is provided, returns a signal that immediately sends
// `self` and then completes.
- (id<RACSignal>)rf_signal;
@end
