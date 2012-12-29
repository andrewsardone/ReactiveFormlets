//
//  NSInvocation+RAFExtensions.h
//  ReactiveCocoa
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSequence;
@class RAFOrderedDictionary;

@interface NSInvocation (RAFExtensions)

// A sequence [NSString] of the invocations.
- (RACSequence *)rf_keywords;

// A sequence [id] of the invocation's arguments.
- (RACSequence *)rf_arguments;

// A sequence [NSString,id] of the invocation's keywords and arguments.
- (RACSequence *)rf_keywordPairs;

// An ordered dictionary of the invocation's keywords and arguments.
- (RAFOrderedDictionary *)rf_argumentDictionary;

@end