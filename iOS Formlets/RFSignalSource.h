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

@protocol RFSignalSource <NSObject>
@concrete
- (id<RACSignal>)rf_signal;
@end
