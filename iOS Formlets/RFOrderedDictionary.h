//
//  RFOrderedDictionary.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/RACSubscribable.h>

@protocol RFOrderedDictionary <NSObject>
- (id)objectForKey:(id<NSCopying>)key;
- (id)objectForKeyedSubscript:(id<NSCopying>)key;
- (NSArray *)allKeys;
- (NSArray *)allValues;
- (NSUInteger)count;
@end

@protocol RFMutableOrderedDictionary <RFOrderedDictionary>
- (void)setObject:(id<NSCopying>)object forKey:(id<NSCopying>)key;
- (void)setObject:(id<NSCopying>)object forKeyedSubscript:(id<NSCopying>)key;
@end

// RFOrderedDictionary is a reactive, mutable associative collection. It
// is almost exactly like an NSMutableDictionary, except that
// keys are always kept in the order they are inserted.
@interface RFOrderedDictionary : RACSubscribable <RFOrderedDictionary, NSFastEnumeration, NSCopying>
- (id)initWithOrderedDictionary:(RFOrderedDictionary *)dictionary;
- (instancetype)modify:(void(^)(id<RFMutableOrderedDictionary> mutableDictionary))block;
@end
