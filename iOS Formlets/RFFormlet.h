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

@protocol RFFormlet <RFSignalSource, RFLens>
@end

@interface RFCompoundFormlet : RFReifiedProtocol <RFFormlet>
@end

@interface RFPrimitiveFormlet : NSObject <RFFormlet>
@end
