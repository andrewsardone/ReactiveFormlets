//
//  JSMenuRow.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/13/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "JSTableRow.h"

// JSMenuRow is for implementing subforms that start with a disclosure
// cell, yielding a new view. This one is rather poorly implemented and
// could even use a rename, to distinguish it from choice-menus, which
// I'll be adding shortly.

@protocol JSMenuRowDelegate;

@interface JSMenuRow : Formlet <JSTableRow>
@property (weak) id <JSMenuRowDelegate> delegate;
@property (copy, readonly) NSString *title;
- (instancetype)withTitle:(NSString *)title;
@end

@protocol JSMenuRowDelegate <NSObject>
- (void)menuRow:(JSMenuRow *)row displayViewController:(UITableViewController *)controller;
@end
