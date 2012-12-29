//
//  RAFTableSection.m
//  ReactiveCocoa
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFTableSection.h"
#import "RAFInputRow.h"
#import "RAFTableForm.h"
#import "RAFFormlet.h"

@implementation RAFTableSection

- (id)copyWithZone:(NSZone *)zone {
	RAFTableSection *copy = [super copyWithZone:zone];
	copy->_title = _title;
	return copy;
}

- (instancetype)title:(NSString *)title {
	RAFTableSection *copy = [self copy];
	copy->_title = title;
	return copy;
}

- (NSUInteger)numberOfRows {
	return self.count;
}

- (UITableViewCell *)cellForRow:(NSUInteger)row {
	return [[self.allValues objectAtIndex:row] cell];
}

@end
