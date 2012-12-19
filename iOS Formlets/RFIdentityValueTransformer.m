//
//  RFIdentityValueTransformer.m
//  iOS Formlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFIdentityValueTransformer.h"

NSString *const RFIdentityValueTransformerName = @"RFIdentityValueTransformerName";

@implementation RFIdentityValueTransformer

+ (void)load {
	@autoreleasepool {
		[NSValueTransformer setValueTransformer:[self new] forName:RFIdentityValueTransformerName];
	}
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	return value;
}

- (id)reverseTransformedValue:(id)value {
	return value;
}

@end
