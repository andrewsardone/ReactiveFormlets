//
//  RAFNumberStringValueTransformer.m
//  ReactiveCocoa
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFNumberStringValueTransformer.h"

NSString *const RAFNumberStringValueTransformerName = @"RAFNumberStringValueTransformerName";

@implementation RAFNumberStringValueTransformer

+ (void)load {
	@autoreleasepool {
		[NSValueTransformer setValueTransformer:[self new] forName:RAFNumberStringValueTransformerName];
	}
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	return [NSDecimalNumber decimalNumberWithString:value];
}

- (id)reverseTransformedValue:(id)value {
	return [value stringValue];
}

@end
