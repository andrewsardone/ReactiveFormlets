//
//  RFOrderedDictionary.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RFMutableOrderedDictionary;

// The block which allows guarded access to the mutable interface of an
// immutable ordered dictionary.
typedef void (^RFOrderedDictionaryModifyBlock)(id<RFMutableOrderedDictionary> dict);

// The immutable interface to an ordered dictionary.
@protocol RFOrderedDictionary <NSFastEnumeration>

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
// `RFOrderedDictionary`.
//
// Returns a modified version of the ordered dictionary.
- (instancetype)modify:(RFOrderedDictionaryModifyBlock)block;
@end

// The mutable interface to the ordered dictionary.
@protocol RFMutableOrderedDictionary <RFOrderedDictionary>

// Destructively updates the dictionary at a certain key; if the key does not
// yet exist in the dictionary, the key-value pair is appended to the end.
//
// key - The key at which to update the dictionary.
// value - The value with which to update the dictionary.
- (void)setObject:(id<NSCopying>)object forKey:(id<NSCopying>)key;
- (void)setObject:(id<NSCopying>)object forKeyedSubscript:(id<NSCopying>)key;
@end

@class RACSequence;

// RFOrderedDictionary is an (optionally) mutable associative collection. It
// is almost exactly like an NSMutableDictionary, except that
// keys are always kept in the order they are inserted.
@interface RFOrderedDictionary : NSObject <RFOrderedDictionary, NSCopying>

// Initializes with an existing ordered dictionary.
- (id)initWithOrderedDictionary:(RFOrderedDictionary *)dictionary;

// Returns a sequence of (key,value) RACTuples.
- (RACSequence *)sequence;
@end
