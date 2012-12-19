//
//  RFNumberStringValueTransformer.m
//  iOS Formlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFNumberStringValueTransformer.h"

NSString *const RFNumberStringValueTransformerName = @"RFNumberStringValueTransformerName";

@implementation RFNumberStringValueTransformer

+ (void)load {
	@autoreleasepool {
		[NSValueTransformer setValueTransformer:[self new] forName:RFNumberStringValueTransformerName];
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
