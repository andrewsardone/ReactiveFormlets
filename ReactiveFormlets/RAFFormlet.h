//
//  RAFFormlet.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveFormlets/ReactiveFormlets.h>
#import <ReactiveFormlets/RAFReifiedProtocol.h>
#import <ReactiveFormlets/RAFModel.h>
#import <ReactiveFormlets/RAFModel.h>

// A formlet emits a signal and provides a lens through which values are mapped
// in and out. A formlet may either bind directly to an interface, or may be
// composed of other formlets.
@protocol RAFFormlet <RAFValidator, RAFValidatedSignalSource, RAFValidatedLens>
@end

typedef BOOL (^RAFValidator)(id value);

// A primitive formlet is one which binds directly to an interface.
// `RAFPrimitiveFormlet` subclasses must provide their own `-raf_signal` and
// `-keyPathForLens` implementations.
@interface RAFPrimitiveFormlet : NSObject <RAFFormlet>
@property (copy, readonly) NSArray *customValidators;
- (instancetype)validators:(NSArray *)validators;
@end

// A compound formlet is one which is composed of smaller formlets, as specified
// in the model protocol it is initialized from.
@interface RAFCompoundFormlet : RAFReifiedProtocol <RAFFormlet>
@end

// A compound formlet is an ordered dictionary, where its keys are model fields
// and its values are other formlets. We can refine the dictionary accessors
// to indicate that all elements of a compound formlet are other formlets.
@interface RAFCompoundFormlet (TypeRefinement)
- (id<RAFFormlet>)objectForKey:(id<NSCopying>)key;
- (id<RAFFormlet>)objectForKeyedSubscript:(id<NSCopying>)key;
@end
