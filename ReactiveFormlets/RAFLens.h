//
//  RAFLens.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFLens.h>
#import <ReactiveFormlets/RAFValidator.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EXTConcreteProtocol.h"

@protocol RAFExtract
@concrete
// The extraction operation of some copointed functor. If no implementation
// is provided, -extract is an identity.
- (id)extract;
@end

// A concrete protocol representing a lens into an object through a value
// transformer.
@protocol RAFLens <NSCopying, RAFExtract>
@required

// The keypath destination of the lens.
- (NSString *)keyPathForLens;

@concrete

// A bidirectional value transformer; by default, the Identity transformer is
// used if none is provided.
- (NSValueTransformer *)valueTransformer;

// Returns the value at the keypath provided in -keyPathForLens fed through the
// above value transformer.
- (id)extract;

// Destructively updates at the provided keypath with a value fed in reverse
// through the above value transformer.
//
// value - The value to reverse-transform and set. If this is `nil`, it will not
// be fed through the value transformer.
- (void)updateInPlace:(id)value;

// Creates a copy of the current object, having been updated at the provided
// keypath with a value fed in reverse through the provided value transformer.
//
// value - The value to reverse-transform and set. If this is `nil`, it will not
// be fed through the value transformer.
//
// Returns the copied and updated object.
- (instancetype)update:(id)value;

// A signal that sends -extract on ever in-place update.
- (RACSignal *)hardUpdateSignal;

@end

// A lens that provides validation
@protocol RAFValidatedLens <RAFLens, RAFValidator>
@concrete
// Reads the lens and passes it through the validator.
- (BOOL)raf_isValid;
@end
