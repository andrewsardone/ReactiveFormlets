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

@protocol RACSignal;

@protocol RFFormlet
- (id<RACSignal>)signal;

@property (strong, nonatomic) id pureData;

@concrete
- (id)initWithPureData:(id)pureData;
- (instancetype)withPureData:(id)pureData;

- (id)copyWithZone:(NSZone *)zone;
@end

@interface RFCompoundFormlet : RFReifiedProtocol <RFFormlet>
@end

@interface RFPrimitiveFormlet : NSObject <RFFormlet>
@end
