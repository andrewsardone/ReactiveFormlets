//
//  RAFTableSection.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFTableSection.h>
#import <ReactiveFormlets/RAFInputRow.h>
#import <ReactiveFormlets/RAFTableForm.h>
#import <ReactiveFormlets/RAFFormlet.h>

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

- (UITableViewCell *)cellForRow:(NSUInteger)index {
	RAFInputRow *row = (self.allValues)[index];
	UITableViewCell *cell = row.cell;
	return cell;
}

@end
