//
//  RAFOrderedDictionary.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RAFMutableOrderedDictionary;

// The block which allows guarded access to the mutable interface of an
// immutable ordered dictionary.
typedef void (^RAFOrderedDictionaryModifyBlock)(id<RAFMutableOrderedDictionary> dict);

// The immutable interface to an ordered dictionary.
@protocol RAFOrderedDictionary <NSFastEnumeration>

// Returns the object at the provided key.
- (id)objectForKey:(id<NSCopying>)key;
- (id)objectForKeyedSubscript:(id<NSCopying>)key;

// Returns an array of all the keys in the ordered dictionary, in order.
- (NSArray *)allKeys;

// Returns an array of all the values in the ordered dictionary, in order.
- (NSArray *)allValues;

// Returns the number of entries in the ordered dictionary.
- (NSUInteger)count;

// Non-destructive update for an ordered dictionary.
//
// block - The destructive operations to be performed on the copy; within the
// block's scope, access is granted statically to the mutable interface of
// `RAFOrderedDictionary`.
//
// Returns a modified version of the ordered dictionary.
- (instancetype)modify:(RAFOrderedDictionaryModifyBlock)block;
@end

// The mutable interface to the ordered dictionary.
@protocol RAFMutableOrderedDictionary <RAFOrderedDictionary>

// Destructively updates the dictionary at a certain key; if the key does not
// yet exist in the dictionary, the key-value pair is appended to the end.
//
// key - The key at which to update the dictionary.
// value - The value with which to update the dictionary.
- (void)setObject:(id)object forKey:(id<NSCopying>)key;
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;
@end

@class RACSequence;

// RAFOrderedDictionary is an (optionally) mutable associative collection. It
// is almost exactly like an NSMutableDictionary, except that
// keys are always kept in the order they are inserted.
@interface RAFOrderedDictionary : NSObject <RAFOrderedDictionary, NSCopying, NSMutableCopying>

// Initializes with an existing ordered dictionary.
- (id)initWithOrderedDictionary:(RAFOrderedDictionary *)dictionary;

// Returns a copy of the dictionary by copying each of its objects.
- (instancetype)deepCopyWithZone:(NSZone *)zone;

// Returns a sequence of (key,value) RACTuples.
- (RACSequence *)sequence;
@end

@interface RAFOrderedDictionary (TypeRefinement)
- (RAFOrderedDictionary<RAFMutableOrderedDictionary> *)mutableCopyWithZone:(NSZone *)zone;
- (RAFOrderedDictionary<RAFMutableOrderedDictionary> *)mutableCopy;
@end
