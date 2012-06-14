//
//  JSTableSection.m
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "JSTableSection.h"
#import "JSInputRow.h"
#import "JSTableForm.h"
#import "Formlet.h"

@implementation JSTableSection

- (id)copyWithZone:(NSZone *)zone
{
    JSTableSection *copy = [super copyWithZone:zone];
    copy->_title = _title;
    return copy;
}

- (instancetype)title:(NSString *)title
{
    JSTableSection *copy = [self copy];
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
