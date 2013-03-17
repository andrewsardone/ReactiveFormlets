//
//  RAFSignalSource.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXTConcreteProtocol.h"
#import "RAFValidator.h"

@class RACSignal;

// A concrete protocol representing an object which emits a signal.
@protocol RAFSignalSource <NSObject>
@concrete

// If no implementation is provided, returns a signal that immediately sends
// `self` and then completes.
- (RACSignal *)raf_signal;
@end


// A concrete protocol representing a signal source with validation.
@protocol RAFValidatedSignalSource <RAFValidator, RAFSignalSource>
@concrete
// If no implementation is provided, returns a boolean signal that maps
// -isValid: over the main signal.
- (RACSignal *)raf_validation;
@end
