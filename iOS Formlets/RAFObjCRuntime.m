//
//  RAFObjCRuntime.m
//  ReactiveCocoa
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFObjCRuntime.h"
#import <ReactiveCocoa/RACObjCRuntime.h>

@implementation RAFObjCRuntime

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol {
	const char *types = [RACObjCRuntime getMethodTypesForMethod:selector inProtocol:protocol];
	return types ? [NSMethodSignature signatureWithObjCTypes:types] : nil;
}

+ (NSMethodSignature *)classMethodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol {
	enum { Required = YES, Optional = NO };

	const char *types = protocol_getMethodDescription(protocol, selector, Required, NO).types;
	if (types == NULL) types = protocol_getMethodDescription(protocol, selector, Optional, NO).types;
	return types ? [NSMethodSignature signatureWithObjCTypes:types] : nil;
}

@end

@implementation NSObject (RAFObjCRuntime)

+ (Class)rf_subclassWithName:(NSString *)name adopting:(NSArray *)protocols {
	Class class = objc_getClass(name.UTF8String);
	if (class != nil) return class;

	class = objc_allocateClassPair(self, name.UTF8String, 0);
	objc_registerClassPair(class);

	for (Protocol *protocol in protocols) {
		class_addProtocol(class, protocol);
	}

	return class;
}

- (id)rf_associatedObjectForKey:(void *)key {
	return objc_getAssociatedObject(self, key);
}

- (void)rf_setAssociatedObject:(id)value forKey:(void *)key policy:(objc_AssociationPolicy)policy {
	objc_setAssociatedObject(self, key, value, policy);
}

+ (id)rf_associatedObjectForKey:(void *)key {
	return objc_getAssociatedObject(self, key);
}

+ (void)rf_setAssociatedObject:(id)value forKey:(void *)key policy:(objc_AssociationPolicy)policy {
	objc_setAssociatedObject(self, key, value, policy);
}

@end
