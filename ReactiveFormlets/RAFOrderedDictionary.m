//
//  RAFOrderedDictionary.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFOrderedDictionary.h>
#import <ReactiveCocoa/RACSubject.h>
#import <ReactiveCocoa/RACSequence.h>
#import <ReactiveCocoa/RACTuple.h>
#import <ReactiveCocoa/NSArray+RACSequenceAdditions.h>

typedef enum {
	RAFMutabilityNone,
	RAFMutabilityTemporary,
	RAFMutabilityPermanent
} RAFMutabilityState;

@interface RAFOrderedDictionary ()
- (void)performWithTemporaryMutability:(void(^)(id<RAFMutableOrderedDictionary> dict))block;
@end

@interface RAFOrderedDictionary (RAFMutableOrderedDictionary) <RAFMutableOrderedDictionary>
@end

@implementation RAFOrderedDictionary {
	NSMutableArray *_keys;
	NSMutableDictionary *_dictionary;
	RAFMutabilityState _mutabilityState;
}

#pragma mark - Initializers

- (id)init {
	if (self = [super init]) {
		_keys = [NSMutableArray new];
		_dictionary = [NSMutableDictionary new];
	}

	return self;
}

- (id)initWithOrderedDictionary:(RAFOrderedDictionary *)dictionary {
	if (self = [super init]) {
		_keys = [dictionary.allKeys mutableCopy];
		_dictionary = [NSMutableDictionary dictionaryWithObjects:dictionary.allValues forKeys:dictionary.allKeys];
	}

	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[[self class] alloc] initWithOrderedDictionary:self];
}

- (instancetype)deepCopyWithZone:(NSZone *)zone {
	RAFOrderedDictionary *copy = [[self class] new];
	[copy performWithTemporaryMutability:^(id<RAFMutableOrderedDictionary> dict) {
		for (id key in self) {
			dict[key] = [self[key] copyWithZone:zone];
		}
	}];
	return copy;
}

#pragma mark - NSMutableCopying

- (RAFOrderedDictionary<RAFMutableOrderedDictionary> *)mutableCopyWithZone:(NSZone *)zone {
	RAFOrderedDictionary *copy = [self copyWithZone:zone];
	copy->_mutabilityState = RAFMutabilityPermanent;
	return copy;
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
	return [_keys countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - Safe Update

- (void)performWithTemporaryMutability:(RAFOrderedDictionaryModifyBlock)block {
	BOOL immutableByDefault = _mutabilityState != RAFMutabilityPermanent;
	if (immutableByDefault) _mutabilityState = RAFMutabilityTemporary;
	block(self);
	if (immutableByDefault) _mutabilityState = RAFMutabilityNone;
}

- (instancetype)modify:(RAFOrderedDictionaryModifyBlock)block {
	BOOL immutableByDefault = _mutabilityState != RAFMutabilityPermanent;
	RAFOrderedDictionary *copy = immutableByDefault ? [self copy] : [self mutableCopy];
	[copy performWithTemporaryMutability:^(id<RAFMutableOrderedDictionary> dict) {
		block(dict);
	}];
	return copy;
}

#pragma mark - Accessors

- (id)objectForKey:(id<NSCopying>)key {
	return [_dictionary objectForKey:key];
}

- (id)objectForKeyedSubscript:(id<NSCopying>)key {
	return [self objectForKey:key];
}

- (NSUInteger)count {
	return _keys.count;
}

- (NSArray *)allKeys {
	return [_keys copy];
}

- (NSArray *)allValues {
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:self.count];
	for (id key in self) {
		[values addObject:self[key]];
	}

	return [values copy];
}

#pragma mark - Key Value Coding

- (id)valueForUndefinedKey:(NSString *)key {
	return self[key];
}

#pragma mark -

- (RACSequence *)sequence {
	NSDictionary *immutableDict = [self copy];

	return [immutableDict.allKeys.rac_sequence map:^(id key) {
		id value = immutableDict[key];
		return [RACTuple tupleWithObjects:key, value, nil];
	}];
}

- (NSString *)description {
	return [self.sequence map:^(RACTuple *value) {
		return [NSString stringWithFormat:@"%@: %@", value.first, value.second];
	}].array.description;
}

@end

@implementation RAFOrderedDictionary (RAFMutableOrderedDictionary)

- (void)assertMutableForSelector:(SEL)selector {
	if (_mutabilityState != RAFMutabilityNone) return;

	NSString *reason = [NSString stringWithFormat:
						@"Attempted to send -%@ to immutable object %@",
						NSStringFromSelector(selector), self];
	@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
	NSParameterAssert(key != nil);
	[self assertMutableForSelector:_cmd];

	if (object == nil) [_keys removeObject:key];
	if (![_keys containsObject:key]) {
		[_keys addObject:key];
	}

	[_dictionary setObject:object forKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
	[self setObject:object forKey:key];
}

@end

