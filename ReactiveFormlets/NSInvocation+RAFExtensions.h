//
//  NSInvocation+RAFExtensions.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSequence;
@class RAFOrderedDictionary;

@interface NSInvocation (RAFExtensions)

// A sequence [NSString] of the invocations.
- (RACSequence *)raf_keywords;

// A sequence [id] of the invocation's arguments.
- (RACSequence *)raf_arguments;

// A sequence [NSString,id] of the invocation's keywords and arguments.
- (RACSequence *)raf_keywordPairs;

// An ordered dictionary of the invocation's keywords and arguments.
- (RAFOrderedDictionary *)raf_argumentDictionary;

@end
