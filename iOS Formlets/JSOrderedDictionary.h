//
//  JSOrderedDictionary.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/RACSubscribable.h>

// JSOrderedDictionary is a reactive, mutable associative collection. It
// is almost exactly like an NSMutableDictionary, except that
// keys are always kept int he order they are inserted.
@interface JSOrderedDictionary : RACSubscribable <NSFastEnumeration, NSCopying>
- (id)initWithOrderedDictionary:(JSOrderedDictionary *)dictionary;

- (id)objectForKey:(id <NSCopying>)key;
- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (NSArray *)allKeys;
- (NSArray *)allValues;
- (NSUInteger)count;

- (void)setObject:(id)object forKey:(id <NSCopying>)key;
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;
@end
