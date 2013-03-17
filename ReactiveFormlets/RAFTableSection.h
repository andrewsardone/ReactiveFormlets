//
//  RAFTableSection.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFFormlet.h>

@class UITableViewCell;

@interface RAFTableSection : RAFCompoundFormlet
@property (copy, readonly) NSString *title;

- (instancetype)title:(NSString *)title;

- (NSUInteger)numberOfRows;
- (UITableViewCell *)cellForRow:(NSUInteger)row;
@end
