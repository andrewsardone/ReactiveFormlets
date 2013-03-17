//
//  RAFObjCRuntime.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface RAFObjCRuntime : NSObject
+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol;
+ (NSMethodSignature *)classMethodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol;
@end

// Some utilities used internally in RAF.
@interface NSObject (RAFObjCRuntime)

// Allocates and registers a subclass of the receiving class.
//
// name - the name to be given the subclass.
// protocols - the protocols which the subclass should adopt.
//
// Returns the subclass.
+ (Class)rf_subclassWithName:(NSString *)name adopting:(NSArray *)protocols;

// Gets an associated object on the receiving object by key.
//
// key - the key at which object is associated to the receiver.
- (id)rf_associatedObjectForKey:(void *)key;
+ (id)rf_associatedObjectForKey:(void *)key;

// Sets an associated object on the receiving object.
//
// value - the object to the associated to the receiver.
// key - the key at which the value is to be associated to the receiver.
// policy - the association policy by which the object is to be associated.
- (void)rf_setAssociatedObject:(id)value forKey:(void *)key policy:(objc_AssociationPolicy)policy;
+ (void)rf_setAssociatedObject:(id)value forKey:(void *)key policy:(objc_AssociationPolicy)policy;

@end
