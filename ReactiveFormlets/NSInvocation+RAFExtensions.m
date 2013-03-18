//
//  NSInvocation+RAFExtensions.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/NSInvocation+RAFExtensions.h>
#import <ReactiveFormlets/RAFOrderedDictionary.h>
#import <ReactiveCocoa/RACSequence.h>
#import <ReactiveCocoa/RACTuple.h>
#import <ReactiveCocoa/NSArray+RACSequenceAdditions.h>

@implementation NSInvocation (RAFExtensions)

- (RACSequence *)raf_keywords {
	NSPredicate *notEmpty = [NSPredicate predicateWithBlock:^BOOL (NSString *string, id _) {
		return string.length > 0;
	}];

	NSString *selector = NSStringFromSelector(self.selector);
	NSArray *components = [selector componentsSeparatedByString:@":"];
	return [components filteredArrayUsingPredicate:notEmpty].rac_sequence;
}

- (RACSequence *)raf_arguments {
	NSUInteger count = self.methodSignature.numberOfArguments;
	NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:count];

	for (NSUInteger i = 2; i < count; ++i) {
		__unsafe_unretained id argument = nil;
		[self getArgument:&argument atIndex:i];
		[arguments addObject:argument ?: [NSNull null]];
	}

	return arguments.rac_sequence;
}


- (RACSequence *)raf_keywordPairs {
	return [RACSequence zip:@[ self.raf_keywords, self.raf_arguments ]];
}

- (RAFOrderedDictionary *)raf_argumentDictionary {
	return [[RAFOrderedDictionary new] modify:^(id<RAFMutableOrderedDictionary> dict) {
		for (RACTuple *pair in self.raf_keywordPairs) {
			dict[pair.first] = pair.second;
		}
	}];
}

@end
