//
//  RFLens.h
//  iOS Formlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/libextobjc/extobjc/EXTConcreteProtocol.h>

@protocol RFLens <NSCopying>
- (NSString *)keyPathForLens;
@concrete
- (id)read;
- (void)updateInPlace:(id)value;
- (instancetype)update:(id)value;

- (NSValueTransformer *)valueTransformer;
@end
