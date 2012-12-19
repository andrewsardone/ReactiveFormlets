//
//  RFAlgebra.m
//  iOS Formlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFLens.h"
#import "RFIdentityValueTransformer.h"

@concreteprotocol(RFLens)

- (id)copyWithZone:(NSZone *)zone { return nil; }
- (NSString *)keyPathForLens { return nil; }

#pragma mark - Concrete

- (NSValueTransformer *)valueTransformer {
	return [NSValueTransformer valueTransformerForName:RFIdentityValueTransformerName];
}

- (id)read {
	id value = [self valueForKeyPath:self.keyPathForLens];
	return value ? [self.valueTransformer transformedValue:value] : nil;
}

- (void)updateInPlace:(id)value {
	id transformed = value ? [self.valueTransformer reverseTransformedValue:value] : nil;
	[self setValue:transformed forKeyPath:self.keyPathForLens];
}

- (instancetype)update:(id)value {
	id copy = [self copyWithZone:NULL];
	[copy updateInPlace:value];
	return copy;
}

@end
