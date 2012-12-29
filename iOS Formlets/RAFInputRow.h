//
//  JSInputRow.h
//  ReactiveCocoa
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFFormlet.h"

// JSInputRow is a table row with a text field.
@interface RAFInputRow : RAFPrimitiveFormlet
@property (strong, readonly) UITableViewCell *cell;

- (instancetype)modifyTextField:(void (^)(UITextField *field))block;
- (instancetype)placeholder:(NSString *)placeholder;

- (void)rowWasSelected;
@end


@interface RAFTextInputRow : RAFInputRow <Text>
@end

@interface RAFNumberInputRow : RAFInputRow <Number>
@end