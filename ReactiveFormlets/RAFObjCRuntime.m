//
//  RAFObjCRuntime.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFObjCRuntime.h"

typedef enum : BOOL {
	RAFInstanceMethodScope = YES,
	RAFClassMethodScope = NO
} RAFMethodScope;

typedef enum : BOOL {
	RAFRequiredMethod = YES,
	RAFOptionalMethod = NO
} RAFMethodObligation;

@implementation RAFObjCRuntime

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol scope:(RAFMethodScope)scope obligation:(RAFMethodObligation)obligation {
	const char *types = protocol_getMethodDescription(protocol, selector, obligation, scope).types;
	return types ? [NSMethodSignature signatureWithObjCTypes:types] : nil;
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol scope:(RAFMethodScope)scope {
	return ([self methodSignatureForSelector:selector
								  inProtocol:protocol
									   scope:scope
								  obligation:RAFRequiredMethod] ?:
			[self methodSignatureForSelector:selector
								  inProtocol:protocol
									   scope:scope
								  obligation:RAFOptionalMethod]);
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol {
	return [self methodSignatureForSelector:selector inProtocol:protocol scope:RAFInstanceMethodScope];
}

+ (NSMethodSignature *)classMethodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol {
	return [self methodSignatureForSelector:selector inProtocol:protocol scope:RAFClassMethodScope];
}

@end

@implementation NSObject (RAFObjCRuntime)

+ (Class)raf_subclassWithName:(NSString *)name adopting:(NSArray *)protocols {
	Class class = objc_getClass(name.UTF8String);
	if (class != nil) return class;

	class = objc_allocateClassPair(self, name.UTF8String, 0);
	objc_registerClassPair(class);

	for (Protocol *protocol in protocols) {
		class_addProtocol(class, protocol);
	}

	return class;
}

- (id)raf_associatedObjectForKey:(void *)key {
	return objc_getAssociatedObject(self, key);
}

- (void)raf_setAssociatedObject:(id)value forKey:(void *)key policy:(objc_AssociationPolicy)policy {
	objc_setAssociatedObject(self, key, value, policy);
}

+ (id)raf_associatedObjectForKey:(void *)key {
	return objc_getAssociatedObject(self, key);
}

+ (void)raf_setAssociatedObject:(id)value forKey:(void *)key policy:(objc_AssociationPolicy)policy {
	objc_setAssociatedObject(self, key, value, policy);
}

@end
