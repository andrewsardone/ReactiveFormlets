//
//  RAFIdentityValueTransformer.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFIdentityValueTransformer.h>

NSString *const RAFIdentityValueTransformerName = @"RAFIdentityValueTransformerName";

@implementation RAFIdentityValueTransformer

+ (void)load {
	@autoreleasepool {
		[NSValueTransformer setValueTransformer:[self new] forName:RAFIdentityValueTransformerName];
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
