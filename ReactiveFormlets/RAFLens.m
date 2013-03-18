//
//  RAFLens.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFLens.h>
#import <ReactiveFormlets/RAFIdentityValueTransformer.h>

@concreteprotocol(RAFExtract)

- (id)extract {
	return self;
}

@end

@concreteprotocol(RAFLens)

#pragma mark - Inherited

- (id)copyWithZone:(NSZone *)zone { return nil; }
- (NSString *)keyPathForLens { return nil; }

#pragma mark - Concrete

- (NSValueTransformer *)valueTransformer {
	return [NSValueTransformer valueTransformerForName:RAFIdentityValueTransformerName];
}

- (id)extract {
	id value = [self valueForKeyPath:self.keyPathForLens];
	return (value && ![value isKindOfClass:[NSNull class]]) ? [self.valueTransformer transformedValue:value] : nil;
}

- (RACBehaviorSubject *)hardUpdateSignal {
	static void *kHardUpdateSignalKey = &kHardUpdateSignalKey;
	if (objc_getAssociatedObject(self, kHardUpdateSignalKey) == nil) {
		objc_setAssociatedObject(self, kHardUpdateSignalKey, [RACBehaviorSubject behaviorSubjectWithDefaultValue:self.extract], OBJC_ASSOCIATION_RETAIN);
	}

	return objc_getAssociatedObject(self, kHardUpdateSignalKey);
}

- (void)updateInPlace:(id)value {
	BOOL valueNotNull = value && ![value isKindOfClass:[NSNull class]];
	id transformed = valueNotNull ? [self.valueTransformer reverseTransformedValue:value] : nil;
	[self setValue:transformed forKeyPath:self.keyPathForLens];
	[(RACBehaviorSubject *)self.hardUpdateSignal sendNext:self.extract];
}

- (instancetype)update:(id)value {
	id copy = [self copyWithZone:NULL];
	[copy updateInPlace:value];
	return copy;
}

@end

@concreteprotocol(RAFValidatedLens)

#pragma mark - Inherited

- (id)copyWithZone:(NSZone *)zone { return nil; }
- (NSString *)keyPathForLens { return nil; }

#pragma mark - Concrete

- (BOOL)raf_isValid {
	return [self raf_isValid:self.extract];
}

@end
