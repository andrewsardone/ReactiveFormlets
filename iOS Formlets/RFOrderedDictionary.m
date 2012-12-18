//
//  RFOrderedDictionary.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFOrderedDictionary.h"
#import <ReactiveCocoa/RACSubject.h>
#import <ReactiveCocoa/RACSequence.h>
#import <ReactiveCocoa/RACTuple.h>
#import <ReactiveCocoa/NSArray+RACSequenceAdditions.h>

@interface RFOrderedDictionary () <RFMutableOrderedDictionary>
@property (strong) RACSubject *signal;
@end

@implementation RFOrderedDictionary {
    NSMutableArray *_keys;
    NSMutableDictionary *_dictionary;
}

- (id)init
{
    if ((self = [super init]))
    {
        _keys = [NSMutableArray new];
        _dictionary = [NSMutableDictionary new];
        _signal = [RACSubject subject];
    }

    return self;
}

- (id)initWithOrderedDictionary:(RFOrderedDictionary *)dictionary
{
    if (self = [super init])
    {
        _keys = [dictionary.allKeys mutableCopy];
        _dictionary = [NSMutableDictionary dictionaryWithObjects:dictionary.allValues forKeys:dictionary.allKeys];
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    RFOrderedDictionary *copy = [[self class] new];
    for (id key in self)
    {
        copy[key] = [self[key] copyWithZone:zone];
    }

    return copy;
}

- (instancetype)modify:(RFOrderedDictionaryModifyBlock)block
{
    RFOrderedDictionary *copy = [self copy];
    block(copy);
    return copy;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_keys countByEnumeratingWithState:state objects:buffer count:len];
}

- (id)objectForKey:(id<NSCopying>)key
{
    return [_dictionary objectForKey:key];
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key
{
    NSParameterAssert(object != nil);
    NSParameterAssert(key != nil);

    if (![_keys containsObject:key])
    {
        [_keys addObject:key];
    }

    [_dictionary setObject:[object copy] forKey:key];
    [_signal sendNext:self];
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key
{
    [self setObject:object forKey:key];
}

- (NSUInteger)count
{
    return _keys.count;
}

- (NSArray *)allKeys
{
    return [_keys copy];
}

- (NSArray *)allValues
{
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:self.count];
    for (id key in self)
    {
        [values addObject:self[key]];
    }

    return [values copy];
}

- (RACSequence *)sequence
{
	NSDictionary *immutableDict = [self copy];

	return [immutableDict.allKeys.rac_sequence map:^(id key) {
		id value = immutableDict[key];
		return [RACTuple tupleWithObjects:key, value, nil];
	}];
}


@end
