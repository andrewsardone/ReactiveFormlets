//
//  Formlet.h
//  Formlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/libextobjc/extobjc/EXTConcreteProtocol.h>
#import "RFReifiedProtocol.h"
#import "RFModel.h"
#import "RFLens.h"

// A formlet emits a signal and provides a lens through which values are mapped
// in and out. A formlet may either bind directly to an interface, or may be
// composed of other formlets.
@protocol RFFormlet <RFSignalSource, RFLens>
@end

// A primitive formlet is one which binds directly to an interface.
// `RFPrimitiveFormlet` subclasses must provide their own `-rf_signal` and
// `-keyPathForLens` implementations.
@interface RFPrimitiveFormlet : NSObject <RFFormlet>
@end

// A compound formlet is one which is composed of smaller formlets, as specified
// in the model protocol it is initialized from.
@interface RFCompoundFormlet : RFReifiedProtocol <RFFormlet>
@end

// A compound formlet is an ordered dictionary, where its keys are model fields
// and its values are other formlets. We can refine the dictionary accessors
// to indicate that all elements of a compound formlet are other formlets.
@interface RFCompoundFormlet (TypeRefinement)
- (id<RFFormlet>)objectForKey:(id<NSCopying>)key;
- (id<RFFormlet>)objectForKeyedSubscript:(id<NSCopying>)key;
@end
