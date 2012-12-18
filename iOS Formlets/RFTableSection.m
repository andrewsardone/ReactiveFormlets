//
//  RFTableSection.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RFTableSection.h"
#import "RFInputRow.h"
#import "RFTableForm.h"
#import "RFFormlet.h"

@implementation RFTableSection

- (id)copyWithZone:(NSZone *)zone
{
	RFTableSection *copy = [super copyWithZone:zone];
	copy->_title = _title;
	return copy;
}

- (instancetype)title:(NSString *)title
{
	RFTableSection *copy = [self copy];
	copy->_title = title;
	return copy;
}

- (NSUInteger)numberOfRows
{
	return self.count;
}

- (UITableViewCell *)cellForRow:(NSUInteger)row
{
	return [[self.allValues objectAtIndex:row] cell];
}

@end
