//
//  RFTableSection.h
//  iOS Formlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFFormlet.h"

@interface RFTableSection : RFFormlet
@property (copy, readonly) NSString *title;

- (instancetype)title:(NSString *)title;

- (NSUInteger)numberOfRows;
- (UITableViewCell *)cellForRow:(NSUInteger)row;
@end
