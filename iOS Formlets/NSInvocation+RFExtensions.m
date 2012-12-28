//
//  NSInvocation+RFExtensions.m
//  iOS Formlets
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "NSInvocation+RFExtensions.h"
#import "RFOrderedDictionary.h"
#import <ReactiveCocoa/RACSequence.h>
#import <ReactiveCocoa/RACTuple.h>
#import <ReactiveCocoa/NSArray+RACSequenceAdditions.h>

@implementation NSInvocation (RFExtensions)

- (RACSequence *)rf_keywords {
	NSPredicate *notEmpty = [NSPredicate predicateWithBlock:^ BOOL (NSString *string, id _) {
		return string.length > 0;
	}];

	NSString *selector = NSStringFromSelector(self.selector);
	NSArray *components = [selector componentsSeparatedByString:@":"];
	return [components filteredArrayUsingPredicate:notEmpty].rac_sequence;
}

- (RACSequence *)rf_arguments {
	NSUInteger count = self.methodSignature.numberOfArguments;
	NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:count];

	for (int i = 2; i < count; ++i) {
		__unsafe_unretained id argument = nil;
		[self getArgument:&argument atIndex:i];
		[arguments addObject:argument];
	}

	return arguments.rac_sequence;
}


- (RACSequence *)rf_keywordPairs {
	return [RACSequence zip:@[ self.rf_keywords, self.rf_arguments ]];
}

- (RFOrderedDictionary *)rf_argumentDictionary {
	return [[RFOrderedDictionary new] modify:^(id<RFMutableOrderedDictionary> dict) {
		for (RACTuple *pair in self.rf_keywordPairs) {
			dict[pair.first] = pair.second;
		}
	}];
}

@end
