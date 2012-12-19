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

@protocol RFFormlet <RFModel>
@property (strong, nonatomic) id pureValue;

@concrete
- (id)initWithPureValue:(id)pureValue;
- (instancetype)withPureValue:(id)pureValue;

- (id)copyWithZone:(NSZone *)zone;
@end

@interface RFCompoundFormlet : RFReifiedProtocol <RFFormlet>
@end

@interface RFPrimitiveFormlet : NSObject <RFFormlet>
@end
