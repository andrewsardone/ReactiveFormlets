//
//  RFOrderedDictionary.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RFMutableOrderedDictionary;
typedef void (^RFOrderedDictionaryModifyBlock)(id<RFMutableOrderedDictionary> dict);

@protocol RFOrderedDictionary <NSObject>
- (id)objectForKey:(id<NSCopying>)key;
- (id)objectForKeyedSubscript:(id<NSCopying>)key;
- (NSArray *)allKeys;
- (NSArray *)allValues;
- (NSUInteger)count;

- (instancetype)modify:(RFOrderedDictionaryModifyBlock)block;
@end

@protocol RFMutableOrderedDictionary <RFOrderedDictionary>
- (void)setObject:(id<NSCopying>)object forKey:(id<NSCopying>)key;
- (void)setObject:(id<NSCopying>)object forKeyedSubscript:(id<NSCopying>)key;
@end

@protocol RACSignal;
@class RACSequence;

// RFOrderedDictionary is an (optionally) mutable associative collection. It
// is almost exactly like an NSMutableDictionary, except that
// keys are always kept in the order they are inserted.
@interface RFOrderedDictionary : NSObject <RFOrderedDictionary, NSFastEnumeration, NSCopying>
- (id)initWithOrderedDictionary:(RFOrderedDictionary *)dictionary;

// Turn the dictionary into a sequence of (key,value) RACTuples.
- (RACSequence *)sequence;
@end
